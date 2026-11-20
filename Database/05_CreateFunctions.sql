-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 05_CreateFunctions.sql
-- Description: Creates scalar utility and calculation functions.
-- ============================================================

USE `RestaurantManagementDb`;

-- -------------------------------------------------------
-- fn_CalculateGrandTotal
-- Calculates grand total for an order including taxes, discounts, packaging and delivery.
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- fn_GetCustomerLoyaltyTier
-- Returns loyalty tier label based on total points.
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- fn_GetTableOccupancyStatus
-- Returns human-readable table status.
-- -------------------------------------------------------
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

-- -------------------------------------------------------
-- fn_GenerateOrderNumber
-- Generates a sequential order number like ORD-20261015-0001
-- -------------------------------------------------------
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
