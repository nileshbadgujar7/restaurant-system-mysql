-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 07_CreateTriggers.sql
-- Description: Creates data integrity and automated workflow triggers.
-- Safe to execute multiple times.
-- ============================================================

USE `RestaurantManagementDb`;

-- -------------------------------------------------------
-- trg_Orders_BeforeInsert
-- Ensures OrderNumber, CreatedAt, and UpdatedAt are properly set
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- trg_Orders_AfterUpdate
-- When an order is settled (IsSettled becomes 1), release table
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- trg_Payments_AfterInsert
-- When a payment is settled, update customer total spend & loyalty
-- -------------------------------------------------------
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
