---------------------------------------------
-------------- SCHEMA CREATION --------------
--------------------------------------------- 

CREATE TABLE Customer (
  cust_id INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  ph_no VARCHAR(10) NOT NULL,
  dob DATE NOT NULL,
  email VARCHAR(25),
  address VARCHAR(256) NOT NULL,
  PRIMARY KEY (cust_id)
);

CREATE TABLE Account (
  cust_id INT NOT NULL,
  acc_num VARCHAR(12) NOT NULL,
  -- Currency considered: Rupees
  available_funds INT NOT NULL,
  -- INT has been used to simulate a boolean
  active INT NOT NULL,
  PRIMARY KEY(acc_num),
  FOREIGN KEY(cust_id) REFERENCES Customer(cust_id)
);

CREATE TABLE Card (
  card_no INT NOT NULL,
  expiry_date DATE NOT NULL,
  cvv INT NOT NULL,
  acc_num VARCHAR(12) NOT NULL,
  card_type VARCHAR(10) NOT NULL,
  -- Available cards can only be of the specified 3 types 
  CHECK (card_type IN ('VISA', 'MASTERCARD','RUPAY')),
  PRIMARY KEY(card_no),
  FOREIGN KEY(acc_num) REFERENCES Account(acc_num)
);

CREATE TABLE Cheque_book (
  book_id INT NOT NULL,
  num_cheques INT NOT NULL,
  acc_num VARCHAR(12) NOT NULL,
  PRIMARY KEY(book_id),
  FOREIGN KEY(acc_num) REFERENCES Account(acc_num)
);

CREATE TABLE Loan_Description (
  type VARCHAR(256) NOT NULL,
  max_amount INT NOT NULL,
  tenure INT NOT NULL,
  desc_id INT NOT NULL,
  PRIMARY KEY(desc_id)
);

CREATE TABLE Loan (
  loan_id INT NOT NULL,
  acc_num VARCHAR(12) NOT NULL,
  loan_amount INT NOT NULL,
  application_date DATE NOT NULL,
  -- INT has been used to simulate a boolean
  active INT NOT NULL,
  desc_id INT NOT NULL,
  PRIMARY KEY(loan_id),
  FOREIGN KEY(acc_num) REFERENCES Account(acc_num),
  FOREIGN KEY(desc_id) REFERENCES Loan_Description(desc_id)
);

CREATE TABLE Tally(
  n_of_loans INT DEFAULT(0),
  n_of_transactions INT DEFAULT(0),
  tally_id INT,
  PRIMARY KEY(tally_id) 
);

-- TALLY TABLE POPULATION

INSERT INTO Tally VALUES(0,0,1);

-- DECLARING EVENT-BASED TRIGGERS

CREATE TRIGGER add_loan_trigger
  BEFORE INSERT
  ON Loan FOR EACH ROW 
  BEGIN
    UPDATE Tally SET n_of_loans = n_of_loans + 1 WHERE tally_id=1;
  END;
/

CREATE TRIGGER delete_loan_trigger
  AFTER UPDATE
  ON Loan FOR EACH ROW 
  BEGIN
    UPDATE Tally SET n_of_loans = n_of_loans - 1 WHERE tally_id=1;
  END;
/

CREATE TRIGGER transaction_trigger
  AFTER UPDATE
  ON Account FOR EACH ROW 
  BEGIN
    UPDATE Tally SET n_of_transactions = n_of_transactions + 1 WHERE tally_id=1;
  END;
/

-- DATA INSERTION

INSERT INTO Customer
VALUES (
    101,
    'Daya Gada',
    '9876543210',
    '09-September-2002',
    NULL,
    'Gokuldham Society, Goregaon-East, Mumbai'
);
INSERT INTO Customer
VALUES (
    102,
    'Tarak Mehta',
    '9867543210',
    '09-October-2003',
    'salad@gmail.com',
    'Gokuldham Society, Goregaon-East, Mumbai'
);
INSERT INTO Customer
VALUES (
    103,
    'Khushi',
    '9876545210',
    '23-January-2001',
    'aslikhushi@yahoo.com',
    'C-35, Vasant Vihar, New Delhi'
);
INSERT INTO Customer
VALUES (
    104,
    'Asit K. Modi',
    '9876543453',
    '25-January-2002',
    'neela.pro@gmail.com',
    'Okhla Industrial Estate, Sector-2, New Delhi'
);
INSERT INTO Customer
VALUES (
    105,
    'Madhavi Bhide',
    '9356543210',
    '17-November-1996',
    NULL,
    'Shivaji Colony, Near Pune-Mumbai Highway, Pune'
);
----------------------------------
INSERT INTO Account
VALUES (
    101,
    '161428043456',
    4500000,
    1
);
INSERT INTO Account
VALUES (
    102,
    '196140786942',
    500000,
    1
);
INSERT INTO Account
VALUES (
    103,
    '385602831038',
    7000456,
    1
);
INSERT INTO Account
VALUES (
    104,
    '923492648263',
    7800000,
    1
);
INSERT INTO Account
VALUES (
    105,
    '274991347537',
    45,
    1
);
INSERT INTO Account
VALUES (
    103,
    '456484475845',
    35,
    1
);
----------------------------------

