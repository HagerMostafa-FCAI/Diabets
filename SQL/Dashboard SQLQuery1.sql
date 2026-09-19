-- Question 1: What is the total number of patients?

SELECT COUNT(*) AS Total_Patients
FROM diabetes;

-- Question 2: What percentage of patients have diabetes?

SELECT 
    CAST(
        ROUND(
            SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Percentage
FROM diabetes;

-- Question 3: How is the population distributed between diabetic and non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    COUNT(*) AS Patient_Count
FROM diabetes
GROUP BY Outcome;

-- Question 4: What is the average age of diabetic vs. non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    ROUND(AVG(Age), 2) AS Average_Age
FROM diabetes
GROUP BY Outcome;

-- Question 5: What is the average glucose level for diabetic vs. non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    ROUND(AVG(Glucose), 2) AS Average_Glucose
FROM diabetes
GROUP BY Outcome;

-- Question 6: What is the average BMI for diabetic vs. non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    ROUND(AVG(BMI), 2) AS Average_BMI
FROM diabetes
GROUP BY Outcome;

-- Question 7: Which age group has the highest diabetes rate?

SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS Age_Group,

    COUNT(*) AS Total_Patients,

    SUM(CASE 
        WHEN Outcome = 1 THEN 1 
        ELSE 0 
    END) AS Diabetic_Patients,

    CAST(
        ROUND(
            SUM(CASE 
                WHEN Outcome = 1 THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Rate

FROM diabetes

GROUP BY
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END

ORDER BY Diabetes_Rate DESC;