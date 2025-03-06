-- Create the person table
CREATE TABLE person (
    per_id SMALLINT PRIMARY KEY,
    per_ssn BINARY(64) UNIQUE NOT NULL,
    per_salt BINARY(64) NOT NULL,
    per_fname VARCHAR(15) NOT NULL,
    per_lname VARCHAR(30) NOT NULL,
    per_street VARCHAR(30),
    per_city VARCHAR(30),
    per_state CHAR(2),
    per_zip VARCHAR(9),
    per_email VARCHAR(100),
    per_dob DATE,
    per_type ENUM('c', 'a', 'j'),
    per_notes VARCHAR(255)
);

-- Create phone table
CREATE TABLE phone (
    phn_id SMALLINT PRIMARY KEY,
    per_id SMALLINT,
    phn_num BIGINT UNIQUE NOT NULL,
    phn_type ENUM('home', 'office', 'mobile') NOT NULL,
    phn_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES person(per_id)
);

-- Create attorney table
CREATE TABLE attorney (
    per_id SMALLINT PRIMARY KEY,
    aty_start_date DATE NOT NULL,
    aty_end_date DATE,
    aty_hourly_rate DECIMAL(5,2) NOT NULL,
    aty_years_in_practice TINYINT NOT NULL,
    aty_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES person(per_id)
);

-- Create judge table
CREATE TABLE judge (
    per_id SMALLINT PRIMARY KEY,
    crt_id TINYINT,
    jud_salary DECIMAL(8,2) NOT NULL,
    jud_years_in_practice TINYINT NOT NULL,
    jud_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES person(per_id)
);

-- Create client table
CREATE TABLE client (
    per_id SMALLINT PRIMARY KEY,
    cli_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES person(per_id)
);

-- Create court table
CREATE TABLE court (
    crt_id TINYINT PRIMARY KEY,
    crt_name VARCHAR(45) NOT NULL,
    crt_street VARCHAR(30),
    crt_city VARCHAR(30),
    crt_state CHAR(2),
    crt_zip VARCHAR(9),
    crt_phone BIGINT,
    crt_email VARCHAR(100),
    crt_url VARCHAR(100),
    crt_notes VARCHAR(255)
);

-- Create judge history table
CREATE TABLE judge_hist (
    jhs_id SMALLINT PRIMARY KEY,
    per_id SMALLINT,
    jhs_crt_id TINYINT,
    jhs_date TIMESTAMP NOT NULL,
    jhs_type ENUM('l', 'r'),
    jhs_salary DECIMAL(8,2),
    jhs_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES judge(per_id),
    FOREIGN KEY (jhs_crt_id) REFERENCES court(crt_id)
);

-- Create case table
CREATE TABLE `case` (
    cse_id SMALLINT PRIMARY KEY,
    per_id SMALLINT,
    cse_type VARCHAR(45) NOT NULL,
    cse_description TEXT,
    cse_start_date DATE NOT NULL,
    cse_end_date DATE,
    cse_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES judge(per_id)
);

-- Create assignment table
CREATE TABLE assignment (
    asn_id SMALLINT PRIMARY KEY,
    per_id SMALLINT,
    cli_id SMALLINT,
    cse_id SMALLINT,
    asn_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES attorney(per_id),
    FOREIGN KEY (cli_id) REFERENCES client(per_id),
    FOREIGN KEY (cse_id) REFERENCES `case`(cse_id)
);

-- Create bar table
CREATE TABLE bar (
    bar_id TINYINT PRIMARY KEY,
    per_id SMALLINT,
    bar_name VARCHAR(45) NOT NULL,
    bar_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES attorney(per_id)
);

-- Create specialty table
CREATE TABLE specialty (
    spc_id TINYINT PRIMARY KEY,
    per_id SMALLINT,
    spc_type VARCHAR(45) NOT NULL,
    spc_notes VARCHAR(255),
    FOREIGN KEY (per_id) REFERENCES attorney(per_id)
);

