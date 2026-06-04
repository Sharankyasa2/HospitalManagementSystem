# Hospital Management System - Web API

## 📋 Overview

The **Hospital Management System** is a comprehensive ASP.NET Core 8 Web API designed to manage hospital operations efficiently. It provides endpoints for patient registration, doctor management, appointment scheduling, and generating business reports. The system includes email notification features and follows industry-standard architectural patterns.

The application is built using a **3-tier architecture** with separation of concerns: Controllers, Services, and Repositories, ensuring maintainability and scalability.

---

## ✨ Key Features

### 1. **Patient Management**
- Register and manage patient profiles
- Update patient information (name, DOB, contact details, etc.)
- Deactivate patient accounts with email notifications
- Retrieve patient details and lists
- Track creation and modification timestamps

### 2. **Doctor Management**
- Register and manage doctor profiles
- Define specializations (Cardiology, Orthopedics, etc.)
- Set consultation fees
- Manage doctor availability status
- Track doctor performance metrics

### 3. **Appointment Scheduling**
- Book appointments between patients and doctors
- Check appointment status (Scheduled, Completed, Cancelled)
- Cancel appointments with automatic email notifications
- View appointment history
- Track appointment dates and cancellation details

### 4. **Reporting & Analytics**
- Generate appointment reports filtered by date range
- Calculate revenue by doctor specialization
- Analyze doctor appointment statistics
- Export comprehensive hospital analytics

### 5. **Email Notifications**
- Automated email confirmations for patient registration
- Account deactivation notifications
- Appointment booking confirmation emails
- SMTP configuration for Gmail integration

### 6. **Middleware & Error Handling**
- Global exception handling middleware
- Request logging for audit trails
- Structured error responses
- CORS enabled for cross-origin requests

---

## 🏗️ Project Architecture

### Directory Structure
```
Hospital_Management_System_WebAPI/
├── Controllers/              # API endpoint controllers
│   ├── PatientController.cs
│   ├── DoctorController.cs
│   ├── AppointmentController.cs
│   ├── ReportController.cs
│   └── WeatherForecastController.cs
│
├── Models/                  # Data models
│   ├── POCO/               # Plain Old CLR Objects (Database entities)
│   │   ├── Patient.cs
│   │   ├── Doctor.cs
│   │   ├── Appointment.cs
│   │   └── Person.cs
│   │
│   └── DTOs/              # Data Transfer Objects (Request/Response)
│       ├── Patient/
│       │   ├── CreatePatientDto.cs
│       │   ├── UpdatePatientDto.cs
│       │   └── PatientResponseDto.cs
│       ├── Doctor/
│       │   ├── CreateDoctorDto.cs
│       │   └── DoctorResponseDto.cs
│       └── Appointment/
│           ├── BookAppointmentDto.cs
│           ├── CancelAppointmentDto.cs
│           ├── AppointmentReportDto.cs
│           ├── DoctorAppointmentStatsDto.cs
│           └── RevenueBySpecializationDto.cs
│
├── Services/              # Business logic layer
│   ├── ServiceInterface/  # Service contracts (Interfaces)
│   │   ├── IPatientService.cs
│   │   ├── IDoctorService.cs
│   │   ├── IAppointmentService.cs
│   │   └── IReportService.cs
│   │
│   ├── ServiceImplementation/  # Service implementations
│   │   ├── PatientService.cs
│   │   ├── DoctorService.cs
│   │   ├── AppointmentService.cs
│   │   └── ReportService.cs
│   │
│   └── EmailService.cs        # Email notification service
│
├── Repository/           # Data access layer
│   ├── RepoInterface/   # Repository contracts
│   │   ├── IPatientRepository.cs
│   │   ├── IDoctorRepository.cs
│   │   ├── IAppointmentRepository.cs
│   │   └── IReportRepository.cs
│   │
│   └── RepoImplementation/  # Repository implementations
│       ├── PatientRepository.cs
│       ├── DoctorRepository.cs
│       ├── AppointmentRepository.cs
│       └── ReportRepository.cs
│
├── Middleware/          # Custom middleware
│   ├── ExceptionMiddleware.cs    # Global exception handling
│   └── RequestLoggingMiddleware.cs # Request/Response logging
│
├── Helpers/            # Utility classes
│   └── DbHelper.cs     # Database connection helper
│
├── SQLFILES/          # SQL scripts
│   ├── ProjectTables.sql
│   ├── SampleData.sql
│   └── ProjectStoredProcedures/
│       ├── PatientSPs.sql
│       ├── DoctorSPs.sql
│       ├── AppointmentsSPs.sql
│       └── ReportsSPs.sql
│
├── Properties/
│   └── launchSettings.json  # Launch configuration
│
├── Program.cs          # Application startup configuration
├── appsettings.json    # Configuration settings
├── Hospital_Management_System_WebAPI.csproj  # Project file
└── Hospital_Management_System_WebAPI.http   # HTTP requests file
```

