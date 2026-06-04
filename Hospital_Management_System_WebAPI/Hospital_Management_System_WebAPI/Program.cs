using Hospital_Management_System_WebAPI.Middleware;
using Hospital_Management_System_WebAPI.Repository.ServiceImplementation;
using Hospital_Management_System_WebAPI.Services;
using Hospital_Management_System_WebAPI.Services.ServiceImplementation;
using Hospital_Management_Web_Api.Helpers;
using Hospital_Management_Web_Api.Middlewares;
using Hospital_Management_Web_Api.Repositories.Interface;
using Hospital_Management_Web_Api.Services.Interface;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


// adding DATABASE DI
builder.Services.AddSingleton<DbHelper>();

// adding Patient related injection
builder.Services.AddScoped<IPatientRepository, PatientRepository>();
builder.Services.AddScoped<IPatientService, PatientService>();


// addin doctor related injection
builder.Services.AddScoped<IDoctorRepository, DoctorRepository>();

builder.Services.AddScoped<IDoctorService, DoctorService>();


// adding appointment related injection
builder.Services.AddScoped<IAppointmentRepository, AppointmentRepository>();
builder.Services.AddScoped<IAppointmentService, AppointmentService>();


builder.Services.AddScoped<IReportRepository, ReportRepository>();
builder.Services.AddScoped<IReportService, ReportService>();

//adding mail service
builder.Services.AddScoped<EmailService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

//logging middle ware
app.UseMiddleware<RequestLoggingMiddleware>();

//exception middleware
app.UseMiddleware<ExceptionMiddleware>();

app.MapControllers();

app.Run();
