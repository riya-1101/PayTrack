
-- ==========================================
-- PAYTRACK
-- FILE 7: PROJECT DEMONSTRATION
-- ==========================================

SET SERVEROUTPUT ON;

-- GENERATE NOVEMBER PAYROLL

BEGIN

    payroll_pkg.generate_monthly_payroll(
        11,
        2026
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(
            'Error: ' || SQLERRM
        );
        RAISE;
END;
/

-- DISPLAY GENERATED PAYROLL

SELECT *
FROM monthly_payroll_report
WHERE payroll_month = 11
AND payroll_year = 2026
ORDER BY employee_code;


-- MARK EMPLOYEE 1 SALARY AS PAID

DECLARE
    v_payroll_id NUMBER;
BEGIN

    SELECT p.payroll_id
    INTO v_payroll_id

    FROM payroll p

    JOIN payroll_runs r
    ON p.run_id = r.run_id

    WHERE p.employee_id = 1
    AND r.payroll_month = 11
    AND r.payroll_year = 2026;

    payroll_pkg.mark_salary_paid(v_payroll_id);

    COMMIT;

END;
/

-- DISPLAY PENDING PAYMENTS

SELECT *
FROM pending_payments;


-- DISPLAY PAYMENT HISTORY

SELECT *
FROM payment_history
ORDER BY payment_history_id;


-- DEPARTMENT-WISE PAYROLL SUMMARY

SELECT
    department_name,
    COUNT(*) AS total_employees,
    SUM(gross_salary) AS total_gross_salary,
    SUM(total_deduction) AS total_deductions,
    SUM(net_salary) AS total_net_salary

FROM monthly_payroll_report

WHERE payroll_month = 11
AND payroll_year = 2026

GROUP BY department_name

ORDER BY department_name;

-- END OF FILE 7
