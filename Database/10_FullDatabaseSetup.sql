-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 10_FullDatabaseSetup.sql
-- Description: Complete, end-to-end database setup script.
--              Executes database creation, tables, indexes,
--              functions, views, stored procedures, triggers,
--              and master default data in the exact required order.
--
-- Prerequisites:
--   - MySQL Server 8.0 or compatible newer version.
--   - User account with CREATE, ALTER, DROP, REFERENCES,
--     INDEX, TRIGGER, ROUTINE permissions.
--
-- Execution Order:
--   1. Database Creation (01)
--   2. Tables & Relational Constraints (02)
--   3. Indexes (03)
--   4. Scalar Functions (05)
--   5. Views (06)
--   6. Stored Procedures (04)
--   7. Triggers (07)
--   8. Master & Default Seed Data (08)
--   9. Schema Versioning & EF Migration History Sync (09)
--  10. Verification of Created Objects
-- ============================================================

-- ------------------------------------------------------------
-- STEP 1: CREATE DATABASE
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `RestaurantManagementDb`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `RestaurantManagementDb`;

-- ------------------------------------------------------------
-- STEP 2: CREATE TABLES & RELATIONAL CONSTRAINTS
-- ------------------------------------------------------------

-- 1. Users
CREATE TABLE IF NOT EXISTS `Users` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Username` VARCHAR(100) NOT NULL,
    `Email` VARCHAR(255) NOT NULL,
    `PasswordHash` VARCHAR(255) NOT NULL,
    `FullName` VARCHAR(150) NOT NULL,
    `Phone` VARCHAR(20) NOT NULL DEFAULT '',
    `Role` INT NOT NULL DEFAULT 4,
    `LastLogin` DATETIME(6) NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Floors
CREATE TABLE IF NOT EXISTS `Floors` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(100) NOT NULL,
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `DisplayOrder` INT NOT NULL DEFAULT 1,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Categories
CREATE TABLE IF NOT EXISTS `Categories` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(100) NOT NULL,
    `NameMarathi` VARCHAR(150) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `DisplayOrder` INT NOT NULL DEFAULT 1,
    `ImageUrl` VARCHAR(500) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. AddOns
CREATE TABLE IF NOT EXISTS `AddOns` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(100) NOT NULL,
    `Price` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `IsAvailable` TINYINT(1) NOT NULL DEFAULT 1,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Customers
CREATE TABLE IF NOT EXISTS `Customers` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(150) NOT NULL,
    `Phone` VARCHAR(20) NOT NULL DEFAULT '',
    `Email` VARCHAR(150) NOT NULL DEFAULT '',
    `DateOfBirth` DATETIME(6) NULL,
    `Address` VARCHAR(500) NOT NULL DEFAULT '',
    `GSTIN` VARCHAR(50) NOT NULL DEFAULT '',
    `Notes` LONGTEXT NULL,
    `TotalVisits` INT NOT NULL DEFAULT 0,
    `TotalSpent` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `LoyaltyPoints` INT NOT NULL DEFAULT 0,
    `Tier` INT NOT NULL DEFAULT 1,
    `LastVisitDate` DATETIME(6) NULL,
    `OutstandingCredit` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Suppliers
CREATE TABLE IF NOT EXISTS `Suppliers` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(150) NOT NULL,
    `ContactPerson` VARCHAR(100) NOT NULL DEFAULT '',
    `Phone` VARCHAR(20) NOT NULL DEFAULT '',
    `Email` VARCHAR(150) NOT NULL DEFAULT '',
    `Address` VARCHAR(500) NOT NULL DEFAULT '',
    `GSTNumber` VARCHAR(50) NOT NULL DEFAULT '',
    `OpeningBalance` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Employees
CREATE TABLE IF NOT EXISTS `Employees` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(150) NOT NULL,
    `Email` VARCHAR(150) NOT NULL DEFAULT '',
    `Phone` VARCHAR(20) NOT NULL DEFAULT '',
    `Role` INT NOT NULL DEFAULT 4,
    `JoiningDate` DATETIME(6) NOT NULL,
    `BaseSalary` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `Shift` VARCHAR(50) NOT NULL DEFAULT 'Morning',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. RestaurantSettings
CREATE TABLE IF NOT EXISTS `RestaurantSettings` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `RestaurantName` VARCHAR(200) NOT NULL DEFAULT 'Girana Garden Fine Dine',
    `RestaurantNameMarathi` VARCHAR(200) NOT NULL DEFAULT '',
    `Address` VARCHAR(500) NOT NULL DEFAULT '101 Grand Galleria, MG Road, Ahmedabad',
    `Phone` VARCHAR(50) NOT NULL DEFAULT '+91 98765 43210',
    `Email` VARCHAR(150) NOT NULL DEFAULT 'contact@giranagarden.com',
    `GSTIN` VARCHAR(50) NOT NULL DEFAULT '24AAACG1234F1Z9',
    `CurrencySymbol` VARCHAR(10) NOT NULL DEFAULT '₹',
    `CGSTPercentage` DECIMAL(18,2) NOT NULL DEFAULT 2.50,
    `SGSTPercentage` DECIMAL(18,2) NOT NULL DEFAULT 2.50,
    `ServiceChargePercentage` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `LogoUrl` VARCHAR(500) NOT NULL DEFAULT '/images/logo.png',
    `InvoicePrefix` VARCHAR(20) NOT NULL DEFAULT 'INV',
    `KitchenMode` INT NOT NULL DEFAULT 2,
    `TrackReadyStatus` TINYINT(1) NOT NULL DEFAULT 0,
    `AutoMarkServedMinutes` INT NOT NULL DEFAULT 0,
    `VoidApproval` INT NOT NULL DEFAULT 1,
    `AllowBillingWithUnservedItems` INT NOT NULL DEFAULT 2,
    `KitchenLiteScreen` TINYINT(1) NOT NULL DEFAULT 0,
    `SinglePersonMode` TINYINT(1) NOT NULL DEFAULT 0,
    `DraftExpiryHours` INT NOT NULL DEFAULT 4,
    `PackagingCharge` DECIMAL(18,2) NOT NULL DEFAULT 15.00,
    `DeliveryCharge` DECIMAL(18,2) NOT NULL DEFAULT 30.00,
    `ManagerPIN` VARCHAR(20) NOT NULL DEFAULT '1234',
    `IsGSTEnabled` TINYINT(1) NOT NULL DEFAULT 1,
    `IsTaxInclusive` TINYINT(1) NOT NULL DEFAULT 0,
    `IsKOTWorkflowEnabled` TINYINT(1) NOT NULL DEFAULT 1,
    `IsQRCodeEnabled` TINYINT(1) NOT NULL DEFAULT 1,
    `QRCodeData` VARCHAR(500) NOT NULL DEFAULT '',
    `ThermalPrinterWidth` INT NOT NULL DEFAULT 80,
    `WhatsAppApiKey` VARCHAR(255) NOT NULL DEFAULT '',
    `EmailSmtpHost` VARCHAR(255) NOT NULL DEFAULT '',
    `EmailSmtpPort` INT NOT NULL DEFAULT 587,
    `EmailSmtpUser` VARCHAR(255) NOT NULL DEFAULT '',
    `EmailSmtpPassword` VARCHAR(255) NOT NULL DEFAULT '',
    `DefaultLanguage` VARCHAR(10) NOT NULL DEFAULT 'en',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Expenses
CREATE TABLE IF NOT EXISTS `Expenses` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Category` VARCHAR(100) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `Amount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `ExpenseDate` DATETIME(6) NOT NULL,
    `RecordedBy` VARCHAR(100) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. AuditLogs
CREATE TABLE IF NOT EXISTS `AuditLogs` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `UserId` INT NULL,
    `UserName` VARCHAR(100) NOT NULL DEFAULT '',
    `Action` VARCHAR(100) NOT NULL DEFAULT '',
    `EntityName` VARCHAR(100) NOT NULL DEFAULT '',
    `EntityId` VARCHAR(100) NOT NULL DEFAULT '',
    `Details` LONGTEXT NULL,
    `Timestamp` DATETIME(6) NOT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. Tables
CREATE TABLE IF NOT EXISTS `Tables` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `TableNumber` VARCHAR(50) NOT NULL,
    `Capacity` INT NOT NULL DEFAULT 4,
    `TableType` VARCHAR(50) NOT NULL DEFAULT 'Dine-In',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `FloorId` INT NOT NULL,
    `Status` INT NOT NULL DEFAULT 1,
    `CurrentOrderId` INT NULL,
    `WaiterId` INT NULL,
    `HasActiveDraft` TINYINT(1) NOT NULL DEFAULT 0,
    `ActiveDraftUserId` INT NULL,
    `ActiveDraftUserName` VARCHAR(100) NOT NULL DEFAULT '',
    `ActiveDraftTime` DATETIME(6) NULL,
    `GroupTableId` INT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Tables_Floors_FloorId` FOREIGN KEY (`FloorId`) REFERENCES `Floors` (`Id`) ON DELETE RESTRICT,
    CONSTRAINT `FK_Tables_Users_WaiterId` FOREIGN KEY (`WaiterId`) REFERENCES `Users` (`Id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. MenuItems
CREATE TABLE IF NOT EXISTS `MenuItems` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `CategoryId` INT NOT NULL,
    `Name` VARCHAR(150) NOT NULL,
    `NameMarathi` VARCHAR(200) NOT NULL DEFAULT '',
    `ItemCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ShortCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Description` VARCHAR(500) NOT NULL DEFAULT '',
    `Price` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `TaxPercentage` DECIMAL(18,2) NOT NULL DEFAULT 5.00,
    `IsVeg` TINYINT(1) NOT NULL DEFAULT 1,
    `ImageUrl` VARCHAR(500) NOT NULL DEFAULT '',
    `IsAvailable` TINYINT(1) NOT NULL DEFAULT 1,
    `KitchenCategory` VARCHAR(100) NOT NULL DEFAULT 'Main Kitchen',
    `PreparationTimeMinutes` INT NOT NULL DEFAULT 15,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_MenuItems_Categories_CategoryId` FOREIGN KEY (`CategoryId`) REFERENCES `Categories` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. MenuItemVariants
CREATE TABLE IF NOT EXISTS `MenuItemVariants` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `MenuItemId` INT NOT NULL,
    `VariantName` VARCHAR(100) NOT NULL,
    `Price` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_MenuItemVariants_MenuItems_MenuItemId` FOREIGN KEY (`MenuItemId`) REFERENCES `MenuItems` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 14. MenuItemAddOns
CREATE TABLE IF NOT EXISTS `MenuItemAddOns` (
    `MenuItemId` INT NOT NULL,
    `AddOnId` INT NOT NULL,
    PRIMARY KEY (`MenuItemId`, `AddOnId`),
    CONSTRAINT `FK_MenuItemAddOns_MenuItems_MenuItemId` FOREIGN KEY (`MenuItemId`) REFERENCES `MenuItems` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_MenuItemAddOns_AddOns_AddOnId` FOREIGN KEY (`AddOnId`) REFERENCES `AddOns` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 15. Orders
CREATE TABLE IF NOT EXISTS `Orders` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `OrderNumber` VARCHAR(50) NOT NULL,
    `OrderType` INT NOT NULL DEFAULT 1,
    `Status` INT NOT NULL DEFAULT 1,
    `TableId` INT NULL,
    `WaiterId` INT NULL,
    `CustomerId` INT NULL,
    `CustomerName` VARCHAR(200) NOT NULL DEFAULT '',
    `CustomerPhone` VARCHAR(20) NOT NULL DEFAULT '',
    `SpecialInstructions` LONGTEXT NULL,
    `SubTotal` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CGST` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `SGST` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `TotalTax` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `DiscountAmount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `PackagingCharge` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `DeliveryCharge` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `RoundOff` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `GrandTotal` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `Covers` INT NOT NULL DEFAULT 1,
    `OrderNote` VARCHAR(255) NOT NULL DEFAULT '',
    `TokenNumber` VARCHAR(50) NOT NULL DEFAULT '',
    `DeliveryAddress` VARCHAR(500) NOT NULL DEFAULT '',
    `OnlinePlatform` VARCHAR(50) NOT NULL DEFAULT '',
    `OnlineOrderReference` VARCHAR(100) NOT NULL DEFAULT '',
    `DeliveryPartnerName` VARCHAR(100) NOT NULL DEFAULT '',
    `CustomerGSTIN` VARCHAR(50) NOT NULL DEFAULT '',
    `Version` INT NOT NULL DEFAULT 1,
    `IsDraft` TINYINT(1) NOT NULL DEFAULT 0,
    `DraftUserId` INT NULL,
    `DraftUserName` VARCHAR(100) NOT NULL DEFAULT '',
    `DraftExpiresAt` DATETIME(6) NULL,
    `CreatedByUserName` VARCHAR(100) NOT NULL DEFAULT '',
    `IsSettled` TINYINT(1) NOT NULL DEFAULT 0,
    `SettledAt` DATETIME(6) NULL,
    `IsWalkout` TINYINT(1) NOT NULL DEFAULT 0,
    `WalkoutReason` VARCHAR(255) NOT NULL DEFAULT '',
    `TableTransferNotes` LONGTEXT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Orders_Tables_TableId` FOREIGN KEY (`TableId`) REFERENCES `Tables` (`Id`) ON DELETE SET NULL,
    CONSTRAINT `FK_Orders_Users_WaiterId` FOREIGN KEY (`WaiterId`) REFERENCES `Users` (`Id`) ON DELETE SET NULL,
    CONSTRAINT `FK_Orders_Customers_CustomerId` FOREIGN KEY (`CustomerId`) REFERENCES `Customers` (`Id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add self-referencing FK to Tables for CurrentOrderId if not present
SET @fk_check = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'FK_Tables_Orders_CurrentOrderId');
SET @alter_sql = IF(@fk_check = 0, 'ALTER TABLE `Tables` ADD CONSTRAINT `FK_Tables_Orders_CurrentOrderId` FOREIGN KEY (`CurrentOrderId`) REFERENCES `Orders` (`Id`) ON DELETE SET NULL;', 'SELECT 1;');
PREPARE stmt_fk FROM @alter_sql;
EXECUTE stmt_fk;
DEALLOCATE PREPARE stmt_fk;

