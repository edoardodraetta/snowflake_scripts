USE DATABASE erd_db;

-----------------
-- RESTAURANTS --
-----------------

CREATE OR REPLACE TABLE restaurants (
    r_restaurant_id INT AUTOINCREMENT
    , r_restaurant_name TEXT
    , r_address TEXT
    , r_city TEXT
    , r_state TEXT
    , r_zipcode INT
    , r_country TEXT 
    , r_open_date_id INT
    , r_close_date_id INT

    , PRIMARY KEY (r_restaurant_id)
);

-- Insert data into the 'restaurants' table
INSERT INTO restaurants (r_restaurant_name, r_address, r_city, r_state, r_zipcode, r_country, r_open_date_id, r_close_date_id)
VALUES
    ('Mike''s Frosty Fries', '123 Main St', 'Anytown', 'CA', 12345, 'USA', 1, NULL),
    ('Gerard''s Beefy Burgers', '24 Cambridge St', 'Milan', 'MI', 12322, 'ITA', 2, NULL);

SELECT * FROM restaurants;


CREATE OR REPLACE TABLE restaurant_daily_schedules (
    rds_restaurant_id INT
    , rds_meal_name TEXT
    , rds_open_time TIME
    , rds_close_time TIME

    , PRIMARY KEY (rds_restaurant_id, rds_meal_name)
);
-- Insert data into the 'restaurant_daily_schedules' table
INSERT INTO restaurant_daily_schedules (rds_restaurant_id, rds_meal_name, rds_open_time, rds_close_time)
VALUES
    (1, 'Breakfast', '07:00'::TIME, '10:00'::TIME),
    (1, 'Lunch', '12:00'::TIME, '14:00'::TIME),
    (1, 'Dinner', '18:00'::TIME, '21:00'::TIME),
    (2, 'Lunch', '18:00'::TIME, '21:00'::TIME),
    (2, 'Dinner', '18:00'::TIME, '21:00'::TIME);

SELECT * FROM restaurant_daily_schedules;

CREATE OR REPLACE TABLE restaurant_weekly_schedules (
    rws_restaurant_id INT
    , rws_day_of_week INT
    , rws_is_open BOOLEAN
    
    , PRIMARY KEY (rws_restaurant_id, rws_day_of_week)
);

-- Insert data into the 'restaurant_weekly_schedules' table
INSERT INTO restaurant_weekly_schedules (rws_restaurant_id, rws_day_of_week, rws_is_open)
VALUES
    (1, 1, FALSE), -- Monday
    (1, 2, TRUE), -- Tuesday
    (1, 3, TRUE), -- Wednesday
    (1, 4, TRUE), -- Thursday
    (1, 5, TRUE), -- Friday
    (1, 6, TRUE), -- Saturday
    (1, 7, TRUE), -- Sunday
    (2, 1, FALSE), -- Monday
    (2, 2, TRUE), -- Tuesday
    (2, 3, TRUE), -- Wednesday
    (2, 4, TRUE), -- Thursday
    (2, 5, TRUE), -- Friday
    (2, 6, TRUE), -- Saturday
    (2, 7, FALSE); -- Sunday
    
SELECT * FROM restaurant_weekly_schedules;


CREATE OR REPLACE TABLE restaurant_services (
    rse_restaurant_id INT
    , rse_mode_id INT 
    // drivethru, dinein, takeout, delivery, breakfast, lunch, dinner, (brunch...)
    , rse_is_provided BOOLEAN
    
    , PRIMARY KEY (rse_restaurant_id, rse_mode_id)
);

-- Insert data into the 'restaurant_services' table
INSERT INTO restaurant_services (rse_restaurant_id, rse_mode_id, rse_is_provided)
VALUES
    (1, 1, TRUE), -- Drive-thru
    (1, 2, TRUE), -- Dine-in
    (1, 3, TRUE), -- Takeout
    (1, 4, FALSE), -- Delivery
    (2, 1, FALSE), -- Drive-thru
    (2, 2, TRUE), -- Dine-in
    (2, 3, TRUE), -- Takeout
    (2, 4, TRUE); -- Delivery

SELECT * FROM restaurant_services;


CREATE OR REPLACE TABLE restaurant_modes (
    rmo_mode_id INT AUTOINCREMENT
    , rmo_mode_name TEXT 
    , PRIMARY KEY (rmo_mode_id )
);

