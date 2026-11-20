using System.Data;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MySqlConnector;

namespace RestaurantManagement.Infrastructure.Data;

public class DatabaseInitializationResult
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public List<string> AppliedScripts { get; set; } = new();
    public int TablesCount { get; set; }
    public int ViewsCount { get; set; }
    public int StoredProceduresCount { get; set; }
    public int FunctionsCount { get; set; }
    public int TriggersCount { get; set; }
    public Exception? Exception { get; set; }
}

public class DatabaseInitializer
{
    private readonly string _connectionString;
    private readonly ILogger<DatabaseInitializer>? _logger;
    private readonly string _databaseName;

    private static readonly string[] ScriptNames = new[]
    {
        "01_CreateDatabase.sql",
        "02_CreateTables.sql",
        "03_CreateIndexes.sql",
        "05_CreateFunctions.sql",
        "06_CreateViews.sql",
        "04_CreateStoredProcedures.sql",
        "07_CreateTriggers.sql",
        "08_InsertDefaultData.sql",
        "09_DatabaseVersion.sql"
    };

    public DatabaseInitializer(string connectionString, ILogger<DatabaseInitializer>? logger = null)
    {
        _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
        _logger = logger;

        var builder = new MySqlConnectionStringBuilder(_connectionString);
        _databaseName = string.IsNullOrWhiteSpace(builder.Database) ? "RestaurantManagementDb" : builder.Database;
    }

    public static DatabaseInitializer FromConfiguration(IConfiguration configuration, ILogger<DatabaseInitializer>? logger = null)
    {
        var connStr = configuration.GetConnectionString("DefaultConnection")
            ?? "Server=localhost;Port=3306;Database=RestaurantManagementDb;User ID=root;Password=;";
        return new DatabaseInitializer(connStr, logger);
    }

    public async Task<DatabaseInitializationResult> InitializeAsync()
    {
        var result = new DatabaseInitializationResult();
        var sanitizedConnStr = MySqlDbHelper.SanitizeConnectionString(_connectionString);

        _logger?.LogInformation("Starting automated MySQL database initialization for target database '{Database}'...", _databaseName);
        _logger?.LogInformation("Connection string: {ConnectionString}", sanitizedConnStr);

        try
        {
            // Step 1 & 2: Connect to server without database
            var serverBuilder = new MySqlConnectionStringBuilder(_connectionString)
            {
                Database = string.Empty,
                AllowUserVariables = true
            };

            _logger?.LogInformation("Connecting to MySQL Server on {Server}:{Port}...", serverBuilder.Server, serverBuilder.Port);

            await using (var serverConn = new MySqlConnection(serverBuilder.ConnectionString))
            {
                await serverConn.OpenAsync();
                _logger?.LogInformation("Successfully connected to MySQL Server instance ({ServerVersion}).", serverConn.ServerVersion);

                // Step 3 & 4: Check if database exists, create if missing
                var checkDbSql = "SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = @dbName;";
                await using var checkCmd = new MySqlCommand(checkDbSql, serverConn);
                checkCmd.Parameters.AddWithValue("@dbName", _databaseName);
                var dbCount = Convert.ToInt32(await checkCmd.ExecuteScalarAsync());

                if (dbCount == 0)
                {
                    _logger?.LogInformation("Database '{Database}' does not exist. Creating database with utf8mb4 encoding...", _databaseName);
                    var createDbSql = $"CREATE DATABASE `{_databaseName}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;";
                    await using var createCmd = new MySqlCommand(createDbSql, serverConn);
                    await createCmd.ExecuteNonQueryAsync();
                    _logger?.LogInformation("Database '{Database}' created successfully.", _databaseName);
                }
                else
                {
                    _logger?.LogInformation("Database '{Database}' already exists. Existing user data and tables will be preserved.", _databaseName);
                }
            }

            // Step 5: Connect to the target database
            var dbBuilder = new MySqlConnectionStringBuilder(_connectionString)
            {
                Database = _databaseName,
                AllowUserVariables = true
            };

            await using (var dbConn = new MySqlConnection(dbBuilder.ConnectionString))
            {
                await dbConn.OpenAsync();

                // Step 6: Create or verify SchemaVersions table
                await EnsureSchemaVersionsTableExistsAsync(dbConn);

                // Step 7: Get list of already applied migrations
                var appliedScripts = await GetAppliedScriptsAsync(dbConn);
                _logger?.LogInformation("Found {Count} previously applied database migration scripts.", appliedScripts.Count);

                // Step 8: Execute pending scripts
                foreach (var scriptName in ScriptNames)
                {
                    if (appliedScripts.Contains(scriptName, StringComparer.OrdinalIgnoreCase))
                    {
                        _logger?.LogDebug("Script '{ScriptName}' already applied. Skipping.", scriptName);
                        continue;
                    }

                    _logger?.LogInformation("Executing pending migration script '{ScriptName}'...", scriptName);
                    var scriptContent = await LoadScriptContentAsync(scriptName);

                    if (string.IsNullOrWhiteSpace(scriptContent))
                    {
                        throw new FileNotFoundException($"Migration script '{scriptName}' could not be located on disk or embedded resources.");
                    }

                    await ExecuteScriptWithDelimitersAsync(dbConn, scriptContent, scriptName);
                    await RecordMigrationAppliedAsync(dbConn, scriptName);

                    result.AppliedScripts.Add(scriptName);
                    _logger?.LogInformation("Successfully applied migration script '{ScriptName}'.", scriptName);
                }

                // Sync EF Core migrations history table
                await SyncEFMigrationsHistoryAsync(dbConn);

                // Step 9: Verify created database objects
                await VerifyDatabaseObjectsAsync(dbConn, result);

                result.Success = true;
                result.Message = $"MySQL Database '{_databaseName}' initialized successfully. " +
                                 $"{result.TablesCount} tables, {result.ViewsCount} views, " +
                                 $"{result.StoredProceduresCount} stored procedures, {result.FunctionsCount} functions, " +
                                 $"{result.TriggersCount} triggers verified.";

                _logger?.LogInformation("=================================================================");
                _logger?.LogInformation("✅ {Message}", result.Message);
                _logger?.LogInformation("=================================================================");
            }
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Exception = ex;
            result.Message = ExplainFailure(ex, _connectionString);
            _logger?.LogError(ex, "❌ Database Initialization Failure:\n{DetailedExplanation}", result.Message);
        }

        return result;
    }

