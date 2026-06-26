USE HealthTrackAnalytics;



-- T01:
SELECT 
	t.full_name ,
	t.Specialty ,
	t.DepartmentName ,
	t.month_name ,
	t.visit_count_by_month ,
	SUM(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY MONTH(t.VisitDate) ) AS rt ,
	LAG(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY MONTH(t.VisitDate) ) AS prvs_mnth_vst_cnt ,
	CAST(t.visit_count_by_month AS FLOAT) / LAG(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY MONTH(t.VisitDate) ) * 100 AS cng_prcntg ,
	DENSE_RANK() OVER (PARTITION BY t.DepartmentName, MONTH(t.VisitDate) ORDER BY t.visit_count_by_month DESC) rnkng ,
	CASE 
		WHEN t.visit_count_by_month = MIN(t.visit_count_by_month ) OVER (PARTITION BY t.DoctorID ) THEN 'Low'
		WHEN t.visit_count_by_month = MAX(t.visit_count_by_month ) OVER (PARTITION BY t.DoctorID ) THEN 'Peak'
		ELSE 'Normal'
	END AS 'performance' 
FROM (
	SELECT 
		CONCAT(d.FirstName , ' ', d.LastName ) AS full_name ,
		d.Specialty ,
		dp.DepartmentName ,
		DATENAME(MONTH, v.VisitDate ) AS month_name ,
		COUNT(v.DoctorID ) OVER (PARTITION BY MONTH(v.VisitDate ), v.DoctorID ) AS visit_count_by_month ,
		ROW_NUMBER() OVER (PARTITION BY MONTH(v.VisitDate ), v.DoctorID ORDER BY d.DoctorID  ) AS RNum ,
		v.VisitDate ,
		d.DoctorID 
	FROM Doctors d 
	LEFT JOIN Departments dp 
		ON d.DepartmentID = dp.DepartmentID
	LEFT JOIN Visits v 
		ON d.DoctorID = v.DoctorID
	)t
WHERE t.RNum = 1;
-- CORRECTION:
SELECT 
    t.full_name,
    t.Specialty,
    t.DepartmentName,
    t.month_name,
    t.visit_count_by_month,
    SUM(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY t.month_num) AS running_total,
    LAG(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY t.month_num) AS prev_month_visits,
    CASE 
        WHEN LAG(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY t.month_num) IS NULL THEN NULL
        ELSE ROUND(
            ((t.visit_count_by_month - LAG(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY t.month_num)) 
            * 100.0 / LAG(t.visit_count_by_month) OVER (PARTITION BY t.DoctorID ORDER BY t.month_num)), 2
        )
    END AS change_percentage,
    DENSE_RANK() OVER (PARTITION BY t.DepartmentName ORDER BY t.total_visits DESC) AS ranking,
    CASE 
        WHEN t.visit_count_by_month = t.min_monthly THEN 'Low'
        WHEN t.visit_count_by_month = t.max_monthly THEN 'Peak'
        ELSE 'Normal'
    END AS performance
FROM (
    SELECT 
        CONCAT(d.FirstName, ' ', d.LastName) AS full_name,
        d.Specialty,
        dp.DepartmentName,
        d.DoctorID,
        MONTH(v.VisitDate) AS month_num,
        DATENAME(MONTH, v.VisitDate) AS month_name,
        COUNT(*) AS visit_count_by_month,
        MIN(COUNT(*)) OVER (PARTITION BY d.DoctorID) AS min_monthly,
        MAX(COUNT(*)) OVER (PARTITION BY d.DoctorID) AS max_monthly,
        SUM(COUNT(*)) OVER (PARTITION BY d.DoctorID) AS total_visits
    FROM Doctors d 
    LEFT JOIN Departments dp ON d.DepartmentID = dp.DepartmentID
    LEFT JOIN Visits v ON d.DoctorID = v.DoctorID
    GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Specialty, dp.DepartmentName, 
             MONTH(v.VisitDate), DATENAME(MONTH, v.VisitDate)
) t
WHERE t.visit_count_by_month IS NOT NULL
ORDER BY t.DepartmentName, t.full_name, t.month_num;



