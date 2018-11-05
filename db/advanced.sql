CREATE OR REPLACE FUNCTION same_password()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Your new password must be different from the old password';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER same_password_trigger
    BEFORE UPDATE ON USERS
    FOR EACH ROW
    WHEN (old.password = new.password)
    EXECUTE PROCEDURE same_password();