-- 16. OrderItems
CREATE TABLE IF NOT EXISTS `OrderItems` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `OrderId` INT NOT NULL,
    `MenuItemId` INT NOT NULL,
    `ItemName` VARCHAR(150) NOT NULL,
    `UnitPrice` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `Quantity` INT NOT NULL DEFAULT 1,
    `TotalPrice` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `SpecialInstructions` LONGTEXT NULL,
    `SelectedVariantName` VARCHAR(100) NOT NULL DEFAULT '',
    `Status` INT NOT NULL DEFAULT 1,
    `KOTId` INT NULL,
    `KOTNumber` VARCHAR(50) NOT NULL DEFAULT '',
    `Course` VARCHAR(50) NOT NULL DEFAULT 'Main',
    `IsHeld` TINYINT(1) NOT NULL DEFAULT 0,
    `Station` VARCHAR(50) NOT NULL DEFAULT 'Main',
    `SentAt` DATETIME(6) NULL,
    `PreparingAt` DATETIME(6) NULL,
    `ReadyAt` DATETIME(6) NULL,
    `ServedAt` DATETIME(6) NULL,
    `CancelledAt` DATETIME(6) NULL,
    `CancelReason` VARCHAR(255) NOT NULL DEFAULT '',
    `IsWastage` TINYINT(1) NOT NULL DEFAULT 0,
    `WastageCost` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `IsComplimentary` TINYINT(1) NOT NULL DEFAULT 0,
    `ComplimentaryReason` VARCHAR(255) NOT NULL DEFAULT '',
    `IsBillAdjusted` TINYINT(1) NOT NULL DEFAULT 0,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_OrderItems_Orders_OrderId` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_OrderItems_MenuItems_MenuItemId` FOREIGN KEY (`MenuItemId`) REFERENCES `MenuItems` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 17. OrderItemAddOns
CREATE TABLE IF NOT EXISTS `OrderItemAddOns` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `OrderItemId` INT NOT NULL,
    `AddOnId` INT NOT NULL,
    `AddOnName` VARCHAR(100) NOT NULL,
    `Price` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_OrderItemAddOns_OrderItems_OrderItemId` FOREIGN KEY (`OrderItemId`) REFERENCES `OrderItems` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_OrderItemAddOns_AddOns_AddOnId` FOREIGN KEY (`AddOnId`) REFERENCES `AddOns` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 18. KOTs
CREATE TABLE IF NOT EXISTS `KOTs` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `KOTNumber` VARCHAR(50) NOT NULL,
    `OrderId` INT NOT NULL,
    `TableNumber` VARCHAR(50) NOT NULL DEFAULT '',
    `WaiterName` VARCHAR(100) NOT NULL DEFAULT '',
    `Status` INT NOT NULL DEFAULT 1,
    `Notes` LONGTEXT NULL,
    `Type` INT NOT NULL DEFAULT 1,
    `Station` VARCHAR(50) NOT NULL DEFAULT 'All',
    `IsRush` TINYINT(1) NOT NULL DEFAULT 0,
    `IsPrinted` TINYINT(1) NOT NULL DEFAULT 1,
    `PrintFailed` TINYINT(1) NOT NULL DEFAULT 0,
    `AcknowledgedByChef` TINYINT(1) NOT NULL DEFAULT 0,
    `InformedKitchenConfirmed` TINYINT(1) NOT NULL DEFAULT 0,
    `Reason` VARCHAR(255) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_KOTs_Orders_OrderId` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 19. KOTItems
CREATE TABLE IF NOT EXISTS `KOTItems` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `KOTId` INT NOT NULL,
    `MenuItemName` VARCHAR(150) NOT NULL,
    `Quantity` INT NOT NULL DEFAULT 1,
    `SpecialInstructions` LONGTEXT NULL,
    `Status` INT NOT NULL DEFAULT 1,
    `OrderItemId` INT NULL,
    `Course` VARCHAR(50) NOT NULL DEFAULT 'Main',
    `IsCancelled` TINYINT(1) NOT NULL DEFAULT 0,
    `Station` VARCHAR(50) NOT NULL DEFAULT 'Main',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_KOTItems_KOTs_KOTId` FOREIGN KEY (`KOTId`) REFERENCES `KOTs` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 20. Bills
CREATE TABLE IF NOT EXISTS `Bills` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `InvoiceNumber` VARCHAR(50) NOT NULL,
    `OrderId` INT NOT NULL,
    `BillDate` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `SubTotal` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `DiscountAmount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `ServiceCharge` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CGST` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `SGST` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `GrandTotal` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `IsPaid` TINYINT(1) NOT NULL DEFAULT 0,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UQ_Bills_OrderId` (`OrderId`),
    CONSTRAINT `FK_Bills_Orders_OrderId` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 21. Payments
CREATE TABLE IF NOT EXISTS `Payments` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `BillId` INT NOT NULL,
    `PaymentMethod` INT NOT NULL DEFAULT 1,
    `Amount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `PaymentStatus` INT NOT NULL DEFAULT 3,
    `TransactionId` VARCHAR(100) NOT NULL DEFAULT '',
    `PaymentDate` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `Notes` LONGTEXT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Payments_Bills_BillId` FOREIGN KEY (`BillId`) REFERENCES `Bills` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 22. LoyaltyAccounts
CREATE TABLE IF NOT EXISTS `LoyaltyAccounts` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `CustomerId` INT NOT NULL,
    `CurrentPoints` INT NOT NULL DEFAULT 0,
    `TotalEarnedPoints` INT NOT NULL DEFAULT 0,
    `Tier` INT NOT NULL DEFAULT 1,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UQ_LoyaltyAccounts_CustomerId` (`CustomerId`),
    CONSTRAINT `FK_LoyaltyAccounts_Customers_CustomerId` FOREIGN KEY (`CustomerId`) REFERENCES `Customers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 23. LoyaltyTransactions
CREATE TABLE IF NOT EXISTS `LoyaltyTransactions` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `LoyaltyAccountId` INT NOT NULL,
    `Points` INT NOT NULL DEFAULT 0,
    `TransactionType` VARCHAR(50) NOT NULL DEFAULT 'EARNED',
    `ReferenceOrderNo` VARCHAR(50) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_LoyaltyTransactions_LoyaltyAccounts_LoyaltyAccountId` FOREIGN KEY (`LoyaltyAccountId`) REFERENCES `LoyaltyAccounts` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 24. Reservations
