-- View the entire table
SELECT * FROM Tobiloba.dbo.appointment;
-- In this table there are 110,527 rows and 14 columns of data

-- Change Hipertension and Handcap column name
EXEC sp_RENAME '[dbo].[appointment].[Hipertension]', 'Hypertension', 'COLUMN';

EXEC sp_RENAME 'dbo.appointment.Handcap', 'Handicap', 'COLUMN';

-- View table again to confirm change
SELECT * FROM Tobiloba.dbo.appointment;

-- Check for missing values or incorrect values
SELECT * FROM Tobiloba.dbo.appointment
WHERE Gender = NULL OR 
AppointmentDay = NULL OR 
Age = NULL OR Neighbourhood = NULL
OR Scholarship = null OR Scholarship > 1
OR Hypertension = NULL OR Hypertension > 1
OR Diabetes = NULL OR Diabetes > 1
OR Alcoholism = NULL OR Alcoholism > 1
OR Handicap = NULL OR Handicap > 1
OR No_show = null;

-- There are 199 such rows, so we have to delete them
DELETE FROM Tobiloba.dbo.appointment
WHERE Gender = NULL OR 
AppointmentDay = NULL OR 
Age = NULL OR Neighbourhood = NULL
OR Scholarship = null OR Scholarship > 1
OR Hypertension = NULL OR Hypertension > 1
OR Diabetes = NULL OR Diabetes > 1
OR Alcoholism = NULL OR Alcoholism > 1
OR Handicap = NULL OR Handicap > 1
OR No_show = null;

-- Total number of appointees
SELECT DISTINCT COUNT(*)  AS Appointees FROM Tobiloba.dbo.appointment;

-- There are 110328 total appointees

-- Total number of male and female appointees
SELECT COUNT(Gender) AS Count_Gender, Gender FROM Tobiloba.dbo.appointment
GROUP BY Gender; 

-- There are 71730 female appointees and 38597 male appointees

-- Percentage of male appointees
SELECT(SELECT COUNT(Gender) FROM Tobiloba.dbo.appointment
WHERE Gender = 'M')*100.0/(SELECT COUNT(Gender)
FROM Tobiloba.dbo.appointment) AS Male_percent;
-- Percentage of female appointees
SELECT(SELECT COUNT(Gender) FROM Tobiloba.dbo.appointment
WHERE Gender = 'F')*100.0/(SELECT COUNT(Gender) AS Female_percent
FROM Tobiloba.dbo.appointment) AS Female_percent;

/* 35% of all appointees are male which means that
65% of all appointees are female */

-- Find the average age of an appointee
SELECT ROUND(AVG(Age),0) AS Average_Age
FROM Tobiloba.dbo.appointment
-- The average age is 37

-- Find the neighbourhood with the most appointees scheduled
SELECT Neighbourhood AS Mode, COUNT(*) AS Count 
FROM Tobiloba.dbo.appointment
GROUP BY Neighbourhood 
HAVING COUNT(*) >= ALL 
(SELECT COUNT(*) FROM Tobiloba.dbo.appointment GROUP BY Neighbourhood);
-- Jardim Camburi is the neiighbourhood with the most appointments scheduled

-- Change the Schedule date and Appointment date to datetime format
ALTER TABLE Tobiloba.dbo.appointment
ALTER COLUMN ScheduledDay date;

ALTER TABLE Tobiloba.dbo.appointment
ALTER COLUMN AppointmentDay date;

-- Find the first and last appointment date
SELECT MIN(AppointmentDay) AS first_day, 
MAX(AppointmentDay) AS last_day
FROM Tobiloba.dbo.appointment;

/* The first appointment date is 29/04/2016 and 
the last appointment date is 08/06/2016 */

-- Find the minimum youngest and oldest ages
SELECT MIN(Age) AS youngest, MAX(Age) AS oldest 
FROM Tobiloba.dbo.appointment;

/*The youngest age is shown to be -1 which indicates
that it is wrong and has to be cleaned*/

-- Drop rows where the Age column has values less than 0
DELETE FROM Tobiloba.dbo.appointment
WHERE Age < 0; -- only one row is affected

-- Check the youngest and oldest again to confirm
SELECT MIN(Age) AS youngest, MAX(Age) AS oldest 
FROM Tobiloba.dbo.appointment;

/* The youngest appointee is 0 and 
the oldest appointee is 115 years old */

-- Check the number of neighbourhoods in the database
SELECT COUNT(DISTINCT(Neighbourhood)) AS Count_Neighbourhood 
FROM Tobiloba.dbo.appointment;

-- There are 81 neighbourhoods represented

-- Find the percentage of appointees that showed up
SELECT(SELECT COUNT(*) FROM Tobiloba.dbo.appointment
WHERE No_show = 'No')*100.0/(SELECT COUNT(*) FROM Tobiloba.dbo.appointment) 
AS Showed_up;

-- 79.8% of people who made appointments showed up for the appointment
-- In other words, 20.2% of people did not show up for their appointment