---

## 🔧 Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Framework** | ASP.NET Core | 8.0 |
| **Language** | C# | Latest |
| **Database** | Microsoft SQL Server | - |
| **ORM** | ADO.NET (Direct SQL & Stored Procedures) | - |
| **Email** | MailKit | 4.17.0 |
| **API Documentation** | Swagger/OpenAPI | 6.6.2 |
| **Database Driver** | Microsoft.Data.SqlClient | 7.0.1 |

---

## 📦 Dependencies

```xml
<ItemGroup>
  <PackageReference Include="MailKit" Version="4.17.0" />
  <PackageReference Include="Microsoft.Data.SqlClient" Version="7.0.1" />
  <PackageReference Include="Swashbuckle.AspNetCore" Version="6.6.2" />
</ItemGroup>
```

---

## 🗄️ Database Schema

### Tables

#### **Patients Table**
- Stores patient information and registration details
- Fields: PatientCode (PK), FullName, DOB, Gender, Phone, Email, IsActive, CreatedAt, UpdatedAt
- Relationships: Referenced by Appointments table

#### **Doctors Table**
- Maintains doctor profiles and specializations
- Fields: DoctorCode (PK), FullName, Specialization, Phone, ConsultationFee, IsAvailable, CreatedAt, UpdatedAt
- Relationships: Referenced by Appointments table

#### **Appointments Table**
- Records patient-doctor appointments and statuses
- Fields: AppointmentId (PK), PatientCode (FK), DoctorCode (FK), AppointmentDate, AppointmentStatus, CancelledAt, CreatedAt, UpdatedAt
- Foreign Keys: Links to Patients and Doctors tables

### Stored Procedures

The system includes comprehensive stored procedures for:
- **PatientSPs.sql**: CRUD operations for patients
- **DoctorSPs.sql**: Doctor management procedures
- **AppointmentsSPs.sql**: Appointment booking, cancellation, and status management
- **ReportsSPs.sql**: Analytics and reporting queries

---

## 🌐 API Endpoints

### **Patient Controller** (`/api/patient`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/patient/all` | Retrieve all patients |
| GET | `/api/patient/{patientCode}` | Get patient by ID |
| POST | `/api/patient` | Register new patient |
| PUT | `/api/patient/{patientCode}` | Update patient details |
| DELETE | `/api/patient/deactivate/{patientCode}` | Deactivate patient account |

### **Doctor Controller** (`/api/doctor`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/doctor/all` | Retrieve all doctors |
| GET | `/api/doctor/{doctorCode}` | Get doctor by ID |
| POST | `/api/doctor` | Register new doctor |
| PUT | `/api/doctor/{doctorCode}` | Update doctor details |

### **Appointment Controller** (`/api/appointment`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/appointment` | Book new appointment |
| DELETE | `/api/appointment/{appointmentId}` | Cancel appointment |
| GET | `/api/appointment/patient/{patientCode}` | Get patient appointments |
| GET | `/api/appointment/doctor/{doctorCode}` | Get doctor appointments |

### **Report Controller** (`/api/report`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/report/appointments` | Get appointment report |
| GET | `/api/report/revenue/specialization` | Revenue by specialization |
| GET | `/api/report/doctor/stats` | Doctor appointment statistics |

---

## 🚀 Getting Started

### Prerequisites

- .NET 8.0 SDK or later
- SQL Server (Express or Full Edition)
- Visual Studio 2022 or Visual Studio Code
- Postman or similar API testing tool (optional)

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd HospitalMSProject
   ```

2. **Open the Project**
   ```bash
   cd Hospital_Management_System_WebAPI
   ```

3. **Restore NuGet Packages**
   ```bash
   dotnet restore
   ```

4. **Configure Database Connection**
   - Edit `appsettings.json`
   - Update `ConnectionStrings.DefaultConnection` with your SQL Server details:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=YOUR_SERVER;Database=Hospital_Management_DB;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;"
   }
   ```