    private static async Task EnsureSchemaVersionsTableExistsAsync(MySqlConnection conn)
    {
        var sql = @"
            CREATE TABLE IF NOT EXISTS `SchemaVersions` (
                `Id` INT NOT NULL AUTO_INCREMENT,
                `ScriptName` VARCHAR(255) NOT NULL,
                `AppliedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                `Description` VARCHAR(255) NULL,
                `Status` VARCHAR(50) NOT NULL DEFAULT 'Success',
                PRIMARY KEY (`Id`),
                UNIQUE KEY `UQ_SchemaVersions_ScriptName` (`ScriptName`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";

        await using var cmd = new MySqlCommand(sql, conn);
        await cmd.ExecuteNonQueryAsync();
    }

    private static async Task<HashSet<string>> GetAppliedScriptsAsync(MySqlConnection conn)
    {
        var scripts = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var sql = "SELECT `ScriptName` FROM `SchemaVersions` WHERE `Status` = 'Success';";

        await using var cmd = new MySqlCommand(sql, conn);
        await using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            scripts.Add(reader.GetString(0));
        }

        return scripts;
    }

    private static async Task RecordMigrationAppliedAsync(MySqlConnection conn, string scriptName)
    {
        var sql = @"
            INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
            VALUES (@name, @desc, 'Success')
            ON DUPLICATE KEY UPDATE `AppliedAt` = CURRENT_TIMESTAMP, `Status` = 'Success';";

        await using var cmd = new MySqlCommand(sql, conn);
        cmd.Parameters.AddWithValue("@name", scriptName);
        cmd.Parameters.AddWithValue("@desc", $"Executed via automated migration runner on {DateTime.UtcNow:yyyy-MM-dd HH:mm:ss} UTC");
        await cmd.ExecuteNonQueryAsync();
    }

    private static async Task SyncEFMigrationsHistoryAsync(MySqlConnection conn)
    {
        var sql = @"
            CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
                `MigrationId` VARCHAR(150) NOT NULL,
                `ProductVersion` VARCHAR(32) NOT NULL,
                PRIMARY KEY (`MigrationId`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            INSERT IGNORE INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`) VALUES
            ('20261015101938_InitialCreate', '9.0.0'),
            ('20261025123201_AddAccountsAndPayroll', '9.0.0'),
            ('20261029061239_AddMastersSuppliersAndCustomerCredit', '9.0.0'),
            ('20261029071656_AddRestaurantNameMarathi', '9.0.0'),
            ('20261030053032_AddShortCodeAndCustomerFields', '9.0.0'),
            ('20261030112424_AddSupplierToInventoryAndOnlineOrderFields', '9.0.0');";

        await using var cmd = new MySqlCommand(sql, conn);
        await cmd.ExecuteNonQueryAsync();
    }

