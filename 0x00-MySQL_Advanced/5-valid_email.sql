-- create a trigger on update
delimiter |
CREATE TRIGGER setValidEmail BEFORE UPDATE
ON users
FOR EACH ROW
BEGIN
SET NEW.valid_email = CASE
    WHEN OLD.valid_email = 0 AND  NEW.email != OLD.email AND NEW.email REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*(\\.[a-zA-Z]{2,4})+$'
    THEN 1
    WHEN OLD.valid_email = 1 AND  NEW.email != OLD.email AND NEW.email NOT REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*(\\.[a-zA-Z]{2,4})+$'
    THEN 0
    ELSE NEW.valid_email
END;
END;
|
delimiter ;
