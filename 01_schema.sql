
-- ==========================================
-- PROJECT: PAYTRACK
-- EMPLOYEE PAYROLL MANAGEMENT SYSTEM
-- FILE 1: DATABASE SCHEMA
-- ==========================================

-- 1. DEPARTMENTS TABLE

CREATE TABLE departments (
    department_id NUMBER(6) PRIMARY KEY,
    department_name VARCHAR2(60) NOT NULL UNIQUE,
    location VARCHAR2(80)
);


-- 2. EMPLOYEES TABLE

CREATE TABLE employees (
    employee_id NUMBER(8) PRIMARY KEY,
    employee_code VARCHAR2(15) NOT NULL UNIQUE,
    first_name VARCHAR2(40) NOT NULL,
    last_name VARCHAR2(40) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    phone VARCHAR2(20),

    department_id NUMBER(6) NOT NULL,
    designation VARCHAR2(60) NOT NULL,

    hire_date DATE DEFAULT SYSDATE NOT NULL,
    basic_salary NUMBER(10,2) NOT NULL,

    employment_status VARCHAR2(12)
        DEFAULT 'ACTIVE' NOT NULL,

    created_at DATE DEFAULT SYSDATE,
    updated_at DATE DEFAULT SYSDATE,

    CONSTRAINT fk_emp_department
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id),

    CONSTRAINT chk_emp_salary
    CHECK (basic_salary > 0),

    CONSTRAINT chk_emp_status
    CHECK (employment_status IN ('ACTIVE', 'INACTIVE'))
);


-- 3. ATTENDANCE TABLE

CREATE TABLE attendance (
    attendance_id NUMBER(10) PRIMARY KEY,
    employee_id NUMBER(8) NOT NULL,

    attendance_month NUMBER(2) NOT NULL,
    attendance_year NUMBER(4) NOT NULL,

    days_present NUMBER(2) DEFAULT 0 NOT NULL,
    days_absent NUMBER(2) DEFAULT 0 NOT NULL,
    overtime_hours NUMBER(5,2) DEFAULT 0 NOT NULL,

    CONSTRAINT fk_att_employee
    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id),

    CONSTRAINT uq_att_employee_month
    UNIQUE (employee_id, attendance_month, attendance_year),

    CONSTRAINT chk_att_month
    CHECK (attendance_month BETWEEN 1 AND 12),

    CONSTRAINT chk_att_present
    CHECK (days_present >= 0),

    CONSTRAINT chk_att_absent
    CHECK (days_absent >= 0),

    CONSTRAINT chk_att_overtime
    CHECK (overtime_hours >= 0),

    CONSTRAINT chk_att_days
    CHECK (days_present + days_absent <= 31)
);


-- 4. PAYROLL RUNS TABLE

CREATE TABLE payroll_runs (
    run_id NUMBER(10) PRIMARY KEY,

    payroll_month NUMBER(2) NOT NULL,
    payroll_year NUMBER(4) NOT NULL,

    generated_on DATE DEFAULT SYSDATE NOT NULL,

    run_status VARCHAR2(12)
        DEFAULT 'GENERATED' NOT NULL,

    CONSTRAINT uq_payroll_period
    UNIQUE (payroll_month, payroll_year),

    CONSTRAINT chk_run_month
    CHECK (payroll_month BETWEEN 1 AND 12),

    CONSTRAINT chk_run_year
    CHECK (payroll_year BETWEEN 2000 AND 2100),

    CONSTRAINT chk_run_status
    CHECK (run_status IN ('GENERATED', 'CANCELLED'))
);


-- 5. PAYROLL TABLE

CREATE TABLE payroll (
    payroll_id NUMBER(10) PRIMARY KEY,
    run_id NUMBER(10) NOT NULL,
    employee_id NUMBER(8) NOT NULL,

    days_present NUMBER(2) DEFAULT 0,
    days_absent NUMBER(2) DEFAULT 0,
    overtime_hours NUMBER(5,2) DEFAULT 0,

    basic_salary NUMBER(10,2) NOT NULL,
    hra NUMBER(10,2) NOT NULL,
    da NUMBER(10,2) NOT NULL,
    other_allowance NUMBER(10,2) NOT NULL,

    overtime_pay NUMBER(10,2) NOT NULL,
    absence_deduction NUMBER(10,2) NOT NULL,

    gross_salary NUMBER(12,2) NOT NULL,

    pf_deduction NUMBER(10,2) NOT NULL,
    tax_deduction NUMBER(10,2) NOT NULL,
    total_deduction NUMBER(10,2) NOT NULL,

    net_salary NUMBER(12,2) NOT NULL,

    payment_status VARCHAR2(10)
        DEFAULT 'PENDING' NOT NULL,

    created_at DATE DEFAULT SYSDATE,

    CONSTRAINT fk_payroll_run
    FOREIGN KEY (run_id)
    REFERENCES payroll_runs(run_id),

    CONSTRAINT fk_payroll_employee
    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id),

    CONSTRAINT uq_payroll_employee_run
    UNIQUE (run_id, employee_id),

    CONSTRAINT chk_payroll_status
    CHECK (payment_status IN ('PENDING', 'PAID')),

    CONSTRAINT chk_payroll_amounts
    CHECK (
        basic_salary > 0
        AND gross_salary >= 0
        AND total_deduction >= 0
        AND net_salary >= 0
    )
);


-- 6. PAYMENT AUDIT TABLE

CREATE TABLE payment_audit (
    payment_history_id NUMBER(10) PRIMARY KEY,

    payroll_id NUMBER(10) NOT NULL,

    old_status VARCHAR2(10),
    new_status VARCHAR2(10) NOT NULL,

    changed_on DATE DEFAULT SYSDATE,

    remarks VARCHAR2(150),

    CONSTRAINT fk_history_payroll
    FOREIGN KEY (payroll_id)
    REFERENCES payroll(payroll_id),

    CONSTRAINT chk_history_status
    CHECK (new_status IN ('PENDING', 'PAID'))
);


-- VERIFY TABLES

SELECT table_name
FROM user_tables
WHERE table_name IN (
    'DEPARTMENTS',
    'EMPLOYEES',
    'ATTENDANCE',
    'PAYROLL_RUNS',
    'PAYROLL',
    'PAYMENT_AUDIT'
)
ORDER BY table_name;

-- END OF FILE 1
