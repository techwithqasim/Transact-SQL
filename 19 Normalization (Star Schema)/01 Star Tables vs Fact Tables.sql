-- Step 1: Initial Star Schema Design
---------------------------------------------------------------------

-- Creating the dim_author_sf table
CREATE TABLE dim_author_sf (
    author_id INT PRIMARY KEY,
    author VARCHAR(256)
);

-- Creating the dim_publisher_sf table
CREATE TABLE dim_publisher_sf (
    publisher_id INT PRIMARY KEY,
    publisher VARCHAR(256)
);

-- Creating the dim_genre_sf table
CREATE TABLE dim_genre_sf (
    genre_id INT PRIMARY KEY,
    genre VARCHAR(128)
);

-- Creating the dim_book_sf table
CREATE TABLE dim_book_sf (
    book_id INT PRIMARY KEY,
    title VARCHAR(256),
    author_id INT,
    publisher_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES dim_author_sf(author_id),
    FOREIGN KEY (publisher_id) REFERENCES dim_publisher_sf(publisher_id),
    FOREIGN KEY (genre_id) REFERENCES dim_genre_sf(genre_id)
);


-- Inserting sample data into dim_author_sf
INSERT INTO dim_author_sf (author_id, author)
VALUES
(1, 'J.K. Rowling'),
(2, 'George R.R. Martin'),
(3, 'J.R.R. Tolkien');

-- Inserting sample data into dim_publisher_sf
INSERT INTO dim_publisher_sf (publisher_id, publisher)
VALUES
(1, 'Bloomsbury'),
(2, 'Bantam Books'),
(3, 'HarperCollins');

-- Inserting sample data into dim_genre_sf
INSERT INTO dim_genre_sf (genre_id, genre)
VALUES
(1, 'Fantasy'),
(2, 'Science Fiction'),
(3, 'Historical Fiction');

-- Inserting sample data into dim_book_sf
INSERT INTO dim_book_sf (book_id, title, author_id, publisher_id, genre_id)
VALUES
(1, 'Harry Potter and the Philosophers Stone', 1, 1, 1),
(2, 'A Game of Thrones', 2, 2, 1),
(3, 'The Hobbit', 3, 3, 1);


select * from dim_author_sf;
select * from dim_publisher_sf;
select * from dim_genre_sf;
select * from dim_book_sf;


-- Example Query: Join books with authors and publishers
SELECT b.title, a.author, p.publisher, g.genre
FROM dim_book_sf b
JOIN dim_author_sf a ON b.author_id = a.author_id
JOIN dim_publisher_sf p ON b.publisher_id = p.publisher_id
JOIN dim_genre_sf g ON b.genre_id = g.genre_id;



-- Step 2: Adding Store and Time Dimensions
---------------------------------------------------------------------

-- Create dim_store_star table
CREATE TABLE dim_store_star (
    store_id INT PRIMARY KEY,
    store_address VARCHAR(256),
    city VARCHAR(128),
    state VARCHAR(128),
    country VARCHAR(128)
);

-- Create dim_time_star table
CREATE TABLE dim_time_star (
    time_id INT PRIMARY KEY,
    day INT,
    month INT,
    quarter INT,
    year INT
);

-- Create fact_booksales table
CREATE TABLE fact_booksales (
    sales_id INT PRIMARY KEY,
    book_id INT,
    time_id INT,
    store_id INT,
    sales_amount FLOAT,
    quantity INT,
    FOREIGN KEY (book_id) REFERENCES dim_book_sf(book_id),
    FOREIGN KEY (time_id) REFERENCES dim_time_star(time_id),
    FOREIGN KEY (store_id) REFERENCES dim_store_star(store_id)
);


-- Insert values into dim_store_star
INSERT INTO dim_store_star (store_id, store_address, city, state, country) VALUES
(1, '123 Main St', 'New York', 'NY', 'USA'),
(2, '456 Broadway', 'Los Angeles', 'CA', 'USA'),
(3, '789 Market St', 'San Francisco', 'CA', 'USA');

-- Insert values into dim_time_star
INSERT INTO dim_time_star (time_id, day, month, quarter, year) VALUES
(1, 1, 1, 1, 2023),
(2, 15, 3, 1, 2023),
(3, 30, 6, 2, 2023);

-- Insert values into fact_booksales
INSERT INTO fact_booksales (sales_id, book_id, time_id, store_id, sales_amount, quantity) VALUES
(1, 1, 1, 1, 29.99, 3),
(2, 2, 2, 2, 19.99, 2),
(3, 3, 3, 3, 14.99, 1);


select * from dim_store_star;
select * from dim_time_star;
select * from fact_booksales;


-- Step 3: Normalizing the Store Dimension
---------------------------------------------------------------------
-- Star Store Table Change to Relation Table

-- First Drop These Table to avoid conflict

drop table dim_store_star;
drop table fact_booksales;

-- Create dim_country_sf table
CREATE TABLE dim_country_sf (
    country_id INT PRIMARY KEY,
    country VARCHAR(128) NOT NULL
);

-- Create dim_state_sf table
CREATE TABLE dim_state_sf (
    state_id INT PRIMARY KEY,
    state VARCHAR(128) NOT NULL,
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES dim_country_sf(country_id)
);

