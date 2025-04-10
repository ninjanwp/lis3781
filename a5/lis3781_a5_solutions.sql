set ansi_warnings on;
GO

Use master;
GO

If exists (select name from master.dbo.sysdatabases where name = N'np22i')
Drop database np22i;
GO

If not exists (select name from master.dbo.sysdatabases where name = N'np22i')
Create database np22i;
GO

Use np22i;
GO

-- Person table

If object_id (N'dbo.person', N'U') is not null
Drop table dbo.person;
GO

Create table dbo.person
(
per_id SMALLINT not null identity(1,1),
per_ssn binary(64) null,
per_salt binary(64) null,
per_fname VARCHAR(15) NOT NULL,
per_lname VARCHAR(30) NOT NULL,
per_gender char(1) not null check (per_gender IN('m', 'f')),
per_dob DATE NOT NULL,
per_street VARCHAR(30) NOT NULL,
per_city VARCHAR(30) NOT NULL,
per_state CHAR(2) NOT NULL default 'FL',
per_zip int NOT NULL check (per_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
per_email VARCHAR(100) NOT NULL,
per_type char(1) NOT NULL check (per_type IN('c', 's')),
per_notes VARCHAR(255) NULL,
PRIMARY KEY(per_id),

CONSTRAINT ux_per_ssn unique nonclustered (per_ssn ASC)
);
GO
-- phone table

If object_id (N'dbo.phone', N'U') is not null
Drop table dbo.phone;
GO

Create table dbo.phone
(
phn_id SMALLINT not null identity(1,1),
per_id SMALLINT not null,
phn_num bigint not null check (phn_num like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
phn_type char(1) not null check (phn_type IN('h', 'c', 'w', 'f')),
phn_notes varchar(255) null,
Primary key (phn_id),

Constraint fk_phone_person
      foreign key (per_id)
      references dbo.person (per_id)
      on delete cascade
      on update cascade
);


-- customer table


If object_id (N'dbo.customer', N'U') is not null
Drop table dbo.customer;
GO

Create table dbo.customer
(
per_id SMALLINT not null,
cus_balance decimal(7,2) not null check(cus_balance >= 0),
cus_total_sales decimal(7,2) not null check(cus_total_sales >= 0),
cus_notes varchar(255) null,
Primary key (per_id),

Constraint fk_customer_person
      foreign key (per_id)
      references dbo.person (per_id)
      on delete cascade
      on update cascade
);


-- slsrep table

If object_id (N'dbo.slsrep', N'U') is not null
Drop table dbo.slsrep;
GO

Create table dbo.slsrep
(
per_id SMALLINT not null,
srp_yr_sales_goal decimal(8,2) not null check (srp_yr_sales_goal >= 0),
srp_ytd_sales decimal(8,2) not null check (srp_ytd_sales >= 0),
srp_ytd_comm decimal(7,2) not null check (srp_ytd_comm >= 0),
srp_notes varchar(255) null,
Primary key (per_id),

Constraint fk_slsrep_person
      foreign key (per_id)
      references dbo.person (per_id)
      on delete cascade
      on update cascade
);

-- srp_hist table

If object_id (N'dbo.srp_hist', N'U') is not null
Drop table dbo.srp_hist;
GO

Create table dbo.srp_hist
(
sht_id SMALLINT not null identity(1,1),
per_id SMALLINT not null,
sht_type char(1) not null check (sht_type IN('I', 'u', 'd')),
sht_modified datetime not null,
sht_modifier varchar(45) not null default system_user,
sht_date date not null default getDate(),
sht_yr_sales_goal decimal(8,2) not null check(sht_yr_sales_goal >= 0),
sht_yr_total_sales decimal(8,2) not null check(sht_yr_total_sales >= 0),
sht_yr_total_comm decimal(7,2) not null check(sht_yr_total_comm >= 0),
sht_notes varchar(255) null,
Primary key (sht_id),

Constraint fk_srp_hist_person
      foreign key (per_id)
      references dbo.slsrep (per_id)
      on delete cascade
      on update cascade
);


-- contact table

If object_id (N'dbo.contact', N'U') is not null
Drop table dbo.contact;
GO

Create table dbo.contact
(
cnt_id int not null identity(1,1),
per_cid smallint not null,
per_sid smallint not null,
cnt_date datetime not null,
cnt_notes varchar(255) null,
Primary key (cnt_id),

Constraint fk_contact_customer
      foreign key (per_cid)
      references dbo.customer (per_id)
      on delete cascade
      on update cascade,

Constraint fk_contact_person
      foreign key (per_sid)
      references dbo.slsrep (per_id)
      on delete no action
      on update no action
);

-- [order] table

If object_id (N'dbo.[order]', N'U') is not null
Drop table dbo.[order];
GO

Create table dbo.[order]
(
ord_id int not null identity(1,1),
cnt_id int not null,
ord_placed_date datetime not null,
ord_filled_date datetime null,
ord_notes varchar(255) null,
Primary key (ord_id),

Constraint fk_order_contact
      foreign key (cnt_id)
      references dbo.contact (cnt_id)
      on delete cascade
      on update cascade
);
GO
-- Region table

If object_id (N'dbo.region', N'U') is not null
Drop table dbo.region;
GO

Create table dbo.region
(
reg_id tinyint not null identity(1,1),
reg_name char(1) not null,
reg_notes varchar(255) null,
primary key(reg_id)
);
GO

-- State table

If object_id (N'dbo.state', N'U') is not null
Drop table dbo.state;
GO

Create table dbo.state
(
ste_id tinyint not null identity(1,1),
reg_id tinyint not null,
ste_name char(2) not null default 'FL',
ste_notes varchar(255) null,
primary key(ste_id),

constraint fk_state_region
  foreign key (reg_id)
  references dbo.region (reg_id)
  on delete cascade
  on update cascade
);
GO

-- City Table

If object_id (N'dbo.city', N'U') is not null
Drop table dbo.city;
GO

Create table dbo.city
(
cty_id smallint not null identity(1,1),
ste_id tinyint not null,
cty_name varchar(30) not null,
cty_notes varchar(255) null,
primary key (cty_id),

constraint fk_city_state
  foreign key (ste_id)
  references dbo.state (ste_id)
  on delete cascade
  on update cascade
);
GO

-- store table

If object_id (N'dbo.store', N'U') is not null
Drop table dbo.store;
GO

Create table dbo.store
(
str_id smallint not null identity(1,1),
cty_id smallint not null,
str_name varchar(45) not null,
str_street VARCHAR(30) NOT NULL,
str_city VARCHAR(30) NOT NULL,
str_state CHAR(2) NOT NULL default 'FL',
str_zip int NOT NULL check (str_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
str_phone bigint not null check (str_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
str_email VARCHAR(100) NOT NULL,
str_url varchar(100) not null,
str_notes varchar(255) null,
Primary key (str_id),

constraint fk_store_city
  foreign key (cty_id)
  references dbo.city (cty_id)
  on delete cascade
  on update cascade
);

-- invoice table

If object_id (N'dbo.invoice', N'U') is not null
Drop table dbo.invoice;
GO

Create table dbo.invoice
(
inv_id int not null identity(1,1),
ord_id int not null,
str_id smallint not null,
inv_date datetime not null,
inv_total decimal(8,2) not null check (inv_total >= 0),
inv_paid bit not null,
inv_notes varchar(255) null,
Primary key (inv_id),

Constraint ux_ord_id unique nonclustered (ord_id ASC),

Constraint fk_invoice_order
      foreign key (ord_id)
      references dbo.[order] (ord_id)
      on delete cascade
      on update cascade,

Constraint fk_invoice_store
      foreign key (str_id)
      references dbo.store (str_id)
      on delete cascade
      on update cascade
);

-- payment table

If object_id (N'dbo.payment', N'U') is not null
Drop table dbo.payment;
GO

Create table dbo.payment
(
pay_id int not null identity(1,1),
inv_id int not null,
pay_date datetime not null,
pay_amt decimal(7,2) not null check (pay_amt >= 0),
pay_notes varchar(255) null,
Primary key (pay_id),

Constraint fk_payment_invoice
      foreign key (inv_id)
      references dbo.invoice (inv_id)
      on delete cascade
      on update cascade
);

-- table vendor

If object_id (N'dbo.vendor', N'U') is not null
Drop table dbo.vendor;
GO

Create table dbo.vendor
(
ven_id smallint not null identity(1,1),
ven_name varchar(45) not null,
ven_street VARCHAR(30) NOT NULL,
ven_city VARCHAR(30) NOT NULL,
ven_state CHAR(2) NOT NULL default 'FL',
ven_zip int NOT NULL check (ven_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
ven_phone bigint not null check (ven_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
ven_email VARCHAR(100) NOT NULL,
ven_url varchar(100) not null,
ven_notes varchar(255) null,
Primary key (ven_id)
);

-- product table

If object_id (N'dbo.product', N'U') is not null
Drop table dbo.product;
GO

Create table dbo.product
(
pro_id smallint not null identity(1,1),
ven_id smallint not null,
pro_name varchar(30) not null,
pro_descript varchar(45) null,
pro_weight float not null check (pro_weight >= 0),
pro_qoh smallint not null check (pro_qoh >= 0),
pro_cost decimal(7,2) not null check (pro_cost >= 0),
pro_price decimal(7,2) not null check (pro_price >= 0),
pro_discount decimal(3,0) null,
pro_notes varchar(255) null,
Primary key (pro_id),

Constraint fk_product_vendor
      foreign key (ven_id)
      references dbo.vendor (ven_id)
      on delete cascade
      on update cascade
);

-- product_hist table

If object_id (N'dbo.product_hist', N'U') is not null
Drop table dbo.product_hist;
GO

Create table dbo.product_hist
(
pht_id int not null identity(1,1),
pro_id smallint not null,
pht_date datetime not null,
pht_cost decimal(7,2) not null check (pht_cost >= 0),
pht_price decimal(7,2) not null check (pht_price >= 0),
pht_discount decimal(3,0) null,
pht_notes varchar(255) null,
Primary key (pht_id),

Constraint fk_product_hist_product
      foreign key (pro_id)
      references dbo.product (pro_id)
      on delete cascade
      on update cascade
);

-- order_line table

If object_id (N'dbo.order_line', N'U') is not null
Drop table dbo.order_line;
GO

Create table dbo.order_line
(
oln_id int not null identity(1,1),
ord_id int not null,
pro_id smallint not null,
oln_qty smallint not null check (oln_qty >= 0),
oln_price decimal(7,2) not null check (oln_price >= 0),
oln_notes varchar(255) null,
Primary key (oln_id),

Constraint fk_order_line_order
      foreign key (ord_id)
      references dbo.[order] (ord_id)
      on delete cascade
      on update cascade,

Constraint fk_order_line_product
        foreign key (pro_id)
      references dbo.product (pro_id)
      on delete cascade
      on update cascade
);

-- Time Table

If object_id (N'dbo.time', N'U') is not null
Drop table dbo.time;
GO

Create table dbo.time
(
tim_id int not null identity(1,1),
tim_yr smallint not null,
tim_qtr tinyint not null,
tim_month tinyint not null,
tim_week tinyint not null,
tim_day tinyint not null,
tim_time time not null,
tim_notes varchar(255) null,
primary key(tim_id)
);

-- Sales Table

If object_id (N'dbo.sale', N'U') is not null
Drop table dbo.sale;
GO

Create table dbo.sale
(
pro_id smallint not null,
str_id smallint not null,
cnt_id int not null,
tim_id int not null,
sal_qty smallint not null,
sal_price decimal(8,2) not null,
sal_total decimal(8,2) not null,
sal_notes varchar(255) null,
primary key (pro_id, cnt_id, tim_id, str_id),

constraint ux_pro_id_str_id_cnt_id_tim_id
unique nonclustered (pro_id ASC, str_id ASC, cnt_id ASC, tim_id ASC),

constraint fk_sale_time
  foreign key (tim_id)
  references dbo.time (tim_id)
  on delete cascade
  on update cascade,

constraint fk_sale_contact
  foreign key (cnt_id)
  references dbo.contact (cnt_id)
  on delete cascade
  on update cascade,

constraint fk_sale_store
  foreign key (str_id)
  references dbo.store (str_id)
  on delete cascade
  on update cascade,

constraint fk_sale_product
  foreign key (pro_id)
  references dbo.product (pro_id)
  on delete cascade
  on update cascade
);
GO

-- person table insert

Insert into dbo.person
(per_ssn, per_salt, per_fname, per_lname, per_gender, per_dob, per_street, per_city, per_state, per_zip, per_email, per_type, per_notes)
values
(1, NULL, 'Steve', 'Rogers', 'm', '1923-10-03', '437 Southern Drive', 'Rochester', 'NY', 324402222, 'srogers@comcast.net', 's', NULL),
(2, NULL, 'Bruce', 'Wayne', 'm', '1968-03-20', '1007 Moutain Drive', 'Gotham', 'NY', 123208440, 'bwayne@comcast.net', 's', NULL),
(3, NULL, 'Peter', 'Parker', 'm', '1988-09-12', '13563 Ocean View Drive', 'New York', 'NY', 102862341, 'pparker@comcast.net', 's', NULL),
(4, NULL, 'Jane', 'Thompson', 'f', '1978-05-08', '543 Oak Ln', 'Seattle', 'WA', 132084409, 'jthompson@comcast.net', 's', NULL),
(5, NULL, 'Debra', 'Steele', 'f', '1994-07-19', '332 Palm Avenue', 'Milwaukee', 'WI', 286234178, 'dsteele@comcast.net', 's', NULL),
(6, NULL, 'Tony', 'Stark', 'm', '1972-05-04', '2355 Brown Street', 'Malibu', 'CA', 902638332, 'tstark@comcast.net', 'c', NULL),
(7, NULL, 'Hank', 'Pyml', 'm', '1980-08-28', '4902 Avendale Avenue', 'Cleveland', 'OH', 122348890, 'hpyml@comcast.net', 'c', NULL),
(8, NULL, 'Bob', 'Best', 'm', '1992-02-10', '87912 Lawrence Ave', 'Scottsdale', 'AZ', 872638332, 'bestb@comcast.net', 'c', NULL),
(9, NULL, 'Sandra', 'Dole', 'f', '1990-01-26', '6432 Thunderbird Ln', 'Atlanta', 'GA', 122348890, 'doles@comcast.net', 'c', NULL),
(10, NULL, 'Ben', 'Avery', 'm', '1983-12-24', '3304 Euclid Avenue', 'Sioux Falls', 'SD', 562638332, 'bavery@comcast.net', 'c', NULL);
GO
-- slsrep table insert

Insert into dbo.slsrep
(per_id, srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes)
Values
(1, 100000, 60000, 1800, null),
(2, 80000, 35000, 3500, null),
(3, 150000, 84000, 9650, null),
(4, 125000, 87000, 15300, null),
(5, 980000, 43000, 88750, null);

-- customer table insert

Insert into dbo.customer
(per_id, cus_balance, cus_total_sales, cus_notes)
Values
(6, 120, 14789, null),
(7, 98.46, 234.92, null),
(8, 0, 4578, 'Customer always pays on time'),
(9, 981.73, 1672.38, 'High balance'),
(10, 541.23, 782.57, null);

-- contact table insert

Insert into dbo.contact
(per_sid, per_cid, cnt_date, cnt_notes)
Values
(1, 6, '1999-01-01', null),
(2, 6, '2001-09-29', null),
(2, 7, '2002-08-15', null),
(4, 7, '2002-09-01', null),
(5, 7, '2004-01-05', null);

-- [order] table insert

Insert into dbo.[order]
(cnt_id, ord_placed_date, ord_filled_date, ord_notes)
Values
(1, '2001-11-23', '2010-12-24', null),
(2, '2005-01-19', '2005-07-28', null),
(3, '2011-07-01', '2011-07-06', null),
(4, '2009-12-24', '2010-01-05', null),
(5, '2008-09-21', '2008-11-26', null);


-- region table insert

Insert into dbo.region
(reg_name, reg_notes)
values
('c', NULL),
('n', NULL),
('e', NULL),
('s', NULL),
('w', NULL);
GO

-- state table insert

Insert into dbo.state
(reg_id, ste_name, ste_notes)
values
(1, 'MI', NULL),
(2, 'IL', NULL),
(2, 'WA', NULL),
(3, 'FL', NULL),
(4, 'TX', NULL);
GO

-- city table insert

Insert into dbo.city
(ste_id, cty_name, cty_notes)
values
(1, 'Detroit', NULL),
(2, 'Aspen', NULL),
(2, 'Chicago', NULL),
(3, 'Clover', NULL),
(4, 'St. Louis', NULL);
GO

-- store table insert

Insert into dbo.store
(cty_id, str_name, str_street, str_city, str_state, str_zip, str_phone, str_email, str_url, str_notes)
Values
(2, 'Walgreens', '14567 Walnut Ln', 'Aspen', 'IL', 475315690, 3127658127, 'info@walgreens.com', 'http://walgreens.com', null),
(3, 'CVS', '572 Casper Rd', 'Chicago', 'IL', 502315191, 3128926534, 'help@cv.com', 'http://cvs.com', null),
(4, 'Lowes', '81309 Catapult ave', 'Clover', 'WA', 802345671, 9017653421, 'sales@lowes.com', 'http://lowes.com', null),
(5, 'Walmart', '14567 Walnut Ln', 'St. Louis', 'FL', 387563628, 8722718923, 'info@walmart.com', 'http://walmart.com', null),
(1, 'Dollar General', '47583 Davison Rd', 'Detroit', 'MI', 482934561, 3137583492, 'ask@dollargeneral.com', 'http://dollargeneral.com', 'recently sold property');

-- invoice table insert


Insert into dbo.invoice
(ord_id, str_id, inv_date, inv_total, inv_paid, inv_notes)
Values
(5, 1, '2001-05-03', 58.23, 0, null),
(4, 1, '2006-11-11', 100.59, 0, null),
(1, 1, '2010-09-16', 57.34, 0, null),
(3, 2, '2011-01-10', 99.32, 1, null),
(2, 3, '2008-06-24', 1109.67, 1, null);

-- vendor table insert

Insert into dbo.vendor
(ven_name, ven_street, ven_city, ven_state, ven_zip, ven_phone, ven_email, ven_url, ven_notes)
Values
('Sysco', '531 Dolphin Run', 'Orlando', 'FL', 344761234, 7641238543, 'sales@sysco.com', 'http://www.sysco.com', null),
('General Electric', '100 Happy Trail Dr.', 'Boston', 'MA', 123458743, 2134569641, 'support@ge.com', 'http://www.ge.com', 'very good turnaround'),
('Cisco', '300 Cisco Dr.', 'Stanford', 'OR', 872315492, 7823456723, 'cisco@cisco.com', 'http://www.cisco.com', null),
('Goodyear', '100 Goodyear Dr.', 'Gary', 'IN', 485321956, 5784218427, 'sales@goodyear.com', 'http://www.goodyear.com','Competing well with firestone'),
('Snap-on', '42185 Magenta Ave', 'Lake Falls', 'ND', 387513649, 9197345632, 'support@snapon.com', 'http://www.snapon.com', null);

-- product table insert

Insert into dbo.product
(ven_id, pro_name, pro_descript, pro_weight, pro_qoh, pro_cost, pro_price, pro_discount, pro_notes)
Values
(1, 'hammer', '', 2.5, 45, 4.99, 7.99, 30, 'Discount only when purchased with screwdriver set.'),
(2, 'screwdriver', '', 1.8, 120, 1.99, 3.49, null, null),
(4, 'pail', '16 Gallon', 2.8, 48, 3.89, 7.99, 40, null),
(5, 'cooking pan', 'peanut oil', 15, 19, 19.99, 28.99, null, 'gallons'),
(3, 'frying pan', '', 3.5, 178, 8.45, 13.99, 50, 'Currently 1/2 price sale.');

-- order_line table insert

Insert into dbo.order_line
(ord_id, pro_id, oln_qty, oln_price, oln_notes)
Values
(1, 2, 10, 8.0, null),
(2, 3, 7, 9.88, null),
(3, 4, 3, 6.99, null),
(5, 1, 2, 12.76, null),
(4, 5, 13, 58.99, null);


-- payment table insert

Insert into dbo.payment
(inv_id, pay_date, pay_amt, pay_notes)
Values
(5, '2008-07-01', 5.99, null),
(4, '2010-09-28', 4.99, null),
(1, '2008-07-23', 8.75, null),
(3, '2010-10-31', 19.55, null),
(2, '2011-03-29', 32.50, null);


-- product_hist table insert

Insert into dbo.product_hist
(pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes)
Values
(1, '2005-01-02 11:53:34', 4.99, 7.99, 30, 'Discount only when purchased with screwdriver set.'),
(2, '2005-02-03 09:13:56', 1.99, 3.49, null, null),
(3, '2005-04-04 23:21:49', 3.89, 7.99, 40, null),
(4, '2006-05-06 18:09:04', 19.99, 28.99, null, 'gallons'),
(5, '2006-05-07 15:07:29', 8.45, 13.99, 50, 'Currently 1/2 price sales');


-- time table insert

Insert into dbo.time
(tim_yr, tim_qtr, tim_month, tim_week, tim_day, tim_time, tim_notes)
values
(2008, 2, 5, 19, 7, '11:59:59', NULL),
(2010, 4, 12, 49, 4, '08:34:21', NULL),
(1999, 4, 12, 52, 5, '05:21:34', NULL),
(2011, 3, 8, 36, 1, '09:32:18', NULL),
(2001, 3, 7, 27, 2, '23:56:32', NULL),
(2008, 1, 1, 5, 4, '04:22:36', NULL),
(2010, 2, 4, 14, 5, '02:49:11', NULL),
(2014, 1, 2, 8, 2, '12:27:14', NULL),
(2013, 3, 9, 38, 4, '10:12:28', NULL),
(2012, 4, 11, 47, 3, '22:36:2', NULL),
(2014, 2, 6, 23, 3, '19:07:10', NULL);
GO


-- sale table insert

Insert into dbo.sale
(pro_id, str_id, cnt_id, tim_id, sal_qty, sal_price, sal_total, sal_notes)
values
(1, 5, 5, 3, 20, 9.99, 199.8, NULL),
(2, 4, 4, 2, 5, 5.99, 29.95, NULL),
(3, 3, 4, 1, 30, 3.99, 119.7, NULL),
(4, 2, 1, 5, 15, 18.99, 284.85, NULL),
(5, 1, 2, 4, 6, 11.99, 71.94, NULL),
(5, 2, 5, 6, 10, 9.99, 199.8, NULL),
(4, 3, 4, 7, 5, 5.99, 29.95, NULL),
(3, 1, 4, 8, 30, 3.99, 119.7, NULL),
(2, 3, 1, 9, 15, 18.99, 284.85, NULL),
(1, 4, 2, 10, 6, 11.99, 71.94, NULL),
(1, 2, 3, 11, 10, 11.99, 119.9, NULL),
(1, 3, 3, 9, 30, 3.99, 199.8, NULL),
(2, 4, 1, 7, 5, 9.99, 29.95, NULL),
(4, 5, 2, 4, 20, 11.99, 119.7, NULL),
(1, 2, 3, 5, 10, 18.99, 281.7, NULL),
(5, 1, 4, 6, 15, 3.99, 79.81, NULL),
(4, 3, 5, 3, 10, 9.99, 29.82, NULL),
(2, 4, 4, 1, 30, 5.99, 119.8, NULL),
(3, 5, 3, 2, 15, 11.99, 199.12, NULL),
(3, 2, 2, 8, 10, 3.99, 29.56, NULL),
(1, 1, 1, 9, 30, 9.99, 71.9, NULL),
(2, 4, 2, 10, 5, 18.99, 19.99, NULL),
(5, 2, 3, 11, 10, 11.99, 289.15, NULL),
(4, 3, 4, 3, 20, 5.99, 119.8, NULL),
(2, 5, 5, 6, 5, 3.99, 29.65, NULL);
GO

-- srp_hist

Insert into dbo.srp_hist
(per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
Values
(1, 'i', getDate(), SYSTEM_USER, getDate(), 100000, 110000, 11000, null),
(4, 'i', getDate(), SYSTEM_USER, getDate(), 150000, 175000, 17500, null),
(3, 'u', getDate(), SYSTEM_USER, getDate(), 100000, 185000, 18500, null),
(2, 'u', getDate(), ORIGINAL_LOGIN(), getDate(), 210000, 220000, 22000, null),
(5, 'i', getDate(), ORIGINAL_LOGIN(), getDate(), 225000, 230000, 2300, null);


-- phone table insert
insert into dbo.phone
(per_id, phn_num, phn_type, phn_notes)
values
(2, 8505551234, 'c', 'Never answers'),
(5, 8505551235, 'w', 'Never shuts up'),
(3, 8505551236, 'h', 'TMI'),
(1, 8505551237, 'f', 'Boring'),
(4, 8505551238, 'c', 'Best Customer');
GO

-- person ssn salt/hash creation

CREATE PROC dbo.CreatePersonSSN
AS
BEGIN

      DECLARE @salt binary(64);
      DECLARE @ran_num int;
      DECLARE @ssn binary(64);
      DECLARE @x INT, @y INT;
      SET @x = 1;

      SET @y=(select count(*) from dbo.person);


        WHILE (@x <= @y)
        BEGIN

        SET @salt=CRYPT_GEN_RANDOM(64);
        SET @ran_num=FLOOR(RAND()*(999999999-111111111+1))+111111111;
        SET @ssn=HASHBYTES('SHA2_512', concat(@salt, @ran_num));


       update dbo.person
       set per_ssn=@ssn, per_salt=@salt
       where per_id=@x;

       set @x = @x + 1;

       end;

End;
GO

Exec dbo.CreatePersonSSN

select * from dbo.person;
      SET @x = 1;

      SET @y=(select count(*) from dbo.person);


        WHILE (@x <= @y)
        BEGIN

        SET @salt=CRYPT_GEN_RANDOM(64);
        SET @ran_num=FLOOR(RAND()*(999999999-111111111+1))+111111111;
        SET @ssn=HASHBYTES('SHA2_512', concat(@salt, @ran_num));


       update dbo.person
       set per_ssn=@ssn, per_salt=@salt
       where per_id=@x;

       set @x = @x + 1;

       end;

End;
GO

Exec dbo.CreatePersonSSN

select * from dbo.person;

-- 1. Stored Procedure: product_days_of_week
CREATE PROCEDURE product_days_of_week
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.pro_name,
        p.pro_descript,
        DATENAME(weekday, CAST(CONCAT(t.tim_yr, '-', t.tim_month, '-', t.tim_day) AS DATE)) AS DayOfWeek
    FROM dbo.sale s
    JOIN dbo.product p 
        ON s.pro_id = p.pro_id
    JOIN dbo.time t 
        ON s.tim_id = t.tim_id
    ORDER BY DATEPART(weekday, CAST(CONCAT(t.tim_yr, '-', t.tim_month, '-', t.tim_day) AS DATE));
END;
GO

EXEC product_days_of_week;


-- 2. Stored Procedure: product_drill_down
CREATE PROCEDURE product_drill_down
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.pro_name,
        p.pro_qoh AS QuantityOnHand,
        st.str_name AS StoreName,
        c.cty_name AS CityName,
        sta.ste_name AS StateName,
        r.reg_name AS RegionName
    FROM dbo.sale s
    JOIN dbo.product p 
        ON s.pro_id = p.pro_id
    JOIN dbo.store st 
        ON s.str_id = st.str_id
    JOIN dbo.city c 
        ON st.cty_id = c.cty_id
    JOIN dbo.state sta 
        ON c.ste_id = sta.ste_id
    JOIN dbo.region r 
        ON sta.reg_id = r.reg_id
    ORDER BY p.pro_qoh DESC;
END;
GO

-- 3. Stored Procedure: add_payment
CREATE PROCEDURE add_payment
    @inv_id INT,
    @pay_date DATETIME,
    @pay_amt DECIMAL(7,2),
    @pay_notes VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.payment (inv_id, pay_date, pay_amt, pay_notes)
    VALUES (@inv_id, @pay_date, @pay_amt, @pay_notes);

    PRINT 'Payment added successfully.';
END;
GO

-- 4. Stored Procedure: customer_balance
CREATE PROCEDURE customer_balance
    @last_name VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.per_id AS CustomerID,
        (p.per_fname + ' ' + p.per_lname) AS CustomerName,
        i.inv_id AS InvoiceID,
        FORMAT(ISNULL(SUM(pay.pay_amt), 0), 'C2') AS TotalPaid,
        FORMAT(i.inv_total - ISNULL(SUM(pay.pay_amt), 0), 'C2') AS Balance
    FROM dbo.person p
    JOIN dbo.customer c 
        ON p.per_id = c.per_id
    JOIN dbo.contact co 
        ON c.per_id = co.per_cid
    JOIN dbo.[order] o 
        ON co.cnt_id = o.cnt_id
    JOIN dbo.invoice i 
        ON o.ord_id = i.ord_id
    LEFT JOIN dbo.payment pay 
        ON i.inv_id = pay.inv_id
    WHERE p.per_lname = @last_name
    GROUP BY p.per_id, p.per_fname, p.per_lname, i.inv_id, i.inv_total;
END;
GO

-- 5. Stored Procedure: store_sales_between_dates
CREATE PROCEDURE store_sales_between_dates
    @start_date DATETIME,
    @end_date DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.str_id AS StoreID,
        t.tim_yr AS SalesYear,
        FORMAT(SUM(s.sal_total), 'C2') AS TotalSales
    FROM dbo.sale s
    JOIN dbo.time t 
        ON s.tim_id = t.tim_id
    WHERE CAST(CONCAT(t.tim_yr, '-', t.tim_month, '-', t.tim_day) AS DATE)
          BETWEEN @start_date AND @end_date
    GROUP BY s.str_id, t.tim_yr
    ORDER BY SUM(s.sal_total) DESC, t.tim_yr DESC;
END;
GO

-- 6. Trigger: trg_check_inv_paid
CREATE TRIGGER trg_check_inv_paid
ON dbo.payment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE i
    SET inv_paid = CASE 
                      WHEN (SELECT SUM(pay_amt) 
                            FROM dbo.payment 
                            WHERE inv_id = i.inv_id) >= i.inv_total 
                           THEN 1 
                      ELSE 0 
                   END
    FROM dbo.invoice i
    INNER JOIN inserted ins 
        ON i.inv_id = ins.inv_id;
END;
GO
