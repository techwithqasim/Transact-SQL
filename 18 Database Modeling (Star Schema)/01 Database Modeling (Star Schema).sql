DROP TABLE route_dim;
DROP TABLE week_dim;
DROP TABLE runs_fact;

-- Create a route dimension table
CREATE TABLE route_dim(
    route_id INTEGER PRIMARY KEY,
    park_name VARCHAR(160) NOT NULL,
    city_name VARCHAR(160) NOT NULL,
    distance_km FLOAT NOT NULL,
    route_name VARCHAR(160) NOT NULL
);

-- Create a week dimension table
CREATE TABLE week_dim(
    week_id INTEGER PRIMARY KEY,
    week INTEGER NOT NULL,
    month VARCHAR(160) NOT NULL,
    year INTEGER NOT NULL
);


-- Create a Route Runs Fact Table 
CREATE TABLE runs_fact(
	run_id INTEGER PRIMARY KEY,
	route_id INTEGER NOT NULL,
	week_id INTEGER NOT NULL,
	duration_mins FLOAT NOT NULL,
	FOREIGN KEY(route_id)
		REFERENCES route_dim(route_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(week_id)
		REFERENCES week_dim(week_id)
		ON DELETE CASCADE ON UPDATE CASCADE
	);

INSERT INTO route_dim (route_id, park_name, city_name, distance_km, route_name)
VALUES 
(1, 'Hilal Park', 'Karachi', 1.50, 'Faisal Road'),
(2, 'Central Park', 'Karachi', 3.2, 'Broadway Circuit'),
(3, 'Hyde Park', 'Karachi', 2.8, 'Lake Loop');

-- Insert data into week_dim
INSERT INTO week_dim (week_id, week, month, year)
VALUES 
(1, 1, 'September', 2024),
(2, 2, 'September', 2024),
(3, 3, 'September', 2024),
(4, 4, 'August', 2024);

-- Insert data into runs_fact
INSERT INTO runs_fact (run_id, route_id, week_id, duration_mins)
VALUES 
(1, 1, 1, 30.5),  -- 1st run on Hilal Park's Faisal Road, Week 1
(2, 2, 2, 45.0),  -- 2nd run on Central Park's Broadway Circuit, Week 2
(3, 3, 3, 40.0),  -- 3rd run on Hyde Park's Lake Loop, Week 3
(4, 1, 4, 35.0);  -- Another run on Hilal Park's Faisal Road, Week 4 (August)

SELECT * FROM route_dim;
SELECT * FROM week_dim;
SELECT * FROM runs_fact;

SELECT 
    -- Get the total duration of all runs
    SUM(duration_mins)  as Total_Duration
FROM 
    runs_fact
--Get all the week_id's that are from July, 2019
INNER JOIN week_dim ON runs_fact.week_id = week_dim.week_id
WHERE month = 'September' and year = '2024';