-- Create dim_city_sf table
CREATE TABLE dim_city_sf (
    city_id INT PRIMARY KEY,
    city VARCHAR(128) NOT NULL,
    state_id INT,
    FOREIGN KEY (state_id) REFERENCES dim_state_sf(state_id)
);

-- Create dim_store_sf table
CREATE TABLE dim_store_sf (
    store_id INT PRIMARY KEY,
    store_address VARCHAR(256) NOT NULL,
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES dim_city_sf(city_id)
);


-- Create fact_booksales table
CREATE TABLE fact_booksales (
    sales_id INT PRIMARY KEY,
    book_id INT,
    time_id INT,
    store_id INT,
    sales_amount FLOAT,
    quantity INT,
    FOREIGN KEY (book_id) REFERENCES dim_book_sf(book_id),
    FOREIGN KEY (time_id) REFERENCES dim_time_star(time_id),
    FOREIGN KEY (store_id) REFERENCES dim_store_sf(store_id)
);



-- Insert values into dim_country_sf
INSERT INTO dim_country_sf (country_id, country) VALUES
(1, 'USA'),
(2, 'Canada');

-- Insert values into dim_state_sf
INSERT INTO dim_state_sf (state_id, state, country_id) VALUES
(1, 'New York', 1),
(2, 'California', 1),
(3, 'Ontario', 2);

-- Insert values into dim_city_sf
INSERT INTO dim_city_sf (city_id, city, state_id) VALUES
(1, 'New York City', 1),
(2, 'Los Angeles', 2),
(3, 'Toronto', 3);

-- Insert values into dim_store_sf
INSERT INTO dim_store_sf (store_id, store_address, city_id) VALUES
(1, '123 Main St', 1),
(2, '456 Broadway', 2),
(3, '789 King St', 3);

-- Insert values into fact_booksales
INSERT INTO fact_booksales (sales_id, book_id, time_id, store_id, sales_amount, quantity) VALUES
(1, 1, 1, 1, 29.99, 3),
(2, 2, 2, 2, 19.99, 2),
(3, 3, 3, 3, 14.99, 1);


-- Step 4: Normalizing the Time Dimension
---------------------------------------------------------------------
-- Star Time Table Change to Relation Table

-- First Drop These Table to avoid conflict

drop table dim_time_star;
drop table fact_booksales;

CREATE TABLE dim_year_sf (
  year_id INT PRIMARY KEY,
  year INT
);

INSERT INTO dim_year_sf (year_id, year) VALUES
  (1, 2023);

CREATE TABLE dim_quarter_sf (
  quarter_id INT PRIMARY KEY,
  quarter INT,
  year_id INT,
  FOREIGN KEY (year_id) REFERENCES dim_year_sf(year_id)
);

INSERT INTO dim_quarter_sf (quarter_id, quarter, year_id) VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 1);

CREATE TABLE dim_month_sf (
  month_id INT PRIMARY KEY,
  month INT,
  quarter_id INT,
  FOREIGN KEY (quarter_id) REFERENCES dim_quarter_sf(quarter_id)
);

INSERT INTO dim_month_sf (month_id, month, quarter_id) VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 1),
  (5, 5, 1),
  (6, 6, 1),
  (7, 7, 2),
  (8, 8, 2),
  (9, 9, 2),
  (10, 10, 2),
  (11, 11, 3),
  (12, 12, 3);

CREATE TABLE dim_time_sf (
  time_id INT PRIMARY KEY,
  day INT,
  month_id INT,
  FOREIGN KEY (month_id) REFERENCES dim_month_sf(month_id)
);

INSERT INTO dim_time_sf (time_id, day, month_id) VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 1),
  (5, 5, 1),
  (6, 6, 1),
  (7, 7, 1),
  (8, 8, 1),
  (9, 9, 1),
  (10, 10, 1),
  (11, 11, 1),
  (12, 12, 1),
  (13, 13, 1),
  (14, 14, 1),
  (15, 15, 1),
  (16, 16, 1),
  (17, 17, 1),
  (18, 18, 1),
  (19, 19, 1),
  (20, 20, 1),
  (21, 21, 1),
  (22, 22, 1),
  (23, 23, 1),
  (24, 24, 1),
  (25, 25, 1),
  (26, 26, 1),
  (27, 27, 1),
  (28, 28, 1),
  (29, 29, 1),
  (30, 30, 1),
  (31, 31, 1);


CREATE TABLE fact_booksales (
  sales_id INT PRIMARY KEY,
  book_id INT,
  time_id INT,
  store_id INT,
  sales_amount FLOAT,
  quantity INT,
  FOREIGN KEY (book_id) REFERENCES dim_book_sf(book_id),
  FOREIGN KEY (time_id) REFERENCES dim_time_sf(time_id),
  FOREIGN KEY (store_id) REFERENCES dim_store_sf(store_id)
);

INSERT INTO fact_booksales (sales_id, book_id, time_id, store_id, sales_amount, quantity) VALUES
  (1, 1, 1, 1, 100.00, 2),
  (2, 2, 2, 2, 50.00, 1),
  (3, 3, 3, 3, 75.00, 3),
  (4, 4, 4, 4, 25.00, 1),
  (5, 5, 5, 5, 125.00, 5),
  (6, 6, 6, 6, 150.00, 2),
  (7, 7, 7, 7, 100.00, 4),
  (8, 8, 8, 8, 200.00, 2);
  