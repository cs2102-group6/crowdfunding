CREATE OR REPLACE FUNCTION change_password()
RETURNS TRIGGER AS $$
BEGIN
	IF NOT EXISTS ( SELECT * FROM password_log WHERE email = new.email AND password = new.password)
	THEN INSERT INTO password_log VALUES(new.email, new.password);
	END IF;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER change_password_trigger
    BEFORE UPDATE ON USERS
    FOR EACH ROW
    EXECUTE PROCEDURE change_password();