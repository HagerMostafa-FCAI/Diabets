-- Question 1: How does BMI differ between diabetic and non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    CAST(ROUND(MIN(BMI), 2) AS DECIMAL(6,2)) AS Minimum_BMI,
    CAST(ROUND(MAX(BMI), 2) AS DECIMAL(6,2)) AS Maximum_BMI,
    CAST(ROUND(AVG(BMI), 2) AS DECIMAL(6,2)) AS Average_BMI
FROM diabetes
GROUP BY Outcome;

-- Question 2: Which BMI range has the highest diabetes rate?

SELECT
    CASE
        WHEN BMI < 18.5 THEN 'Underweight (<18.5)'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal (18.5-24.9)'
        WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight (25-29.9)'
        WHEN BMI BETWEEN 30 AND 34.9 THEN 'Obese I (30-34.9)'
        WHEN BMI BETWEEN 35 AND 39.9 THEN 'Obese II (35-39.9)'
        ELSE 'Obese III (40+)'
    END AS BMI_Range,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) AS Diabetic_Patients,
    CAST(
        ROUND(
            SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Rate
FROM diabetes
WHERE BMI > 0
GROUP BY
    CASE
        WHEN BMI < 18.5 THEN 'Underweight (<18.5)'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal (18.5-24.9)'
        WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight (25-29.9)'
        WHEN BMI BETWEEN 30 AND 34.9 THEN 'Obese I (30-34.9)'
        WHEN BMI BETWEEN 35 AND 39.9 THEN 'Obese II (35-39.9)'
        ELSE 'Obese III (40+)'
    END
ORDER BY Diabetes_Rate DESC;

-- Question 3: How does diabetes prevalence change as BMI increases?

SELECT
    CASE
        WHEN BMI < 20 THEN 'Below 20'
        WHEN BMI BETWEEN 20 AND 24.9 THEN '20-24.9'
        WHEN BMI BETWEEN 25 AND 29.9 THEN '25-29.9'
        WHEN BMI BETWEEN 30 AND 34.9 THEN '30-34.9'
        WHEN BMI BETWEEN 35 AND 39.9 THEN '35-39.9'
        ELSE '40+'
    END AS BMI_Range,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) AS Diabetic_Patients,
    CAST(
        ROUND(
            SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Rate
FROM diabetes
WHERE BMI > 0
GROUP BY
    CASE
        WHEN BMI < 20 THEN 'Below 20'
        WHEN BMI BETWEEN 20 AND 24.9 THEN '20-24.9'
        WHEN BMI BETWEEN 25 AND 29.9 THEN '25-29.9'
        WHEN BMI BETWEEN 30 AND 34.9 THEN '30-34.9'
        WHEN BMI BETWEEN 35 AND 39.9 THEN '35-39.9'
        ELSE '40+'
    END
ORDER BY MIN(BMI);

-- Question 4: What is the average insulin level for diabetic vs. non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    CAST(ROUND(AVG(NULLIF(Insulin, 0)), 2) AS DECIMAL(8,2)) AS Average_Insulin
FROM diabetes
GROUP BY Outcome;

-- Question 5: Which insulin range has the highest diabetes rate?

SELECT
    CASE
        WHEN Insulin < 50 THEN 'Low (<50)'
        WHEN Insulin BETWEEN 50 AND 99 THEN '50-99'
        WHEN Insulin BETWEEN 100 AND 149 THEN '100-149'
        WHEN Insulin BETWEEN 150 AND 199 THEN '150-199'
        ELSE '200+'
    END AS Insulin_Range,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) AS Diabetic_Patients,
    CAST(
        ROUND(
            SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Rate
FROM diabetes
WHERE Insulin > 0
GROUP BY
    CASE
        WHEN Insulin < 50 THEN 'Low (<50)'
        WHEN Insulin BETWEEN 50 AND 99 THEN '50-99'
        WHEN Insulin BETWEEN 100 AND 149 THEN '100-149'
        WHEN Insulin BETWEEN 150 AND 199 THEN '150-199'
        ELSE '200+'
    END
ORDER BY MIN(Insulin);
-- Question 6: How does blood pressure differ between diabetic and non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    CAST(ROUND(MIN(BloodPressure), 2) AS DECIMAL(6,2)) AS Minimum_BloodPressure,
    CAST(ROUND(MAX(BloodPressure), 2) AS DECIMAL(6,2)) AS Maximum_BloodPressure,
    CAST(
        ROUND(
            AVG(NULLIF(BloodPressure, 0)),
            2
        ) AS DECIMAL(6,2)
    ) AS Average_BloodPressure
FROM diabetes
GROUP BY Outcome;
-- Question 7: What is the diabetes rate among patients with both high BMI and high insulin levels?

SELECT
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) AS Diabetic_Patients,
    CAST(
        ROUND(
            SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Rate
FROM diabetes
WHERE BMI >= 30
  AND Insulin >= 200;