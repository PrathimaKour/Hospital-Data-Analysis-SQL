CREATE DATABASE HospitalDataAssignment;

USE hospitaldataassignment;

CREATE TABLE HospitalData 
(Hospital_Name VARCHAR(25), Location VARCHAR(25), Department VARCHAR(25), Doctors_count INT,
Patient_count INT, Admission_date DATE, Discharge_date DATE, Medical_Expenses DOUBLE);

SELECT * FROM hospitaldata;

LOAD DATA LOCAL INFILE 'C:/Users/prath/OneDrive/Desktop/Dhawle MySQL Assignment/HospitalData.csv'
INTO TABLE hospitaldata
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@Hospital_Name,
 @Location,
 @Department,
 @Doctors_count,
 @Patient_count,
 @Admission_date,
 @Discharge_date,
 @Medical_Expenses)

SET
Hospital_Name = @Hospital_Name,
Location = @Location,
Department = @Department,
Doctors_count = @Doctors_count,
Patient_count = @Patient_count,
Admission_date = STR_TO_DATE(@Admission_date, '%d-%m-%Y'),
Discharge_date = STR_TO_DATE(@Discharge_date, '%d-%m-%Y'),
Medical_Expenses = @Medical_Expenses;

-- Total Number of Patients: Write an SQL query to find the total number of patients across all hospitals. 
SELECT SUM(Patient_count) AS Total_Number_Of_Patients FROM Hospitaldata	;

-- Average Number of Doctors per Hospital: Retrieve the average count of doctors available in each hospital. 
SELECT Hospital_name, AVG(Doctors_count) AS Average_Count_of_doctors 
FROM Hospitaldata 
GROUP BY Hospital_name;

-- Top 3 Departments with the Highest Number of Patients: Find the top 3 hospital departments that have the highest number of patients. 
SELECT Department, SUM(Patient_Count) AS Total_Patients 
FROM Hospitaldata 
GROUP BY Department 
ORDER BY Total_Patients DESC LIMIT 3;

-- Hospital with the Maximum Medical Expenses: Identify the hospital that recorded the highest medical expenses. 
SELECT Hospital_Name, MAX(Medical_Expenses) AS Highest_Expense 
FROM Hospitaldata 
GROUP BY Hospital_name 
ORDER BY Highest_Expense DESC LIMIT 1;

-- Daily Average Medical Expenses: Calculate the average medical expenses per day for each hospital.
SELECT Hospital_Name, ROUND(SUM(Medical_Expenses) / SUM(DATEDIFF(Discharge_date, Admission_date)), 2) AS Daily_Avg_Expense 
FROM hospitaldata 
GROUP BY Hospital_Name;

-- Longest Hospital Stay: Find the patient with the longest stay by calculating the difference between Discharge Date and Admission Date. 
SELECT Hospital_Name, Admission_date, Discharge_date, DATEDIFF(Discharge_date, Admission_date) AS Hospital_Stay 
FROM Hospitaldata 
ORDER BY Hospital_Stay DESC LIMIT 1;

-- Total Patients Treated Per City: Count the total number of patients treated in each city. 
SELECT Location, SUM(Patient_count) AS Patients_Treated 
FROM Hospitaldata 
GROUP BY Location 
ORDER BY Patients_Treated DESC;

-- Average Length of Stay Per Department: Calculate the average number of days patients spend in each department. 
SELECT Department, AVG(DATEDIFF(Discharge_date, Admission_date)) AS Avg_Hospital_Stay 
FROM Hospitaldata 
GROUP BY Department 
ORDER BY Avg_Hospital_Stay DESC;

-- Identify the Department with the Lowest Number of Patients: Find the department with the least number of patients. 
SELECT Department, SUM(Patient_Count) AS Total_Patients 
FROM Hospitaldata 
GROUP BY Department 
ORDER BY Total_Patients ASC LIMIT 1;

-- Monthly Medical Expenses Report: Group the data by month and calculate the total medical expenses for each month. 
SELECT MONTHNAME(Admission_date) AS Month_Name, ROUND(SUM(Medical_Expenses),2) AS Total_Medical_Expenses 
FROM Hospitaldata 
GROUP BY MONTH(Admission_date), MONTHNAME(Admission_date) 
ORDER BY MONTH(Admission_date);

-- Rank Hospital By Expenses:
SELECT Hospital_name, SUM(Medical_expenses), RANK() OVER(ORDER BY SUM(Medical_Expenses) DESC) AS RNK 
FROM Hospitaldata	
GROUP BY Hospital_name;

-- Running Monthly Expenses: 
SELECT MONTHNAME(Admission_date) AS Monthname, ROUND(SUM(Medical_expenses),2)
FROM hospitaldata
GROUP BY Monthname;

-- Top City By Patient:
SELECT Location, SUM(Patient_count)
FROM hospitaldata
GROUP BY Location
ORDER BY SUM(Patient_count) DESC
LIMIT 1;