-- Insert data into the 'restaurant_modes' table
INSERT INTO restaurant_modes (rmo_mode_name)
VALUES
     ('Drive-thru'),
     ('Dine-in'),
     ('Takeout'),
     ('Delivery');
     
SELECT * FROM restaurant_modes;

CREATE OR REPLACE TABLE restaurant_closures (
    rcl_restaurant_id INT
    , rcl_closing_date_id INT
    , rcl_reason TEXT
    
    , PRIMARY KEY (rcl_restaurant_id, rcl_closing_date_id)
);

CREATE OR REPLACE TABLE restaurant_staff (
    rst_restaurant_id INT
    , rst_employee_id INT
    , rst_shift_date_id INT
    , rst_position_id INT
    , rst_shift_start TIME
    , rst_shift_end TIME

    , PRIMARY KEY (rst_restaurant_id, rst_employee_id, rst_shift_date_id, rst_position_id)
); 

INSERT INTO restaurant_staff (rst_restaurant_id, rst_employee_id, rst_shift_date_id, rst_position_id, rst_shift_start, rst_shift_end)
VALUES
    (1, 1, 1, 1, '7:00'::TIME, '19:00'::TIME),
    (1, 2, 1, 2, '7:00'::TIME, '19:00'::TIME),
    (1, 3, 1, 3, '7:00'::TIME, '19:00'::TIME),
    (1, 3, 6, 3, '7:00'::TIME, '19:00'::TIME),
    (1, 4, 6, 3, '7:00'::TIME, '19:00'::TIME),
    (1, 4, 7, 2, '7:00'::TIME, '19:00'::TIME);

SELECT * FROM restaurant_staff



CREATE OR REPLACE DATABASE erd_db;
USE DATABASE erd_db;

----------
-- DATE --
----------

CREATE OR REPLACE TABLE date_dim (
    d_date_id INT AUTOINCREMENT
   , d_day INT
   , d_month INT
   , d_year INT
   , d_quarter INT
   , d_dow INT
   , d_dom INT
   , d_doy INT
   , d_qoy INT
   , d_holiday BOOLEAN
   , d_weekend BOOLEAN

   , PRIMARY KEY (d_date_id)
);

-- Insert data into the 'date_dim' table
INSERT INTO date_dim (d_day, d_month, d_year, d_quarter, d_dow, d_dom, d_doy, d_qoy, d_holiday, d_weekend)
VALUES
    (25, 9, 2023, 3, 2, 25, 268, 3, FALSE, FALSE),
    (26, 9, 2023, 3, 3, 26, 269, 3, FALSE, FALSE),
    (27, 9, 2023, 3, 4, 27, 270, 3, FALSE, FALSE),
    (28, 9, 2023, 3, 5, 28, 271, 3, FALSE, FALSE),
    (29, 9, 2023, 3, 6, 29, 272, 3, FALSE, FALSE),
    (30, 9, 2023, 3, 7, 30, 273, 3, FALSE, TRUE),
    (1, 10, 2023, 3, 2, 1, 268, 3, FALSE, TRUE);


SELECT * FROM date_dim;

USE DATABASE erd_db;
---------------
-- EMPLOYEES --
---------------

CREATE OR REPLACE TABLE employees (
    e_employee_id INT AUTOINCREMENT
    , e_first_name TEXT
    , e_last_name TEXT
    , e_email TEXT
    , e_phone INT
    , e_start_date_id INT
    , e_end_date_id INT

    , PRIMARY KEY (e_employee_id)
);

-- Insert data into the 'employees' table
INSERT INTO employees (e_first_name, e_last_name, e_email, e_phone, e_start_date_id, e_end_date_id)
VALUES
    ('John', 'Doe', 'john@example.com', 5551234567, 1, NULL),
    ('Gerard', 'Perello', 'gp@example.com', 5551234567, 1, NULL),
    ('Guillermo', 'Izquierdo', 'gi@example.com', 5551234567, 2, NULL),
    ('Luca', 'Balduzzi', 'lb@example.com', 5551234567, 2, NULL);

SELECT * FROM employees;


CREATE OR REPLACE TABLE positions (
    p_position_id INT AUTOINCREMENT
    , p_position_name TEXT
    , p_hourly_rate NUMBER

    , PRIMARY KEY (p_position_id)
);


-- Insert data into the 'positions' table
INSERT INTO positions (p_position_id, p_position_name, p_hourly_rate)
VALUES
    (1, 'Waiter', 15.0),
    (2, 'Chef', 20.0),
    (3, 'Manager', 30.0);
    
SELECT * FROM positions;


