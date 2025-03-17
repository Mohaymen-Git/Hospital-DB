use master
GO

--create Hospital database
create database Hospital;
use Hospital
GO

--create Patient table
create table Patient
(
Patient_ID int IDENTITY(1,1) PRIMARY KEY,
First_Name varchar(100) NOT NULL,
Middle_Name varchar(100) NOT NULL,
Last_Name varchar(100) NOT NULL,
DateOfBirth date,
Gender varchar(10) CHECK(Gender IN ('M','F','Other')),
InsuranceDetails varchar(150),
Address varchar(100)
);

--create table Patient_Contact
create table Patient_Contact
(
Patient_ID int FOREIGN KEY references Patient(Patient_ID),
Contact_Number int NOT NULL,
constraint PC_primarykey PRIMARY KEY (Patient_ID)
);


--create Bill table
create table Bill
(
Bill_ID int PRIMARY KEY,
Patient_ID int FOREIGN KEY references Patient(Patient_ID),
TotalAmount decimal(10,2) NOT NULL,
PaymentStatus varchar(20) CHECK(PaymentStatus IN ('Paid','Unpaid')),
DateIssued date NOT NULL
);


--create Room table
create table Room
(
Room_ID int PRIMARY KEY,
RoomNumber varchar(10) NOT NULL,
RoomType varchar(50),
AvailabilityStatus varchar(20) CHECK(AvailabilityStatus IN ('Available','Occupied'))
);

--create Patient_Room table
create table Patient_Room
(
Patient_ID int FOREIGN KEY references Patient(Patient_ID),
Room_ID int FOREIGN KEY references Room(Room_ID),
Duration int NOT NULL,
constraint PR_primarykey PRIMARY KEY (Patient_ID,Room_ID)
);


--create Appointment table
create table Appointment
(
Appointment_ID int PRIMARY KEY,
Patient_ID int FOREIGN KEY references Patient(Patient_ID),
AppointmentDate date NOT NULL,
Status varchar(50) CHECK(Status IN ('Scheduled','Completed','Cancelled'))
);


--create Doctor table
create table Doctor
(
Doctor_ID int PRIMARY KEY,
Name varchar(100) NOT NULL,
Specialty varchar(30) NOT NULL,
YearsOfExperience int CHECK(YearsOfExperience >= 0),
Department_ID int 
);

--create Doctor_Patient table
create table Doctor_Patient
(
Doctor_ID int FOREIGN KEY references Doctor(Doctor_ID),
Patient_ID int FOREIGN KEY references Patient(Patient_ID),
constraint DP_primarykey PRIMARY KEY (Doctor_ID,Patient_ID)
);

--create Doctor_Contact table
create table Doctor_Contact
(
Doctor_ID int FOREIGN KEY references Doctor(Doctor_ID),
Contact_Number int NOT NULL,
constraint DC_primarykey PRIMARY KEY (Doctor_ID)
);


--create Treatment table
create table Treatment
(
Treatment_ID int PRIMARY KEY,
Diagnosis varchar(200),
TreatmentDetails text 
);

--create Patient_Treatment table
create table Patient_Treatment 
(
Patient_ID int FOREIGN KEY references Patient(Patient_ID),
Treatment_ID int FOREIGN KEY references Treatment(Treatment_ID),
constraint PT_primarykey PRIMARY KEY (Patient_ID,Treatment_ID)
);

--create Doctor_Treatment table
create table Doctor_Treatment
(
Doctor_ID int FOREIGN KEY references Doctor(Doctor_ID),
Treatment_ID int FOREIGN KEY references Treatment(Treatment_ID),
constraint DT_primarykey PRIMARY KEY (Doctor_ID,Treatment_ID)
);


--create Department table
create table Department
(
Department_ID int PRIMARY KEY,
Name varchar(100) NOT NULL,
Location varchar(50),
HeadOfDepartment int -- Placeholder for the foreign key
);