CREATE TABLE IF NOT EXISTS `Reservations` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `CustomerName` VARCHAR(150) NOT NULL,
    `CustomerPhone` VARCHAR(20) NOT NULL DEFAULT '',
    `ReservationDate` DATETIME(6) NOT NULL,
    `GuestCount` INT NOT NULL DEFAULT 2,
    `TableId` INT NULL,
    `Status` INT NOT NULL DEFAULT 1,
    `SpecialRequests` LONGTEXT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Reservations_Tables_TableId` FOREIGN KEY (`TableId`) REFERENCES `Tables` (`Id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 25. InventoryItems
CREATE TABLE IF NOT EXISTS `InventoryItems` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(150) NOT NULL,
    `Category` VARCHAR(100) NOT NULL DEFAULT '',
    `Unit` VARCHAR(20) NOT NULL DEFAULT 'KG',
    `CurrentStock` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `MinimumStock` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `UnitCost` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `ReorderLevel` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `SupplierId` INT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_InventoryItems_Suppliers_SupplierId` FOREIGN KEY (`SupplierId`) REFERENCES `Suppliers` (`Id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 26. StockTransactions
CREATE TABLE IF NOT EXISTS `StockTransactions` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `InventoryItemId` INT NOT NULL,
    `Quantity` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `TransactionType` VARCHAR(50) NOT NULL DEFAULT 'IN',
    `Notes` LONGTEXT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_StockTransactions_InventoryItems_InventoryItemId` FOREIGN KEY (`InventoryItemId`) REFERENCES `InventoryItems` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 27. Recipes
CREATE TABLE IF NOT EXISTS `Recipes` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `MenuItemId` INT NOT NULL,
    `Instructions` LONGTEXT NULL,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UQ_Recipes_MenuItemId` (`MenuItemId`),
    CONSTRAINT `FK_Recipes_MenuItems_MenuItemId` FOREIGN KEY (`MenuItemId`) REFERENCES `MenuItems` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 28. RecipeItems
CREATE TABLE IF NOT EXISTS `RecipeItems` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `RecipeId` INT NOT NULL,
    `InventoryItemId` INT NOT NULL,
    `QuantityRequired` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `Unit` VARCHAR(20) NOT NULL DEFAULT 'KG',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_RecipeItems_Recipes_RecipeId` FOREIGN KEY (`RecipeId`) REFERENCES `Recipes` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_RecipeItems_InventoryItems_InventoryItemId` FOREIGN KEY (`InventoryItemId`) REFERENCES `InventoryItems` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 29. PurchaseOrders
CREATE TABLE IF NOT EXISTS `PurchaseOrders` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `PONumber` VARCHAR(50) NOT NULL,
    `SupplierId` INT NOT NULL,
    `OrderDate` DATETIME(6) NOT NULL,
    `TotalAmount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `Status` VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_PurchaseOrders_Suppliers_SupplierId` FOREIGN KEY (`SupplierId`) REFERENCES `Suppliers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 30. PurchaseOrderItems
CREATE TABLE IF NOT EXISTS `PurchaseOrderItems` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `PurchaseOrderId` INT NOT NULL,
    `InventoryItemId` INT NOT NULL,
    `Quantity` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `UnitPrice` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `TotalPrice` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_PurchaseOrderItems_PurchaseOrders_PurchaseOrderId` FOREIGN KEY (`PurchaseOrderId`) REFERENCES `PurchaseOrders` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_PurchaseOrderItems_InventoryItems_InventoryItemId` FOREIGN KEY (`InventoryItemId`) REFERENCES `InventoryItems` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 31. Attendances
CREATE TABLE IF NOT EXISTS `Attendances` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `EmployeeId` INT NOT NULL,
    `Date` DATETIME(6) NOT NULL,
    `CheckInTime` DATETIME(6) NOT NULL,
    `CheckOutTime` DATETIME(6) NULL,
    `Status` VARCHAR(50) NOT NULL DEFAULT 'Present',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Attendances_Employees_EmployeeId` FOREIGN KEY (`EmployeeId`) REFERENCES `Employees` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 32. EmployeeLedgers
CREATE TABLE IF NOT EXISTS `EmployeeLedgers` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `EmployeeId` INT NOT NULL,
    `TransactionDate` DATETIME(6) NOT NULL,
    `TransactionType` VARCHAR(50) NOT NULL DEFAULT 'Advance',
    `Amount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `PaymentMethod` VARCHAR(50) NOT NULL DEFAULT 'Cash',
    `ReferenceNumber` VARCHAR(100) NOT NULL DEFAULT '',
    `Notes` LONGTEXT NULL,
    `RecordedBy` VARCHAR(100) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_EmployeeLedgers_Employees_EmployeeId` FOREIGN KEY (`EmployeeId`) REFERENCES `Employees` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 33. PayrollRecords
CREATE TABLE IF NOT EXISTS `PayrollRecords` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `EmployeeId` INT NOT NULL,
    `Month` INT NOT NULL,
    `Year` INT NOT NULL,
    `BaseSalary` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `TotalDaysInMonth` INT NOT NULL DEFAULT 30,
    `PresentDays` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `HalfDays` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `PaidLeaveDays` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `UnpaidLeaveDays` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `DailyRate` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `GrossSalary` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `AdvanceDeducted` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `OtherDeductions` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `Bonus` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `NetSalary` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `Status` VARCHAR(50) NOT NULL DEFAULT 'Paid',
    `PaymentDate` DATETIME(6) NULL,
    `PaymentMethod` VARCHAR(50) NOT NULL DEFAULT 'Cash',
    `Notes` LONGTEXT NULL,
    `ProcessedBy` VARCHAR(100) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_PayrollRecords_Employees_EmployeeId` FOREIGN KEY (`EmployeeId`) REFERENCES `Employees` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 34. CustomerLedgers
CREATE TABLE IF NOT EXISTS `CustomerLedgers` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `CustomerId` INT NOT NULL,
    `Date` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `DebitAmount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `CreditAmount` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `RunningBalance` DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    `ReferenceInvoiceNumber` VARCHAR(100) NOT NULL DEFAULT '',
    `Notes` LONGTEXT NULL,
    `RecordedBy` VARCHAR(100) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_CustomerLedgers_Customers_CustomerId` FOREIGN KEY (`CustomerId`) REFERENCES `Customers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 35. LeaveRequests
CREATE TABLE IF NOT EXISTS `LeaveRequests` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `EmployeeId` INT NOT NULL,
    `StartDate` DATETIME(6) NOT NULL,
    `EndDate` DATETIME(6) NOT NULL,
    `LeaveType` VARCHAR(50) NOT NULL DEFAULT 'Casual',
    `Reason` VARCHAR(255) NOT NULL DEFAULT '',
    `Status` VARCHAR(50) NOT NULL DEFAULT 'Pending',
    `ApprovedBy` VARCHAR(100) NOT NULL DEFAULT '',
    `ApprovedDate` DATETIME(6) NULL,
    `RejectionReason` VARCHAR(255) NOT NULL DEFAULT '',
    `CreatedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `UpdatedAt` DATETIME(6) NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_LeaveRequests_Employees_EmployeeId` FOREIGN KEY (`EmployeeId`) REFERENCES `Employees` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Migration History Table
CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` VARCHAR(150) NOT NULL,
    `ProductVersion` VARCHAR(32) NOT NULL,
    PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- STEP 3: CREATE INDEXES
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS `sp_CreateIndexIfNotExists`;

DELIMITER $$
CREATE PROCEDURE `sp_CreateIndexIfNotExists`(
    IN p_TableName VARCHAR(64),
    IN p_IndexName VARCHAR(64),
    IN p_Columns VARCHAR(255)
)
BEGIN
    DECLARE v_IndexExists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_IndexExists
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_TableName
      AND INDEX_NAME = p_IndexName;

    IF v_IndexExists = 0 THEN
        SET @sql = CONCAT('CREATE INDEX `', p_IndexName, '` ON `', p_TableName, '` (', p_Columns, ');');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

CALL sp_CreateIndexIfNotExists('Users', 'IX_Users_Username', '`Username`');
CALL sp_CreateIndexIfNotExists('Users', 'IX_Users_Email', '`Email`');
CALL sp_CreateIndexIfNotExists('Users', 'IX_Users_Role', '`Role`');

CALL sp_CreateIndexIfNotExists('Tables', 'IX_Tables_FloorId', '`FloorId`');
CALL sp_CreateIndexIfNotExists('Tables', 'IX_Tables_Status', '`Status`');
CALL sp_CreateIndexIfNotExists('Tables', 'IX_Tables_TableNumber', '`TableNumber`');

CALL sp_CreateIndexIfNotExists('MenuItems', 'IX_MenuItems_CategoryId', '`CategoryId`');
CALL sp_CreateIndexIfNotExists('MenuItems', 'IX_MenuItems_IsAvailable', '`IsAvailable`');
CALL sp_CreateIndexIfNotExists('MenuItems', 'IX_MenuItems_ItemCode', '`ItemCode`');
CALL sp_CreateIndexIfNotExists('MenuItems', 'IX_MenuItems_ShortCode', '`ShortCode`');

CALL sp_CreateIndexIfNotExists('Orders', 'IX_Orders_TableId', '`TableId`');
CALL sp_CreateIndexIfNotExists('Orders', 'IX_Orders_Status', '`Status`');
CALL sp_CreateIndexIfNotExists('Orders', 'IX_Orders_OrderNumber', '`OrderNumber`');
CALL sp_CreateIndexIfNotExists('Orders', 'IX_Orders_CreatedAt', '`CreatedAt`');
CALL sp_CreateIndexIfNotExists('Orders', 'IX_Orders_IsSettled', '`IsSettled`');
CALL sp_CreateIndexIfNotExists('Orders', 'IX_Orders_CustomerId', '`CustomerId`');

CALL sp_CreateIndexIfNotExists('OrderItems', 'IX_OrderItems_OrderId', '`OrderId`');
CALL sp_CreateIndexIfNotExists('OrderItems', 'IX_OrderItems_MenuItemId', '`MenuItemId`');
CALL sp_CreateIndexIfNotExists('OrderItems', 'IX_OrderItems_Status', '`Status`');

CALL sp_CreateIndexIfNotExists('KOTs', 'IX_KOTs_OrderId', '`OrderId`');
CALL sp_CreateIndexIfNotExists('KOTs', 'IX_KOTs_Status', '`Status`');
CALL sp_CreateIndexIfNotExists('KOTs', 'IX_KOTs_KOTNumber', '`KOTNumber`');

CALL sp_CreateIndexIfNotExists('KOTItems', 'IX_KOTItems_KOTId', '`KOTId`');
CALL sp_CreateIndexIfNotExists('KOTItems', 'IX_KOTItems_Status', '`Status`');

CALL sp_CreateIndexIfNotExists('Bills', 'IX_Bills_InvoiceNumber', '`InvoiceNumber`');
CALL sp_CreateIndexIfNotExists('Bills', 'IX_Bills_BillDate', '`BillDate`');

CALL sp_CreateIndexIfNotExists('Payments', 'IX_Payments_BillId', '`BillId`');
CALL sp_CreateIndexIfNotExists('Payments', 'IX_Payments_PaymentStatus', '`PaymentStatus`');
CALL sp_CreateIndexIfNotExists('Payments', 'IX_Payments_PaymentDate', '`PaymentDate`');

CALL sp_CreateIndexIfNotExists('Customers', 'IX_Customers_Phone', '`Phone`');
CALL sp_CreateIndexIfNotExists('Customers', 'IX_Customers_Email', '`Email`');

CALL sp_CreateIndexIfNotExists('Reservations', 'IX_Reservations_TableId', '`TableId`');
CALL sp_CreateIndexIfNotExists('Reservations', 'IX_Reservations_ReservationDate', '`ReservationDate`');
CALL sp_CreateIndexIfNotExists('Reservations', 'IX_Reservations_Status', '`Status`');

CALL sp_CreateIndexIfNotExists('InventoryItems', 'IX_InventoryItems_Category', '`Category`');
CALL sp_CreateIndexIfNotExists('InventoryItems', 'IX_InventoryItems_SupplierId', '`SupplierId`');

CALL sp_CreateIndexIfNotExists('StockTransactions', 'IX_StockTransactions_InventoryItemId', '`InventoryItemId`');
CALL sp_CreateIndexIfNotExists('StockTransactions', 'IX_StockTransactions_CreatedAt', '`CreatedAt`');

CALL sp_CreateIndexIfNotExists('Employees', 'IX_Employees_Role', '`Role`');

CALL sp_CreateIndexIfNotExists('Attendances', 'IX_Attendances_EmployeeId_Date', '`EmployeeId`, `Date`');

CALL sp_CreateIndexIfNotExists('EmployeeLedgers', 'IX_EmployeeLedgers_EmployeeId', '`EmployeeId`');
CALL sp_CreateIndexIfNotExists('EmployeeLedgers', 'IX_EmployeeLedgers_TransactionDate', '`TransactionDate`');

CALL sp_CreateIndexIfNotExists('PayrollRecords', 'IX_PayrollRecords_EmployeeId_Year_Month', '`EmployeeId`, `Year`, `Month`');

CALL sp_CreateIndexIfNotExists('CustomerLedgers', 'IX_CustomerLedgers_CustomerId', '`CustomerId`');

DROP PROCEDURE IF EXISTS `sp_CreateIndexIfNotExists`;

-- ------------------------------------------------------------
-- STEP 4: CREATE FUNCTIONS
-- ------------------------------------------------------------

DROP FUNCTION IF EXISTS `fn_CalculateGrandTotal`;

DELIMITER $$
CREATE FUNCTION `fn_CalculateGrandTotal`(
    p_SubTotal        DECIMAL(18,2),
    p_CGSTPercent     DECIMAL(18,2),
    p_SGSTPercent     DECIMAL(18,2),
    p_DiscountAmount  DECIMAL(18,2),
    p_PackagingCharge DECIMAL(18,2),
    p_DeliveryCharge  DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
DETERMINISTIC
BEGIN
    DECLARE v_CGST       DECIMAL(18,2);
    DECLARE v_SGST       DECIMAL(18,2);
    DECLARE v_TotalTax   DECIMAL(18,2);
    DECLARE v_GrandTotal DECIMAL(18,2);

    SET v_CGST = ROUND(p_SubTotal * p_CGSTPercent / 100, 2);
    SET v_SGST = ROUND(p_SubTotal * p_SGSTPercent / 100, 2);
    SET v_TotalTax = v_CGST + v_SGST;
    SET v_GrandTotal = p_SubTotal + v_TotalTax - p_DiscountAmount + p_PackagingCharge + p_DeliveryCharge;
    RETURN v_GrandTotal;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `fn_GetCustomerLoyaltyTier`;

DELIMITER $$
CREATE FUNCTION `fn_GetCustomerLoyaltyTier`(p_TotalPoints INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN p_TotalPoints >= 5000 THEN 'Platinum'
        WHEN p_TotalPoints >= 2000 THEN 'Gold'
        ELSE 'Silver'
    END;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `fn_GetTableOccupancyStatus`;

DELIMITER $$
CREATE FUNCTION `fn_GetTableOccupancyStatus`(p_StatusId INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE p_StatusId
        WHEN 1 THEN 'Available'
        WHEN 2 THEN 'Occupied'
        WHEN 3 THEN 'Reserved'
        WHEN 4 THEN 'Billing'
        WHEN 5 THEN 'Cleaning'
        WHEN 6 THEN 'Out of Service'
        ELSE 'Unknown'
    END;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS `fn_GenerateOrderNumber`;

DELIMITER $$
CREATE FUNCTION `fn_GenerateOrderNumber`(p_CurrentDate DATE)
RETURNS VARCHAR(30)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_DateStr  VARCHAR(8);
    DECLARE v_Count    INT DEFAULT 1;
    DECLARE v_OrderNum VARCHAR(30);

    SET v_DateStr = DATE_FORMAT(p_CurrentDate, '%Y%m%d');

    SELECT COUNT(*) + 1 INTO v_Count
    FROM `Orders`
    WHERE DATE(`CreatedAt`) = p_CurrentDate;

    SET v_OrderNum = CONCAT('ORD-', v_DateStr, '-', LPAD(v_Count, 4, '0'));
    RETURN v_OrderNum;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- STEP 5: CREATE VIEWS
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW `vw_ActiveOrders` AS
SELECT
    o.`Id` AS `OrderId`,
    o.`OrderNumber`,
    o.`OrderType`,
    o.`Status` AS `OrderStatus`,
    o.`TableId`,
    t.`TableNumber`,
    f.`Name` AS `FloorName`,
    o.`CustomerName`,
    o.`CustomerPhone`,
    o.`Covers`,
    o.`SubTotal`,
    o.`TotalTax`,
    o.`GrandTotal`,
    o.`CreatedAt`,
    o.`IsSettled`
FROM `Orders` o
LEFT JOIN `Tables` t ON t.`Id` = o.`TableId`
LEFT JOIN `Floors` f ON f.`Id` = t.`FloorId`
WHERE o.`IsSettled` = 0
  AND o.`Status` NOT IN (5, 6)
  AND o.`IsDeleted` = 0;

CREATE OR REPLACE VIEW `vw_TableStatusSummary` AS
SELECT
    f.`Id` AS `FloorId`,
    f.`Name` AS `FloorName`,
    f.`DisplayOrder` AS `FloorDisplayOrder`,
    t.`Id` AS `TableId`,
    t.`TableNumber`,
    t.`Capacity`,
    t.`Status` AS `TableStatusId`,
    fn_GetTableOccupancyStatus(t.`Status`) AS `TableStatusLabel`,
    t.`CurrentOrderId`,
    o.`OrderNumber`,
    o.`GrandTotal` AS `RunningTotal`,
    o.`CreatedAt` AS `OrderStartTime`
FROM `Floors` f
JOIN `Tables` t ON t.`FloorId` = f.`Id` AND t.`IsActive` = 1 AND t.`IsDeleted` = 0
LEFT JOIN `Orders` o ON o.`Id` = t.`CurrentOrderId` AND o.`IsDeleted` = 0
WHERE f.`IsActive` = 1 AND f.`IsDeleted` = 0;

CREATE OR REPLACE VIEW `vw_DailySalesSummary` AS
SELECT
    DATE(o.`CreatedAt`) AS `SaleDate`,
    COUNT(DISTINCT o.`Id`) AS `TotalOrders`,
    IFNULL(SUM(o.`SubTotal`), 0) AS `TotalSubTotal`,
    IFNULL(SUM(o.`TotalTax`), 0) AS `TotalTax`,
    IFNULL(SUM(o.`DiscountAmount`), 0) AS `TotalDiscount`,
    IFNULL(SUM(o.`GrandTotal`), 0) AS `TotalRevenue`,
    COUNT(CASE WHEN o.`OrderType` = 1 THEN 1 END) AS `DineInOrders`,
    COUNT(CASE WHEN o.`OrderType` = 2 THEN 1 END) AS `TakeawayOrders`,
    COUNT(CASE WHEN o.`OrderType` = 3 THEN 1 END) AS `DeliveryOrders`,
    COUNT(CASE WHEN o.`OrderType` = 4 THEN 1 END) AS `OnlineOrders`
FROM `Orders` o
WHERE o.`IsSettled` = 1
  AND o.`IsDeleted` = 0
GROUP BY DATE(o.`CreatedAt`);

CREATE OR REPLACE VIEW `vw_MenuCatalog` AS
SELECT
    c.`Id` AS `CategoryId`,
    c.`Name` AS `CategoryName`,
    c.`DisplayOrder` AS `CategoryOrder`,
    mi.`Id` AS `MenuItemId`,
    mi.`Name` AS `ItemName`,
    mi.`NameMarathi` AS `ItemNameMarathi`,
    mi.`ShortCode`,
    mi.`Description`,
    mi.`Price`,
    mi.`TaxPercentage`,
    mi.`IsVeg`,
    mi.`IsAvailable`,
    mi.`PreparationTimeMinutes`,
    mi.`KitchenCategory`
FROM `Categories` c
JOIN `MenuItems` mi ON mi.`CategoryId` = c.`Id`
WHERE c.`IsActive` = 1 AND c.`IsDeleted` = 0
  AND mi.`IsActive` = 1 AND mi.`IsDeleted` = 0;

CREATE OR REPLACE VIEW `vw_InventoryStockStatus` AS
SELECT
    i.`Id`,
    i.`Name`,
    i.`Category`,
    i.`Unit`,
    i.`CurrentStock`,
    i.`MinimumStock`,
    i.`ReorderLevel`,
    i.`UnitCost`,
    s.`Name` AS `SupplierName`,
    CASE
        WHEN i.`CurrentStock` <= i.`MinimumStock` THEN 'CRITICAL'
        WHEN i.`CurrentStock` <= i.`ReorderLevel` THEN 'LOW'
        ELSE 'OK'
    END AS `StockStatus`
FROM `InventoryItems` i
LEFT JOIN `Suppliers` s ON s.`Id` = i.`SupplierId`
WHERE i.`IsActive` = 1 AND i.`IsDeleted` = 0;

CREATE OR REPLACE VIEW `vw_CustomerLoyaltySummary` AS
SELECT
    c.`Id` AS `CustomerId`,
    c.`Name`,
    c.`Phone`,
    c.`Email`,
    c.`TotalVisits`,
    c.`TotalSpent`,
    c.`LoyaltyPoints`,
    fn_GetCustomerLoyaltyTier(c.`LoyaltyPoints`) AS `CalculatedTier`,
    la.`CurrentPoints` AS `AccountCurrentPoints`,
    la.`TotalEarnedPoints` AS `AccountTotalEarnedPoints`,
    c.`OutstandingCredit`,
    c.`LastVisitDate`
FROM `Customers` c
LEFT JOIN `LoyaltyAccounts` la ON la.`CustomerId` = c.`Id`
WHERE c.`IsActive` = 1 AND c.`IsDeleted` = 0;

CREATE OR REPLACE VIEW `vw_StaffAttendanceMonthly` AS
SELECT
    e.`Id` AS `EmployeeId`,
    e.`Name`,
    e.`Role`,
    e.`Shift`,
    MONTH(a.`Date`) AS `Month`,
    YEAR(a.`Date`) AS `Year`,
    COUNT(a.`Id`) AS `TotalDaysRecorded`,
    SUM(CASE WHEN a.`Status` = 'Present' THEN 1 ELSE 0 END) AS `PresentDays`,
    SUM(CASE WHEN a.`Status` = 'Absent' THEN 1 ELSE 0 END) AS `AbsentDays`,
    SUM(CASE WHEN a.`Status` = 'Half day' THEN 1 ELSE 0 END) AS `HalfDays`,
    SUM(CASE WHEN a.`Status` = 'Leave' THEN 1 ELSE 0 END) AS `LeaveDays`
FROM `Employees` e
LEFT JOIN `Attendances` a ON a.`EmployeeId` = e.`Id` AND a.`IsDeleted` = 0
WHERE e.`IsActive` = 1 AND e.`IsDeleted` = 0
GROUP BY e.`Id`, e.`Name`, e.`Role`, e.`Shift`, MONTH(a.`Date`), YEAR(a.`Date`);

-- ------------------------------------------------------------
-- STEP 6: CREATE STORED PROCEDURES
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS `sp_GetDashboardStats`;

DELIMITER $$
CREATE PROCEDURE `sp_GetDashboardStats`()
BEGIN
    DECLARE v_Today DATE;
    SET v_Today = CURDATE();

    SELECT
        IFNULL(SUM(o.`GrandTotal`), 0)                                      AS `TodayRevenue`,
        COUNT(o.`Id`)                                                       AS `TodayOrders`,
        COUNT(CASE WHEN o.`OrderType` = 1 THEN 1 END)                       AS `DineInCount`,
        COUNT(CASE WHEN o.`OrderType` = 2 THEN 1 END)                       AS `TakeawayCount`,
        COUNT(CASE WHEN o.`OrderType` = 3 THEN 1 END)                       AS `DeliveryCount`,
        IFNULL(AVG(o.`GrandTotal`), 0)                                      AS `AvgOrderValue`,
        (SELECT COUNT(*) FROM `Tables` WHERE `Status` = 2 AND `IsDeleted` = 0) AS `OccupiedTables`,
        (SELECT COUNT(*) FROM `Tables` WHERE `IsActive` = 1 AND `IsDeleted` = 0) AS `TotalActiveTables`,
        (SELECT COUNT(*) FROM `Reservations`
             WHERE DATE(`ReservationDate`) = v_Today
               AND `Status` IN (1, 2)
               AND `IsDeleted` = 0)                                         AS `TodayReservations`
    FROM `Orders` o
    WHERE o.`IsSettled` = 1
      AND o.`IsDeleted` = 0
      AND DATE(o.`CreatedAt`) = v_Today;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetActiveOrders`;