    private async Task VerifyDatabaseObjectsAsync(MySqlConnection conn, DatabaseInitializationResult result)
    {
        // 1. Tables count
        await using (var cmd = new MySqlCommand("SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = @db AND TABLE_TYPE = 'BASE TABLE';", conn))
        {
            cmd.Parameters.AddWithValue("@db", _databaseName);
            result.TablesCount = Convert.ToInt32(await cmd.ExecuteScalarAsync());
        }

        // 2. Views count
        await using (var cmd = new MySqlCommand("SELECT COUNT(*) FROM information_schema.VIEWS WHERE TABLE_SCHEMA = @db;", conn))
        {
            cmd.Parameters.AddWithValue("@db", _databaseName);
            result.ViewsCount = Convert.ToInt32(await cmd.ExecuteScalarAsync());
        }

        // 3. Stored Procedures count
        await using (var cmd = new MySqlCommand("SELECT COUNT(*) FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = @db AND ROUTINE_TYPE = 'PROCEDURE';", conn))
        {
            cmd.Parameters.AddWithValue("@db", _databaseName);
            result.StoredProceduresCount = Convert.ToInt32(await cmd.ExecuteScalarAsync());
        }

        // 4. Functions count
        await using (var cmd = new MySqlCommand("SELECT COUNT(*) FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = @db AND ROUTINE_TYPE = 'FUNCTION';", conn))
        {
            cmd.Parameters.AddWithValue("@db", _databaseName);
            result.FunctionsCount = Convert.ToInt32(await cmd.ExecuteScalarAsync());
        }

        // 5. Triggers count
        await using (var cmd = new MySqlCommand("SELECT COUNT(*) FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = @db;", conn))
        {
            cmd.Parameters.AddWithValue("@db", _databaseName);
            result.TriggersCount = Convert.ToInt32(await cmd.ExecuteScalarAsync());
        }

        if (result.TablesCount < 30)
        {
            _logger?.LogWarning("Verification warning: Expected at least 35 tables, found {Count}.", result.TablesCount);
        }
    }

    private static async Task ExecuteScriptWithDelimitersAsync(MySqlConnection conn, string scriptContent, string scriptName)
    {
        var statements = SplitScript(scriptContent);
        foreach (var statement in statements)
        {
            var trimmed = statement.Trim();
            if (string.IsNullOrWhiteSpace(trimmed)) continue;

            // Skip USE statement if pointing to hardcoded DB name
            if (trimmed.StartsWith("USE ", StringComparison.OrdinalIgnoreCase)) continue;

            try
            {
                await using var cmd = new MySqlCommand(trimmed, conn)
                {
                    CommandTimeout = 120
                };
                await cmd.ExecuteNonQueryAsync();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException(
                    $"Error executing statement in script '{scriptName}':\n{trimmed.Substring(0, Math.Min(300, trimmed.Length))}...\nError: {ex.Message}", ex);
            }
        }
    }

    public static List<string> SplitScript(string script)
    {
        var statements = new List<string>();
        var lines = script.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
        var currentDelimiter = ";";
        var buffer = new StringBuilder();

        foreach (var rawLine in lines)
        {
            var line = rawLine.Trim();

            // Check for DELIMITER changes
            if (line.StartsWith("DELIMITER", StringComparison.OrdinalIgnoreCase))
            {
                var parts = line.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                if (parts.Length > 1)
                {
                    currentDelimiter = parts[1].Trim();
                }
                continue;
            }

            buffer.AppendLine(rawLine);

            // Check if buffer ends with currentDelimiter
            var currentBufferText = buffer.ToString().TrimEnd();
            if (currentBufferText.EndsWith(currentDelimiter, StringComparison.Ordinal))
            {
                var stmt = currentBufferText.Substring(0, currentBufferText.Length - currentDelimiter.Length).Trim();
                if (IsExecutableSql(stmt))
                {
                    statements.Add(stmt);
                }
                buffer.Clear();
            }
        }

        var remaining = buffer.ToString().Trim();
        if (IsExecutableSql(remaining))
        {
            statements.Add(remaining);
        }

        return statements;
    }

    public static bool IsExecutableSql(string text)
    {
        if (string.IsNullOrWhiteSpace(text)) return false;
        var withoutBlockComments = Regex.Replace(text, @"/\*.*?\*/", "", RegexOptions.Singleline);
        var withoutLineComments = Regex.Replace(withoutBlockComments, @"(--|#)[^\r\n]*", "");
        return !string.IsNullOrWhiteSpace(withoutLineComments);
    }

