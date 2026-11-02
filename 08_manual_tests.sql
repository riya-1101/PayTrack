
-- ==========================================
-- PAYTRACK
-- FILE 8: MANUAL TESTING
-- ==========================================

-- 1. DISPLAY ALL EMPLOYEES

SELECT *
FROM employee_payroll_summary;


-- 2. DISPLAY ALL DEPARTMENTS

SELECT *
FROM departments;


-- 3. DISPLAY ATTENDANCE

SELECT
    e.employee_code,
    e.first_name,
    e.last_name,
    a.attendance_month,
    a.attendance_year,
    a.days_present,
    a.days_absent,
    a.overtime_hours

FROM attendance a

JOIN employees e
ON a.employee_id = e.employee_id;


-- 4. DISPLAY PAYROLL

SELECT *
FROM monthly_payroll_report;


-- 5. DISPLAY PENDING SALARIES

SELECT *
FROM pending_payments;


-- 6. DISPLAY PAYMENT HISTORY

SELECT *
FROM payment_history;


-- 7. TEST GROSS SALARY FUNCTION

SELECT
    payroll_pkg.calculate_gross_salary(
        30000,
        2,
        4
    ) AS calculated_gross

FROM dual;


-- 8. TEST TOTAL DEDUCTION FUNCTION

SELECT
    payroll_pkg.calculate_total_deduction(
        30000,
        40000
    ) AS total_deduction

FROM dual;


-- 9. TEST NET SALARY FUNCTION

SELECT
    payroll_pkg.calculate_net_salary(
        40000,
        3600
    ) AS net_salary

FROM dual;


-- 10. EMPLOYEE COUNT BY DEPARTMENT

SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count

FROM departments d

LEFT JOIN employees e
ON d.department_id = e.department_id

GROUP BY d.department_name;

-- END OF FILE 8