DELIMITER $$
CREATE PROCEDURE `sp_GetActiveOrders`()
BEGIN
    SELECT
        o.`Id`,
        o.`OrderNumber`,
        o.`OrderType`,
        o.`Status`,
        t.`TableNumber`,
        f.`Name` AS `FloorName`,
        o.`CustomerName`,
        o.`SubTotal`,
        o.`GrandTotal`,
        o.`CreatedAt`,
        o.`Covers`,
        o.`IsSettled`
    FROM `Orders` o
    LEFT JOIN `Tables` t ON t.`Id` = o.`TableId`
    LEFT JOIN `Floors` f ON f.`Id` = t.`FloorId`
    WHERE o.`IsSettled` = 0
      AND o.`Status` NOT IN (5, 6)
      AND o.`IsDeleted` = 0
    ORDER BY o.`CreatedAt` DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetOrderDetails`;

DELIMITER $$
CREATE PROCEDURE `sp_GetOrderDetails`(IN p_OrderId INT)
BEGIN
    -- Order Header
    SELECT
        o.`Id`, o.`OrderNumber`, o.`OrderType`, o.`Status`,
        o.`TableId`, t.`TableNumber`, f.`Name` AS `FloorName`,
        o.`CustomerName`, o.`CustomerPhone`, o.`SpecialInstructions`,
        o.`SubTotal`, o.`CGST`, o.`SGST`, o.`TotalTax`,
        o.`DiscountAmount`, o.`PackagingCharge`, o.`DeliveryCharge`,
        o.`RoundOff`, o.`GrandTotal`, o.`Covers`,
        o.`OrderNote`, o.`DeliveryAddress`, o.`CreatedAt`, o.`IsSettled`, o.`SettledAt`
    FROM `Orders` o
    LEFT JOIN `Tables` t ON t.`Id` = o.`TableId`
    LEFT JOIN `Floors` f ON f.`Id` = t.`FloorId`
    WHERE o.`Id` = p_OrderId;

    -- Order Items
    SELECT
        oi.`Id`, oi.`MenuItemId`, mi.`Name` AS `MenuItemName`,
        mi.`IsVeg`,
        oi.`Quantity`, oi.`UnitPrice`, oi.`TotalPrice`,
        oi.`Status`, oi.`SpecialInstructions`,
        oi.`SelectedVariantName` AS `VariantName`
    FROM `OrderItems` oi
    INNER JOIN `MenuItems` mi ON mi.`Id` = oi.`MenuItemId`
    WHERE oi.`OrderId` = p_OrderId
      AND oi.`IsDeleted` = 0;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_CreateOrder`;

DELIMITER $$
CREATE PROCEDURE `sp_CreateOrder`(
    IN  p_OrderType      INT,
    IN  p_TableId        INT,
    IN  p_CustomerName   VARCHAR(200),
    IN  p_CustomerPhone  VARCHAR(20),
    IN  p_Covers         INT,
    IN  p_WaiterId       INT,
    IN  p_CustomerId     INT,
    OUT p_NewOrderId     INT
)
BEGIN
    DECLARE v_OrderNum VARCHAR(30);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_OrderNum = fn_GenerateOrderNumber(CURDATE());

    INSERT INTO `Orders`
        (`OrderNumber`, `OrderType`, `Status`, `TableId`, `WaiterId`, `CustomerId`,
         `CustomerName`, `CustomerPhone`, `Covers`,
         `SubTotal`, `CGST`, `SGST`, `TotalTax`, `DiscountAmount`, `PackagingCharge`,
         `DeliveryCharge`, `RoundOff`, `GrandTotal`,
         `IsDraft`, `IsSettled`, `Version`,
         `SpecialInstructions`, `OrderNote`, `TokenNumber`, `DeliveryAddress`,
         `OnlinePlatform`, `OnlineOrderReference`, `DeliveryPartnerName`,
         `CustomerGSTIN`, `DraftUserName`, `CreatedByUserName`, `WalkoutReason`, `TableTransferNotes`,
         `CreatedAt`, `UpdatedAt`, `IsActive`, `IsDeleted`)
    VALUES
        (v_OrderNum, p_OrderType, 1 /*Pending*/, p_TableId, p_WaiterId, p_CustomerId,
         IFNULL(p_CustomerName, ''), IFNULL(p_CustomerPhone, ''), IFNULL(p_Covers, 1),
         0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
         0.00, 0.00, 0.00,
         0, 0, 1,
         '', '', '', '',
         '', '', '',
         '', '', '', '', '',
         NOW(6), NOW(6), 1, 0);

    SET p_NewOrderId = LAST_INSERT_ID();

    IF p_OrderType = 1 AND p_TableId IS NOT NULL THEN
        UPDATE `Tables`
        SET `Status` = 2, `CurrentOrderId` = p_NewOrderId, `UpdatedAt` = NOW(6)
        WHERE `Id` = p_TableId;
    END IF;

    COMMIT;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_SettleOrder`;

DELIMITER $$
CREATE PROCEDURE `sp_SettleOrder`(
    IN p_OrderId  INT,
    IN p_RoundOff DECIMAL(18,2)
)
BEGIN
    DECLARE v_TableId INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE `Orders`
    SET `IsSettled` = 1, `SettledAt` = NOW(6), `Status` = 5 /*Completed*/,
        `RoundOff` = IFNULL(p_RoundOff, 0.00), `UpdatedAt` = NOW(6)
    WHERE `Id` = p_OrderId;

    SELECT `TableId` INTO v_TableId FROM `Orders` WHERE `Id` = p_OrderId;

    IF v_TableId IS NOT NULL THEN
        UPDATE `Tables`
        SET `Status` = 5 /*Cleaning*/, `CurrentOrderId` = NULL, `UpdatedAt` = NOW(6)
        WHERE `Id` = v_TableId;
    END IF;

    COMMIT;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetMenuWithCategories`;

