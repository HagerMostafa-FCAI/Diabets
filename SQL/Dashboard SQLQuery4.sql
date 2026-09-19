-- Question 1: What is the diabetes rate among patients with high glucose and high BMI?

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
WHERE Glucose > 125
  AND BMI >= 30;

  -- Question 2: How does diabetes prevalence vary by number of pregnancies?

SELECT
    CASE
        WHEN Pregnancies = 0 THEN '0 Pregnancies'
        WHEN Pregnancies BETWEEN 1 AND 2 THEN '1-2 Pregnancies'
        WHEN Pregnancies BETWEEN 3 AND 5 THEN '3-5 Pregnancies'
        ELSE '6+ Pregnancies'
    END AS Pregnancy_Group,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) AS Diabetic_Patients,
    CAST(
        ROUND(
            SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Rate
FROM diabetes
GROUP BY
    CASE
        WHEN Pregnancies = 0 THEN '0 Pregnancies'
        WHEN Pregnancies BETWEEN 1 AND 2 THEN '1-2 Pregnancies'
        WHEN Pregnancies BETWEEN 3 AND 5 THEN '3-5 Pregnancies'
        ELSE '6+ Pregnancies'
    END
ORDER BY MIN(Pregnancies);

-- Question 3: How does diabetes prevalence vary across age and BMI categories?

SELECT
    CASE
        WHEN Age < 35 THEN 'Under 35'
        WHEN Age BETWEEN 35 AND 49 THEN '35-49'
        ELSE '50+'
    END AS Age_Group,
    CASE
        WHEN BMI < 30 THEN 'BMI < 30'
        ELSE 'BMI 30+'
    END AS BMI_Group,
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
        WHEN Age < 35 THEN 'Under 35'
        WHEN Age BETWEEN 35 AND 49 THEN '35-49'
        ELSE '50+'
    END,
    CASE
        WHEN BMI < 30 THEN 'BMI < 30'
        ELSE 'BMI 30+'
    END
ORDER BY Diabetes_Rate DESC;

-- Question 4: What percentage of diabetic patients have both high glucose and high BMI?

SELECT
    COUNT(*) AS Total_Diabetic_Patients,
    SUM(
        CASE
            WHEN Glucose > 125 AND BMI >= 30 THEN 1
            ELSE 0
        END
    ) AS High_Glucose_High_BMI,
    CAST(
        ROUND(
            SUM(
                CASE
                    WHEN Glucose > 125 AND BMI >= 30 THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Percentage
FROM diabetes
WHERE Outcome = 1;
-- Question 5: What is the diabetes rate among patients with high glucose and high insulin levels?

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
WHERE Glucose > 125
  AND Insulin >= 200;
  -- Question 6: What is the diabetes rate among patients with high glucose, high BMI, and high insulin levels?

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
WHERE Glucose > 125
  AND BMI >= 30
  AND Insulin >= 200;

  -- Question 7: What are the average characteristics of diabetic patients compared with non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,
    CAST(ROUND(AVG(Age), 2) AS DECIMAL(6,2)) AS Average_Age,
    CAST(ROUND(AVG(Pregnancies), 2) AS DECIMAL(6,2)) AS Average_Pregnancies,
    CAST(ROUND(AVG(Glucose), 2) AS DECIMAL(6,2)) AS Average_Glucose,
    CAST(ROUND(AVG(BMI), 2) AS DECIMAL(6,2)) AS Average_BMI,
    CAST(ROUND(AVG(NULLIF(Insulin, 0)), 2) AS DECIMAL(8,2)) AS Average_Insulin,
    CAST(ROUND(AVG(NULLIF(BloodPressure, 0)), 2) AS DECIMAL(6,2)) AS Average_BloodPressure
FROM diabetes
GROUP BY Outcome;