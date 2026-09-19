-- Question 1: How does glucose level differ between diabetic and non-diabetic patients?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,

    MIN(Glucose) AS Minimum_Glucose,
    MAX(Glucose) AS Maximum_Glucose,
    CAST(ROUND(AVG(Glucose), 2) AS DECIMAL(6,2)) AS Average_Glucose

FROM diabetes

GROUP BY Outcome;

-- Question 2: Which glucose range has the highest diabetes rate?

SELECT
    CASE
        WHEN Glucose < 100 THEN 'Low (<100)'
        WHEN Glucose BETWEEN 100 AND 125 THEN 'Normal (100-125)'
        ELSE 'High (>125)'
    END AS Glucose_Range,

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
        WHEN Glucose < 100 THEN 'Low (<100)'
        WHEN Glucose BETWEEN 100 AND 125 THEN 'Normal (100-125)'
        ELSE 'High (>125)'
    END

ORDER BY Diabetes_Rate DESC;

-- Question 3: What percentage of patients with high glucose have diabetes?

SELECT
    CAST(
        ROUND(
            SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Diabetes_Percentage

FROM diabetes

WHERE Glucose > 125;

-- Question 3: How does diabetes prevalence change as glucose levels increase?

SELECT
    CASE
        WHEN Glucose < 80 THEN 'Below 80'
        WHEN Glucose BETWEEN 80 AND 99 THEN '80-99'
        WHEN Glucose BETWEEN 100 AND 119 THEN '100-119'
        WHEN Glucose BETWEEN 120 AND 139 THEN '120-139'
        WHEN Glucose BETWEEN 140 AND 159 THEN '140-159'
        ELSE '160+'
    END AS Glucose_Range,

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
        WHEN Glucose < 80 THEN 'Below 80'
        WHEN Glucose BETWEEN 80 AND 99 THEN '80-99'
        WHEN Glucose BETWEEN 100 AND 119 THEN '100-119'
        WHEN Glucose BETWEEN 120 AND 139 THEN '120-139'
        WHEN Glucose BETWEEN 140 AND 159 THEN '140-159'
        ELSE '160+'
    END

ORDER BY
    MIN(Glucose);

    -- Question 4: Which age group has the highest average glucose level?

SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS Age_Group,

    CAST(ROUND(AVG(Glucose), 2) AS DECIMAL(6,2)) AS Average_Glucose

FROM diabetes

GROUP BY
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END

ORDER BY Average_Glucose DESC;

-- Question 5: Is glucose level strongly associated with diabetes outcome?

SELECT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,

    CAST(ROUND(AVG(Glucose), 2) AS DECIMAL(6,2)) AS Average_Glucose,

    COUNT(*) AS Patient_Count

FROM diabetes

GROUP BY Outcome
ORDER BY Average_Glucose DESC;
-- Question 6: What is the median glucose level for diabetic and non-diabetic patients?

SELECT DISTINCT
    CASE
        WHEN Outcome = 1 THEN 'Diabetic'
        ELSE 'Non-Diabetic'
    END AS Diabetes_Status,

    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY Glucose)
    OVER (PARTITION BY Outcome) AS Median_Glucose

FROM diabetes;

-- Question 7: What is the correlation between glucose level and diabetes outcome?

SELECT
    CAST(
        ROUND(
            (
                COUNT(*) * SUM(
                    CAST(Glucose AS FLOAT) * CAST(Outcome AS FLOAT)
                )
                - SUM(CAST(Glucose AS FLOAT))
                  * SUM(CAST(Outcome AS FLOAT))
            )
            /
            NULLIF(
                SQRT(
                    (
                        COUNT(*) * SUM(CAST(Glucose AS FLOAT) * CAST(Glucose AS FLOAT))
                        - POWER(SUM(CAST(Glucose AS FLOAT)), 2)
                    )
                    *
                    (
                        COUNT(*) * SUM(CAST(Outcome AS FLOAT) * CAST(Outcome AS FLOAT))
                        - POWER(SUM(CAST(Outcome AS FLOAT)), 2)
                    )
                ),
                0
            ),
            3
        ) AS DECIMAL(5,3)
    ) AS Glucose_Outcome_Correlation
FROM diabetes;