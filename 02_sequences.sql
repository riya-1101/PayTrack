
-- ==========================================
-- FILE 2: SEQUENCES
-- ==========================================

CREATE SEQUENCE seq_department
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_employee
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_attendance
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_payroll_run
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_payroll
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_payment_history
START WITH 1
INCREMENT BY 1
NOCACHE;


-- VERIFY SEQUENCES

SELECT sequence_name
FROM user_sequences
ORDER BY sequence_name;

-- END OF FILE 2