DELIMITER $$
CREATE PROCEDURE `sp_GetMenuWithCategories`(IN p_IsAvailableOnly TINYINT(1))
BEGIN
    SELECT
        c.`Id`                      AS `CategoryId`,
        c.`Name`                    AS `CategoryName`,
        c.`DisplayOrder`            AS `CategoryOrder`,
        mi.`Id`                     AS `MenuItemId`,
        mi.`Name`                   AS `ItemName`,
        mi.`Description`,
        mi.`Price`,
        mi.`IsVeg`,
        mi.`IsAvailable`,
        mi.`PreparationTimeMinutes`,
        mi.`ImageUrl`,
        mi.`TaxPercentage`
    FROM `Categories` c
    INNER JOIN `MenuItems` mi ON mi.`CategoryId` = c.`Id`
    WHERE c.`IsActive` = 1 AND c.`IsDeleted` = 0
      AND mi.`IsDeleted` = 0
      AND (IFNULL(p_IsAvailableOnly, 1) = 0 OR mi.`IsAvailable` = 1)
    ORDER BY c.`DisplayOrder`, mi.`Name`;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetInventoryAlerts`;

DELIMITER $$
CREATE PROCEDURE `sp_GetInventoryAlerts`()
BEGIN
    SELECT
        `Id`,
        `Name`,
        `Category`,
        `Unit`,
        `CurrentStock`,
        `MinimumStock`,
        `ReorderLevel`,
        `UnitCost`,
        CASE
            WHEN `CurrentStock` <= `MinimumStock` THEN 'CRITICAL'
            WHEN `CurrentStock` <= `ReorderLevel` THEN 'LOW'
            ELSE 'OK'
        END AS `StockStatus`
    FROM `InventoryItems`
    WHERE `CurrentStock` <= `ReorderLevel`
      AND `IsActive` = 1
      AND `IsDeleted` = 0
    ORDER BY `CurrentStock` ASC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetDailySalesSummary`;

DELIMITER $$
CREATE PROCEDURE `sp_GetDailySalesSummary`(
    IN p_FromDate DATE,
    IN p_ToDate   DATE
)
BEGIN
    SELECT
        DATE(o.`CreatedAt`)                           AS `SaleDate`,
        COUNT(DISTINCT o.`Id`)                        AS `TotalOrders`,
        SUM(o.`SubTotal`)                             AS `TotalSubTotal`,
        SUM(o.`TotalTax`)                             AS `TotalTax`,
        SUM(o.`DiscountAmount`)                       AS `TotalDiscount`,
        SUM(o.`GrandTotal`)                           AS `TotalRevenue`,
        COUNT(CASE WHEN o.`OrderType` = 1 THEN 1 END) AS `DineInOrders`,
        COUNT(CASE WHEN o.`OrderType` = 2 THEN 1 END) AS `TakeawayOrders`,
        COUNT(CASE WHEN o.`OrderType` = 3 THEN 1 END) AS `DeliveryOrders`,
        COUNT(CASE WHEN o.`OrderType` = 4 THEN 1 END) AS `OnlineOrders`
    FROM `Orders` o
    WHERE o.`IsSettled` = 1
      AND o.`IsDeleted` = 0
      AND DATE(o.`CreatedAt`) BETWEEN p_FromDate AND p_ToDate
    GROUP BY DATE(o.`CreatedAt`)
    ORDER BY `SaleDate`;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetTopSellingItems`;

DELIMITER $$
CREATE PROCEDURE `sp_GetTopSellingItems`(
    IN p_FromDate DATE,
    IN p_ToDate   DATE,
    IN p_TopN     INT
)
BEGIN
    SET @from = p_FromDate;
    SET @to = p_ToDate;
    SET @limit = IFNULL(p_TopN, 10);

    PREPARE stmt FROM '
        SELECT
            mi.`Id`                      AS `MenuItemId`,
            mi.`Name`                    AS `MenuItemName`,
            c.`Name`                     AS `CategoryName`,
            SUM(oi.`Quantity`)           AS `TotalQuantitySold`,
            SUM(oi.`TotalPrice`)         AS `TotalRevenue`,
            COUNT(DISTINCT oi.`OrderId`) AS `OrderCount`
        FROM `OrderItems` oi
        INNER JOIN `MenuItems` mi ON mi.`Id` = oi.`MenuItemId`
        INNER JOIN `Categories` c ON c.`Id` = mi.`CategoryId`
        INNER JOIN `Orders` o ON o.`Id` = oi.`OrderId`
        WHERE o.`IsSettled` = 1
          AND o.`IsDeleted` = 0
          AND oi.`IsDeleted` = 0
          AND DATE(o.`CreatedAt`) BETWEEN ? AND ?
        GROUP BY mi.`Id`, mi.`Name`, c.`Name`
        ORDER BY `TotalQuantitySold` DESC
        LIMIT ?';

    EXECUTE stmt USING @from, @to, @limit;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetSalesReport`;

DELIMITER $$
CREATE PROCEDURE `sp_GetSalesReport`(
    IN p_FromDate DATE,
    IN p_ToDate   DATE
)
BEGIN
    -- 1. Daily summary
    CALL sp_GetDailySalesSummary(p_FromDate, p_ToDate);

    -- 2. Top 10 items
    CALL sp_GetTopSellingItems(p_FromDate, p_ToDate, 10);

    -- 3. Payment method breakdown
    SELECT
        CASE p.`PaymentMethod`
            WHEN 1 THEN 'Cash'
            WHEN 2 THEN 'UPI'
            WHEN 3 THEN 'Credit Card'
            WHEN 4 THEN 'Debit Card'
            WHEN 5 THEN 'Wallet'
            WHEN 6 THEN 'Split'
            WHEN 7 THEN 'Credit'
            ELSE 'Other'
        END                             AS `PaymentMethod`,
        COUNT(*)                        AS `TransactionCount`,
        IFNULL(SUM(p.`Amount`), 0)      AS `TotalAmount`
    FROM `Payments` p
    INNER JOIN `Bills` b ON b.`Id` = p.`BillId`
    INNER JOIN `Orders` o ON o.`Id` = b.`OrderId`
    WHERE p.`PaymentStatus` = 3
      AND p.`IsDeleted` = 0
      AND DATE(o.`CreatedAt`) BETWEEN p_FromDate AND p_ToDate
    GROUP BY p.`PaymentMethod`
    ORDER BY `TotalAmount` DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetFloorPlan`;

DELIMITER $$
CREATE PROCEDURE `sp_GetFloorPlan`()
BEGIN
    SELECT
        f.`Id`            AS `FloorId`,
        f.`Name`          AS `FloorName`,
        f.`DisplayOrder`,
        t.`Id`            AS `TableId`,
        t.`TableNumber`,
        t.`Capacity`,
        t.`Status`        AS `TableStatusId`,
        fn_GetTableOccupancyStatus(t.`Status`) AS `TableStatusLabel`,
        t.`CurrentOrderId`,
        o.`OrderNumber`,
        o.`GrandTotal`    AS `RunningTotal`
    FROM `Floors` f
    LEFT JOIN `Tables` t ON t.`FloorId` = f.`Id` AND t.`IsActive` = 1 AND t.`IsDeleted` = 0
    LEFT JOIN `Orders` o ON o.`Id` = t.`CurrentOrderId` AND o.`IsDeleted` = 0
    WHERE f.`IsActive` = 1 AND f.`IsDeleted` = 0
    ORDER BY f.`DisplayOrder`, t.`TableNumber`;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetCustomerHistory`;

DELIMITER $$
CREATE PROCEDURE `sp_GetCustomerHistory`(IN p_CustomerId INT)
BEGIN
    -- Customer info + loyalty points
    SELECT
        c.`Id`, c.`Name`, c.`Phone`, c.`Email`,
        c.`TotalVisits`, c.`TotalSpent`,
        c.`LoyaltyPoints`,
        c.`Tier`,
        fn_GetCustomerLoyaltyTier(c.`LoyaltyPoints`) AS `TierLabel`,
        la.`CurrentPoints`            AS `LoyaltyCurrentPoints`,
        la.`TotalEarnedPoints`
    FROM `Customers` c
    LEFT JOIN `LoyaltyAccounts` la ON la.`CustomerId` = c.`Id`
    WHERE c.`Id` = p_CustomerId;

    -- Past orders (last 20)
    SELECT
        o.`Id`, o.`OrderNumber`, o.`OrderType`, o.`GrandTotal`,
        o.`CreatedAt`, o.`IsSettled`
    FROM `Orders` o
    WHERE o.`CustomerId` = p_CustomerId
      AND o.`IsDeleted` = 0
    ORDER BY o.`CreatedAt` DESC
    LIMIT 20;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_UpdateTableStatus`;

DELIMITER $$
CREATE PROCEDURE `sp_UpdateTableStatus`(
    IN p_TableId INT,
    IN p_Status  INT
)
BEGIN
    UPDATE `Tables`
    SET `Status` = p_Status, `UpdatedAt` = NOW(6)
    WHERE `Id` = p_TableId;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_CreateKOT`;

