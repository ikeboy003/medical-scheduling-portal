DROP TRIGGER IF EXISTS user_role_trigger ON users;
DROP FUNCTION IF EXISTS add_user_to_doctor_or_patient();
CREATE OR REPLACE FUNCTION add_user_to_doctor_or_patient()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role = 'ROLE_ADMIN' THEN
        INSERT INTO doctor (user_id, first_name, last_name, time_slot_default, email)
        VALUES (NEW.user_id, '', '', 0, '');

    ELSIF NEW.role = 'ROLE_USER' THEN
        INSERT INTO patient (user_id, first_name, last_name, date_of_birth, address, phone_number)
        VALUES (NEW.user_id, '', '', '1900-01-01', '', '');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_role_trigger
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION add_user_to_doctor_or_patient();