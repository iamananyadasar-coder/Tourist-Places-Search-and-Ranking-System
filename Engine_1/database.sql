-- Tourist Place Search and Ranking System
-- Engine 1: Database Management

CREATE DATABASE IF NOT EXISTS tourist_place_db;

USE tourist_place_db;

-- Create categories table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Create tourist places table
CREATE TABLE tourist_places (
    place_id INT AUTO_INCREMENT PRIMARY KEY,
    place_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    estimated_budget DECIMAL(10,2),
    rating DECIMAL(3,2),
    recommended_duration INT,
    state VARCHAR(50) DEFAULT 'Karnataka',
    category_id INT,

    CONSTRAINT fk_tourist_category
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id),

    CONSTRAINT chk_budget CHECK (estimated_budget >= 0),
    CONSTRAINT chk_duration CHECK (recommended_duration > 0),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 0 AND 5)
);
-- Insert tourist place categories

INSERT INTO categories (category_name) VALUES
('Historical'),
('Hill Station'),
('Beach'),
('Garden'),
('Park'),
('Waterfall'),
('Temple'),
('Wildlife'),
('Adventure');
-- Insert tourist place details

INSERT INTO tourist_places
(place_name, location, estimated_budget, rating, recommended_duration, state, category_id)
VALUES
('Mysore Palace', 'Mysuru', 100, 4.9, 2, 'Karnataka', 1),
('Coorg', 'Kodagu', 1500, 4.7, 24, 'Karnataka', 2),
('Hampi', 'Vijayanagara', 800, 4.6, 5, 'Karnataka', 1),
('Gokarna Beach', 'Gokarna', 500, 4.5, 4, 'Karnataka', 3),
('Nandi Hills', 'Chikkaballapur', 300, 4.4, 3, 'Karnataka', 2),
('Lalbagh Botanical Garden', 'Bengaluru', 50, 4.5, 2, 'Karnataka', 4),
('Cubbon Park', 'Bengaluru', 0, 4.4, 2, 'Karnataka', 5),
('Jog Falls', 'Shivamogga', 100, 4.7, 3, 'Karnataka', 6),
('Murudeshwar Temple', 'Uttara Kannada', 200, 4.6, 3, 'Karnataka', 7),
('Udupi Sri Krishna Temple', 'Udupi', 100, 4.7, 2, 'Karnataka', 7),
('Chikmagalur', 'Chikkamagaluru', 1200, 4.6, 24, 'Karnataka', 2),
('Bandipur National Park', 'Chamarajanagar', 800, 4.5, 5, 'Karnataka', 8),
('Dandeli', 'Uttara Kannada', 1500, 4.4, 8, 'Karnataka', 9),
('Belur Chennakeshava Temple', 'Hassan', 100, 4.6, 2, 'Karnataka', 1),
('Halebidu Hoysaleswara Temple', 'Hassan', 100, 4.5, 2, 'Karnataka', 1),
('Badami Cave Temples', 'Bagalkot', 150, 4.6, 3, 'Karnataka', 1),
('Pattadakal', 'Bagalkot', 100, 4.5, 2, 'Karnataka', 1),
('Aihole', 'Bagalkot', 100, 4.4, 2, 'Karnataka', 1),
('Shravanabelagola', 'Hassan', 50, 4.5, 2, 'Karnataka', 7),
('Kabini', 'Mysuru', 2000, 4.6, 24, 'Karnataka', 8);
-- Search tourist places by location

SELECT *
FROM tourist_places
WHERE location = 'Hassan';

-- Search tourist places by budget

SELECT *
FROM tourist_places
WHERE estimated_budget <= 500;

-- Display places by highest rating

SELECT *
FROM tourist_places
ORDER BY rating DESC;
-- Search tourist places by location

SELECT *
FROM tourist_places
WHERE location = 'Hassan';

-- Search tourist places by budget

SELECT *
FROM tourist_places
WHERE estimated_budget <= 500;

-- Display places by highest rating

SELECT *
FROM tourist_places
ORDER BY rating DESC;
-- Display tourist places with category names

SELECT
    tp.place_id,
    tp.place_name,
    tp.location,
    c.category_name,
    tp.estimated_budget,
    tp.rating
FROM tourist_places tp
JOIN categories c
ON tp.category_id = c.category_id;
-- Delete a temporary test record

DELETE FROM tourist_places
WHERE place_name = 'Test Place';
-- Add a new column to store place descriptions

ALTER TABLE tourist_places
ADD COLUMN description VARCHAR(255);
-- Create indexes to improve search performance

CREATE INDEX idx_place_location
ON tourist_places(location);

CREATE INDEX idx_place_rating
ON tourist_places(rating);

-- Create a view for highly rated tourist places

CREATE OR REPLACE VIEW ranked_tourist_places AS
SELECT
    tp.place_id,
    tp.place_name,
    tp.location,
    c.category_name,
    tp.estimated_budget,
    tp.rating
FROM tourist_places tp
JOIN categories c
ON tp.category_id = c.category_id
WHERE tp.rating >= 4.5
ORDER BY tp.rating DESC;

-- Stored procedure to search places by category

DELIMITER //

CREATE PROCEDURE SearchPlacesByCategory(IN cat_name VARCHAR(50))
BEGIN
    SELECT
        tp.place_name,
        tp.location,
        tp.rating,
        tp.estimated_budget
    FROM tourist_places tp
    JOIN categories c
    ON tp.category_id = c.category_id
    WHERE c.category_name = cat_name;
END //

DELIMITER ;

-- Test the category search procedure

CALL SearchPlacesByCategory('Historical');

-- Search tourist places within a budget

SELECT place_name, location, estimated_budget
FROM tourist_places
WHERE estimated_budget <= 1000;

-- Search highly rated tourist places

SELECT place_name, location, rating
FROM tourist_places
WHERE rating >= 4.5
ORDER BY rating DESC;

-- Verify total tourist places

SELECT COUNT(*) AS total_places
FROM tourist_places;

-- Verify total categories

SELECT COUNT(*) AS total_categories
FROM categories;

-- Display all tourist places

SELECT * FROM tourist_places;

-- Display all categories

SELECT * FROM categories;