5. **Create Database and Tables**
   - Execute SQL scripts in the following order:
     1. `sql/1_tables.sql` - Creates all tables
     2. `sql/2_seed.sql` - Inserts sample data
     3. `sql/3_stored_procedures.sql` - Creates stored procedures

   **Or use the main SQL file:**
   - Execute `HMS.sql` for complete database setup

6. **Configure Email Service**
   - Update `appsettings.json` with SMTP settings:
   ```json
   "SmtpSettings": {
     "Host": "your-smtp-host",
     "Port": 587,
     "Username": "your-email@example.com",
     "Password": "your-app-password",
     "FromEmail": "sender@example.com",
     "FromName": "Hospital Name"
   }
   ```

7. **Run the Application**
   ```bash
   dotnet run
   ```

8. **Access the API**
   - Base URL: `https://localhost:5001` (or `http://localhost:5000`)
   - Swagger UI: `https://localhost:5001/swagger` (in Development mode)

---

## 📝 Configuration

### appsettings.json

```json
{
  "SmtpSettings": {
    "Host": "smtp.gmail.com",
    "Port": 587,
    "Username": "your-email@gmail.com",
    "Password": "your-app-password",
    "FromEmail": "your-email@gmail.com",
    "FromName": "Hospital Name"
  },
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER\\SQLEXPRESS;Database=Hospital_Management_DB;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

---

## 🔐 Security Considerations

1. **Email Credentials**: Store sensitive credentials in environment variables or Azure Key Vault, not in appsettings.json
2. **Connection Strings**: Use Windows Authentication or secure credential management
3. **CORS Configuration**: Update `Program.cs` for production deployments
4. **Input Validation**: All DTOs include data validation attributes
5. **Error Handling**: Global exception middleware prevents sensitive data exposure

---

## 🛠️ Development Patterns

### Dependency Injection
The project uses .NET Core's built-in DI container configured in `Program.cs`:
```csharp
// Services are registered with appropriate lifetimes:
builder.Services.AddSingleton<DbHelper>();
builder.Services.AddScoped<IPatientService, PatientService>();
builder.Services.AddScoped<IPatientRepository, PatientRepository>();
```

### Repository Pattern
- **Repository Interfaces**: Define data access contracts
- **Repository Implementations**: Execute SQL queries and stored procedures
- **Separation of Concerns**: Data access logic separated from business logic

### Service Layer
- **Service Interfaces**: Define business logic contracts
- **Service Implementations**: Implement business rules and orchestrate repository calls
- **DTOs**: Used for request/response transformation

---

## 📊 API Response Examples

### Patient Registration Response
```json
{
  "status": 201,
  "message": "Patient added successfully",
  "data": {
    "patientCode": 1,
    "fullName": "John Doe",
    "email": "john@example.com",
    "createdAt": "2024-06-03T10:30:00Z"
  }
}
```

### Appointment Report Response
```json
{
  "status": 200,
  "message": "Report generated successfully",
  "data": [
    {
      "appointmentId": 1,
      "patientName": "John Doe",
      "doctorName": "Dr. Smith",
      "specialization": "Cardiology",
      "appointmentDate": "2024-06-10T09:00:00Z",
      "status": "Scheduled",
      "consultationFee": 500.00
    }
  ]
}
```

---

## 🧪 Testing

### Using Swagger UI
1. Navigate to `https://localhost:5001/swagger`
2. Expand desired controller
3. Click "Try it out"
4. Enter parameters and click "Execute"

### Using Postman
1. Import the `Hospital_Management_System_WebAPI.http` file
2. Test each endpoint with sample data
3. Verify responses match expected format

### Sample Test Cases
- Register patient → Verify email notification
- Book appointment → Check appointment status
- Generate report → Verify calculations
- Update patient info → Confirm changes reflected

---

## 📈 Performance Considerations

1. **Database Indexes**: Created on commonly queried columns (PatientCode, DoctorCode, AppointmentDate)
2. **Stored Procedures**: Used for complex queries to reduce network round trips
3. **Connection Pooling**: Configured in connection string for efficient resource management
4. **Async Operations**: All controller methods are async for better resource utilization

