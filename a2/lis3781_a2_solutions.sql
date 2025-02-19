-- Part 1: MySQL Server

-- Step 1: Create Database
CREATE DATABASE np22i;
USE np22i;

-- Step 2: Create Tables
CREATE TABLE company (
    cmp_id INT AUTO_INCREMENT PRIMARY KEY,
    cmp_type ENUM('C-Corp','S-Corp','Non-Profit-Corp','LLC','Partnership') NOT NULL,
    cmp_street VARCHAR(255) NOT NULL,
    cmp_city VARCHAR(100) NOT NULL,
    cmp_state CHAR(2) NOT NULL,
    cmp_zip CHAR(10) NOT NULL,
    cmp_phone VARCHAR(20) NOT NULL,
    cmp_ytd_sales DECIMAL(15,2) NOT NULL,
    cmp_url VARCHAR(255),
    cmp_notes TEXT
);

CREATE TABLE customer (
    cus_id INT AUTO_INCREMENT PRIMARY KEY,
    cmp_id INT,
    cus_ssn BINARY(64) NOT NULL,
    cus_salt BINARY(64) NOT NULL,
    cus_type ENUM('Loyal','Discount','Impulse','Need-Based','Wandering') NOT NULL,
    cus_first VARCHAR(100) NOT NULL,
    cus_last VARCHAR(100) NOT NULL,
    cus_street VARCHAR(255) NOT NULL,
    cus_city VARCHAR(100) NOT NULL,
    cus_state CHAR(2) NOT NULL,
    cus_zip CHAR(10) NOT NULL,
    cus_phone VARCHAR(20) NOT NULL,
    cus_email VARCHAR(255) NOT NULL,
    cus_balance DECIMAL(15,2) NOT NULL,
    cus_tot_sales DECIMAL(15,2) NOT NULL,
    cus_notes TEXT,
    FOREIGN KEY (cmp_id) REFERENCES company(cmp_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Step 3: Insert Data into Tables
INSERT INTO company (cmp_type, cmp_street, cmp_city, cmp_state, cmp_zip, cmp_phone, cmp_ytd_sales, cmp_url, cmp_notes) VALUES
('C-Corp', '123 Main St', 'Tallahassee', 'FL', '32301', '850-555-1234', 5000000.00, 'http://example.com', 'Leading provider'),
('LLC', '456 Elm St', 'Miami', 'FL', '33101', '305-555-5678', 2000000.00, 'http://example2.com', 'Growing startup'),
('Partnership', '789 Oak St', 'Orlando', 'FL', '32801', '407-555-7890', 1500000.00, NULL, 'Regional business'),
('Non-Profit-Corp', '321 Pine St', 'Jacksonville', 'FL', '32201', '904-555-3210', 300000.00, 'http://nonprofit.org', 'Charitable organization'),
('S-Corp', '654 Cedar St', 'Tampa', 'FL', '33601', '813-555-6543', 750000.00, 'http://scorpbiz.com', 'Mid-size business');

INSERT INTO customer (cmp_id, cus_ssn, cus_salt, cus_type, cus_first, cus_last, cus_street, cus_city, cus_state, cus_zip, cus_phone, cus_email, cus_balance, cus_tot_sales, cus_notes) VALUES
(1, RANDOM_BYTES(64), RANDOM_BYTES(64), 'Loyal', 'John', 'Doe', '100 Peach St', 'Tallahassee', 'FL', '32302', '850-555-1111', 'johndoe@email.com', 1000.00, 5000.00, 'Preferred customer'),
(2, RANDOM_BYTES(64), RANDOM_BYTES(64), 'Discount', 'Jane', 'Smith', '200 Orange St', 'Miami', 'FL', '33102', '305-555-2222', 'janesmith@email.com', 500.00, 2000.00, 'Frequent buyer'),
(3, RANDOM_BYTES(64), RANDOM_BYTES(64), 'Impulse', 'Alice', 'Brown', '300 Lemon St', 'Orlando', 'FL', '32802', '407-555-3333', 'alicebrown@email.com', 300.00, 1000.00, 'Occasional shopper'),
(4, RANDOM_BYTES(64), RANDOM_BYTES(64), 'Need-Based', 'Bob', 'White', '400 Apple St', 'Jacksonville', 'FL', '32202', '904-555-4444', 'bobwhite@email.com', 800.00, 3500.00, 'Seasonal buyer'),
(5, RANDOM_BYTES(64), RANDOM_BYTES(64), 'Wandering', 'Charlie', 'Davis', '500 Grape St', 'Tampa', 'FL', '33602', '813-555-5555', 'charliedavis@email.com', 200.00, 700.00, 'Infrequent customer');

-- Step 4: Create Users & Grant Privileges
CREATE USER 'user1'@'localhost' IDENTIFIED BY 'password1';
CREATE USER 'user2'@'localhost' IDENTIFIED BY 'password2';
GRANT SELECT, UPDATE, DELETE ON np22i.company TO 'user1'@'localhost';
GRANT SELECT, UPDATE, DELETE ON np22i.customer TO 'user1'@'localhost';
GRANT SELECT, INSERT ON np22i.customer TO 'user2'@'localhost';
FLUSH PRIVILEGES;

-- Step 5: Verify Permissions
SHOW GRANTS FOR 'user1'@'localhost';
SHOW GRANTS FOR 'user2'@'localhost';

-- Step 6: Test User Restrictions
-- Log in as user1 and try inserting into company (should fail)
INSERT INTO company (cmp_type, cmp_street, cmp_city, cmp_state, cmp_zip, cmp_phone, cmp_ytd_sales, cmp_url, cmp_notes) 
VALUES ('LLC', '600 Maple St', 'Tampa', 'FL', '33603', '813-555-6666', 1000000.00, 'http://mapleco.com', 'Small business');

-- Log in as user2 and try deleting from customer (should fail)
DELETE FROM customer WHERE cus_id = 1;

-- Step 7: Cleanup (Admin Only)
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS company;
DROP DATABASE IF EXISTS np22i;

-- End of Script