/* Find the percentage of handicap appointees
that showed up for their appointment */
SELECT(SELECT COUNT(*) FROM Tobiloba.dbo.appointment
WHERE Handicap = 1 AND No_show ='No')*100.0/(SELECT COUNT(*)
FROM Tobiloba.dbo.appointment WHERE Handicap = 1) AS Handicap_showup_percent;
/* Approximately 82.1% of handicap appointees
showed up for their appointment */

/* Find the percentage of appointees with hypertension
that showed up for their appointment */
SELECT(SELECT COUNT(*) FROM Tobiloba.dbo.appointment
WHERE Hypertension = 1 AND No_show ='No')*100.0/(SELECT COUNT(*)
FROM Tobiloba.dbo.appointment WHERE Hypertension = 1)
AS Hypertension_showup_percent;
/* Approximately 82.7% of appointees with hypertension 
showed up for their appointment */

/* Find the percentage of appointees with diabetes
that showed up for their appointment */
SELECT(SELECT COUNT(*) FROM Tobiloba.dbo.appointment
WHERE Diabetes = 1 AND No_show ='No')*100.0/(SELECT COUNT(*)
FROM Tobiloba.dbo.appointment WHERE Diabetes = 1)
AS Diabetes_showup_percent;
/* Approximately 82% of appointees with diabetes 
showed up for their appointment */

/* Find the percentage of appointees with alcoholism 
that showed up for their appointment */
SELECT(SELECT COUNT(*) FROM Tobiloba.dbo.appointment
WHERE Alcoholism = 1 AND No_show ='No')*100.0/(SELECT COUNT(*)
FROM Tobiloba.dbo.appointment WHERE Alcoholism = 1)
AS Alcoholism_showup_percent;
/* Approximately 79.9% of appointees with alcoholism
showed up for their appointment */

/* Find the percentage of appointees funded by the government 
that showed up for their appointment */
SELECT(SELECT COUNT(*) FROM Tobiloba.dbo.appointment
WHERE Scholarship = 1 AND No_show ='No')*100.0/(SELECT COUNT(*)
FROM Tobiloba.dbo.appointment WHERE Scholarship = 1)
AS Scholarship_showup_percent;
/* Approximately 76.2% of appointees funded by the goverment
showed up for their appointment */

/* Find the percentage of appointees who received at least
one SMS that showed up for their appointment */
SELECT(SELECT COUNT(*) FROM Tobiloba.dbo.appointment
WHERE SMS_received = 1 AND No_show ='No')*100.0/(SELECT COUNT(*)
FROM Tobiloba.dbo.appointment WHERE SMS_received = 1)
AS SMS;
/* Approximately 72.4% of appointees who received at least
one SMS showed up for their appointment */

/* In general, we see that regardless of the condition,
-- about 20% of people did not make it for their appointment */

/* Now, let us create tables that will be used for
the data visualization */

/* Group by gender and whether they attended 
their appointment and save result as a table */
SELECT Gender, No_Show, COUNT(*) AS Gender_Count
FROM Tobiloba.dbo.appointment
GROUP BY No_Show, Gender
ORDER BY No_Show DESC, Gender;

/* Group by neighbourhood and whether they attended 
their appointment and save result as a table */
SELECT Neighbourhood, No_Show, COUNT(*) AS Neigh_Count
FROM Tobiloba.dbo.appointment
GROUP BY Neighbourhood, No_Show
ORDER BY Neighbourhood ASC, No_Show DESC;

/* Group by Scholarship and whether they attended 
their appointment and save result as a table */
SELECT Scholarship, No_Show, COUNT(*) AS Scholarship_Show
FROM Tobiloba.dbo.appointment
GROUP BY Scholarship, No_show
ORDER BY Scholarship ASC, No_Show DESC

/* Group by Hypertension and whether they attended 
their appointment and save result as a table */
SELECT Hypertension, No_Show, COUNT(*) AS Handicap_Show
FROM Tobiloba.dbo.appointment
GROUP BY Hypertension, No_show
ORDER BY Hypertension ASC, No_Show DESC

/* Group by Diabetes and whether they attended 
their appointment and save result as a table */
SELECT Diabetes, No_Show, COUNT(*) AS Handicap_Show
FROM Tobiloba.dbo.appointment
GROUP BY Diabetes, No_show
ORDER BY Diabetes ASC, No_Show DESC

/* Group by Alcoholism and whether they attended 
their appointment and save result as a table */
SELECT Alcoholism, No_Show, COUNT(*) AS Handicap_Show
FROM Tobiloba.dbo.appointment
GROUP BY Alcoholism, No_show
ORDER BY Alcoholism ASC, No_Show DESC

/* Group by Handicap and whether they attended 
their appointment and save result as a table */
SELECT Handicap, No_Show, COUNT(*) AS Handicap_Show
FROM Tobiloba.dbo.appointment
GROUP BY Handicap, No_show
ORDER BY Handicap ASC, No_Show DESC

/* Group by SMS_received  and whether they attended 
their appointment and save result as a table */
SELECT SMS_received, No_Show, COUNT(*) AS Handicap_Show
FROM Tobiloba.dbo.appointment
GROUP BY SMS_received, No_show
ORDER BY SMS_received ASC, No_Show DESC

-- That is the end of the data cleaning and analysis section of this case study
-- Data visualization will be carried out using Tableau