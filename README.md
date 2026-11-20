# Restaurant Management System (RMS) - MySQL Edition

A comprehensive, production-grade Restaurant Management System built with **.NET 9**, **Entity Framework Core 9**, and **MySQL 8.0+**. This solution provides an end-to-end platform for Point of Sale (POS), Kitchen Order Tickets (KOT), Kitchen Display Systems (KDS), Table & Floor Plan Management, Menu Engineering, Inventory & Recipe Control, Staff Attendance & Payroll, Customer Loyalty & CRM, and Sales & Expense Analytics.

---

## 🌟 Key Features

- **Point of Sale (POS) & Billing**: Dine-In, Takeaway, Delivery, and Quick-Sale modes with multi-tender payment processing (Cash, Card, UPI, Wallet, Customer Credit).
- **Floor & Table Management**: Interactive visual floor plans, real-time table status tracking (Available, Occupied, Billed, Reserved, Cleaning).
- **Kitchen Order Management**: Real-time Kitchen Order Tickets (KOT) with automated routing by category and status tracking.
- **Inventory & Recipe Control**: Stock level alerts, minimum threshold warnings, supplier purchase orders, and item stock consumption.
- **Customer CRM & Loyalty**: Tiered customer loyalty points (Bronze, Silver, Gold, Platinum), credit accounts, and visit history.
- **Staff Attendance & Payroll**: Shift logging, daily attendance, advance salary tracking, and monthly payroll calculation.
- **Rich Analytics & Reports**: Daily sales, product profitability, GST reports, revenue by tender type, and expense tracking.

---

## 🛠️ Architecture & Solution Structure

The solution follows Clean Architecture and Domain-Driven Design (DDD) principles:

```
RestaurantManagementSystem/
│
├── Database/                                     # MySQL 8.0+ Schema Scripts & Documentation
│   ├── 01_CreateDatabase.sql                     # Database creation with utf8mb4 charset & collation
│   ├── 02_CreateTables.sql                       # 35 tables, primary keys, auto_increments, foreign keys
│   ├── 03_CreateIndexes.sql                      # Performance, foreign key, and lookup indexes
│   ├── 04_CreateStoredProcedures.sql             # 15 stored procedures for POS, orders, reports
│   ├── 05_CreateFunctions.sql                    # Scalar functions for calculations and order formatting
│   ├── 06_CreateViews.sql                        # Operational views for active orders, tables, sales
│   ├── 07_CreateTriggers.sql                     # Workflow automation triggers (order status, payments)
│   ├── 08_InsertDefaultData.sql                  # Idempotent master data seeding (users, floors, menu)
│   ├── 09_DatabaseVersion.sql                    # SchemaVersions tracking table & EF migration sync
│   ├── 10_FullDatabaseSetup.sql                  # End-to-end master script (executes all steps)
│   └── README.md                                 # Database setup guide & script execution matrix
│
├── RestaurantManagementSystem/
│   ├── src/
│   │   ├── RestaurantManagement.Domain/          # Core Domain Entities, Enums, Interfaces, Value Objects
│   │   ├── RestaurantManagement.Application/     # Application Services, DTOs, Business Logic, FluentValidators
│   │   ├── RestaurantManagement.Infrastructure/  # EF Core DbContext, MySQL Data Helpers, Database Initializer
│   │   ├── RestaurantManagement.Web/             # ASP.NET Core MVC UI (Views, Controllers, ViewModels, SignalR)
│   │   └── RestaurantManagement.API/             # RESTful API endpoints, Swagger/OpenAPI documentation
│   │
│   └── tests/
│       └── RestaurantManagement.Tests/           # Unit, Integration, and MySQL Migration Test Suite
│
├── RestaurantManagementSystem.sln                # Root Visual Studio 2022 Solution File
└── README.md                                     # System Documentation & Developer Guide
```

---

## 🚀 Quick Start Guide for New Developers

### 1. Prerequisites
- **Visual Studio 2022** (v17.10 or newer) with the **ASP.NET and web development** workload, OR **.NET 9 SDK**.
- **MySQL Server 8.0+** (MySQL 8.0, 8.4 LTS, or MariaDB 10.5+) installed and running locally or on a network host.
- A MySQL user account (such as `root`) with `CREATE`, `ALTER`, `DROP`, `REFERENCES`, `INDEX`, `TRIGGER`, and `ROUTINE` privileges.

