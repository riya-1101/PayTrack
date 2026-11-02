
-- ==========================================
-- FILE 3: PAYROLL PACKAGE
-- ==========================================

-- PACKAGE SPECIFICATION

CREATE OR REPLACE PACKAGE payroll_pkg AS

    FUNCTION calculate_gross_salary(
        p_basic_salary NUMBER,
        p_days_absent NUMBER,
        p_overtime_hours NUMBER
    ) RETURN NUMBER;

    FUNCTION calculate_total_deduction(
        p_basic_salary NUMBER,
        p_gross_salary NUMBER
    ) RETURN NUMBER;

    FUNCTION calculate_net_salary(
        p_gross_salary NUMBER,
        p_total_deduction NUMBER
    ) RETURN NUMBER;

    PROCEDURE generate_monthly_payroll(
        p_month NUMBER,
        p_year NUMBER
    );

    PROCEDURE mark_salary_paid(
        p_payroll_id NUMBER
    );

END payroll_pkg;
/

-- PACKAGE BODY

CREATE OR REPLACE PACKAGE BODY payroll_pkg AS

    -- 1. GROSS SALARY FUNCTION

    FUNCTION calculate_gross_salary(
        p_basic_salary NUMBER,
        p_days_absent NUMBER,
        p_overtime_hours NUMBER
    ) RETURN NUMBER

    IS
        v_hra NUMBER(12,2);
        v_da NUMBER(12,2);
        v_other NUMBER(12,2) := 1500;
        v_overtime NUMBER(12,2);
        v_absence NUMBER(12,2);
        v_gross NUMBER(12,2);

    BEGIN

        IF p_basic_salary IS NULL OR p_basic_salary <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Invalid basic salary');
        END IF;

        IF NVL(p_days_absent,0) < 0
           OR NVL(p_overtime_hours,0) < 0 THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Invalid attendance values');
        END IF;

        v_hra := p_basic_salary * 0.20;

        v_da := p_basic_salary * 0.10;

        v_overtime :=
            (p_basic_salary / 240)
            * 1.5 * NVL(p_overtime_hours,0);

        v_absence :=
            (p_basic_salary / 30)
            * NVL(p_days_absent,0);

        v_gross :=
            p_basic_salary
            + v_hra
            + v_da
            + v_other
            + v_overtime
            - v_absence;

        RETURN GREATEST(ROUND(v_gross,2),0);

    END calculate_gross_salary;


    -- 2. TOTAL DEDUCTION FUNCTION

    FUNCTION calculate_total_deduction(
        p_basic_salary NUMBER,
        p_gross_salary NUMBER
    ) RETURN NUMBER

    IS
        v_pf NUMBER(12,2);
        v_tax NUMBER(12,2);

    BEGIN

        v_pf := p_basic_salary * 0.12;

        IF p_gross_salary > 50000 THEN
            v_tax := p_gross_salary * 0.05;
        ELSE
            v_tax := 0;
        END IF;

        RETURN ROUND(v_pf + v_tax,2);

    END calculate_total_deduction;


    -- 3. NET SALARY FUNCTION

    FUNCTION calculate_net_salary(
        p_gross_salary NUMBER,
        p_total_deduction NUMBER
    ) RETURN NUMBER

    IS
    BEGIN

        RETURN GREATEST(
            ROUND(p_gross_salary - p_total_deduction,2),
            0
        );

    END calculate_net_salary;


    -- 4. MONTHLY PAYROLL PROCEDURE

    PROCEDURE generate_monthly_payroll(
        p_month NUMBER,
        p_year NUMBER
    )

    IS
        v_run_id NUMBER;
        v_employee_count NUMBER;
        v_attendance_count NUMBER;

        v_hra NUMBER(12,2);
        v_da NUMBER(12,2);
        v_other NUMBER(12,2);
        v_ot_pay NUMBER(12,2);
        v_absence NUMBER(12,2);
        v_gross NUMBER(12,2);
        v_pf NUMBER(12,2);
        v_tax NUMBER(12,2);
        v_total_ded NUMBER(12,2);
        v_net NUMBER(12,2);

        v_count NUMBER := 0;

        CURSOR c_employees IS

            SELECT
                e.employee_id,
                e.basic_salary,
                a.days_present,
                a.days_absent,
                a.overtime_hours

            FROM employees e

            JOIN attendance a
            ON e.employee_id = a.employee_id

            WHERE a.attendance_month = p_month
            AND a.attendance_year = p_year
            AND e.employment_status = 'ACTIVE'

            ORDER BY e.employee_id;

    BEGIN

        IF p_month IS NULL OR p_month NOT BETWEEN 1 AND 12 THEN
            RAISE_APPLICATION_ERROR(-20003,
                'Invalid payroll month');
        END IF;

        IF p_year IS NULL OR p_year NOT BETWEEN 2000 AND 2100 THEN
            RAISE_APPLICATION_ERROR(-20004,
                'Invalid payroll year');
        END IF;

        SELECT COUNT(*)
        INTO v_employee_count
        FROM employees
        WHERE employment_status = 'ACTIVE';

        SELECT COUNT(*)
        INTO v_attendance_count
        FROM attendance a
        JOIN employees e
        ON a.employee_id = e.employee_id
        WHERE a.attendance_month = p_month
        AND a.attendance_year = p_year
        AND e.employment_status = 'ACTIVE';

        IF v_employee_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20005,
                'No active employees found');
        END IF;

        IF v_employee_count <> v_attendance_count THEN
            RAISE_APPLICATION_ERROR(-20006,
                'Attendance missing for active employees');
        END IF;

        SELECT seq_payroll_run.NEXTVAL
        INTO v_run_id
        FROM dual;

        INSERT INTO payroll_runs (
            run_id,
            payroll_month,
            payroll_year,
            run_status
        )
        VALUES (
            v_run_id,
            p_month,
            p_year,
            'GENERATED'
        );

        FOR emp IN c_employees LOOP

            v_hra := emp.basic_salary * 0.20;

            v_da := emp.basic_salary * 0.10;

            v_other := 1500;

            v_ot_pay :=
                (emp.basic_salary / 240)
                * 1.5 * emp.overtime_hours;

            v_absence :=
                (emp.basic_salary / 30)
                * emp.days_absent;

            v_gross := calculate_gross_salary(
                emp.basic_salary,
                emp.days_absent,
                emp.overtime_hours
            );

            v_pf := emp.basic_salary * 0.12;

            IF v_gross > 50000 THEN
                v_tax := v_gross * 0.05;
            ELSE
                v_tax := 0;
            END IF;

            v_total_ded := calculate_total_deduction(
                emp.basic_salary,
                v_gross
            );

            v_net := calculate_net_salary(
                v_gross,
                v_total_ded
            );

            INSERT INTO payroll (
                payroll_id,
                run_id,
                employee_id,
                days_present,
                days_absent,
                overtime_hours,
                basic_salary,
                hra,
                da,
                other_allowance,
                overtime_pay,
                absence_deduction,
                gross_salary,
                pf_deduction,
                tax_deduction,
                total_deduction,
                net_salary,
                payment_status
            )
            VALUES (
                seq_payroll.NEXTVAL,
                v_run_id,
                emp.employee_id,
                emp.days_present,
                emp.days_absent,
                emp.overtime_hours,
                emp.basic_salary,
                v_hra,
                v_da,
                v_other,
                ROUND(v_ot_pay,2),
                ROUND(v_absence,2),
                v_gross,
                ROUND(v_pf,2),
                ROUND(v_tax,2),
                v_total_ded,
                v_net,
                'PENDING'
            );

            v_count := v_count + 1;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE(
            'Payroll generated successfully for '
            || v_count || ' employees.'
        );

    END generate_monthly_payroll;


    -- 5. MARK SALARY AS PAID

    PROCEDURE mark_salary_paid(
        p_payroll_id NUMBER
    )

    IS
    BEGIN

        UPDATE payroll
        SET payment_status = 'PAID'
        WHERE payroll_id = p_payroll_id
        AND payment_status = 'PENDING';

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20007,
                'Payroll not found or already paid');
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Salary payment updated successfully.'
        );

    END mark_salary_paid;

END payroll_pkg;
/

-- CHECK COMPILATION

SHOW ERRORS PACKAGE payroll_pkg;
SHOW ERRORS PACKAGE BODY payroll_pkg;
