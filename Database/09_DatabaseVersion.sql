-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 09_DatabaseVersion.sql
-- Description: Creates the SchemaVersions migration tracking table
--              and records baseline migration state.
-- Safe to execute multiple times.
-- ============================================================

USE `RestaurantManagementDb`;

-- 1. Create SchemaVersions table
CREATE TABLE IF NOT EXISTS `SchemaVersions` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `ScriptName` VARCHAR(255) NOT NULL,
    `AppliedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Description` VARCHAR(255) NULL,
    `Status` VARCHAR(50) NOT NULL DEFAULT 'Success',
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UQ_SchemaVersions_ScriptName` (`ScriptName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Record migration scripts
INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '01_CreateDatabase.sql', 'Creates database with utf8mb4 encoding', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '01_CreateDatabase.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '02_CreateTables.sql', 'Creates all 35 entity tables and relational constraints', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '02_CreateTables.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '03_CreateIndexes.sql', 'Creates lookup and performance indexes', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '03_CreateIndexes.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '04_CreateStoredProcedures.sql', 'Creates stored procedures for POS, Dashboard, Orders, Reports', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '04_CreateStoredProcedures.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '05_CreateFunctions.sql', 'Creates calculation and formatting scalar functions', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '05_CreateFunctions.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '06_CreateViews.sql', 'Creates reporting and dashboard views', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '06_CreateViews.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '07_CreateTriggers.sql', 'Creates audit, table release, and sequence triggers', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '07_CreateTriggers.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '08_InsertDefaultData.sql', 'Inserts default users, settings, menu items, and tables', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '08_InsertDefaultData.sql');

INSERT INTO `SchemaVersions` (`ScriptName`, `Description`, `Status`)
SELECT '09_DatabaseVersion.sql', 'Migration version tracking baseline', 'Success'
WHERE NOT EXISTS (SELECT 1 FROM `SchemaVersions` WHERE `ScriptName` = '09_DatabaseVersion.sql');

-- Sync with EF Core Migration History Table
INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
SELECT '20261015101938_InitialCreate', '9.0.0'
WHERE NOT EXISTS (SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261015101938_InitialCreate');

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
SELECT '20261025123201_AddAccountsAndPayroll', '9.0.0'
WHERE NOT EXISTS (SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261025123201_AddAccountsAndPayroll');

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
SELECT '20261029061239_AddMastersSuppliersAndCustomerCredit', '9.0.0'
WHERE NOT EXISTS (SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261029061239_AddMastersSuppliersAndCustomerCredit');

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
SELECT '20261029071656_AddRestaurantNameMarathi', '9.0.0'
WHERE NOT EXISTS (SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261029071656_AddRestaurantNameMarathi');

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
SELECT '20261030053032_AddShortCodeAndCustomerFields', '9.0.0'
WHERE NOT EXISTS (SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261030053032_AddShortCodeAndCustomerFields');

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
SELECT '20261030112424_AddSupplierToInventoryAndOnlineOrderFields', '9.0.0'
WHERE NOT EXISTS (SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261030112424_AddSupplierToInventoryAndOnlineOrderFields');