--create Staff table
create table Staff
(
Staff_ID int PRIMARY KEY,
First_Name varchar(100) NOT NULL,
Middle_Name varchar(100) NOT NULL,
Last_Name varchar(100) NOT NULL,
Role varchar(50) NOT NULL,
ContactNumber varchar(15),
Manager_ID int FOREIGN KEY references Staff(Staff_ID),
Department_ID int FOREIGN KEY references Department(Department_ID)
);

--Add Department foreign key for Doctor
Alter table Doctor
add constraint FK_Doctor_Dpartment
FOREIGN KEY(Department_ID) references Department(Department_ID);

--Add Staff foreign key for Department
Alter table Department
add constraint FK_Department_Staff
FOREIGN KEY (HeadOfDepartment) references Staff(Staff_ID);


-- Sample data insertion

USE Hospital;
GO

-- Insert sample data into Department table
INSERT INTO Department (Department_ID, Name, Location, HeadOfDepartment)
VALUES
(1, 'Cardiology', 'Building A - Floor 2', NULL),
(2, 'Neurology', 'Building A - Floor 3', NULL),
(3, 'Pediatrics', 'Building B - Floor 1', NULL),
(4, 'Oncology', 'Building B - Floor 2', NULL);

-- Insert sample data into Doctor table
INSERT INTO Doctor (Doctor_ID, Name, Specialty, YearsOfExperience, Department_ID)
VALUES
(1, 'Ahmed Khaled', 'Cardiologist', 10, 1),
(2, 'Sarah Ismail', 'Neurologist', 8, 2),
(3, 'Hassan Ali', 'Pediatrician', 5, 3),
(4, 'Layla Mahmoud', 'Oncologist', 7, 4),
(5, 'Omar Youssef', 'Cardiologist', 12, 1),
(6, 'Nour Hany', 'Neurologist', 6, 2),
(7, 'Yasmine Tarek', 'Pediatrician', 4, 3);

-- Insert sample data into Patient table
INSERT INTO Patient (First_Name, Middle_Name, Last_Name, DateOfBirth, Gender, InsuranceDetails, Address)
VALUES
 ('Ali', 'Hassan', 'Omar', '1985-05-14', 'M', 'Basic Plan', 'Cairo'),
 ('Mona', 'Ahmed', 'Zaki', '1990-08-22', 'F', 'Premium Plan', 'Giza'),
 ('Khaled', 'Mahmoud', 'Ibrahim', '1978-11-30', 'M', 'None', 'Alexandria'),
 ('Sara', 'Nour', 'Fouad', '1995-02-17', 'F', 'Basic Plan', 'Cairo'),
 ('Youssef', 'Ali', 'Farid', '2000-07-25', 'M', 'Premium Plan', 'Giza'),
 ('Fatma', 'Tamer', 'Hussein', '1988-09-13', 'F', 'None', 'Tanta'),
 ('Amira', 'Omar', 'Salem', '1992-03-19', 'F', 'Basic Plan', 'Asyut'),
 ('Hussein', 'Sami', 'Adel', '1981-12-06', 'M', 'Basic Plan', 'Cairo'),
 ('Aya', 'Hany', 'Sameh', '1999-06-04', 'F', 'Premium Plan', 'Alexandria'),
 ('Mohamed', 'Tarek', 'Hafez', '2003-01-15', 'M', 'None', 'Port Said'),
 ('Layla', 'Youssef', 'Ibrahim', '1987-10-23', 'F', 'Basic Plan', 'Giza'),
 ('Omar', 'Ismail', 'Hassan', '1994-04-12', 'M', 'Premium Plan', 'Cairo'),
 ('Rana', 'Ali', 'Kamel', '1996-07-18', 'F', 'None', 'Cairo'),
 ('Mahmoud', 'Nabil', 'Hassan', '1975-09-20', 'M', 'Basic Plan', 'Mansoura'),
 ('Salma', 'Ahmed', 'Gamal', '2001-11-09', 'F', 'Premium Plan', 'Luxor');

