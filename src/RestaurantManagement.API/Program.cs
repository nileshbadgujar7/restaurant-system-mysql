using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using RestaurantManagement.Application.Interfaces;
using RestaurantManagement.Application.Services;
using RestaurantManagement.Infrastructure.Data;
using RestaurantManagement.Infrastructure.DbContext;
using RestaurantManagement.Infrastructure.Repositories;
using Serilog;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
builder.Host.UseSerilog();

// MySQL 8.0+ Connection String
string connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? "Server=localhost;Port=3306;Database=RestaurantManagementDb;User ID=root;Password=root;TreatTinyAsBoolean=true;";

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

// Register MySQL Database Helper
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

// JWT Authentication Configuration
var jwtKey = builder.Configuration["Jwt:Key"] ?? "RestaurantManagementSuperSecretKey1234567890!";
var jwtIssuer = builder.Configuration["Jwt:Issuer"] ?? "RestaurantManagementAPI";

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtIssuer,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

// Swagger Configuration with JWT Bearer support
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Restaurant Management Web API", Version = "v1", Description = "API for Restaurant Operations, POS, KOT, KDS, Billing, and Analytics" });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
            },
            Array.Empty<string>()
        }
    });
});

var app = builder.Build();

// Automated MySQL Database Initialization & Seed
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

// Configure HTTP pipeline
if (app.Environment.IsDevelopment() || true)
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Restaurant Management API v1"));
}

app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
