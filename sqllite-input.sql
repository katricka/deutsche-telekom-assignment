-- tables preparation which should be done before interview
-- Assignment in SQLLite. Recommended to go to https://sqliteonline.com/ and past following commands

CREATE TABLE customers
(
    customer_id    int,
    last_name      varchar(50),
    first_name     varchar(50),
    referred_by_id varchar(50)
);

INSERT INTO customers (customer_id, first_name, last_name, referred_by_id)
VALUES (1, ''John'', ''White'', ''''),
       (2, ''Sarah'', ''Green'', ''''),
       (3, ''George'', ''Black'', ''''),
       (4, ''Mark'', ''Koon'', ''''),
       (5, ''Tom'', ''Gone'', ''''),
       (6, ''Ezra'', ''Beck'', ''''),
       (7, ''Jan'', ''Wick'', 2),
       (8, ''Petr'', ''Lame'', ''''),
       (9, ''Lucy'', ''Can'', ''''),
       (10, ''Karl'', ''Opel'', 1),
       (11, ''Ron'', ''Varon'', 10),
       (12, ''Harry'', ''Bond'', ''''),
       (13, ''Paul'', ''Kong'', ''''),
       (14, ''Shaun'', ''King'', 3),
       (15, ''Elisabeth'', ''Yellow'', '''');

CREATE TABLE contacts
(
    customer_id  int,
    address      varchar(255),
    city         varchar(255),
    phone_number varchar(20),
    email        VARCHAR(255)
);


INSERT INTO contacts (customer_id, address, city, phone_number, email)
VALUES (1, ''3525  Fort Street'', ''COLUMBUS'', ''2532326578'', ''JW@email.com''),
       (2, ''3924  Cooks Mine Road'', ''Albuquerque'', ''5057657670'', ''SarahG@email.com''),
       (3, ''925  College Street'', ''Atlanta'', ''4043278560'', ''Georgie@email.com'');

CREATE TABLE orders
(
    customer_id    int,
    order_id       INT,
    item           varchar(50),
    order_value    DECIMAL(12, 2),
    order_currency varchar(3),
    order_date     TIMESTAMP
);

INSERT INTO orders (customer_id, order_id, item, order_value, order_currency, order_date)
VALUES (1, 1, ''HDMI cable'', 3.25, ''EUR'', ''2020-01-21 14:50:04''),
       (2, 2, ''Keyboard'', ''15.99'', ''EUR'', ''2020-01-21 17:50:04''),
       (3, 3, ''Charger'', ''9.99'', ''EUR'', ''2020-01-22 18:00:07''),
       (3, 3, ''Charger'', ''9.99'', ''EUR'', ''2020-01-22 18:00:07''),
       (3, 4, ''Phone'', ''225.89'', ''EUR'', ''2020-01-22 19:10:56''),
       (2, 5, ''Camera'', ''199.99'', ''EUR'', ''2020-01-23 07:50:44''),
       (1, 6, ''Speakers'', ''75.50'', ''EUR'', ''2020-01-23 08:40:00''),
       (1, 6, ''Speakers'', ''75.50'', ''EUR'', ''2020-01-23 08:40:00''),
       (2, 7, ''Mouse'', ''22.19'', ''EUR'', ''2020-01-23 09:20:59'');



--TASK 1--
--Write query which will show our customers with contacts and orders (all columns)
SELECT *
FROM customers
         LEFT JOIN contacts ON customers.customer_id = contacts.customer_id
         LEFT JOIN orders ON customers.customer_id = orders.customer_id;


--TASK 2--
-- There is  suspision that some orders were wrongly inserted more times. Check if there are any duplicated orders.
-- If so, return unique duplicates with the following details:
-- first name, last name, email, order id and item
SELECT DISTINCT customers.first_name,
                customers.last_name,
                contacts.email,
                orders.order_id
FROM customers
         INNERJOIN contacts ON customers.customer_id = contacts.customer_id
         INNER JOIN orders ON customers.customer_id = orders.customer_id
         INNER JOIN (
    SELECT order_id, count(*)
    FROM orders
    GROUP by order_id
    HAVING COUNT(*) > 1
) dupl ON orders.order_id = dupl.order_id;

--TASK 3-
-- As you found out, there are some duplicated order which are incorrect, adjust query so it does following:
-- Show first name, last name, email, order id and item
-- Does not show duplicates
-- Order result by customer last name
SELECT DISTINCT customers.first_name,
                customers.last_name,
                contacts.email,
                orders.order_id,
                orders.item
FROM customers
         LEFT JOIN contacts ON customers.customer_id = contacts.customer_id
         INNER JOIN orders ON customers.customer_id = orders.customer_id
ORDER BY customers.last_name;

--TASK 4--
--Our company distinguishes orders to sizes by value like so:
--order with value less or equal to 25 euro is marked as SMALL
--order with value more than 25 euro but less or equal to 100 euro is marked as MEDIUM
--order with value more than 100 euro is marked as BIG
--Write query which shows only three columns: full_name (first and last name divided by space), order_id and order_size
--Make sure the duplicated values are not shown
--Sort by order ID (ascending)
SELECT DISTINCT customers.first_name || '' '' || customers.last_name AS full_name,
                orders.order_id,
                CASE
                    WHEN orders.order_value <= 25 THEN "SMALL"
                    when orders.order_value > 25 AND orders.order_value <= 100 THEN "MEDIUM"
                    ELSE "BIG" END                                   AS order_size
FROM customers
         INNER JOIN orders ON customers.customer_id = orders.customer_id
ORDER BY orders.order_id DESC;

--TASK 5--
-- Show all items from orders table which containt in their name ''ea'' or start with ''Key''
SELECT DISTINCT *
FROM orders
WHERE item LIKE '%ea%'
   OR item LIKE 'Key%';


--TASK 6--
-- Please find out if some customer was referred by already existing customer
-- Return results in following format "Customer Last name Customer First name" "Last name First name of customer who recomended the new customer"
-- Sort/Order by customer last name (ascending)

SELECT c1.customer_id,
       c1.last_name || ' ' || c1.first_name as customer_name,
       c2.last_name || ' ' || c2.first_name as refferal_name,
       c1.referred_by_id
FROM customers c1
         INNER JOIN customers c2 ON c1.referred_by_id = c2.customer_id
WHERE c1.referred_by_id IN (SELECT customer_id FROM customers)
ORDER BY c1.last_name;