### 2. Configure Connection String
Open `RestaurantManagementSystem/src/RestaurantManagement.Web/appsettings.json` (or `RestaurantManagement.API/appsettings.json`) and configure your MySQL credentials:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Port=3306;Database=RestaurantManagementDb;User ID=root;Password=YOUR_MYSQL_PASSWORD;TreatTinyAsBoolean=true;"
  }
}
```

> **Note**: A template file `appsettings.sample.json` is provided in both web and API projects for reference. Never commit production passwords into version control.

### 3. Run the Application (Zero-Touch Automatic Database Setup!)
You **do NOT need to manually create the database or execute any SQL scripts**.

1. Open `RestaurantManagementSystem.sln` in Visual Studio 2022 (or open the project folder in VS Code / JetBrains Rider).
2. Set `RestaurantManagement.Web` (or `RestaurantManagement.API`) as the startup project.
3. Press **F5** (or `Ctrl+F5`) to build and run the application.

**What happens automatically on first startup:**
1. The built-in `DatabaseInitializer` detects your MySQL connection settings.
2. Checks if `RestaurantManagementDb` exists on your MySQL server; creates it automatically if missing.
3. Automatically executes each versioned migration script in sequence:
   - Tables, Primary Keys, Foreign Keys, AUTO_INCREMENT columns
   - Indexes and Unique Constraints
   - Stored Procedures and Handlers
   - Scalar and Utility Functions
   - Analytical & Operational Views
   - Automated Triggers
   - Default Master Data (admin users, dining floors, tables, item categories, menu items, sample inventory)
4. Records each migration in the `SchemaVersions` tracking table and synchronizes `__EFMigrationsHistory`.
5. Verifies all database objects are healthy before launching the Web UI / Swagger documentation.
6. On subsequent startups, existing user data and configurations are **strictly preserved** — only pending migrations (if any) are executed.

---

## 🔑 Default Login Credentials

The automatic database seeder initializes the following pre-configured user accounts with distinct operational roles:

| Username | Password | Role | Description |
| :--- | :--- | :--- | :--- |
| `admin` | `admin123` | Administrator | Full system access, configuration, user management, and audit logs |
| `manager` | `manager123` | Manager | POS oversight, price overrides, void orders, and sales reports |
| `cashier` | `cashier123` | Cashier | Order settlement, invoice generation, multi-tender payments |
| `waiter` | `waiter123` | Waiter | Dine-in order taking, table assignments, and KOT dispatch |
| `kitchen` | `kitchen123` | Kitchen Staff | Kitchen Display System (KDS), preparation status updates |
| `inventory` | `inventory123` | Inventory Staff | Stock receiving, supplier orders, minimum threshold alerts |

---

## 🔄 SQL Server to MySQL Migration Highlights

| Aspect | SQL Server (Previous) | MySQL 8.0+ (Current) |
| :--- | :--- | :--- |
| **ORM Provider** | `Microsoft.EntityFrameworkCore.SqlServer` | `Pomelo.EntityFrameworkCore.MySql` (v9.0.0) |
| **ADO.NET Driver** | `Microsoft.Data.SqlClient` / `System.Data.SqlClient` | `MySqlConnector` (v3.0.0) |
| **Auto Increment** | `IDENTITY(1,1)` | `AUTO_INCREMENT` |
| **String Types** | `NVARCHAR(n)`, `NVARCHAR(MAX)` | `VARCHAR(n)`, `LONGTEXT` with `CHARACTER SET utf8mb4` |
| **Date & Time** | `DATETIME2`, `GETDATE()` | `DATETIME(6)`, `NOW()`, `CURRENT_TIMESTAMP(6)` |
| **Null Replacement** | `ISNULL(col, default)` | `IFNULL(col, default)` or `COALESCE(col, default)` |
| **Paging** | `TOP (n)` / `OFFSET n ROWS FETCH NEXT m` | `LIMIT m OFFSET n` |
| **Identity Retrieval**| `SCOPE_IDENTITY()`, `@@IDENTITY` | `LAST_INSERT_ID()` |
| **Table-Valued Functions** | `RETURNS TABLE ... AS RETURN (SELECT ...)` | Stored Procedures with Result Sets (`sp_GetDailySalesSummary`, `sp_GetTopSellingItems`) |
| **Transaction Handling**| `BEGIN TRANSACTION ... COMMIT` | `START TRANSACTION ... COMMIT`, with `DECLARE EXIT HANDLER FOR SQLEXCEPTION` |
| **Delimiters** | Implicit / `GO` batch separator | Explicit `DELIMITER $$ ... DELIMITER ;` handled by custom runner |
| **Migration Tracking**| `__EFMigrationsHistory` | Unified `SchemaVersions` audit table + synchronized `__EFMigrationsHistory` |

---

## 🧪 Testing and Quality Assurance

The solution includes an extensive automated test suite covering domain logic, order calculations, tax computation, scenario workflows, connection string sanitization, delimiter parsing, and MySQL model building.

To run tests via the command line:
```bash
dotnet test
```

### Test Results
```text
Passed!  - Failed: 0, Passed: 50, Skipped: 0, Total: 50, Duration: 1 s - RestaurantManagement.Tests.dll (net9.0)
```

All 50 unit and scenario tests pass with zero warnings and zero errors.

---

## 🛡️ Error Handling and Diagnostics

- **Connection Health Checks**: If MySQL is not running or the password is incorrect, the application displays clear diagnostic instructions and prevents partial execution.
- **Credential Protection**: Connection strings are automatically sanitized in all logs and error messages — passwords are never exposed (`Password=***`).
- **Resilient Retry**: MySQL connections employ transient error resilience (`EnableRetryOnFailure`) to recover smoothly from temporary network drops.
- **Script Diagnostics**: If a script error occurs during initialization, the exact statement, error code, and script name are logged for rapid troubleshooting.

---

## 📄 License & Attribution

Developed with .NET 9 and MySQL 8.0+. All UI components, business logic, entities, controllers, and application workflows remain completely identical to the original system.
