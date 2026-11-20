using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using RestaurantManagement.Application.Interfaces;
using RestaurantManagement.Application.Services;
using RestaurantManagement.Infrastructure.Data;
using RestaurantManagement.Infrastructure.DbContext;
using RestaurantManagement.Infrastructure.Repositories;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
builder.Host.UseSerilog();

// MySQL 8.0+ Connection String
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? "Server=localhost;Port=3306;Database=RestaurantManagementDb;User ID=root;Password=root;TreatTinyAsBoolean=true;";

// Register MySQL DbContext with resilience and connection retry
builder.Services.AddDbContext<RestaurantDbContext>(options =>
{
    var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));
    options.UseMySql(connectionString, serverVersion, mySqlOptions =>
    {
        mySqlOptions.EnableRetryOnFailure(
            maxRetryCount: 3,
            maxRetryDelay: TimeSpan.FromSeconds(5),
            errorNumbersToAdd: null);
        mySqlOptions.CommandTimeout(60);
    });
    options.ConfigureWarnings(w => w.Ignore(Microsoft.EntityFrameworkCore.Diagnostics.RelationalEventId.PendingModelChangesWarning));
});

// Register MySQL Database Helper for direct ADO.NET and Stored Procedure calls
builder.Services.AddSingleton<IDatabaseHelper>(sp =>
{
    var logger = sp.GetService<ILogger<MySqlDbHelper>>();
    return new MySqlDbHelper(connectionString, logger);
});

// Register Repositories and Services
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<ITableService, TableService>();
builder.Services.AddScoped<IMenuService, MenuService>();
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<IKOTService, KOTService>();
builder.Services.AddScoped<IBillingService, BillingService>();
builder.Services.AddScoped<ICustomerService, CustomerService>();
builder.Services.AddScoped<IReservationService, ReservationService>();
builder.Services.AddScoped<IInventoryService, InventoryService>();
builder.Services.AddScoped<IStaffService, StaffService>();
builder.Services.AddScoped<ISupplierService, SupplierService>();
builder.Services.AddScoped<IDashboardService, DashboardService>();
builder.Services.AddScoped<IReportService, ReportService>();

// Cookie Authentication for Web MVC
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "GiranaRMS.Auth";
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
        options.AccessDeniedPath = "/Account/AccessDenied";
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = true;
        options.Cookie.HttpOnly = true;
        options.Cookie.SameSite = SameSiteMode.Lax;
        options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
    });

builder.Services.AddControllersWithViews();

var app = builder.Build();

// Automated MySQL Database Initialization & Versioned Migrations
using (var scope = app.Services.CreateScope())
{
    var loggerFactory = scope.ServiceProvider.GetRequiredService<ILoggerFactory>();
    var initLogger = loggerFactory.CreateLogger<DatabaseInitializer>();
    var dbContext = scope.ServiceProvider.GetRequiredService<RestaurantDbContext>();

    try
    {
        var initializer = DatabaseInitializer.FromConfiguration(builder.Configuration, initLogger);
        var initResult = initializer.InitializeAsync().GetAwaiter().GetResult();

        if (initResult.Success)
        {
            initLogger.LogInformation("Database verified successfully. Proceeding with application seed data.");
            DbInitializer.SeedData(dbContext);
        }
        else
        {
            initLogger.LogWarning("Automated initialization encountered an issue: {Message}", initResult.Message);
        }
    }
    catch (Exception ex)
    {
        initLogger.LogError(ex, "Unexpected error during database initialization: {Message}", ex.Message);
    }
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

// Always open login page first at root URL
app.MapGet("/", context =>
{
    context.Response.Redirect("/Account/Login");
    return Task.CompletedTask;
});

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Dashboard}/{action=Index}/{id?}");

app.Run();
