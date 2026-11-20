# Restaurant Management System - MySQL Database Documentation

This directory contains the complete MySQL 8.0+ database schema, scripts, migrations, and initialization assets for the Restaurant Management System.

---

## 📁 Directory Structure & Execution Order

| Script Name | Purpose | Execution Order | Idempotent |
| :--- | :--- | :---: | :---: |
| `01_CreateDatabase.sql` | Creates `RestaurantManagementDb` with `utf8mb4` encoding and collation | 1 | Yes |
| `02_CreateTables.sql` | Creates all 35 entity tables, primary keys, and foreign keys | 2 | Yes |
| `03_CreateIndexes.sql` | Creates performance, foreign key, and lookup indexes | 3 | Yes |
| `04_CreateStoredProcedures.sql` | Creates stored procedures for Dashboard, Orders, KOT, POS, Reports | 4 | Yes |
| `05_CreateFunctions.sql` | Creates scalar calculation and utility functions | 5 | Yes |
| `06_CreateViews.sql` | Creates operational views for active orders, tables, sales, inventory | 6 | Yes |
| `07_CreateTriggers.sql` | Creates triggers for order number generation, table release, loyalty | 7 | Yes |
| `08_InsertDefaultData.sql` | Seeds initial settings, users, floors, tables, categories, menu items | 8 | Yes |
| `09_DatabaseVersion.sql` | Creates `SchemaVersions` tracking table and syncs EF migration history | 9 | Yes |
| `10_FullDatabaseSetup.sql` | Master script executing the complete setup in one single script | All-in-one | Yes |

---

## 🚀 Prerequisites

1. **MySQL Server 8.0** or compatible newer version (e.g., MySQL 8.0, 8.4 LTS, or MariaDB 10.5+).
2. A MySQL user account (such as `root`) with `CREATE`, `ALTER`, `DROP`, `REFERENCES`, `INDEX`, `TRIGGER`, and `ROUTINE` privileges.
3. Default port `3306` (or any custom port configured in `appsettings.json`).

---

## ⚡ Automatic Database Initialization (Zero Manual Setup)

**You do NOT need to execute these SQL scripts manually.**

When the application starts, the built-in `DatabaseInitializer` automatically:
1. Connects to the configured MySQL Server.
2. Checks whether `RestaurantManagementDb` exists, and creates it if missing.
3. Executes all pending migration scripts in sequential order.
4. Records applied migrations in the `SchemaVersions` table.
5. Seeds master default users and operational settings.
6. Verifies that all required database objects exist.

If the database and tables already exist, existing records are **preserved intact** and only missing/pending scripts are run.

---

## 🛠️ Manual Database Setup (Optional)

If you prefer to initialize the database manually via the MySQL CLI or MySQL Workbench:

### Option A: Using MySQL Command Line Client
```bash
# Connect and execute the full database setup in one command
mysql -u root -p < Database/10_FullDatabaseSetup.sql
```

### Option B: Using Individual Scripts
```bash
mysql -u root -p < Database/01_CreateDatabase.sql
mysql -u root -p < Database/02_CreateTables.sql
mysql -u root -p < Database/03_CreateIndexes.sql
mysql -u root -p < Database/05_CreateFunctions.sql
mysql -u root -p < Database/06_CreateViews.sql
mysql -u root -p < Database/04_CreateStoredProcedures.sql
mysql -u root -p < Database/07_CreateTriggers.sql
mysql -u root -p < Database/08_InsertDefaultData.sql
mysql -u root -p < Database/09_DatabaseVersion.sql
```

---

## 🔑 Default Master Credentials

| Username | Password | Role | Description |
| :--- | :--- | :--- | :--- |
| `admin` | `admin123` | Administrator | Full administrative control & masters |
| `manager` | `manager123` | Manager | POS, reports, voids, overrides |
| `cashier` | `cashier123` | Cashier | Billing and payments |
| `waiter` | `waiter123` | Waiter | Dine-in orders, KOT creation |
| `kitchen` | `kitchen123` | Kitchen Staff | KDS and order preparation |
| `inventory` | `inventory123` | Inventory Staff | Stock and recipe management |
