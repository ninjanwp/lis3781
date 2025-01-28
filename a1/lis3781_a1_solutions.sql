-- Create Database
CREATE DATABASE IF NOT EXISTS np22i;
USE np22i;

-- Table: job
CREATE TABLE job (
    job_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(45) NOT NULL,
    job_notes VARCHAR(255) DEFAULT NULL
);

-- Table: employee
CREATE TABLE employee (
    emp_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    job_id TINYINT UNSIGNED NOT NULL,
    emp_ssn INT(9) ZEROFILL NOT NULL,
    emp_fname VARCHAR(15) NOT NULL,
    emp_lname VARCHAR(30) NOT NULL,
    emp_dob DATE NOT NULL,
    emp_start_date DATE NOT NULL,
    emp_end_date DATE DEFAULT NULL,
    emp_salary DECIMAL(8,2) NOT NULL,
    emp_street VARCHAR(30) NOT NULL,
    emp_city VARCHAR(30) NOT NULL,
    emp_state CHAR(2) NOT NULL,
    emp_zip INT(9) ZEROFILL NOT NULL,
    emp_phone BIGINT NOT NULL,
    emp_email VARCHAR(100) NOT NULL,
    emp_notes VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (job_id) REFERENCES job(job_id)
);

-- Table: dependent
CREATE TABLE dependent (
    dep_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT UNSIGNED NOT NULL,
    dep_ssn INT(9) ZEROFILL NOT NULL,
    dep_fname VARCHAR(15) NOT NULL,
    dep_lname VARCHAR(30) NOT NULL,
    dep_dob DATE NOT NULL,
    dep_added DATE NOT NULL,
    dep_relation VARCHAR(30) NOT NULL,
    dep_street VARCHAR(30) NOT NULL,
    dep_city VARCHAR(30) NOT NULL,
    dep_state CHAR(2) NOT NULL,
    dep_zip INT(9) ZEROFILL NOT NULL,
    dep_phone BIGINT DEFAULT NULL,
    dep_email VARCHAR(100) DEFAULT NULL,
    dep_notes VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

-- Table: benefit
CREATE TABLE benefit (
    ben_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    ben_name VARCHAR(45) NOT NULL,
    ben_notes VARCHAR(255) DEFAULT NULL
);

-- Table: plan
CREATE TABLE plan (
    pln_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT UNSIGNED NOT NULL,
    ben_id TINYINT UNSIGNED NOT NULL,
    pln_type ENUM('single', 'spouse', 'family') NOT NULL,
    pln_cost DECIMAL(6,2) NOT NULL,
    pln_election_date DATE NOT NULL,
    pln_notes VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id),
    FOREIGN KEY (ben_id) REFERENCES benefit(ben_id)
);