-- 15 Inserts for person table
INSERT INTO person (per_id, per_ssn, per_salt, per_fname, per_lname, per_street, per_city, per_state, per_zip, per_email, per_dob, per_type, per_notes) VALUES
(1,  UNHEX(SHA2(CONCAT('111111111', 'salt1'), 256)),  UNHEX(SHA2('salt1', 256)),  'John',    'Doe',       '101 A St', 'Springfield','FL','32301','john.doe@example.com','1990-01-01','c','Client #1'),
(2,  UNHEX(SHA2(CONCAT('222222222', 'salt2'), 256)),  UNHEX(SHA2('salt2', 256)),  'Jane',    'Smith',     '202 B St', 'Springfield','FL','32302','jane.smith@example.com','1988-02-05','c','Client #2'),
(3,  UNHEX(SHA2(CONCAT('333333333', 'salt3'), 256)),  UNHEX(SHA2('salt3', 256)),  'Alex',    'Brown',     '303 C Ave','Springfield','FL','32303','alex.brown@example.com','1985-03-10','c','Client #3'),
(4,  UNHEX(SHA2(CONCAT('444444444', 'salt4'), 256)),  UNHEX(SHA2('salt4', 256)),  'Chris',   'Miller',    '404 D Blvd','Springfield','FL','32304','chris.miller@example.com','1992-04-15','c','Client #4'),
(5,  UNHEX(SHA2(CONCAT('555555555', 'salt5'), 256)),  UNHEX(SHA2('salt5', 256)),  'Pat',     'Johnson',   '505 E Rd', 'Springfield','FL','32305','pat.johnson@example.com','1987-05-20','c','Client #5'),
(6,  UNHEX(SHA2(CONCAT('666666666', 'salt6'), 256)),  UNHEX(SHA2('salt6', 256)),  'Robert',  'Davis',     '606 F Ln', 'Springfield','FL','32306','robert.davis@example.com','1975-06-25','a','Attorney #1'),
(7,  UNHEX(SHA2(CONCAT('777777777', 'salt7'), 256)),  UNHEX(SHA2('salt7', 256)),  'Michael', 'Clark',     '707 G St','Springfield','FL','32307','michael.clark@example.com','1980-07-12','a','Attorney #2'),
(8,  UNHEX(SHA2(CONCAT('888888888', 'salt8'), 256)),  UNHEX(SHA2('salt8', 256)),  'Emily',   'Martinez',  '808 H Ave','Springfield','FL','32308','emily.martinez@example.com','1983-08-08','a','Attorney #3'),
(9,  UNHEX(SHA2(CONCAT('999999999', 'salt9'), 256)),  UNHEX(SHA2('salt9', 256)),  'Sarah',   'Rodriguez', '909 I Blvd','Springfield','FL','32309','sarah.rodriguez@example.com','1979-09-09','a','Attorney #4'),
(10, UNHEX(SHA2(CONCAT('101010101','salt10'),256)), UNHEX(SHA2('salt10',256)), 'Daniel','Garcia','101 J Rd','Springfield','FL','32310','daniel.garcia@example.com','1991-10-10','a','Attorney #5'),
(11, UNHEX(SHA2(CONCAT('111111000','salt11'),256)), UNHEX(SHA2('salt11',256)), 'Alice','Lopez','111 K Ln','Springfield','FL','32311','alice.lopez@example.com','1970-11-11','j','Judge #1'),
(12, UNHEX(SHA2(CONCAT('121212121','salt12'),256)),UNHEX(SHA2('salt12',256)), 'George','Harris','121 L St','Springfield','FL','32312','george.harris@example.com','1972-12-12','j','Judge #2'),
(13, UNHEX(SHA2(CONCAT('131313131','salt13'),256)),UNHEX(SHA2('salt13',256)), 'Nancy','Young','131 M Ave','Springfield','FL','32313','nancy.young@example.com','1965-03-03','j','Judge #3'),
(14, UNHEX(SHA2(CONCAT('141414141','salt14'),256)),UNHEX(SHA2('salt14',256)), 'Jessica','Scott','141 N Blvd','Springfield','FL','32314','jessica.scott@example.com','1968-04-04','j','Judge #4'),
(15, UNHEX(SHA2(CONCAT('151515151','salt15'),256)),UNHEX(SHA2('salt15',256)), 'Kevin','Green','151 O Rd','Springfield','FL','32315','kevin.green@example.com','1969-05-05','j','Judge #5');

