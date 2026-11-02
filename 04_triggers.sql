
-- ==========================================
-- PAYTRACK
-- FILE 4: TRIGGERS
-- ==========================================

-- TRIGGER 1: UPDATE EMPLOYEE TIMESTAMP

CREATE OR REPLACE TRIGGER trg_employee_updated
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSDATE;
END;
/

-- TRIGGER 2: VALIDATE PAYROLL AMOUNTS

CREATE OR REPLACE TRIGGER trg_payroll_validate
BEFORE INSERT OR UPDATE ON payroll
FOR EACH ROW
BEGIN
    IF :NEW.net_salary < 0
       OR :NEW.gross_salary < 0
       OR :NEW.total_deduction < 0 THEN

        RAISE_APPLICATION_ERROR(
            -20008,
            'Salary amounts cannot be negative.'
        );

    END IF;
END;
/

-- TRIGGER 3: PAYMENT HISTORY AUDIT

CREATE OR REPLACE TRIGGER trg_payment_history
AFTER UPDATE OF payment_status ON payroll
FOR EACH ROW
WHEN (OLD.payment_status <> NEW.payment_status)
BEGIN
    INSERT INTO payment_audit (
        payment_history_id,
        payroll_id,
        old_status,
        new_status,
        changed_on,
        remarks
    )
    VALUES (
        seq_payment_history.NEXTVAL,
        :NEW.payroll_id,
        :OLD.payment_status,
        :NEW.payment_status,
        SYSDATE,
        'Payment status changed automatically'
    );
END;
/

-- END OF FILE 4
