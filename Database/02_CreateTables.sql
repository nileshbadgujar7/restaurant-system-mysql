-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 02_CreateTables.sql
-- Description: Creates all 35 tables, primary keys, and foreign keys.
-- Safe to execute multiple times (uses CREATE TABLE IF NOT EXISTS).
-- ============================================================

USE `RestaurantManagementDb`;

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
ALTER TABLE `Tables`
    ADD CONSTRAINT `FK_Tables_Orders_CurrentOrderId`
    FOREIGN KEY (`CurrentOrderId`) REFERENCES `Orders` (`Id`) ON DELETE SET NULL;

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

-- Migration History Table for EF Core Synchronization
CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` VARCHAR(150) NOT NULL,
    `ProductVersion` VARCHAR(32) NOT NULL,
    PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
