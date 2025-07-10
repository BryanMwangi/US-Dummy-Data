-- 
-- This is a demo query to show how to join tables in MySQL
--

SELECT c.ID, c.FIRST_NAME, c.LAST_NAME, ci.CITY, s.STATE_NAME
FROM US_CITIZENS c
JOIN US_CITIES ci ON c.ID_CITY = ci.ID
JOIN US_STATES s ON ci.ID_STATE = s.ID
LIMIT 20;

-- 
-- Aggregation demo. Average income per state
--

SELECT s.STATE_NAME, AVG(c.INCOME) AS avg_income
FROM US_CITIZENS c
JOIN US_STATES s ON c.ID_STATE = s.ID
GROUP BY s.STATE_NAME
ORDER BY avg_income DESC;

-- 
-- Find the highest income citizen per state
-- 

SELECT s.STATE_NAME, c.FIRST_NAME, c.LAST_NAME, MAX(c.INCOME) AS max_income
FROM US_CITIZENS c
LEFT JOIN US_STATES s ON c.ID_STATE = s.ID
GROUP BY s.STATE_NAME, c.FIRST_NAME, c.LAST_NAME
ORDER BY max_income DESC;



-- 
-- Find the oldest citizen per state
--

SELECT s.STATE_NAME, c.FIRST_NAME, c.LAST_NAME, MIN(c.BIRTHDATE) AS min_birthdate
FROM US_CITIZENS c
LEFT JOIN US_STATES s ON c.ID_STATE = s.ID
GROUP BY s.STATE_NAME, c.FIRST_NAME, c.LAST_NAME
ORDER BY min_birthdate ASC;

-- 
-- Find the oldest citizen per city and state
-- using a window function
-- 

SELECT CITY, STATE_NAME, FIRST_NAME, LAST_NAME, BIRTHDATE
FROM (
    SELECT ct.CITY, s.STATE_NAME, c.FIRST_NAME, c.LAST_NAME, c.BIRTHDATE,
    ROW_NUMBER() OVER (
        PARTITION BY ct.ID
        ORDER BY c.BIRTHDATE ASC
    ) AS row_num
    FROM US_CITIZENS c
    JOIN US_CITIES ct ON c.ID_CITY = ct.ID
    JOIN US_STATES s ON ct.ID_STATE = s.ID
) ranked
WHERE row_num = 1
ORDER BY BIRTHDATE ASC;

-- 
-- Alternative method to find the oldest citizen per city and state
-- using a correlated subquery
-- 
SELECT ct.CITY, s.STATE_NAME, c.FIRST_NAME, c.LAST_NAME, c.BIRTHDATE
FROM US_CITIZENS c
JOIN US_CITIES ct ON c.ID_CITY = ct.ID
JOIN US_STATES s ON ct.ID_STATE = s.ID
WHERE c.BIRTHDATE = (
    SELECT MIN(c.BIRTHDATE)
    FROM US_CITIZENS c2
    WHERE c2.ID_CITY = c.ID_CITY
    LIMIT 1
)
ORDER BY c.BIRTHDATE ASC;

-- 
-- Practice of different join types on states and cities only
--

-- a) inner join
SELECT s.STATE_NAME, ct.CITY
FROM US_STATES s
INNER JOIN US_CITIES ct ON s.ID = ct.ID_STATE
GROUP BY s.STATE_NAME, ct.CITY
LIMIT 10;

-- b) left join
SELECT s.STATE_NAME, ct.CITY
FROM US_STATES s
LEFT JOIN US_CITIES ct ON s.ID = ct.ID_STATE
GROUP BY s.STATE_NAME, ct.CITY
LIMIT 10;

-- c) right join
SELECT s.STATE_NAME, ct.CITY
FROM US_STATES s
RIGHT JOIN US_CITIES ct ON s.ID = ct.ID_STATE
GROUP BY s.STATE_NAME, ct.CITY
LIMIT 10;

-- d) full outer join in mysql
-- 
-- full outer join is not supported in mysql
--

-- e) union
SELECT s.STATE_NAME, ct.CITY
FROM US_STATES s
LEFT JOIN US_CITIES ct ON s.ID = ct.ID_STATE

UNION

SELECT s.STATE_NAME, ct.CITY
FROM US_STATES s
RIGHT JOIN US_CITIES ct ON s.ID = ct.ID_STATE
LIMIT 10;

-- 
-- Optimization techniques to improve query performance
-- 

