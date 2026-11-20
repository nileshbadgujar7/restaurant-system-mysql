-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 06_CreateViews.sql
-- Description: Creates operational, analytical, and reporting views.
-- Safe to execute multiple times.
-- ============================================================

USE `RestaurantManagementDb`;

-- 1. vw_ActiveOrders: Non-settled, non-cancelled orders
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
  AND o.`Status` NOT IN (5, 6) -- Exclude Completed/Cancelled
  AND o.`IsDeleted` = 0;

-- 2. vw_TableStatusSummary: Current floor and table layout with live status
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

-- 3. vw_DailySalesSummary: Aggregated daily sales for settled orders
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

-- 4. vw_MenuCatalog: Active menu catalog with category details
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

-- 5. vw_InventoryStockStatus: Inventory status with alert levels
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

-- 6. vw_CustomerLoyaltySummary: Customer loyalty and spending breakdown
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

-- 7. vw_StaffAttendanceMonthly: Attendance aggregation for staff
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
