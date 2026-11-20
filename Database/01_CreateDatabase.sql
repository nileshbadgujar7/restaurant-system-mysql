-- ============================================================
-- Restaurant Management System - MySQL 8.0+
-- Script: 01_CreateDatabase.sql
-- Description: Creates the database if it does not already exist
--              with UTF-8 (utf8mb4) character set and collation.
-- ============================================================

CREATE DATABASE IF NOT EXISTS `RestaurantManagementDb`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `RestaurantManagementDb`;