---

## 🐛 Common Issues & Troubleshooting

### Issue: Database Connection Failed
**Solution**: 
- Verify SQL Server is running
- Check connection string in appsettings.json
- Ensure Windows Authentication is enabled (for integrated security)

### Issue: Email Not Sending
**Solution**:
- Verify SMTP credentials in appsettings.json
- For Gmail: Use App Password (not regular password)
- Ensure "Less Secure App Access" is enabled (if applicable)
- Check firewall allows port 587

### Issue: Swagger UI Not Loading
**Solution**:
- Ensure `app.Environment.IsDevelopment()` returns true
- Verify `.AddEndpointsApiExplorer()` and `.AddSwaggerGen()` are called

### Issue: Stored Procedures Not Found
**Solution**:
- Execute SQL scripts in correct order (tables → stored procedures)
- Verify database name matches connection string
- Check stored procedure names match repository method calls

---

## 📚 Code Examples

### Creating a New Patient
```csharp
var patientDto = new CreatePatientDto 
{
    FullName = "John Doe",
    DOB = new DateTime(1990, 05, 15),
    Gender = "Male",
    Phone = "1234567890",
    Email = "john@example.com"
};

// POST /api/patient
await _patientService.AddPatientAsync(patientDto);
```

### Booking an Appointment
```csharp
var appointmentDto = new BookAppointmentDto
{
    PatientCode = 1,
    DoctorCode = 1,
    AppointmentDate = DateTime.Now.AddDays(7)
};

// POST /api/appointment
await _appointmentService.BookAppointmentAsync(appointmentDto);
```

### Generating a Report
```csharp
var report = await _reportService.GetAppointmentReportAsync(
    startDate: DateTime.Now.AddMonths(-1),
    endDate: DateTime.Now
);
```

---

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'Add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

---

## 📄 Project Structure Summary

| Layer | Responsibility | Key Classes |
|-------|-----------------|------------|
| **Presentation** | API endpoints | PatientController, DoctorController, etc. |
| **Business Logic** | Rules & workflows | PatientService, AppointmentService, etc. |
| **Data Access** | Database operations | PatientRepository, AppointmentRepository, etc. |
| **Database** | Data persistence | SQL Server, Stored Procedures |

---

## 🔄 Workflow Example: Patient Registration

1. **User Request**: POST `/api/patient` with patient details
2. **Controller**: `PatientController.AddPatient()` receives request
3. **Service**: `PatientService.AddPatientAsync()` validates business rules
4. **Repository**: `PatientRepository.AddPatientAsync()` executes stored procedure
5. **Database**: Inserts record and returns identity
6. **Email Service**: Sends confirmation email
7. **Response**: Returns 201 Created status

---

## 🚀 Future Enhancements

- [ ] Authentication & Authorization (JWT)
- [ ] Role-based access control
- [ ] Appointment reminders (SMS/Email)
- [ ] Doctor rating and review system
- [ ] Prescription management
- [ ] Billing and invoice generation
- [ ] Patient medical records
- [ ] Advanced analytics dashboard
- [ ] Mobile app integration

---

## 📞 Support & Documentation

- **API Documentation**: Swagger/OpenAPI (Available at `/swagger` in development)
- **SQL Documentation**: SQL scripts include detailed comments
- **Code Comments**: Business logic includes inline documentation
- **Email Support**: Configure SMTP for notifications

---

## 📄 License

This project is the property of SHARAN HOSPITALS. All rights reserved.

---

## 👥 Author Information

**Project Name**: Hospital Management System Web API  
**Framework**: ASP.NET Core 8  
**Database**: Microsoft SQL Server  
**Status**: Production Ready  

---

## ✅ Checklist Before Deployment

- [ ] Database setup completed with all SQL scripts
- [ ] Connection string configured for production SQL Server
- [ ] SMTP credentials updated for email notifications
- [ ] CORS policy configured for frontend domain
- [ ] Error logging configured
- [ ] API tested with Postman/Swagger
- [ ] All endpoints verified for response accuracy
- [ ] Performance tested under load
- [ ] Security vulnerabilities assessed
- [ ] Database backups configured
- [ ] Monitoring and alerting setup

---

**Last Updated**: June 2024  
**Version**: 1.0.0  
**Status**: Ready for Production
