--  CREATE DATABASE Users;
USE Users;
DROP PROCEDURE IF EXISTS create_user;
DROP PROCEDURE IF EXISTS get_users_list;
DROP PROCEDURE IF EXISTS delete_user;
DROP PROCEDURE IF EXISTS get_curses_list;
DROP PROCEDURE IF EXISTS get_users_number;
DROP PROCEDURE IF EXISTS get_users_by_name;
DROP PROCEDURE IF EXISTS get_users_number_name;
DROP PROCEDURE IF EXISTS get_user;
DROP PROCEDURE IF EXISTS update_user;
DROP TABLE IF EXISTS UsersList_Courses;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS UsersList;
CREATE TABLE Courses (
    NAME VARCHAR(100),
    CODE CHAR(10) NOT NULL,
    PRIMARY KEY(CODE)
);

CREATE TABLE UsersList (
    id INT AUTO_INCREMENT,
    NAME VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(255),
    MobilePhone VARCHAR(255),
    Status ENUM('Active', 'Inactive'),
    PRIMARY KEY(id)
);

-- This table is used to create many-to-many relationship
-- between Courses and UsersList table
CREATE TABLE UsersList_Courses(
    USER_ID INT,
    COURSES_ID CHAR(10),
    FOREIGN KEY(USER_ID) REFERENCES UsersList(id),
    FOREIGN KEY(COURSES_ID) REFERENCES Courses(CODE)
);

DELIMITER //
CREATE PROCEDURE create_user (IN name VARCHAR(255), IN email VARCHAR(255), IN phone VARCHAR(255), 
                              IN mobile VARCHAR(255), IN status ENUM('Active',  'Inactive'))
BEGIN
    INSERT INTO UsersList(NAME, Email, Phone, MobilePhone, Status) VALUES (name, email, phone, mobile, status);
END //

CREATE PROCEDURE get_user(IN user_id INT)
BEGIN
    SELECT * FROM UsersList WHERE id = user_id;
END //

CREATE PROCEDURE update_user(IN user_id INT, IN email VARCHAR(255),
                             IN phone VARCHAR(255), IN mobile VARCHAR(255),
                             IN status ENUM('Active',  'Inactive'))
BEGIN
    UPDATE UsersList SET Email = email, Phone = phone, MobilePhone = mobile, Status = status WHERE id = user_id;
END //

CREATE PROCEDURE get_users_list(IN lim INT, IN offs INT)
BEGIN
    SELECT * FROM UsersList LIMIT lim OFFSET offs;
END //

CREATE PROCEDURE get_users_by_name(IN lim INT, in offs INT, IN user_name TEXT)
BEGIN
    SELECT * FROM UsersList WHERE NAME = user_name LIMIT lim OFFSET offs;
END //

CREATE PROCEDURE get_users_number()
BEGIN
    SELECT COUNT(*) FROM UsersList;
END //

CREATE PROCEDURE get_users_number_name(IN user_name TEXT)
BEGIN
    SELECT COUNT(*) FROM UsersList WHERE NAME = user_name;
END //

CREATE PROCEDURE get_curses_list()
BEGIN
    SELECT * FROM Courses;
END //

CREATE PROCEDURE delete_user(IN user_id INT)
BEGIN 
    DELETE FROM UsersList WHERE id = user_id;
    DELETE FROM UsersList_Courses WHERE USER_ID = user_id;
END //
DELIMITER ;

INSERT INTO Courses(NAME, CODE) VALUES ('Python-Base', 'P012345');
INSERT INTO Courses(NAME, CODE) VALUES ('Python-Database', 'P234567');
INSERT INTO Courses(NAME, CODE) VALUES ('HTML', 'H345678');
INSERT INTO Courses(NAME, CODE) VALUES ('Java-Base', 'J456789');
INSERT INTO Courses(NAME, CODE) VALUES ('JavaScript-Base', 'JS543210');