-- Table: emp_hist
CREATE TABLE emp_hist (
    eht_id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    emp_id SMALLINT UNSIGNED NOT NULL,
    eht_date DATETIME NOT NULL,
    eht_type ENUM('job', 'salary', 'benefit') NOT NULL,
    eht_job_id TINYINT UNSIGNED DEFAULT NULL,
    eht_emp_salary DECIMAL(8,2) DEFAULT NULL,
    eht_usr_changed VARCHAR(30) NOT NULL,
    eht_reason VARCHAR(45) NOT NULL,
    eht_notes VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

-- Insert Records for Table: job
INSERT INTO job (job_title, job_notes) VALUES
('Manager', 'Oversees operations'),
('Cashier', 'Handles customer transactions'),
('Janitor', 'Maintains cleanliness'),
('Technician', 'Handles technical tasks'),
('Secretary', 'Administrative support');

-- Insert Records for Table: employee
INSERT INTO employee (job_id, emp_ssn, emp_fname, emp_lname, emp_dob, emp_start_date, emp_salary, emp_street, emp_city, emp_state, emp_zip, emp_phone, emp_email, emp_notes) VALUES
(1, 123456789, 'John', 'Doe', '1980-01-01', '2010-05-15', 75000.00, '123 Main St', 'Springfield', 'IL', 62704, 2175551234, 'jdoe@example.com', 'Excellent manager'),
(2, 987654321, 'Jane', 'Smith', '1990-02-15', '2015-03-10', 30000.00, '456 Elm St', 'Lincoln', 'NE', 68508, 4025556789, 'jsmith@example.com', 'Great with customers'),
(3, 567890123, 'Bob', 'Johnson', '1985-07-20', '2012-07-01', 28000.00, '789 Oak St', 'Austin', 'TX', 73301, 5125552468, 'bjohnson@example.com', 'Hard worker'),
(4, 192837465, 'Alice', 'Brown', '1978-11-25', '2008-09-15', 55000.00, '321 Pine St', 'Madison', 'WI', 53703, 6085551357, 'abrown@example.com', 'Tech expert'),
(5, 102938475, 'Eve', 'Davis', '1982-05-05', '2011-12-20', 45000.00, '654 Cedar St', 'Columbus', 'OH', 43215, 6145559863, 'edavis@example.com', 'Organized and efficient');

-- Insert Records for Table: dependent
INSERT INTO dependent (emp_id, dep_ssn, dep_fname, dep_lname, dep_dob, dep_added, dep_relation, dep_street, dep_city, dep_state, dep_zip, dep_phone, dep_email, dep_notes) VALUES
(1, 234567891, 'Mary', 'Doe', '2005-03-10', '2010-06-01', 'Daughter', '123 Main St', 'Springfield', 'IL', 62704, NULL, NULL, 'Dependent of John Doe'),
(2, 345678912, 'Mike', 'Smith', '2010-08-15', '2015-04-01', 'Son', '456 Elm St', 'Lincoln', 'NE', 68508, NULL, NULL, 'Dependent of Jane Smith'),
(3, 456789123, 'Anna', 'Johnson', '2007-12-20', '2013-01-10', 'Daughter', '789 Oak St', 'Austin', 'TX', 73301, NULL, NULL, 'Dependent of Bob Johnson'),
(4, 567891234, 'Sam', 'Brown', '2000-07-01', '2009-03-01', 'Son', '321 Pine St', 'Madison', 'WI', 53703, NULL, NULL, 'Dependent of Alice Brown'),
(5, 678912345, 'Chris', 'Davis', '2012-09-30', '2012-10-15', 'Son', '654 Cedar St', 'Columbus', 'OH', 43215, NULL, NULL, 'Dependent of Eve Davis');

-- Insert Records for Table: benefit
INSERT INTO benefit (ben_name, ben_notes) VALUES
('Medical', 'Covers healthcare expenses'),
('Dental', 'Covers dental care'),
('401k', 'Retirement savings plan'),
('Term Life Insurance', 'Life insurance policy'),
('Disability', 'Covers long-term disability');

-- Insert Records for Table: plan
INSERT INTO plan (emp_id, ben_id, pln_type, pln_cost, pln_election_date, pln_notes) VALUES
(1, 1, 'family', 250.00, '2022-01-01', 'Family healthcare'),
(2, 2, 'spouse', 150.00, '2023-01-01', 'Spouse dental care'),
(3, 3, 'single', 100.00, '2022-06-15', '401k retirement plan'),
(4, 4, 'family', 300.00, '2021-11-01', 'Life insurance policy'),
(5, 5, 'single', 200.00, '2020-12-01', 'Disability coverage');

-- Insert Records for Table: emp_hist
INSERT INTO emp_hist (emp_id, eht_date, eht_type, eht_job_id, eht_emp_salary, eht_usr_changed, eht_reason, eht_notes) VALUES
(1, '2023-05-01 10:30:00', 'salary', NULL, 80000.00, 'admin', 'Annual review', 'Salary increased'),
(2, '2022-08-15 09:00:00', 'job', 2, NULL, 'hr_manager', 'Promotion', 'Moved to senior cashier'),
(3, '2021-12-10 14:20:00', 'benefit', NULL, NULL, 'benefits_admin', 'Updated benefits', 'Added dental coverage'),
(4, '2023-03-05 11:00:00', 'salary', NULL, 60000.00, 'admin', 'Annual review', 'Salary increased'),
(5, '2022-07-20 16:00:00', 'job', 4, NULL, 'hr_manager', 'Transfer', 'Moved to IT technician role');

-- SQL STATEMENTS FOR A1

-- Backward-engineer the query resultset
-- a. List current job title for each employee, including name, address, phone, SSN
-- b. Order by last name in descending order, use old-style join
SELECT 
    e.emp_id, 
    e.emp_fname, 
    e.emp_lname, 
    CONCAT(e.emp_street, ', ', e.emp_city, ', ', e.emp_state, ' ', e.emp_zip) AS address, 
    e.emp_phone, 
    e.emp_ssn, 
    j.job_title
FROM 
    Employee e, 
    Job j
WHERE 
    e.job_id = j.job_id
ORDER BY 
    e.emp_lname DESC;


-- 2) List all job titles and salaries each employee has and had
-- Include employee ID, full name, job ID, job title, salaries, and respective dates
-- Sort by employee ID and date, use old-style join
SELECT e.emp_id, e.emp_fname, e.emp_lname, eh.eht_date, eh.eht_job_id, j.job_title, 
       eh.eht_emp_salary, eh.eht_notes
FROM employee e, employee_history eh, job j
WHERE e.emp_id = eh.eht_emp_id AND eh.eht_job_id = j.job_id
ORDER BY e.emp_id, eh.eht_date;

-- 3) List employee and dependent full names, DOBs, relationships, and ages
-- Sort by employee last name in ascending order, use natural join
SELECT emp_fname, emp_lname, emp_dob, TIMESTAMPDIFF(YEAR, emp_dob, CURDATE()) AS emp_age,
       dep_fname, dep_lname, dep_relation, dep_dob, TIMESTAMPDIFF(YEAR, dep_dob, CURDATE()) AS dep_age
FROM employee
NATURAL JOIN dependent
ORDER BY emp_lname ASC;

-- 4) Create a transaction to update job ID 1 to "owner" and display before/after results
START TRANSACTION;

-- Display before change
SELECT job_id, job_title, job_notes FROM job;

-- Perform the update
UPDATE job SET job_title = 'owner' WHERE job_id = 1;

-- Display after change
SELECT job_id, job_title, job_notes FROM job;

COMMIT;

-- 5) Create a stored procedure to add one record to the benefit table
DELIMITER $$

CREATE PROCEDURE AddBenefit()
BEGIN
    -- Display before change
    SELECT * FROM benefit;

    -- Insert new record
    INSERT INTO benefit (ben_name, ben_notes) VALUES ('new benefit', 'testing');

    -- Display after change
    SELECT * FROM benefit;
END$$

DELIMITER ;

-- Call the stored procedure
CALL AddBenefit();


describe employee;