-- T02:
SELECT 
	* ,
	CASE 
		WHEN t.quartiles = 1 THEN 'Expensive'
		WHEN t.quartiles BETWEEN 2 AND 3 THEN 'Average'
		ELSE 'Inexpensive'
	END AS 'cost_category'
FROM (
	SELECT 
		CONCAT(pt.FirstName , ' ' ,pt.LastName ) AS pName ,
		CONCAT(d.FirstName , ' ' ,d.LastName ) AS dName ,
		v.Diagnosis ,
		pp.Quantity * pp.Cost AS prescription_cost ,
		FIRST_VALUE(pp.MedicationName) OVER (PARTITION BY v.Diagnosis ORDER BY pp.Quantity * pp.Cost DESC) AS most_Expensive ,
		LAST_VALUE(pp.MedicationName) OVER (PARTITION BY v.Diagnosis ORDER BY pp.Quantity * pp.Cost DESC
											ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS least_Expensive ,
		MAX(pp.Quantity * pp.Cost) OVER (PARTITION BY v.Diagnosis ) - (pp.Quantity * pp.Cost ) AS diff_from_max_diag ,
		NTILE(4) OVER (PARTITION BY v.Diagnosis ORDER BY pp.Quantity * pp.Cost DESC) AS quartiles 
	FROM Visits v 
	LEFT JOIN Doctors d 
		ON v.DoctorID = d.DoctorID
	LEFT JOIN Patients pt
		ON v.PatientID = pt.PatientID
	LEFT JOIN Prescriptions pp
		ON v.VisitID = pp.VisitID
)t;
-- CORRECTION:
SELECT 
    t.pName,
    t.dName,
    t.Diagnosis,
    t.total_prescription_cost,
    FIRST_VALUE(t.medication_name) OVER (PARTITION BY t.Diagnosis ORDER BY t.total_prescription_cost DESC) AS most_expensive,
    LAST_VALUE(t.medication_name) OVER (PARTITION BY t.Diagnosis ORDER BY t.total_prescription_cost DESC
                                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS least_expensive,
    ROUND(MAX(t.total_prescription_cost) OVER (PARTITION BY t.Diagnosis) - t.total_prescription_cost, 2) AS diff_from_max_diag,
    NTILE(4) OVER (PARTITION BY t.Diagnosis ORDER BY t.total_prescription_cost DESC) AS quartiles,
    CASE 
        WHEN NTILE(4) OVER (PARTITION BY t.Diagnosis ORDER BY t.total_prescription_cost DESC) = 1 THEN 'Expensive'
        WHEN NTILE(4) OVER (PARTITION BY t.Diagnosis ORDER BY t.total_prescription_cost DESC) BETWEEN 2 AND 3 THEN 'Average'
        ELSE 'Inexpensive'
    END AS cost_category
FROM (
    SELECT 
        CONCAT(pt.FirstName, ' ', pt.LastName) AS pName,
        CONCAT(d.FirstName, ' ', d.LastName) AS dName,
        v.Diagnosis,
        v.VisitID,
        -- Get the most expensive medication name for this visit (for display)
        (SELECT TOP 1 MedicationName FROM Prescriptions WHERE VisitID = v.VisitID ORDER BY Quantity * Cost DESC) AS medication_name,
        ROUND(SUM(pp.Quantity * pp.Cost), 2) AS total_prescription_cost
    FROM Visits v 
    LEFT JOIN Doctors d ON v.DoctorID = d.DoctorID
    LEFT JOIN Patients pt ON v.PatientID = pt.PatientID
    LEFT JOIN Prescriptions pp ON v.VisitID = pp.VisitID
    GROUP BY v.VisitID, pt.FirstName, pt.LastName, d.FirstName, d.LastName, v.Diagnosis
) t
ORDER BY t.Diagnosis, t.total_prescription_cost DESC;



-- T03:
SELECT 
	t.DepartmentName ,
	t.weekn_yr ,
	t.visit_count_by_week ,
	ROUND(
		AVG(CAST(t.visit_count_by_week AS FLOAT)) 
			OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn ROWS BETWEEN 2 PRECEDING AND CURRENT ROW )
		, 2) AS moving_avg ,
	SUM(t.visit_count_by_week) 
		OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn 
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rt ,
	LEAD(t.visit_count_by_week) OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn) AS next_weeks_visit ,
	t.visit_count_by_week - LEAD(t.visit_count_by_week) OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn) AS diff_from_next ,
	CASE NTILE(3) OVER (PARTITION BY t.DepartmentName ORDER BY t.visit_count_by_week DESC) 
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
	END AS week_category ,
	FIRST_VALUE(t.weekn) OVER (PARTITION BY t.DepartmentName ORDER BY t.visit_count_by_week DESC) AS height_visit_counted_week