    private async Task<string> LoadScriptContentAsync(string scriptName)
    {
        // 1. Try file system search in known paths
        var candidatePaths = new[]
        {
            Path.Combine(AppContext.BaseDirectory, "Database", scriptName),
            Path.Combine(Directory.GetCurrentDirectory(), "Database", scriptName),
            Path.Combine(Directory.GetCurrentDirectory(), "..", "Database", scriptName),
            Path.Combine(Directory.GetCurrentDirectory(), "..", "..", "Database", scriptName),
            Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "Database", scriptName),
            Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "RestaurantManagementSystem", "Database", scriptName)
        };

        foreach (var p in candidatePaths)
        {
            if (File.Exists(p))
            {
                _logger?.LogDebug("Loaded migration script '{ScriptName}' from disk: {Path}", scriptName, p);
                return await File.ReadAllTextAsync(p, Encoding.UTF8);
            }
        }

        // 2. Try embedded resources
        var assembly = Assembly.GetExecutingAssembly();
        var resourceNames = assembly.GetManifestResourceNames();
        var matchingResource = resourceNames.FirstOrDefault(r => r.EndsWith(scriptName, StringComparison.OrdinalIgnoreCase));

        if (matchingResource != null)
        {
            _logger?.LogDebug("Loaded migration script '{ScriptName}' from embedded resource: {ResourceName}", scriptName, matchingResource);
            await using var stream = assembly.GetManifestResourceStream(matchingResource);
            if (stream != null)
            {
                using var reader = new StreamReader(stream, Encoding.UTF8);
                return await reader.ReadToEndAsync();
            }
        }

        return string.Empty;
    }

    public static string ExplainFailure(Exception ex, string connectionString)
    {
        var sanitized = MySqlDbHelper.SanitizeConnectionString(connectionString);
        var sb = new StringBuilder();
        sb.AppendLine("================================================================================");
        sb.AppendLine("🚨 RESTAURANT MANAGEMENT SYSTEM - MYSQL INITIALIZATION ERROR");
        sb.AppendLine("================================================================================");

        var mySqlEx = FindMySqlException(ex);
        if (mySqlEx != null)
        {
            sb.AppendLine($"MySQL Error Code: {mySqlEx.Number} ({mySqlEx.ErrorCode})");
            sb.AppendLine($"Error Message: {mySqlEx.Message}");
            sb.AppendLine();

            switch (mySqlEx.Number)
            {
                case 1042: // Unable to connect to host
                case 0:    // Connection failure / socket error
                    sb.AppendLine("DIAGNOSIS: MySQL Server is not running or unreachable.");
                    sb.AppendLine("ACTION REQUIRED:");
                    sb.AppendLine("  1. Verify MySQL Server is installed (MySQL 8.0 or newer recommended).");
                    sb.AppendLine("  2. Start the MySQL Windows Service:");
                    sb.AppendLine("       PowerShell: Start-Service mysql (or Start-Service MySQL80)");
                    sb.AppendLine("  3. Verify port 3306 is open and listening:");
                    sb.AppendLine("       PowerShell: Test-NetConnection -ComputerName localhost -Port 3306");
                    break;

                case 1045: // Access denied (bad username or password)
                    sb.AppendLine("DIAGNOSIS: MySQL authentication failed (invalid username or password).");
                    sb.AppendLine("ACTION REQUIRED:");
                    sb.AppendLine("  1. Check 'appsettings.json' and verify 'User ID' and 'Password'.");
                    sb.AppendLine("  2. Test connecting via MySQL Command Line:");
                    sb.AppendLine("       mysql -u root -p");
                    sb.AppendLine("  3. Update password in appsettings.json if changed.");
                    break;

                case 1044: // Access denied to database
                    sb.AppendLine("DIAGNOSIS: MySQL user lacks permissions to access or create databases.");
                    sb.AppendLine("ACTION REQUIRED:");
                    sb.AppendLine("  Grant full privileges to your MySQL user:");
                    sb.AppendLine("       GRANT ALL PRIVILEGES ON RestaurantManagementDb.* TO 'root'@'localhost';");
                    sb.AppendLine("       FLUSH PRIVILEGES;");
                    break;

                case 1064: // SQL Syntax error
                    sb.AppendLine("DIAGNOSIS: SQL syntax error encountered in migration script.");
                    sb.AppendLine("ACTION REQUIRED: Check script compatibility with your MySQL version (8.0+ required).");
                    break;

                default:
                    sb.AppendLine($"DIAGNOSIS: MySQL database operation failed with code {mySqlEx.Number}.");
                    break;
            }
        }
        else
        {
            sb.AppendLine($"Error Type: {ex.GetType().FullName}");
            sb.AppendLine($"Error Message: {ex.Message}");
        }

        sb.AppendLine();
        sb.AppendLine($"Configured Connection String: {sanitized}");
        sb.AppendLine("================================================================================");

        return sb.ToString();
    }

    private static MySqlException? FindMySqlException(Exception ex)
    {
        var cur = ex;
        while (cur != null)
        {
            if (cur is MySqlException mySqlEx) return mySqlEx;
            cur = cur.InnerException;
        }
        return null;
    }
}