DELIMITER $$
CREATE PROCEDURE `sp_CreateKOT`(
    IN  p_OrderId  INT,
    IN  p_KOTType  INT,
    IN  p_Notes    VARCHAR(500),
    OUT p_NewKOTId INT
)
BEGIN
    DECLARE v_KOTNumber VARCHAR(30);
    DECLARE v_KOTCount  INT DEFAULT 1;
    DECLARE v_TableNum  VARCHAR(50) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) + 1 INTO v_KOTCount
    FROM `KOTs`
    WHERE `OrderId` = p_OrderId;

    SELECT IFNULL(t.`TableNumber`, '') INTO v_TableNum
    FROM `Orders` o
    LEFT JOIN `Tables` t ON t.`Id` = o.`TableId`
    WHERE o.`Id` = p_OrderId;

    SET v_KOTNumber = CONCAT('KOT-', p_OrderId, '-', v_KOTCount);

    INSERT INTO `KOTs`
        (`OrderId`, `KOTNumber`, `Status`, `Type`, `Notes`,
         `TableNumber`, `WaiterName`, `Station`, `Reason`, `PrintFailed`,
         `CreatedAt`, `UpdatedAt`, `IsActive`, `IsDeleted`)
    VALUES
        (p_OrderId, v_KOTNumber, 1 /*New*/, IFNULL(p_KOTType, 1), IFNULL(p_Notes, ''),
         v_TableNum, '', 'All', '', 0,
         NOW(6), NOW(6), 1, 0);

    SET p_NewKOTId = LAST_INSERT_ID();

    COMMIT;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_GetStaffAttendanceSummary`;

DELIMITER $$
CREATE PROCEDURE `sp_GetStaffAttendanceSummary`(
    IN p_Month INT,
    IN p_Year  INT
)
BEGIN
    SELECT
        e.`Id`            AS `EmployeeId`,
        e.`Name`,
        e.`Role`,
        e.`Shift`,
        COUNT(a.`Id`)                                            AS `TotalDays`,
        SUM(CASE WHEN a.`Status` = 'Present' THEN 1 ELSE 0 END)  AS `PresentDays`,
        SUM(CASE WHEN a.`Status` = 'Absent' THEN 1 ELSE 0 END)   AS `AbsentDays`,
        SUM(CASE WHEN a.`Status` = 'Half day' THEN 1 ELSE 0 END) AS `HalfDays`,
        SUM(CASE WHEN a.`Status` = 'Leave' THEN 1 ELSE 0 END)    AS `LeaveDays`
    FROM `Employees` e
    LEFT JOIN `Attendances` a
        ON a.`EmployeeId` = e.`Id`
        AND MONTH(a.`Date`) = p_Month
        AND YEAR(a.`Date`) = p_Year
        AND a.`IsDeleted` = 0
    WHERE e.`IsActive` = 1 AND e.`IsDeleted` = 0
    GROUP BY e.`Id`, e.`Name`, e.`Role`, e.`Shift`
    ORDER BY e.`Name`;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- STEP 7: CREATE TRIGGERS
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS `trg_Orders_BeforeInsert`;

DELIMITER $$
CREATE TRIGGER `trg_Orders_BeforeInsert`
BEFORE INSERT ON `Orders`
FOR EACH ROW
BEGIN
    IF NEW.`OrderNumber` IS NULL OR TRIM(NEW.`OrderNumber`) = '' THEN
        SET NEW.`OrderNumber` = fn_GenerateOrderNumber(CURDATE());
    END IF;
    IF NEW.`CreatedAt` IS NULL THEN
        SET NEW.`CreatedAt` = NOW(6);
    END IF;
    IF NEW.`UpdatedAt` IS NULL THEN
        SET NEW.`UpdatedAt` = NOW(6);
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `trg_Orders_AfterUpdate`;

DELIMITER $$
CREATE TRIGGER `trg_Orders_AfterUpdate`
AFTER UPDATE ON `Orders`
FOR EACH ROW
BEGIN
    IF OLD.`IsSettled` = 0 AND NEW.`IsSettled` = 1 AND NEW.`TableId` IS NOT NULL THEN
        UPDATE `Tables`
        SET `Status` = 5 /*Cleaning*/, `CurrentOrderId` = NULL, `UpdatedAt` = NOW(6)
        WHERE `Id` = NEW.`TableId` AND `CurrentOrderId` = NEW.`Id`;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `trg_Payments_AfterInsert`;

DELIMITER $$
CREATE TRIGGER `trg_Payments_AfterInsert`
AFTER INSERT ON `Payments`
FOR EACH ROW
BEGIN
    DECLARE v_CustomerId INT DEFAULT NULL;

    IF NEW.`PaymentStatus` = 3 /*Paid*/ THEN
        SELECT o.`CustomerId` INTO v_CustomerId
        FROM `Bills` b
        INNER JOIN `Orders` o ON o.`Id` = b.`OrderId`
        WHERE b.`Id` = NEW.`BillId`;

        IF v_CustomerId IS NOT NULL THEN
            UPDATE `Customers`
            SET `TotalSpent` = `TotalSpent` + NEW.`Amount`,
                `TotalVisits` = `TotalVisits` + 1,
                `LoyaltyPoints` = `LoyaltyPoints` + FLOOR(NEW.`Amount` / 100),
                `LastVisitDate` = NOW(6),
                `UpdatedAt` = NOW(6)
            WHERE `Id` = v_CustomerId;
        END IF;
    END IF;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- STEP 8: INSERT DEFAULT DATA
-- ------------------------------------------------------------

INSERT INTO `RestaurantSettings`
    (`Id`, `RestaurantName`, `RestaurantNameMarathi`, `Address`, `Phone`, `Email`, `GSTIN`,
     `CurrencySymbol`, `CGSTPercentage`, `SGSTPercentage`, `ServiceChargePercentage`,
     `LogoUrl`, `InvoicePrefix`, `KitchenMode`, `TrackReadyStatus`, `AutoMarkServedMinutes`,
     `VoidApproval`, `AllowBillingWithUnservedItems`, `KitchenLiteScreen`, `SinglePersonMode`,
     `DraftExpiryHours`, `PackagingCharge`, `DeliveryCharge`, `ManagerPIN`,
     `IsGSTEnabled`, `IsTaxInclusive`, `IsKOTWorkflowEnabled`, `IsQRCodeEnabled`, `QRCodeData`,
     `ThermalPrinterWidth`, `DefaultLanguage`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT
    1, 'Girana Garden Fine Dine & Bar', 'गिराणा गार्डन फाईन डाईन आणि बार',
    '101 Grand Galleria, MG Road, Ahmedabad - 380001', '+91 98765 43210', 'contact@giranagarden.com',
    '24AAACG1234F1Z9', '₹', 2.50, 2.50, 0.00,
    '/images/logo.png', 'INV', 2, 0, 0,
    1, 2, 0, 0,
    4, 15.00, 30.00, '1234',
    1, 0, 1, 1, 'https://giranagarden.com/menu',
    80, 'en', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `RestaurantSettings` WHERE `Id` = 1);

INSERT INTO `Users` (`Username`, `Email`, `PasswordHash`, `FullName`, `Phone`, `Role`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'admin', 'admin@giranagarden.com', 'admin123', 'System Administrator', '9876500001', 1, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Users` WHERE `Username` = 'admin');

INSERT INTO `Users` (`Username`, `Email`, `PasswordHash`, `FullName`, `Phone`, `Role`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'manager', 'manager@giranagarden.com', 'manager123', 'Rajesh Verma (Manager)', '9876500002', 2, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Users` WHERE `Username` = 'manager');

INSERT INTO `Users` (`Username`, `Email`, `PasswordHash`, `FullName`, `Phone`, `Role`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'cashier', 'cashier@giranagarden.com', 'cashier123', 'Suresh Patel (Cashier)', '9876500003', 3, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Users` WHERE `Username` = 'cashier');

INSERT INTO `Users` (`Username`, `Email`, `PasswordHash`, `FullName`, `Phone`, `Role`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'waiter', 'waiter@giranagarden.com', 'waiter123', 'Amit Kumar (Waiter)', '9876500004', 4, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Users` WHERE `Username` = 'waiter');

INSERT INTO `Users` (`Username`, `Email`, `PasswordHash`, `FullName`, `Phone`, `Role`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'kitchen', 'kitchen@giranagarden.com', 'kitchen123', 'Chef Sunita (Kitchen Head)', '9876500005', 5, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Users` WHERE `Username` = 'kitchen');

INSERT INTO `Users` (`Username`, `Email`, `PasswordHash`, `FullName`, `Phone`, `Role`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'inventory', 'inventory@giranagarden.com', 'inventory123', 'Vikram Singh (Inventory)', '9876500006', 6, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Users` WHERE `Username` = 'inventory');

INSERT INTO `Floors` (`Id`, `Name`, `Description`, `DisplayOrder`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 1, 'Ground Floor', 'Main Dining Area', 1, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Floors` WHERE `Id` = 1);

INSERT INTO `Floors` (`Id`, `Name`, `Description`, `DisplayOrder`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 2, 'First Floor', 'AC Lounge & Family Area', 2, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Floors` WHERE `Id` = 2);

INSERT INTO `Floors` (`Id`, `Name`, `Description`, `DisplayOrder`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 3, 'Outdoor Patio', 'Open Garden Seating', 3, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Floors` WHERE `Id` = 3);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '01', 2, 1, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '01' AND `FloorId` = 1);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '02', 4, 1, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '02' AND `FloorId` = 1);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '03', 4, 1, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '03' AND `FloorId` = 1);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '04', 6, 1, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '04' AND `FloorId` = 1);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '05', 4, 1, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '05' AND `FloorId` = 1);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '11', 4, 2, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '11' AND `FloorId` = 2);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '12', 6, 2, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '12' AND `FloorId` = 2);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '21', 2, 3, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '21' AND `FloorId` = 3);

