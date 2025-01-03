CREATE TABLE organiser (
    organiser_id VARCHAR(16) PRIMARY KEY,
    organiser_name VARCHAR(255) NOT NULL,
    pass VARCHAR(255) NOT NULL
);
CREATE TABLE parent_event (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(255) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_date DATE NOT NULL,
    organiser_id VARCHAR(16) NOT NULL,
    FOREIGN KEY (organiser_id) REFERENCES organiser(organiser_id)
);
CREATE TABLE partispants (
    partispant_id VARCHAR(16) PRIMARY KEY,
    partispant_name VARCHAR(255) NOT NULL,
    pass VARCHAR(255) NOT NULL
);
CREATE TABLE event_enrolments (
    enroll_id INT PRIMARY KEY,
    partispant_id VARCHAR(16) NOT NULL,
    event_id INT NOT NULL,
    enrolled_time TIMESTAMP NOT NULL,
    FOREIGN KEY (partispant_id) REFERENCES partispants(partispant_id),
    FOREIGN KEY (event_id) REFERENCES parent_event(event_id)
);
CREATE TABLE child_event (
    child_event_id INT PRIMARY KEY,
    child_event_name VARCHAR(255) NOT NULL,
    child_event_type VARCHAR(50) NOT NULL,
    max_partispant INT NOT NULL,
    event_id INT NOT NULL,
    FOREIGN KEY (event_id) REFERENCES parent_event(event_id)
);
CREATE TABLE child_event_enrolments (
    event_id INT NOT NULL,
    child_event_id INT NOT NULL,
    partispant_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (event_id, child_event_id),
    FOREIGN KEY (partispant_id) REFERENCES partispants(partispant_id),
    FOREIGN KEY (child_event_id) REFERENCES child_event(child_event_id),
    FOREIGN KEY (event_id) REFERENCES parent_event(event_id)
);
-- 1. Retrieve all parent events and their corresponding organizers
SELECT 
    pe.event_id, 
    pe.event_name, 
    pe.event_date, 
    o.organiser_name
FROM 
    parent_event pe
JOIN 
    organiser o
ON 
    pe.organiser_id = o.organiser_id;

-- 2. Get the list of participants enrolled in a specific parent event
SELECT 
    p.partispant_id, 
    p.partispant_name
FROM 
    event_enrolments ee
JOIN 
    partispants p
ON 
    ee.partispant_id = p.partispant_id
WHERE 
    ee.event_id = ?; 

--3. Find child events under a specific parent event along with max participants
SELECT 
    ce.child_event_id, 
    ce.child_event_name, 
    ce.child_event_type, 
    ce.max_partispant
FROM 
    child_event ce
WHERE 
    ce.event_id = ?;

--4. Get all enrollments for a child event
SELECT 
    ce.child_event_name, 
    p.partispant_name
FROM 
    child_event_enrolments cee
JOIN 
    partispants p
ON 
    cee.partispant_id = p.partispant_id
JOIN 
    child_event ce
ON 
    cee.child_event_id = ce.child_event_id
WHERE 
    ce.child_event_id = 2;

--5. List all parent events and their child events
SELECT 
    pe.event_name AS parent_event_name, 
    ce.child_event_name AS child_event_name
FROM 
    parent_event pe
LEFT JOIN 
    child_event ce
ON 
    pe.event_id = ce.event_id;

--6. Count participants in each child event
SELECT 
    ce.child_event_name, 
    COUNT(cee.partispant_id) AS participant_count
FROM 
    child_event ce
LEFT JOIN 
    child_event_enrolments cee
ON 
    ce.child_event_id = cee.child_event_id
GROUP BY 
    ce.child_event_name;