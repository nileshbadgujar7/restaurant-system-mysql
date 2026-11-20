-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 08_InsertDefaultData.sql
-- Description: Seeds essential master data and sample default records.
-- Safe to execute multiple times (idempotent inserts).
-- ============================================================

USE `RestaurantManagementDb`;

-- 1. Restaurant Settings
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

-- 2. Users (Default system roles)
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

-- 3. Floors
INSERT INTO `Floors` (`Id`, `Name`, `Description`, `DisplayOrder`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 1, 'Ground Floor', 'Main Dining Area', 1, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Floors` WHERE `Id` = 1);

INSERT INTO `Floors` (`Id`, `Name`, `Description`, `DisplayOrder`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 2, 'First Floor', 'AC Lounge & Family Area', 2, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Floors` WHERE `Id` = 2);

INSERT INTO `Floors` (`Id`, `Name`, `Description`, `DisplayOrder`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 3, 'Outdoor Patio', 'Open Garden Seating', 3, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Floors` WHERE `Id` = 3);

-- 4. Tables
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

-- 5. Categories
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

-- 6. Menu Items
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

-- 7. Inventory Items
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

-- 8. Employees
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

-- 9. Customers
INSERT INTO `Customers` (`Name`, `Phone`, `Email`, `Address`, `GSTIN`, `Notes`, `Tier`, `TotalVisits`, `TotalSpent`, `LoyaltyPoints`, `OutstandingCredit`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Anand Patil', '9823456781', 'anand.patil@example.com', 'Flat 402, Shivneri Heights, Pune', '27AAACP1234A1Z5', 'Regular diner, prefers outdoor seating', 2, 14, 18500.00, 185, 0.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Customers` WHERE `Phone` = '9823456781');

INSERT INTO `Customers` (`Name`, `Phone`, `Email`, `Address`, `GSTIN`, `Notes`, `Tier`, `TotalVisits`, `TotalSpent`, `LoyaltyPoints`, `OutstandingCredit`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Pooja Kulkarni', '9823456782', 'pooja.k@example.com', 'B-12, Green Acres, Pune', '', 'Likes spicy food', 1, 6, 7200.00, 72, 1250.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Customers` WHERE `Phone` = '9823456782');

INSERT INTO `Customers` (`Name`, `Phone`, `Email`, `Address`, `GSTIN`, `Notes`, `Tier`, `TotalVisits`, `TotalSpent`, `LoyaltyPoints`, `OutstandingCredit`, `CreatedAt`, `IsActive`, `IsDeleted`)
SELECT 'Vikram Deshmukh (Infosys)', '9823456783', 'vikram.d@infosys.com', 'Phase 2, Hinjawadi IT Park, Pune', '27AAACI4567B1Z8', 'Corporate client, requires GST invoice', 3, 28, 54000.00, 540, 3500.00, NOW(6), 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `Customers` WHERE `Phone` = '9823456783');
