using System.Data;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Logging;
using MySqlConnector;

namespace RestaurantManagement.Infrastructure.Data;

public interface IDatabaseHelper
{
    string ConnectionString { get; }
    MySqlConnection CreateConnection();
    MySqlConnection CreateServerConnection();
    Task<int> ExecuteNonQueryAsync(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters);
    Task<object?> ExecuteScalarAsync(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters);
    Task<T?> ExecuteScalarAsync<T>(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters);
    Task<DataTable> ExecuteDataTableAsync(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters);
    Task<int> ExecuteStoredProcedureAsync(string spName, params MySqlParameter[] parameters);
    MySqlParameter CreateParameter(string name, object? value);
    Task<bool> TestConnectionAsync();
}

public class MySqlDbHelper : IDatabaseHelper
{
    private readonly string _connectionString;
    private readonly ILogger<MySqlDbHelper>? _logger;

    public string ConnectionString => _connectionString;

    public MySqlDbHelper(string connectionString, ILogger<MySqlDbHelper>? logger = null)
    {
        _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
        _logger = logger;
    }

    public MySqlConnection CreateConnection()
    {
        return new MySqlConnection(_connectionString);
    }

    public MySqlConnection CreateServerConnection()
    {
        var builder = new MySqlConnectionStringBuilder(_connectionString)
        {
            Database = string.Empty
        };
        return new MySqlConnection(builder.ConnectionString);
    }

    public async Task<int> ExecuteNonQueryAsync(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters)
    {
        await using var conn = CreateConnection();
        await conn.OpenAsync();
        await using var cmd = new MySqlCommand(sql, conn)
        {
            CommandType = commandType,
            CommandTimeout = 120
        };

        if (parameters != null && parameters.Length > 0)
        {
            cmd.Parameters.AddRange(parameters);
        }

        return await cmd.ExecuteNonQueryAsync();
    }

    public async Task<object?> ExecuteScalarAsync(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters)
    {
        await using var conn = CreateConnection();
        await conn.OpenAsync();
        await using var cmd = new MySqlCommand(sql, conn)
        {
            CommandType = commandType,
            CommandTimeout = 120
        };

        if (parameters != null && parameters.Length > 0)
        {
            cmd.Parameters.AddRange(parameters);
        }

        return await cmd.ExecuteScalarAsync();
    }

    public async Task<T?> ExecuteScalarAsync<T>(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters)
    {
        var result = await ExecuteScalarAsync(sql, commandType, parameters);
        if (result == null || result == DBNull.Value)
        {
            return default;
        }

        return (T)Convert.ChangeType(result, typeof(T));
    }

    public async Task<DataTable> ExecuteDataTableAsync(string sql, CommandType commandType = CommandType.Text, params MySqlParameter[] parameters)
    {
        await using var conn = CreateConnection();
        await conn.OpenAsync();
        await using var cmd = new MySqlCommand(sql, conn)
        {
            CommandType = commandType,
            CommandTimeout = 120
        };

        if (parameters != null && parameters.Length > 0)
        {
            cmd.Parameters.AddRange(parameters);
        }

        using var adapter = new MySqlDataAdapter(cmd);
        var dt = new DataTable();
        adapter.Fill(dt);
        return dt;
    }

    public async Task<int> ExecuteStoredProcedureAsync(string spName, params MySqlParameter[] parameters)
    {
        return await ExecuteNonQueryAsync(spName, CommandType.StoredProcedure, parameters);
    }

    public MySqlParameter CreateParameter(string name, object? value)
    {
        return new MySqlParameter(name, value ?? DBNull.Value);
    }

    public async Task<bool> TestConnectionAsync()
    {
        try
        {
            await using var conn = CreateConnection();
            await conn.OpenAsync();
            return conn.State == ConnectionState.Open;
        }
        catch (Exception ex)
        {
            _logger?.LogError("MySQL Connection check failed: {Message}", ex.Message);
            return false;
        }
    }

    public static string SanitizeConnectionString(string connectionString)
    {
        if (string.IsNullOrWhiteSpace(connectionString)) return string.Empty;
        var sanitized = Regex.Replace(connectionString, @"(password|pwd)\s*=\s*[^;]*", "$1=***", RegexOptions.IgnoreCase);
        return sanitized;
    }
}
