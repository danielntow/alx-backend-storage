-- create a stored procedure that adds a new correction for a student
DELIMITER |
CREATE PROCEDURE AddBonus(IN user_id INT, IN project_name VARCHAR(255), IN score INT)
BEGIN
-- check if projects table has a name column
IF COL_LENGTH('projects', 'name') IS NULL
THEN
-- if if doesn't exist, put it there
ALTER TABLE projects
ADD COLUMN name VARCHAR(255);
-- insert the new project details
INSERT INTO projects (name) VALUES (project_name);
END IF;
-- get the id of the project passed
SET @x := (SELECT id FROM projects WHERE name = project_name);

-- insert the userid, project id and score into the corrections table
INSERT INTO corrrections (user_id, project_id, score)
VALUES (user_id, @pro_id, score);
END;
|
DELIMITER ;
