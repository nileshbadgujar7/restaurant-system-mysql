-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 03_CreateIndexes.sql
-- Description: Creates performance and lookup indexes on foreign keys,
--              status columns, phone, and date columns.
-- Safe to execute multiple times.
-- ============================================================

USE `RestaurantManagementDb`;

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

-- Create indexes on lookup and relationship columns
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