INSERT INTO `Tables` (`TableNumber`, `Capacity`, `FloorId`, `Status`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT '22', 4, 3, 1, NOW(6), 1, 0 WHERE NOT EXISTS (SELECT 1 FROM `Tables` WHERE `TableNumber` = '22' AND `FloorId` = 3);

INSERT INTO `Categories` (`Id`, `Name`, `Description`, `DisplayOrder`, `ImageUrl`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 1, 'Starters', 'Delicious appetizers and quick bites', 1, 'https://images.unsplash.com/photo-1541544741938-0af808871cc0?w=500', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Categories` WHERE `Id` = 1);

INSERT INTO `Categories` (`Id`, `Name`, `Description`, `DisplayOrder`, `ImageUrl`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 2, 'Main Course', 'Authentic Indian Curries & Gravies', 2, 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=500', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Categories` WHERE `Id` = 2);

INSERT INTO `Categories` (`Id`, `Name`, `Description`, `DisplayOrder`, `ImageUrl`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 3, 'Biryani & Rice', 'Aromatic Hyderabadi & Dum Biryanis', 3, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Categories` WHERE `Id` = 3);

INSERT INTO `Categories` (`Id`, `Name`, `Description`, `DisplayOrder`, `ImageUrl`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 4, 'Beverages', 'Refreshing Mocktails & Shakes', 4, 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=500', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Categories` WHERE `Id` = 4);

INSERT INTO `Categories` (`Id`, `Name`, `Description`, `DisplayOrder`, `ImageUrl`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 5, 'Desserts', 'Sweet indulgences', 5, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Categories` WHERE `Id` = 5);

INSERT INTO `MenuItems` (`CategoryId`, `Name`, `ShortCode`, `Description`, `Price`, `TaxPercentage`, `IsVeg`, `IsAvailable`, `PreparationTimeMinutes`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 1, 'Paneer Tikka', '101', 'Cottage cheese marinated in yogurt and spices', 250.00, 5.00, 1, 1, 15, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `MenuItems` WHERE `Name` = 'Paneer Tikka');

INSERT INTO `MenuItems` (`CategoryId`, `Name`, `ShortCode`, `Description`, `Price`, `TaxPercentage`, `IsVeg`, `IsAvailable`, `PreparationTimeMinutes`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 2, 'Dal Makhani', '102', 'Slow cooked black lentils with cream and butter', 250.00, 5.00, 1, 1, 20, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `MenuItems` WHERE `Name` = 'Dal Makhani');

INSERT INTO `MenuItems` (`CategoryId`, `Name`, `ShortCode`, `Description`, `Price`, `TaxPercentage`, `IsVeg`, `IsAvailable`, `PreparationTimeMinutes`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 2, 'Butter Naan', '103', 'Freshly baked clay oven bread with butter', 50.00, 5.00, 1, 1, 8, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `MenuItems` WHERE `Name` = 'Butter Naan');

INSERT INTO `MenuItems` (`CategoryId`, `Name`, `ShortCode`, `Description`, `Price`, `TaxPercentage`, `IsVeg`, `IsAvailable`, `PreparationTimeMinutes`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 3, 'Chicken Biryani', '104', 'Flavorful Basmati rice cooked with tender chicken', 320.00, 5.00, 0, 1, 25, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `MenuItems` WHERE `Name` = 'Chicken Biryani');

INSERT INTO `MenuItems` (`CategoryId`, `Name`, `ShortCode`, `Description`, `Price`, `TaxPercentage`, `IsVeg`, `IsAvailable`, `PreparationTimeMinutes`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 4, 'Cold Drink / Soda', '105', 'Chilled carbonated beverage 300ml', 60.00, 5.00, 1, 1, 2, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `MenuItems` WHERE `Name` = 'Cold Drink / Soda');

INSERT INTO `MenuItems` (`CategoryId`, `Name`, `ShortCode`, `Description`, `Price`, `TaxPercentage`, `IsVeg`, `IsAvailable`, `PreparationTimeMinutes`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 4, 'Cold Coffee with Ice Cream', '106', 'Rich blended espresso with vanilla scoop', 140.00, 5.00, 1, 1, 10, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `MenuItems` WHERE `Name` = 'Cold Coffee with Ice Cream');

INSERT INTO `MenuItems` (`CategoryId`, `Name`, `ShortCode`, `Description`, `Price`, `TaxPercentage`, `IsVeg`, `IsAvailable`, `PreparationTimeMinutes`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 5, 'Gulab Jamun (2 Pcs)', '107', 'Warm milk dumplings in rose flavored sugar syrup', 90.00, 5.00, 1, 1, 5, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `MenuItems` WHERE `Name` = 'Gulab Jamun (2 Pcs)');

INSERT INTO `InventoryItems` (`Name`, `Category`, `Unit`, `CurrentStock`, `MinimumStock`, `UnitCost`, `ReorderLevel`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Paneer', 'Dairy', 'KG', 25.00, 10.00, 350.00, 12.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `InventoryItems` WHERE `Name` = 'Paneer');

INSERT INTO `InventoryItems` (`Name`, `Category`, `Unit`, `CurrentStock`, `MinimumStock`, `UnitCost`, `ReorderLevel`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Tomato', 'Vegetables', 'KG', 20.00, 10.00, 40.00, 15.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `InventoryItems` WHERE `Name` = 'Tomato');

INSERT INTO `InventoryItems` (`Name`, `Category`, `Unit`, `CurrentStock`, `MinimumStock`, `UnitCost`, `ReorderLevel`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Cooking Oil', 'Grocery', 'L', 20.00, 10.00, 140.00, 12.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `InventoryItems` WHERE `Name` = 'Cooking Oil');

INSERT INTO `InventoryItems` (`Name`, `Category`, `Unit`, `CurrentStock`, `MinimumStock`, `UnitCost`, `ReorderLevel`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Basmati Rice', 'Grocery', 'KG', 50.00, 20.00, 110.00, 25.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `InventoryItems` WHERE `Name` = 'Basmati Rice');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Rajesh Verma', 'rajesh.manager@giranagarden.com', '9876500002', 2, 45000.00, 'General', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'rajesh.manager@giranagarden.com');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Chef Sanjeev Kapoor', 'cook.head@giranagarden.com', '9876500010', 7, 38000.00, 'Morning', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'cook.head@giranagarden.com');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Sunita Sharma', 'sunita@giranagarden.com', '9876500005', 7, 28000.00, 'Evening', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'sunita@giranagarden.com');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Amit Kumar', 'amit@giranagarden.com', '9876500004', 4, 18000.00, 'Morning', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'amit@giranagarden.com');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Ramesh Rathore', 'ramesh@giranagarden.com', '9876500011', 4, 18000.00, 'Evening', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'ramesh@giranagarden.com');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Suresh Patel', 'suresh.cashier@giranagarden.com', '9876500003', 3, 22000.00, 'Morning', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'suresh.cashier@giranagarden.com');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Kishore Solanki', 'kishore.hk@giranagarden.com', '9876500012', 8, 15000.00, 'Morning', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'kishore.hk@giranagarden.com');

INSERT INTO `Employees` (`Name`, `Email`, `Phone`, `Role`, `BaseSalary`, `Shift`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Pooja Ben', 'pooja.hk@giranagarden.com', '9876500013', 8, 15000.00, 'Evening', NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Employees` WHERE `Email` = 'pooja.hk@giranagarden.com');

INSERT INTO `Customers` (`Name`, `Phone`, `Email`, `Address`, `GSTIN`, `Notes`, `Tier`, `TotalVisits`, `TotalSpent`, `LoyaltyPoints`, `OutstandingCredit`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Anand Patil', '9823456781', 'anand.patil@example.com', 'Flat 402, Shivneri Heights, Pune', '27AAACP1234A1Z5', 'Regular diner, prefers outdoor seating', 2, 14, 18500.00, 185, 0.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Customers` WHERE `Phone` = '9823456781');

INSERT INTO `Customers` (`Name`, `Phone`, `Email`, `Address`, `GSTIN`, `Notes`, `Tier`, `TotalVisits`, `TotalSpent`, `LoyaltyPoints`, `OutstandingCredit`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Pooja Kulkarni', '9823456782', 'pooja.k@example.com', 'B-12, Green Acres, Pune', '', 'Likes spicy food', 1, 6, 7200.00, 72, 1250.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Customers` WHERE `Phone` = '9823456782');

INSERT INTO `Customers` (`Name`, `Phone`, `Email`, `Address`, `GSTIN`, `Notes`, `Tier`, `TotalVisits`, `TotalSpent`, `LoyaltyPoints`, `OutstandingCredit`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Vikram Deshmukh (Infosys)', '9823456783', 'vikram.d@infosys.com', 'Phase 2, Hinjawadi IT Park, Pune', '27AAACI4567B1Z8', 'Corporate client, requires GST invoice', 3, 28, 54000.00, 540, 3500.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Customers` WHERE `Phone` = '9823456783');

-- ------------------------------------------------------------
-- STEP 9: RECORD MIGRATIONS & SCHEMA VERSION
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `SchemaVersions` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `ScriptName` VARCHAR(255) NOT NULL,
    `AppliedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Description` VARCHAR(255) NULL,
    `Status` VARCHAR(50) NOT NULL DEFAULT 'Success',
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UQ_SchemaVersions_ScriptName` (`ScriptName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- ------------------------------------------------------------
-- STEP 10: VERIFICATION SUMMARY
-- ------------------------------------------------------------
SELECT 'TABLES' AS `ObjectType`, COUNT(*) AS `TotalCount`
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'RestaurantManagementDb' AND TABLE_TYPE = 'BASE TABLE'
UNION ALL
SELECT 'VIEWS', COUNT(*)
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'RestaurantManagementDb'
UNION ALL
SELECT 'PROCEDURES', COUNT(*)
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'RestaurantManagementDb' AND ROUTINE_TYPE = 'PROCEDURE'
UNION ALL
SELECT 'FUNCTIONS', COUNT(*)
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'RestaurantManagementDb' AND ROUTINE_TYPE = 'FUNCTION'
UNION ALL
SELECT 'TRIGGERS', COUNT(*)
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'RestaurantManagementDb';
