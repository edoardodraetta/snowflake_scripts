-- EASY
CREATE OR REPLACE TABLE Customers (
    CustomerID INT ,
    CustomerName VARCHAR,
    Age INT
);

INSERT INTO Customers (CustomerID, CustomerName, Age) VALUES
(1, 'John Doe', 25),
(2, 'Jane Smith', 30),
(3, 'Alice Johnson', 28);

-- List all customer names.
SELECT customername
FROM customers;

-- List all customers who are older than 27.
SELECT customername
FROM customers
WHERE age > 27;

-- List customer names in uppercase.
SELECT UPPER(customername)
FROM customers;

-- Update age of 'John Doe' to 26.
UPDATE customers SET AGE = 26
WHERE customername = 'John Doe';

SELECT customername, Age
FROM customers;

-- MEDIUM
CREATE OR REPLACE TABLE Orders (
    OrderID INT ,
    CustomerID INT,
    OrderDate DATE
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2023-01-15'),
(2, 2, '2023-05-20'),
(3, 3, '2023-08-05'),
(4, 1, '2023-09-01');


-- List all customers who have made more than one order.
SELECT 
    customers.customername
FROM customers
INNER JOIN orders 
    USING(customerid);
    
-- List customer names and order dates, sorted by date.
SELECT 
    customers.customername
    , orders.orderdate
FROM customers
LEFT JOIN orders 
    USING(customerid)
ORDER BY orders.orderdate;

-- List all distinct customers who made an order in 2023.
SELECT 
    DISTINCT customers.customername
FROM customers
LEFT JOIN orders 
    USING(customerid)
WHERE YEAR(orders.orderdate::TIMESTAMP) = 2023;

-- Update 'Jane Smith' CustomerID to 4 where OrderID is 2.
UPDATE orders SET customerid = 4
WHERE orders.orderid = 2;

SELECT * FROM orders;

-- HARD
CREATE OR REPLACE TABLE Products (
    ProductID INT,
    ProductName VARCHAR,
    Price DECIMAL(10,2)
);

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Phone', 800.00),
(3, 'Tablet', 500.00);

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(4, 'Sword', 1200.00);

CREATE OR REPLACE TABLE OrderDetails (
    OrderDetailID INT,
    OrderID INT,
    ProductID INT,
    Quantity INT
);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 3, 1),
(4, 3, 2, 1);

-- List total amount spent by each customer.
SELECT
    customers.customername
    , SUM(products.price * orderdetails.quantity) AS total
FROM customers
INNER JOIN orders
    USING(customerid)
INNER JOIN orderdetails
    USING(orderid)
INNER JOIN products
    USING(productid)
GROUP BY customers.customername;

-- List all products which haven't been ordered.
SELECT
    products.productname
    , IFNULL(SUM(orderdetails.Quantity), 0) AS total_ordered
FROM products
LEFT JOIN orderdetails
    USING(productid)
GROUP BY products.productname
HAVING total_ordered = 0;