-- a) creating and index for columns frequently used in the query
CREATE INDEX idx_us_citizens_id_city ON US_CITIZENS(ID_CITY);
CREATE INDEX idx_us_cities_id_state ON US_CITIES(ID_STATE);

-- b) creating a composite index for columns frequently used in the query
CREATE INDEX idx_us_citizens_city_state ON US_CITIZENS(ID_CITY, ID_STATE);
CREATE INDEX idx_us_citizens_id_city_birthdate ON US_CITIZENS(ID_CITY, BIRTHDATE);


-- 
-- Stored Procedures
--

-- 
-- Create a stored procedure to return citizens by state
-- 

CREATE PROCEDURE US_CITIZENS_BY_STATE(IN p_state_code CHAR(2))
BEGIN
	SELECT c.*
    FROM US_CITIZENS c
    JOIN US_STATES s ON c.ID_STATE = s.ID
    WHERE s.STATE_CODE = p_state_code;
END;

-- 
-- Create a stored procedure to return citizens by state and SSN
--
CREATE PROCEDURE US_CITIZENS_SSN_BY_STATE(IN p_state_code CHAR(2))
BEGIN
	SELECT c.ID, c.FIRST_NAME, c.LAST_NAME, c.SSN
    FROM US_CITIZENS c
    JOIN US_STATES s ON c.ID_STATE = s.ID
    WHERE s.STATE_CODE = p_state_code
    GROUP BY c.ID, c.FIRST_NAME, c.LAST_NAME, c.SSN
    ORDER BY c.ID ASC;
END;

-- 
-- Create a procedure to calculate total income by state
--

CREATE PROCEDURE US_CITIZENS_TOTAL_INCOME_BY_STATE(IN p_state_code CHAR(2))
BEGIN
	SELECT s.STATE_NAME, SUM(c.INCOME) AS total_income
    FROM US_CITIZENS c
    JOIN US_STATES s ON c.ID_STATE = s.ID
    WHERE s.STATE_CODE = p_state_code
    GROUP BY s.STATE_NAME
    ORDER BY total_income DESC;
END;

-- 
-- Create a procedure to calculate average income by state
--

CREATE PROCEDURE US_CITIZENS_AVERAGE_INCOME_BY_STATE(IN p_state_code CHAR(2))
BEGIN
	SELECT s.STATE_NAME, AVG(c.INCOME) AS avg_income
    FROM US_CITIZENS c
    JOIN US_STATES s ON c.ID_STATE = s.ID
    WHERE s.STATE_CODE = p_state_code
    GROUP BY s.STATE_NAME
    ORDER BY avg_income DESC;
END;

-- 
-- Calling stored procedures
--

CALL US_CITIZENS_BY_STATE('CA');

CALL US_CITIZENS_SSN_BY_STATE('CA');

CALL US_CITIZENS_TOTAL_INCOME_BY_STATE('CA');

CALL US_CITIZENS_AVERAGE_INCOME_BY_STATE('CA');

-- 
-- Verifying stored procedures
--

SHOW PROCEDURE STATUS LIKE 'US_CITIZENS_BY_STATE';

-- 
-- Delete procedure
-- 

DROP PROCEDURE IF EXISTS US_CITIZENS_BY_STATE;

-- 
-- Using SQL functions
--

CREATE FUNCTION US_CITIZENS_TOTAL_BY_STATE(p_state_code CHAR(2))
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE v_total_citizens BIGINT;
    SELECT COUNT(*) INTO v_total_citizens
    FROM US_CITIZENS c
    JOIN US_STATES s ON c.ID_STATE = s.ID
    WHERE s.STATE_CODE = p_state_code;
    RETURN v_total_citizens;
END;

-- 
-- Calling SQL functions
-- 

SELECT US_CITIZENS_TOTAL_BY_STATE('CA');

-- 
-- Verify functions
-- 

SHOW FUNCTION STATUS WHERE Db = 'US_DUMMY_DATA';

-- 
-- Using triggers in mySQL
-- 

CREATE TRIGGER US_CITIZENS_INSERT_TRIGGER
AFTER INSERT ON US_CITIZENS
FOR EACH ROW
BEGIN
    INSERT INTO US_CITIZENS_TOTALS (ID_STATE, TOTAL_CITIZENS)
    VALUES (NEW.ID_STATE, US_CITIZENS_TOTAL_BY_STATE(NEW.ID_STATE));
END;

-- 
-- Veifying triggers
--

SHOW TRIGGERS;

