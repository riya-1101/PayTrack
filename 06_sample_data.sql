
-- ==========================================
-- PAYTRACK
-- FILE 6: SAMPLE DATA
-- ==========================================

-- DEPARTMENTS

INSERT INTO departments
VALUES (
    seq_department.NEXTVAL,
    'Human Resources',
    'Block A'
);

INSERT INTO departments
VALUES (
    seq_department.NEXTVAL,
    'Information Technology',
    'Block B'
);

INSERT INTO departments
VALUES (
    seq_department.NEXTVAL,
    'Finance',
    'Block C'
);


-- EMPLOYEE 1

INSERT INTO employees (
    employee_id,
    employee_code,
    first_name,
    last_name,
    email,
    phone,
    department_id,
    designation,
    hire_date,
    basic_salary,
    employment_status
)
VALUES (
    seq_employee.NEXTVAL,
    'PT1001',
    'Aarav',
    'Sharma',
    'aarav.sharma@example.com',
    '9876501001',
    1,
    'HR Executive',
    DATE '2024-04-15',
    30000,
    'ACTIVE'
);


-- EMPLOYEE 2

INSERT INTO employees (
    employee_id,
    employee_code,
    first_name,
    last_name,
    email,
    phone,
    department_id,
    designation,
    hire_date,
    basic_salary,
    employment_status
)
VALUES (
    seq_employee.NEXTVAL,
    'PT1002',
    'Meera',
    'Kapoor',
    'meera.kapoor@example.com',
    '9876501002',
    2,
    'Software Developer',
    DATE '2023-08-01',
    45000,
    'ACTIVE'
);


-- EMPLOYEE 3

INSERT INTO employees (
    employee_id,
    employee_code,
    first_name,
    last_name,
    email,
    phone,
    department_id,
    designation,
    hire_date,
    basic_salary,
    employment_status
)
VALUES (
    seq_employee.NEXTVAL,
    'PT1003',
    'Kabir',
    'Verma',
    'kabir.verma@example.com',
    '9876501003',
    3,
    'Accountant',
    DATE '2025-01-10',
    25000,
    'ACTIVE'
);


-- ATTENDANCE FOR NOVEMBER 2026

INSERT INTO attendance (
    attendance_id,
    employee_id,
    attendance_month,
    attendance_year,
    days_present,
    days_absent,
    overtime_hours
)
VALUES (
    seq_attendance.NEXTVAL,
    1, 11, 2026, 28, 2, 4
);


INSERT INTO attendance (
    attendance_id,
    employee_id,
    attendance_month,
    attendance_year,
    days_present,
    days_absent,
    overtime_hours
)
VALUES (
    seq_attendance.NEXTVAL,
    2, 11, 2026, 30, 0, 8
);


INSERT INTO attendance (
    attendance_id,
    employee_id,
    attendance_month,
    attendance_year,
    days_present,
    days_absent,
    overtime_hours
)
VALUES (
    seq_attendance.NEXTVAL,
    3, 11, 2026, 27, 3, 2
);

COMMIT;

-- END OF FILE 6
