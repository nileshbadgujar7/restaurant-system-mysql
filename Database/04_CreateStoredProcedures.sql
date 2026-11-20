-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 04_CreateStoredProcedures.sql
-- Description: Creates all operational and reporting stored procedures.
-- ============================================================

USE `RestaurantManagementDb`;

-- -------------------------------------------------------
-- sp_GetDashboardStats
-- Returns operational KPIs and dashboard statistics
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetActiveOrders
-- Returns currently active (unsettled) orders
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetOrderDetails
-- Returns header and line-item details for an order
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_CreateOrder
-- Creates a new order and returns generated OrderId
-- -------------------------------------------------------
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

    -- Mark table as Occupied if DineIn
    IF p_OrderType = 1 AND p_TableId IS NOT NULL THEN
        UPDATE `Tables`
        SET `Status` = 2, `CurrentOrderId` = p_NewOrderId, `UpdatedAt` = NOW(6)
        WHERE `Id` = p_TableId;
    END IF;

    COMMIT;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- sp_SettleOrder
-- Closes an order and transitions table to Cleaning status
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetMenuWithCategories
-- Returns active menu grouped by category
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetInventoryAlerts
-- Returns inventory items at or below reorder level
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetDailySalesSummary
-- Returns daily sales breakdown for a date range
-- (Migrated from SQL Server table-valued function)
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetTopSellingItems
-- Returns top N selling menu items by quantity
-- (Migrated from SQL Server table-valued function)
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetSalesReport
-- Multi-result-set report: daily summary, top items, and payment methods
-- -------------------------------------------------------
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
    WHERE p.`PaymentStatus` = 3 -- Paid
      AND p.`IsDeleted` = 0
      AND DATE(o.`CreatedAt`) BETWEEN p_FromDate AND p_ToDate
    GROUP BY p.`PaymentMethod`
    ORDER BY `TotalAmount` DESC;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- sp_GetFloorPlan
-- Returns floor and table layout with live status and running totals
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetCustomerHistory
-- Returns customer profile and last 20 orders
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_UpdateTableStatus
-- Updates table status and timestamp
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_CreateKOT
-- Creates kitchen order ticket
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- sp_GetStaffAttendanceSummary
-- Monthly staff attendance aggregation
-- -------------------------------------------------------
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