-- Insert sample data into Room table
INSERT INTO Room (Room_ID, RoomNumber, RoomType, AvailabilityStatus)
VALUES
(1, 101, 'General', 'Available'),
(2, 102, 'ICU', 'Available'),
(3, 103, 'Private', 'Available'),
(4, 104, 'General', 'Available'),
(5, 105, 'ICU', 'Available');

-- Assign patients to rooms
INSERT INTO Patient_Room (Patient_ID, Room_ID, Duration)
VALUES
(1, 1, 5),
(2, 2, 3),
(3, 3, 7),
(4, 4, 2),
(5, 5, 6);

-- Assign doctors to patients
INSERT INTO Doctor_Patient (Doctor_ID, Patient_ID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

-- Insert sample treatments
INSERT INTO Treatment (Treatment_ID, Diagnosis, TreatmentDetails)
VALUES
(1, 'Heart Disease', 'Prescribed medication and monitoring'),
(2, 'Migraine', 'Prescribed painkillers and lifestyle changes'),
(3, 'Asthma', 'Provided inhaler and breathing exercises'),
(4, 'Cancer', 'Started chemotherapy sessions'),
(5, 'Fracture', 'Applied cast and follow-up care');

-- Link treatments to patients
INSERT INTO Patient_Treatment (Patient_ID, Treatment_ID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Link treatments to doctors
INSERT INTO Doctor_Treatment (Doctor_ID, Treatment_ID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert sample appointments
INSERT INTO Appointment (Appointment_ID, Patient_ID, AppointmentDate, Status)
VALUES
(1, 1, '2024-01-10', 'Scheduled'),
(2, 2, '2024-01-12', 'Completed'),
(3, 3, '2024-01-15', 'Scheduled'),
(4, 4, '2024-01-18', 'Cancelled'),
(5, 5, '2024-01-20', 'Scheduled');

-- Insert sample billing information
INSERT INTO Bill (Bill_ID, Patient_ID, TotalAmount, PaymentStatus, DateIssued)
VALUES
(1, 1, 5000, 'Paid', '2024-01-05'),
(2, 2, 3000, 'Unpaid', '2024-01-07'),
(3, 3, 7000, 'Paid', '2024-01-10'),
(4, 4, 2000, 'Paid', '2024-01-12'),
(5, 5, 6000, 'Unpaid', '2024-01-14');

-- Insert 7 staff members
INSERT INTO Staff (Staff_ID, First_Name, Middle_Name, Last_Name, Role, ContactNumber, Manager_ID, Department_ID)
VALUES
(1, 'Ahmed', 'Ali', 'Al-Farsi', 'Doctor', '01123456789', NULL, 1),  
(2, 'Mona', 'Mohamed', 'El-Sayed', 'Nurse', '01123456780', 1, 1),
(3, 'Youssef', 'Hassan', 'Abdullah', 'Technician', '01123456781', 2, 2),
(4, 'Fatima', 'Zahra', 'Hussein', 'Pharmacist', '01123456782', 1, 1),
(5, 'Khaled', 'Mohamed', 'Salah', 'Nurse', '01123456783', 1, 1),
(6, 'Sara', 'Mahmoud', 'Ibrahim', 'Administrator', '01123456784', 4, 3),
(7, 'Omar', 'Tariq', 'Al-Najjar', 'Surgeon', '01123456785', 1, 2);

-- Insert into Doctor_Contact 
INSERT INTO Doctor_Contact (Doctor_ID,Contact_Number)
values
(1,'01123456756'),
(2,'01265735755'),
(3,'01067245727'),
(4,'01567357577'),
(5,'01037274045')

-- INSERT INTO Patient_Contact
INSERT INTO Patient_Contact (Patient_ID,Contact_Number)
values
(1,'01123216756'),
(2,'01215735755'),
(3,'01067244527'),
(4,'01567313577'),
(5,'01037243045')
