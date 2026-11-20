using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using MySqlConnector;
using RestaurantManagement.Infrastructure.Data;
using RestaurantManagement.Infrastructure.DbContext;
using Xunit;

namespace RestaurantManagement.Tests;

public class MySqlMigrationTests
{
    [Fact]
    public void SanitizeConnectionString_HidesPassword_WhenPasswordProvided()
    {
        // Arrange
        var connStr = "Server=localhost;Port=3306;Database=RestaurantManagementDB;User ID=root;Password=SuperSecretPassword123!;";

        // Act
        var sanitized = MySqlDbHelper.SanitizeConnectionString(connStr);

        // Assert
        Assert.DoesNotContain("SuperSecretPassword123!", sanitized);
        Assert.Contains("Password=***", sanitized);
        Assert.Contains("Server=localhost", sanitized);
        Assert.Contains("Database=RestaurantManagementDB", sanitized);
    }

    [Fact]
    public void SanitizeConnectionString_HidesPwd_WhenShortKeyProvided()
    {
        // Arrange
        var connStr = "Server=127.0.0.1;Uid=myuser;Pwd=SecretPassWord!;Database=RMS;";

        // Act
        var sanitized = MySqlDbHelper.SanitizeConnectionString(connStr);

        // Assert
        Assert.DoesNotContain("SecretPassWord!", sanitized);
        Assert.Contains("Pwd=***", sanitized);
    }

    [Fact]
    public void SplitScript_SplitsStandardStatements_Correctly()
    {
        // Arrange
        var sql = @"
            CREATE TABLE TestA (Id INT PRIMARY KEY);
            CREATE TABLE TestB (Id INT PRIMARY KEY);
        ";

        // Act
        var statements = DatabaseInitializer.SplitScript(sql);

        // Assert
        Assert.Equal(2, statements.Count);
        Assert.Contains("CREATE TABLE TestA", statements[0]);
        Assert.Contains("CREATE TABLE TestB", statements[1]);
    }

    [Fact]
    public void SplitScript_HandlesDelimitersForStoredProcedures()
    {
        // Arrange
        var sql = @"
            DELIMITER $$
            CREATE PROCEDURE sp_Test()
            BEGIN
                SELECT 1;
                SELECT 2;
            END$$
            DELIMITER ;
            SELECT 3;
        ";

        // Act
        var statements = DatabaseInitializer.SplitScript(sql);

        // Assert
        Assert.Equal(2, statements.Count);
        Assert.Contains("CREATE PROCEDURE sp_Test()", statements[0]);
        Assert.Contains("SELECT 1;", statements[0]);
        Assert.Contains("SELECT 2;", statements[0]);
        Assert.Contains("SELECT 3", statements[1]);
    }

    [Fact]
    public void SplitScript_SkipsPureCommentsAndWhitespace()
    {
        // Arrange
        var sql = @"
            -- Comment 1
            /* Block comment */
            SELECT 1;
            -- Trailing comment
        ";

        // Act
        var statements = DatabaseInitializer.SplitScript(sql);

        // Assert
        Assert.Single(statements);
        Assert.Contains("SELECT 1", statements[0]);
    }

    [Fact]
    public void MySqlDbHelper_CreateParameter_CreatesValidParameter()
    {
        // Arrange
        var helper = new MySqlDbHelper("Server=localhost;Database=RMS;User ID=root;Password=secret;");

        // Act
        var param = helper.CreateParameter("@OrderId", 42);

        // Assert
        Assert.NotNull(param);
        Assert.IsType<MySqlParameter>(param);
        Assert.Equal("@OrderId", param.ParameterName);
        Assert.Equal(42, param.Value);
    }

    [Fact]
    public void SanitizeConnectionString_HandlesEmptyOrNull()
    {
        Assert.Equal(string.Empty, MySqlDbHelper.SanitizeConnectionString(""));
        Assert.Equal(string.Empty, MySqlDbHelper.SanitizeConnectionString(null!));
    }

    [Theory]
    [InlineData("-- Just a comment", false)]
    [InlineData("/* multi\nline\ncomment */", false)]
    [InlineData("# MySQL comment", false)]
    [InlineData("   \r\n\t  ", false)]
    [InlineData("SELECT 1;", true)]
    [InlineData("/* prefix */ SELECT * FROM Users; -- suffix", true)]
    [InlineData("INSERT INTO T VALUES (1);", true)]
    public void IsExecutableSql_DetectsExecutableQueries(string input, bool expected)
    {
        var result = DatabaseInitializer.IsExecutableSql(input);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void MySqlDbHelper_Constructor_ThrowsOnNullConnectionString()
    {
        Assert.Throws<ArgumentNullException>(() => new MySqlDbHelper(null!));
    }

    [Fact]
    public void DatabaseInitializer_Constructor_ThrowsOnNullConnectionString()
    {
        Assert.Throws<ArgumentNullException>(() => new DatabaseInitializer(null!));
    }

    [Fact]
    public void DbContextOptions_CanBeConfigured_WithPomeloMySql()
    {
        // Arrange
        var optionsBuilder = new DbContextOptionsBuilder<RestaurantDbContext>();
        var connStr = "Server=localhost;Port=3306;Database=RestaurantManagementDB;User ID=root;Password=root;";
        var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));

        // Act & Assert (Should not throw)
        optionsBuilder.UseMySql(connStr, serverVersion);
        var options = optionsBuilder.Options;

        Assert.NotNull(options);
    }
}
