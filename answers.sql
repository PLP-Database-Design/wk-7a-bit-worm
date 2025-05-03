-- Question 1

-- spliting up the table
CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);


CREATE TABLE products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(100),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID)
);



INSERT INTO orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM ProductDetail;




WITH RECURSIVE split_products AS (
  SELECT 
    OrderID,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS remaining
  FROM ProductDetail

  UNION ALL

  SELECT 
    OrderID,
    TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS Product,
    SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)
  FROM split_products
  WHERE remaining <> ''
)

INSERT INTO products (OrderID, Product)
SELECT 
    OrderID,
    Product
FROM 
    split_products;




SELECT 
    orders.OrderID,
    orders.CustomerName,
    products.Product
FROM 
    orders
JOIN 
    products ON orders.OrderID = products.OrderID;





-- Question 2

-- we split the table to remove the partial dependecy by creating a new table for customers
CREATE TABLE customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);


-- a new table for products
CREATE TABLE products (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES customers(OrderID)
);



-- we insert data into the tables
INSERT INTO customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;


INSERT INTO products (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;



-- now we join the tables


SELECT 
    customers.OrderID,
    customers.CustomerName,
    products.Product,
    products.Quantity
FROM 
    customers
JOIN 
    products ON customers.OrderID = products.OrderID;
