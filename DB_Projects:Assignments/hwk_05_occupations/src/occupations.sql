-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student: Fin Martinez
-- Description: a database of occupations

CREATE DATABASE occupations;

\c occupations

DROP TABLE IF EXISTS Occupations;

\d Occupations

-- TODO: create table Occupations

CREATE TABLE Occupations(
    code CHAR(10) PRIMARY KEY,
    occupation VARCHAR(250) NOT NULL,
    jobFamily VARCHAR(50) NOT NULL);

-- TODO: populate table Occupations

\copy Occupations
    (code, occupation, jobFamily) from /var/lib/postgresql/data/occupations.csv
    DELIMITER ',' CSV HEADER;

-- TODO: a) the total number of occupations (expect 1016).

SELECT COUNT(*) AS occupation FROM Occupations;

-- TODO: b) a list of all job families in alphabetical order (expect 23).

SELECT DISTINCT jobFamily AS jobFamily FROM Occupations
ORDER BY 1;

-- TODO: c) the total number of job families (expect 23)

SELECT COUNT(DISTINCT jobFamily) AS total FROM Occupations;

-- TODO: d) the total number of occupations per job family in alphabetical order of job family.

SELECT COUNT(*) AS total, jobFamily FROM Occupations
GROUP BY jobFamily
ORDER BY 1;

-- TODO: e) the number of occupations in the "Computer and Mathematical" job family (expect 38)

SELECT COUNT(*) AS total, jobFamily FROM Occupations
WHERE jobFamily = 'Computer and Mathematical'
GROUP BY jobFamily;

-- BONUS POINTS

-- TODO: f) an alphabetical list of occupations in the "Computer and Mathematical" job family.

SELECT DISTINCT occupation AS jobList FROM Occupations
WHERE jobFamily = 'Computer and Mathematical'
ORDER BY 1;

-- TODO: g) an alphabetical list of occupations in the "Computer and Mathematical" job family that begins with the word "Database"

SELECT occupation AS databaseJobs FROM Occupations
WHERE jobFamily = 'Computer and Mathematical' AND occupation LIKE 'Database%';