FROM (
	SELECT 
		dp.DepartmentName ,
		CONCAT(DATEPART(WEEK, v.VisitDate ), ' ', YEAR(v.VisitDate)) AS weekn_yr ,
		COUNT(*) OVER (PARTITION BY dp.DepartmentName, DATEPART(WEEK, v.VisitDate )) visit_count_by_week ,
		DATEPART(WEEK, v.VisitDate ) weekn
	FROM Visits v 
	LEFT JOIN Doctors d  
		ON v.DoctorID = d.DoctorID 
	LEFT JOIN Departments dp 
		ON d.DepartmentID = dp.DepartmentID 
	GROUP BY dp.DepartmentName, v.VisitDate
)t;
-- CORRECTION:
SELECT 
    t.DepartmentName,
    t.weekn_yr,
    t.visit_count_by_week,
    ROUND(
        AVG(CAST(t.visit_count_by_week AS FLOAT)) 
        OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn 
              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2
    ) AS moving_avg,
    SUM(t.visit_count_by_week) 
        OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn 
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    LEAD(t.visit_count_by_week) OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn) AS next_weeks_visits,
    t.visit_count_by_week - LEAD(t.visit_count_by_week) OVER (PARTITION BY t.DepartmentName ORDER BY t.weekn) AS diff_from_next,
    CASE NTILE(3) OVER (PARTITION BY t.DepartmentName ORDER BY t.visit_count_by_week DESC) 
        WHEN 1 THEN 'High'
        WHEN 2 THEN 'Medium'
        ELSE 'Low'
    END AS week_category,
    FIRST_VALUE(t.weekn) OVER (PARTITION BY t.DepartmentName ORDER BY t.visit_count_by_week DESC) AS highest_visit_week
FROM (
    SELECT 
        dp.DepartmentName,
        DATEPART(WEEK, v.VisitDate) AS weekn,
        CONCAT(DATEPART(WEEK, v.VisitDate), ' ', YEAR(v.VisitDate)) AS weekn_yr,
        COUNT(*) AS visit_count_by_week
    FROM Visits v 
    LEFT JOIN Doctors d ON v.DoctorID = d.DoctorID 
    LEFT JOIN Departments dp ON d.DepartmentID = dp.DepartmentID 
    GROUP BY dp.DepartmentName, DATEPART(WEEK, v.VisitDate), YEAR(v.VisitDate)
) t
WHERE t.DepartmentName IS NOT NULL
ORDER BY t.DepartmentName, t.weekn;



