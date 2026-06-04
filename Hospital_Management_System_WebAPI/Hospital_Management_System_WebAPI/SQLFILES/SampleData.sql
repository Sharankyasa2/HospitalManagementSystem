-- PATIENTS SAMPLE DATA

INSERT INTO Patients
(FullName, DOB, Gender, Phone, Email)
VALUES
('Sharan Kyasa', '2003-05-10', 'Male', '9876500001', 'sharan@gmail.com'),

('Rahul Sharma', '1999-08-14', 'Male', '9876500002', 'rahul@gmail.com'),

('Sneha Reddy', '2001-11-20', 'Female', '9876500003', 'sneha@gmail.com'),

('Priya Nair', '1998-03-25', 'Female', '9876500004', 'priya@gmail.com'),

('Kiran Kumar', '2000-07-12', 'Male', '9876500005', 'kiran@gmail.com');


-- DOCTORS SAMPLE DATA

INSERT INTO Doctors
(FullName, Specialization, Phone, ConsultationFee)
VALUES
('Dr. Rajesh', 'Cardiology', '9000000001', 800.00),
('Dr. Vikram', 'Cardiology', '9000000005', 600.00),
('Dr. Anil', 'Cardiology', '9000000016', 750.00),
('Dr. Sneha', 'Cardiology', '9000000017', 900.00),

('Dr. Meena', 'Neurology', '9000000002', 1200.00),
('Dr. Rohan', 'Neurology', '9000000018', 1100.00),
('Dr. Divya', 'Neurology', '9000000019', 1000.00),

('Dr. Arjun', 'Orthopedics', '9000000003', 700.00),
('Dr. Karthik', 'Orthopedics', '9000000020', 850.00),
('Dr. Pooja', 'Orthopedics', '9000000021', 750.00),

('Dr. Kavya', 'Dermatology', '9000000004', 500.00),
('Dr. Neha', 'Dermatology', '9000000022', 650.00),
('Dr. Sanjay', 'Dermatology', '9000000023', 550.00),

('Dr. Suresh', 'Pediatrics', '9000000024', 650.00),
('Dr. Ananya', 'Pediatrics', '9000000025', 700.00),
('Dr. Ravi', 'Pediatrics', '9000000026', 600.00),

('Dr. Priya', 'General Medicine', '9000000027', 1000.00),
('Dr. Lakshmi', 'General Medicine', '9000000028', 1200.00),
('Dr. Shalini', 'General Medicine', '9000000029', 1100.00);


-- APPOINTMENTS SAMPLE DATA
INSERT INTO Appointments
(PatientCode, DoctorCode, AppointmentDate, AppointmentStatus)
VALUES
(1000, 100, '2026-05-30 10:00:00', 'Scheduled'),

(1001, 101, '2026-05-30 11:00:00', 'Completed'),

(1002, 102, '2026-05-31 09:30:00', 'Scheduled'),

(1003, 103, '2026-06-01 02:00:00', 'Cancelled'),

(1004, 104, '2026-06-02 04:30:00', 'Scheduled');