CREATE OR REPLACE TABLE employee_roles (
    er_employee_id INT
    , er_position_id INT
    , er_role_start_date_id INT
    , er_role_end_date_id INT

    , PRIMARY KEY (er_employee_id, er_position_id)
);

-- Insert data into the 'employee_roles' table
INSERT INTO employee_roles (er_employee_id, er_position_id, er_role_start_date_id, er_role_end_date_id)
VALUES
    (1, 1, 1, NULL),
    (1, 2, 1, NULL),
    (1, 3, 1, NULL),
    (2, 1, 1, NULL),
    (2, 2, 1, NULL), 
    (3, 1, 1, NULL),
    (3, 3, 1, NULL);

SELECT * FROM employee_roles;

USE DATABASE erd_db;
------------
-- ORDERS -- 
------------

CREATE OR REPLACE TABLE orders (
    o_restaurant_id INT
    , o_order_id INT AUTOINCREMENT
    , o_order_date_id INT
    , o_time TIME
    , o_total_price NUMBER(10,2)
    , o_order_discount NUMBER (4, 2)
    , o_dining_mode_id INT
    , o_payment_type TEXT

    , PRIMARY KEY (o_restaurant_id, o_order_id, o_order_date_id)
);

INSERT INTO orders (o_restaurant_id, o_order_id, o_order_date_id, o_time, o_total_price, o_order_discount, o_dining_mode_id, o_payment_type)
VALUES 
    (1, 1, 1, '8:00'::TIME, 15, 0.2, 1, 'Cash'),
    (1, 2, 1, '8:45'::TIME, 15, 0, 2, 'Credit Card'),
    (2, 3, 1, '8:00'::TIME, 20, 0, 3, 'Credit Card');

SELECT * FROM orders;


CREATE OR REPLACE TABLE order_details (
    od_order_id INT 
    , od_line_number INT
    , od_order_date_id INT
    , od_item_id INT
    , od_line_price NUMBER(10, 2)
    , od_item_discount NUMBER(10, 2)
    , od_item_quantity INT
    , od_combo_type_id INT
    , od_combo_line INT
    , od_combo_line_item INT
    
    , PRIMARY KEY (od_order_id, od_line_number, od_order_date_id)
);

INSERT INTO order_details (od_order_id, od_line_number, od_order_date_id, od_item_id, od_line_price, od_item_discount, od_item_quantity, od_combo_type_id, od_combo_line, od_combo_line_item)
VALUES 
    (1, 1, 1, 2, 15, 0, 1, NULL, NULL, NULL),
    (2, 1, 1, 1, 15, 0, 1, NULL, NULL, NULL),
    (3, 1, 1, 3, 20, 0, 1, NULL, NULL, NULL);

SELECT * FROM order_details;


CREATE OR REPLACE TABLE applied_toppings (
    at_order_id INT 
    , at_line_number INT
    , at_order_date_id INT
    , at_ingredient_id INT 
    , at_applied_topping_price NUMBER(10, 2)
    , at_applied_topping_quantity INT

    , PRIMARY KEY (at_order_id, at_line_number, at_order_date_id)
);

INSERT INTO applied_toppings (at_order_id, at_line_number, at_order_date_id, at_ingredient_id, at_applied_topping_price, at_applied_topping_quantity)
VALUES 
(1, 1, 1, 2, 1.1, 2),
(1, 1, 1, 1, 1.5, 1),
(2, 1, 1, 2, 1.6, 1),
(3, 1, 1, 1, 1.9, 1);

SELECT * FROM applied_toppings;


USE DATABASE erd_db;
----------
-- FOOD -- 
----------

CREATE OR REPLACE TABLE items (
    i_item_id INT AUTOINCREMENT
    , i_item_name TEXT
    , i_item_price NUMBER(10,2)
    , i_item_category TEXT
    
    , PRIMARY KEY (i_item_id)
);

INSERT INTO items (i_item_name, i_item_price, i_item_category)
VALUES
    ('Egg and Cheese Burger', 7.99, 'Breakfast Burgers'),
    ('Classic Hamburger', 8.99, 'Burgers'),
    ('BBQ Burger', 12.99, 'Specialty Burgers'),
    ('French Fries', 3.99, 'Sides'),
    ('Sweet Potato Fries', 4.99, 'Sides'),
    ('Pepsi', 2.99, 'Soft Drinks');

SELECT * FROM items;
    
