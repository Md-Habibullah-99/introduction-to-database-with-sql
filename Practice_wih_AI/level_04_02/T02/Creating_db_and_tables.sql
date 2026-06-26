-- Create the database
CREATE DATABASE HealthTrackAnalytics;
GO

USE HealthTrackAnalytics;
GO

-- Table 1: Departments (create this first since Doctors reference it)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50),
    Budget DECIMAL(12,2)
);

-- Table 2: Doctors (fixed BOOLEAN → BIT)
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2),
    DepartmentID INT,
    IsChief BIT DEFAULT 0,  -- Changed from BOOLEAN to BIT
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Table 3: Patients
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender CHAR(1),
    InsuranceProvider VARCHAR(50)
);

-- Table 4: Visits
CREATE TABLE Visits (
    VisitID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    VisitDate DATE,
    Diagnosis VARCHAR(100),
    TreatmentCode VARCHAR(20),
    VisitDuration INT, -- in minutes
    IsEmergency BIT DEFAULT 0,  -- Changed from BOOLEAN to BIT
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table 5: Prescriptions
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY,
    VisitID INT,
    MedicationName VARCHAR(100),
    Dosage VARCHAR(50),
    Quantity INT,
    Cost DECIMAL(10,2),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);
