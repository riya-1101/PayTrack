
-- ==========================================
-- PAYTRACK
-- FILE 5: VIEWS
-- ==========================================

-- VIEW 1: EMPLOYEE DETAILS

CREATE OR REPLACE VIEW employee_payroll_summary AS
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    e.designation,
    e.basic_salary,
    e.employment_status

FROM employees e

JOIN departments d
ON e.department_id = d.department_id;


-- VIEW 2: MONTHLY PAYROLL REPORT

CREATE OR REPLACE VIEW monthly_payroll_report AS
SELECT
    pr.payroll_month,
    pr.payroll_year,

    p.payroll_id,

    e.employee_code,
    e.first_name || ' ' || e.last_name AS employee_name,

    d.department_name,

    p.basic_salary,
    p.hra,
    p.da,
    p.other_allowance,

    p.overtime_pay,
    p.absence_deduction,

    p.gross_salary,

    p.pf_deduction,
    p.tax_deduction,
    p.total_deduction,

    p.net_salary,
    p.payment_status

FROM payroll p

JOIN payroll_runs pr
ON p.run_id = pr.run_id

JOIN employees e
ON p.employee_id = e.employee_id

JOIN departments d
ON e.department_id = d.department_id;


-- VIEW 3: PENDING PAYMENTS

CREATE OR REPLACE VIEW pending_payments AS
SELECT
    p.payroll_id,
    pr.payroll_month,
    pr.payroll_year,

    e.employee_code,
    e.first_name || ' ' || e.last_name AS employee_name,

    p.net_salary,
    p.payment_status

FROM payroll p

JOIN payroll_runs pr
ON p.run_id = pr.run_id

JOIN employees e
ON p.employee_id = e.employee_id

WHERE p.payment_status = 'PENDING';


-- VIEW 4: PAYMENT HISTORY

CREATE OR REPLACE VIEW payment_history AS
SELECT
    ph.payment_history_id,
    ph.payroll_id,

    e.employee_code,
    e.first_name || ' ' || e.last_name AS employee_name,

    ph.old_status,
    ph.new_status,
    ph.changed_on,
    ph.remarks

FROM payment_audit ph

JOIN payroll p
ON ph.payroll_id = p.payroll_id

JOIN employees e
ON p.employee_id = e.employee_id;


-- END OF FILE 5