CREATE OR REPLACE TABLE ingredients (
    ing_ingredient_id INT AUTOINCREMENT
    , ing_item_id INT
    , ing_ingredient_name TEXT
    , ing_ingredient_price NUMBER(10,2)
    , ing_is_topping BOOLEAN

    , PRIMARY KEY (ing_ingredient_id)
);

-- Insert data into the 'ingredients' table
INSERT INTO ingredients (ing_ingredient_name, ing_item_id, ing_ingredient_price, ing_is_topping)
VALUES
    ('Cheese', NULL, 1.50, TRUE),
    ('Bacon', NULL, 2.00, TRUE),
    ('Burger Patty', 2, 2.00, FALSE),
    ('Burger Bun', 2, 2.00, FALSE);


SELECT * FROM ingredients;


CREATE OR REPLACE TABLE dietary_restrictions (
    dr_ingredient_id INT
    , dr_restriction_name TEXT
    , dr_is_restriction BOOLEAN

    , PRIMARY KEY (dr_ingredient_id, dr_restriction_name)
);

INSERT INTO dietary_restrictions (dr_ingredient_id, dr_restriction_name, dr_is_restriction) 
VALUES 
    (1, 'VEGAN', FALSE),
    (2, 'VEGAN', FALSE),
    (3, 'VEGAN', FALSE),
    (4, 'VEGAN', TRUE),
    (1, 'DAIRY-FREE', FALSE),
    (2, 'DAIRY-FREE', TRUE),
    (3, 'DAIRY-FREE', TRUE),
    (4, 'DAIRY-FREE', TRUE);

SELECT * FROM dietary_restrictions;

CREATE OR REPLACE TABLE combos (
    c_combo_type_id INT AUTOINCREMENT
    , c_combo_name TEXT
    , c_combo_price NUMBER(10,2)

    , PRIMARY KEY (c_combo_type_id)
);

INSERT INTO combos (c_combo_name, c_combo_price)
VALUES
('Classic Combo', 12.99),
('Specialty Combo', 15.99);

SELECT * FROM combos;

USE database erd_db;


-- Give the owner examples of data they could retrieve from this information that they’ve currently have. 
-- (Small pieces of information that can have big impacts on the system and build on what’s already there)
-- What pieces of information are completely missing to really complete this database and system as a whole?


-- Revenue by month of year 2023
SELECT 
    SUM(o_total_price) AS monthly_revenue
    , d_month
FROM orders
INNER JOIN date_dim
    ON o_order_date_id = d_date_id
WHERE d_year = 2023
GROUP BY d_month
ORDER BY d_month;

-- Which food item is most popular?
SELECT
    COUNT(od_item_id) AS total_orders
    , i_item_name
FROM order_details
INNER JOIN items
    ON od_item_id = i_item_id
GROUP BY i_item_name
ORDER BY total_orders DESC;

-- Which food + topping is most popular?
SELECT
    SUM(at_applied_topping_quantity) AS times_ordered
    , i_item_name
    , ing_ingredient_name
FROM applied_toppings
INNER JOIN ingredients
    ON at_ingredient_id = ing_ingredient_id
INNER JOIN order_details
    ON at_order_id = od_order_id
    AND at_order_date_id = od_order_date_id
INNER JOIN items
    ON od_item_id = i_item_id
GROUP BY i_item_name, ing_ingredient_name
ORDER BY times_ordered DESC;

-- Which employee is working most weekends?
SELECT
    CONCAT(e_first_name, ' ', e_last_name) AS employee_name
    , SUM(d_weekend::INT) AS weekends_worked 
FROM employees
LEFT JOIN restaurant_staff
    ON e_employee_id = rst_employee_id
LEFT JOIN date_dim
    ON rst_shift_date_id = d_date_id
GROUP BY employee_name
ORDER BY weekends_worked DESC;

-- Which restaurant is making the most profit?
SELECT
    SUM(o_total_price) AS profit
    , r_restaurant_name
FROM orders
LEFT JOIN restaurants
    ON o_restaurant_id = r_restaurant_id
GROUP BY r_restaurant_name
ORDER BY profit DESC;

-- Which restaurant is making the most profit on weekends?
SELECT
    SUM(o_total_price) AS weekend_profit
    , r_restaurant_name
FROM orders
LEFT JOIN restaurants
    ON o_restaurant_id = r_restaurant_id
INNER JOIN date_dim
    ON o_order_date_id = d_date_id
WHERE d_weekend = TRUE
GROUP BY r_restaurant_name
ORDER BY weekend_profit DESC;