-- 5 Inserts for phone table
INSERT INTO phone (phn_id, per_id, phn_num, phn_type, phn_notes) VALUES
(1, 1,  8501110000, 'home',   'Client 1 home phone'),
(2, 2,  8502220000, 'mobile', 'Client 2 mobile phone'),
(3, 6,  8506660000, 'office', 'Attorney 6 office phone'),
(4, 11, 8501119999, 'office', 'Judge 11 office phone'),
(5, 15, 8505558888, 'mobile', 'Judge 15 mobile phone');

-- 5 Inserts for attorney table (IDs 6 to 10)
INSERT INTO attorney (per_id, aty_start_date, aty_end_date, aty_hourly_rate, aty_years_in_practice, aty_notes)
VALUES
(6, '2020-01-01', NULL, 250.00, 5, 'Attorney #6 details'),
(7, '2019-06-15', NULL, 200.00, 4, 'Attorney #7 details'),
(8, '2021-03-10', '2024-03-10', 300.00, 3, 'Attorney #8 resigned 2024'),
(9, '2018-11-20', NULL, 180.00, 7, 'Attorney #9 details'),
(10, '2022-02-02', NULL, 225.50, 1, 'Attorney #10 details');

-- 5 Inserts for judge table (IDs 11 to 15)
INSERT INTO judge (per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
VALUES
(11, 1, 95000.00, 15, 'Judge #11 presides in court 1'),
(12, 2, 100000.00, 20, 'Judge #12 presides in court 2'),
(13, 3, 110000.00, 10, 'Judge #13 presides in court 3'),
(14, 4, 125000.00, 12, 'Judge #14 presides in court 4'),
(15, 5, 90000.00, 8, 'Judge #15 presides in court 5');

-- 5 Inserts for client table (IDs 1 to 5)
INSERT INTO client (per_id, cli_notes)
VALUES
(1, 'Client #1 details'),
(2, 'Client #2 details'),
(3, 'Client #3 details'),
(4, 'Client #4 details'),
(5, 'Client #5 details');

-- 5 Inserts for court table (IDs 1 to 5)
INSERT INTO court (crt_id, crt_name, crt_street, crt_city, crt_state, crt_zip, crt_phone, crt_email, crt_url, crt_notes)
VALUES
(1, 'Downtown Court', '123 Main St', 'Springfield', 'FL', '32301', 8501112222, 'dtcourt@example.com', 'http://downtown.example.com', 'Court #1'),
(2, 'Uptown Court',   '456 High St', 'Springfield', 'FL', '32302', 8502223333, 'upcourt@example.com', 'http://uptown.example.com', 'Court #2'),
(3, 'Westside Court', '789 West Ave','Springfield', 'FL', '32303', 8503334444, 'wscourt@example.com', 'http://westside.example.com', 'Court #3'),
(4, 'Eastside Court', '135 East Rd', 'Springfield', 'FL', '32304', 8504445555, 'escourt@example.com', 'http://eastside.example.com', 'Court #4'),
(5, 'Northside Court','246 North Blvd','Springfield','FL','32305',8505556666,'nscourt@example.com','http://northside.example.com','Court #5');

-- 5 Inserts for judge_hist table
INSERT INTO judge_hist (jhs_id, per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
VALUES
(1, 11, 1, '2023-01-01 10:00:00', 'l', 95000.00, 'Judge #11 assigned court #1'),
(2, 12, 2, '2023-02-01 10:00:00', 'l', 100000.00, 'Judge #12 assigned court #2'),
(3, 13, 3, '2023-03-01 10:00:00', 'l', 110000.00, 'Judge #13 assigned court #3'),
(4, 14, 4, '2023-04-01 10:00:00', 'r', 125000.00, 'Judge #14 retired from court #4'),
(5, 15, 5, '2023-05-01 10:00:00', 'l', 90000.00,  'Judge #15 assigned court #5');

-- 5 Inserts for case table
INSERT INTO `case` (cse_id, per_id, cse_type, cse_description, cse_start_date, cse_end_date, cse_notes)
VALUES
(1, 11, 'Criminal',       'Case #1 description', '2023-01-15', NULL,        'Case #1 note'),
(2, 12, 'Civil',          'Case #2 description', '2023-02-15', '2023-03-15','Case #2 closed'),
(3, 13, 'Family',         'Case #3 description', '2023-03-20', NULL,        'Case #3 note'),
(4, 14, 'Personal Injury','Case #4 description', '2022-12-01', '2023-01-01','Case #4 closed'),
(5, 15, 'Criminal',       'Case #5 description', '2023-06-10', NULL,        'Case #5 note');

-- 5 Inserts for assignment table
INSERT INTO assignment (asn_id, per_id, cli_id, cse_id, asn_notes)
VALUES
(1, 6,  1, 1, 'Attorney #6 for Client #1 in Case #1'),
(2, 7,  2, 2, 'Attorney #7 for Client #2 in Case #2'),
(3, 8,  3, 3, 'Attorney #8 for Client #3 in Case #3'),
(4, 9,  4, 4, 'Attorney #9 for Client #4 in Case #4'),
(5, 10, 5, 5, 'Attorney #10 for Client #5 in Case #5');

-- 5 Inserts for bar table
INSERT INTO bar (bar_id, per_id, bar_name, bar_notes)
VALUES
(1, 6,  'Florida Bar',   'Bar record #1'),
(2, 7,  'California Bar','Bar record #2'),
(3, 8,  'New York Bar',  'Bar record #3'),
(4, 9,  'Texas Bar',     'Bar record #4'),
(5, 10, 'Georgia Bar',   'Bar record #5');

-- 5 Inserts for specialty table
INSERT INTO specialty (spc_id, per_id, spc_type, spc_notes)
VALUES
(1, 6,  'Criminal Law',     'Specialty record #1'),
(2, 7,  'Family Law',       'Specialty record #2'),
(3, 8,  'Corporate Law',    'Specialty record #3'),
(4, 9,  'Immigration',      'Specialty record #4'),
(5, 10, 'Civil Litigation', 'Specialty record #5');

SELECT count(*) FROM information_schema.tables WHERE table_schema = "np22i";

SELECT 'person' AS TableName, COUNT(*) AS RowCount FROM np22i.person
UNION
SELECT 'phone', COUNT(*) FROM np22i.phone
UNION
SELECT 'attorney', COUNT(*) FROM np22i.attorney
UNION
SELECT 'judge', COUNT(*) FROM np22i.judge
UNION
SELECT 'client', COUNT(*) FROM np22i.client
UNION
SELECT 'court', COUNT(*) FROM np22i.court
UNION
SELECT 'judge_hist', COUNT(*) FROM np22i.judge_hist
UNION
SELECT 'case', COUNT(*) FROM np22i.case
UNION
SELECT 'assignment', COUNT(*) FROM np22i.assignment
UNION
SELECT 'bar', COUNT(*) FROM np22i.bar
UNION
SELECT 'specialty', COUNT(*) FROM np22i.specialty;

-- 1) Create a view displaying attorney details
DROP VIEW IF EXISTS attorney_details;
CREATE VIEW attorney_details AS
SELECT 
    a.per_id,
    CONCAT(p.per_fname, ' ', p.per_lname) AS full_name,
    CONCAT(p.per_street, ', ', p.per_city, ', ', p.per_state, ' ', p.per_zip) AS full_address,
    TIMESTAMPDIFF(YEAR, p.per_dob, CURDATE()) AS age,
    a.aty_hourly_rate,
    b.bar_name,
    s.spc_type AS specialty
FROM attorney a
JOIN person p ON a.per_id = p.per_id
LEFT JOIN bar b ON a.per_id = b.per_id
LEFT JOIN specialty s ON a.per_id = s.per_id
ORDER BY p.per_lname;

SELECT *
FROM attorney_details;


-- Extra Credit: Scheduled event to retain only the first 100 judge_hist rows
DELIMITER $$
CREATE EVENT remove_judge_history
ON SCHEDULE
  EVERY 2 MONTH
  STARTS (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 3 WEEK))
  ENDS (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 4 YEAR))
DO
BEGIN
  DELETE FROM judge_hist
  WHERE jhs_id > (
    SELECT t.jhs_id 
    FROM (
      SELECT jhs_id
      FROM judge_hist
      ORDER BY jhs_id
      LIMIT 1 OFFSET 99
    ) AS t
  );
END$$
DELIMITER ;