-- T04:
SELECT 
	t.name ,
	t.Specialty ,
	t.unique_patients ,
	t.total_visits ,
	t.avg_visit_duration ,
	t.total_revenue ,
	RANK() OVER (PARTITION BY t.Specialty ORDER BY t.total_revenue ) AS rnk ,
	DENSE_RANK() OVER (PARTITION BY t.Specialty ORDER BY t.total_revenue ) AS drnk ,
	MAX(t.total_revenue ) OVER (PARTITION BY t.Specialty ) - t.total_revenue AS diff_from_max ,
	PERCENT_RANK() OVER (PARTITION BY t.Specialty ORDER BY t.total_revenue ) AS pRank ,
	FIRST_VALUE(t.name ) OVER (PARTITION BY t.Specialty ORDER BY t.total_visits ) AS most_visited ,
	LAST_VALUE(t.name ) OVER (PARTITION BY t.Specialty ORDER BY t.total_visits 
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS least_visited ,
	CASE 
		WHEN t.total_visits > (1.5 * avg_by_specialty) THEN 'Overwhelmed'
		WHEN t.total_visits BETWEEN 0.75 AND (1.5 * avg_by_specialty) THEN 'Balanced'
		WHEN t.total_visits < (0.75 * avg_by_specialty) THEN 'Underutilized'
	END AS 'Busyness Level' ,
	t.avg_by_specialty ,
	ROUND((CAST(t.total_visits AS FLOAT) / SUM(t.total_visits ) OVER (PARTITION BY t.Specialty)) * 100 , 2) AS contrib_p 
FROM (
	SELECT 
		CONCAT(d.FirstName , ' ', d.LastName ) AS name ,
		d.Specialty ,
		COUNT(DISTINCT v.PatientID ) AS unique_patients ,
		COUNT(v.PatientID ) AS total_visits ,
		AVG(v.VisitDuration ) AS avg_visit_duration ,
		SUM(pp.Quantity * pp.Cost ) AS total_revenue ,
		ROUND(AVG(CAST(COUNT(v.PatientID) AS FLOAT )) OVER (PARTITION BY d.Specialty), 2) AS avg_by_specialty 
	FROM Doctors d 
	LEFT JOIN Visits v 
		ON v.DoctorID = d.DoctorID
	LEFT JOIN Prescriptions pp
		ON v.VisitID = pp.VisitID 
	GROUP BY d.DoctorID , d.FirstName , d.LastName ,d.Specialty 
)t
ORDER BY t.Specialty , t.total_revenue DESC;
-- CORRECTION:
SELECT 
    t.name,
    t.Specialty,
    t.unique_patients,
    t.total_visits,
    t.avg_visit_duration,
    t.total_revenue,
    RANK() OVER (PARTITION BY t.Specialty ORDER BY t.total_revenue DESC) AS rank,
    DENSE_RANK() OVER (PARTITION BY t.Specialty ORDER BY t.total_revenue DESC) AS dense_rank,
    ROUND(MAX(t.total_revenue) OVER (PARTITION BY t.Specialty) - t.total_revenue, 2) AS diff_from_max,
    ROUND(PERCENT_RANK() OVER (PARTITION BY t.Specialty ORDER BY t.total_revenue DESC), 2) AS percent_rank,
    FIRST_VALUE(t.name) OVER (PARTITION BY t.Specialty ORDER BY t.total_visits DESC) AS most_visited,
    LAST_VALUE(t.name) OVER (PARTITION BY t.Specialty ORDER BY t.total_visits DESC
                             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS least_visited,
    CASE 
        WHEN t.total_visits > (1.5 * t.avg_by_specialty) THEN 'Overwhelmed'
        WHEN t.total_visits BETWEEN (0.75 * t.avg_by_specialty) AND (1.5 * t.avg_by_specialty) THEN 'Balanced'
        WHEN t.total_visits < (0.75 * t.avg_by_specialty) THEN 'Underutilized'
        ELSE 'No Data'
    END AS Busyness_Level,
    ROUND(t.avg_by_specialty, 2) AS specialty_avg_visits,
    ROUND((CAST(t.total_visits AS FLOAT) / SUM(t.total_visits) OVER (PARTITION BY t.Specialty)) * 100, 2) AS contribution_percentage
FROM (
    SELECT 
        CONCAT(d.FirstName, ' ', d.LastName) AS name,
        d.Specialty,
        COUNT(DISTINCT v.PatientID) AS unique_patients,
        COUNT(v.PatientID) AS total_visits,
        ROUND(ISNULL(AVG(v.VisitDuration), 0), 2) AS avg_visit_duration,
        ROUND(ISNULL(SUM(pp.Quantity * pp.Cost), 0), 2) AS total_revenue,
        -- Calculate average visits per specialty using a window function on the grouped data
        AVG(COUNT(v.PatientID)) OVER (PARTITION BY d.Specialty) AS avg_by_specialty
    FROM Doctors d 
    LEFT JOIN Visits v ON v.DoctorID = d.DoctorID
    LEFT JOIN Prescriptions pp ON v.VisitID = pp.VisitID 
    GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Specialty
) t
ORDER BY t.Specialty, t.total_revenue DESC;



SELECT * FROM Departments dp;
SELECT * FROM Doctors dc;
SELECT * FROM Patients pt;
SELECT * FROM Visits v;
SELECT * FROM Prescriptions pp;