INSERT INTO Card
VALUES (
    '2616284315396913',
    '25-January-2025',
    '541', 
    '456484475845',
    'MASTERCARD'
);
INSERT INTO Card
VALUES (
    '32283274415362923',
    '06-April-2030',
    '948', 
    '161428043456',
    'VISA'
);
INSERT INTO Card
VALUES (
    '8685142622591322',
    '31-October-2034',
    '371', 
    '923492648263',
    'VISA'
);
----------------------------------

INSERT INTO Cheque_book
VALUES (
    1,
    43,
    '161428043456'
);
INSERT INTO Cheque_book
VALUES (
    4,
    24,
    '196140786942'
);
INSERT INTO Cheque_book
VALUES (
    2,
    3,
    '385602831038'
);
INSERT INTO Cheque_book
VALUES (
    22,
    15,
    '923492648263'
);
INSERT INTO Cheque_book
VALUES (
    7,
    10,
    '274991347537'
);
INSERT INTO Cheque_book
VALUES (
    5,
    10,
    '456484475845'
);
----------------------------------

INSERT INTO Loan_Description
VALUES (
    'Education Loan',
    2000000,
    5,
    1
);
INSERT INTO Loan_Description
VALUES (
    'Home Loan',
    90000000,
    30,
    2
);
INSERT INTO Loan_Description
VALUES (
    'Personal Loan',
    500000,
    2,
    3
);
----------------------------------

INSERT INTO Loan
VALUES (
    1002,
    '161428043456',
    20000,
    '21-November-2021',
    1,
    3
);
INSERT INTO Loan
VALUES (
    1003,
    '923492648263',
    1000000,
    '21-November-2021',
    1,
    2
);

---------------------------------------------
------------ INTERACTIVE QUERIES ------------
---------------------------------------------

-- 1| Suppose a user, Khushi decides to deactivate her second account after withdrawing the entire available funds. 
UPDATE Account
SET available_funds = 0
WHERE acc_num = '456484475845';
UPDATE Account
SET active = 0
WHERE acc_num = '456484475845';

-- 2| Suppose a bank wanted to contact their customers to request the ones with no email contacts to get the same added.
SELECT *
FROM Customer
WHERE email IS NULL;

-- 3| Suppose a user, Madhavi Bhide decides to link her email id to her bank account after the communication from the bank.
UPDATE Customer
SET email = 'achar.papad@gmail.com'
WHERE cust_id = 105;

-- 4| Suppose the bank then decides to find the number of customers using Gmail for their email services.
select COUNT(*) AS "Gmail users"
from Customer
WHERE email LIKE '%@gmail.com';

-- 5| Based on user demand, the bank decides to introduce a new type of loan called Start-up loan with a max cap of 75 lakhs and a settlement tenure of 15 years.
INSERT INTO Loan_Description
VALUES (
    'Startup Loan',
    7500000,
    15,
    4
);

-- 6| Now a user, Daya Gada, wants to take a Start-up Loan worth Rs. 50 lakhs from the bank on 21st November, 2021.
INSERT INTO Loan
VALUES (
    1001,
    '161428043456',
    5000000,
    '21-November-2021',
    1,
    4
);

-- 7| Daya decides to settle her personal loan with the money in her bank account.
DECLARE
    curr_fund Account.available_funds% TYPE;
    amt NUMBER:=20000;
    acc char(12):= '161428043456';
BEGIN
    select available_funds INTO curr_fund FROM Account WHERE acc_num = acc;
    IF amt > curr_fund THEN
        DBMS_output.put_line('Transaction failed: Insufficient Funds');
    ELSE
       UPDATE Account
       SET available_funds = available_funds - amt 
       WHERE (acc_num = acc); 
    END IF;
END;
/

-- 8| Thereafter, the bank updates the active status of Daya's personal loan to an inactive state. 
UPDATE Loan 
SET active = 0 
WHERE (loan_id = 1002);

-- 9| Daya then decides to verify if her loan was successfully deactivated.
SELECT * 
FROM Loan 
WHERE (acc_num = '161428043456');

-- 10| During the bank inspection, one of the inspectors wanted to see the non-confidential (account and contact) details of all the customers of the bank.
CREATE view Customer_Account AS
SELECT name,
    ph_no,
    acc_num,
    dob,
    email,
    address,
    available_funds,
    active as "Account activity"
FROM Account
    FULL OUTER JOIN Customer ON Account.cust_id = Customer.cust_id;

SELECT *
FROM Customer_Account;

-- 11| Later during the inspection, the inspector decides to crosscheck if the tally of currently active loans issued by the bank matches with the count of active loans in the bank database. 
SELECT n_of_loans AS "Tally of currently active loans" 
FROM Tally; 

SELECT COUNT(*) AS "Active loans in bank DB" 
FROM Loan 
WHERE active = 1;

-- 12| A customer, Madhavi Bhide, forgets that she has a very low balance in her only bank account and makes a transaction worth Rs. 4000. 
DECLARE
    curr_fund Account.available_funds% TYPE;
    amt NUMBER:=4000;
    acc char(12):= '274991347537';
BEGIN
    select available_funds INTO curr_fund FROM Account WHERE acc_num = acc;
    IF amt > curr_fund THEN
        DBMS_output.put_line('Transaction failed: Insufficient Funds');
    ELSE
       UPDATE Account
       SET available_funds = available_funds - amt 
       WHERE (acc_num = acc); 
    END IF;
END;
/
-------------------------------------