// # SECTION 1

CREATE DATABASE database_a;

CREATE TABLE table_a (
    id INT
);

INSERT INTO table_a VALUES
(1), 
(2), 
(3), 
(4), 
(5);

SELECT * FROM table_a;

DROP TABLE table_a;

CREATE TABLE table_a (
    id INT
);

-- Doesn't work for table of the same name!
UNDROP TABLE table_a;

SELECT * FROM table_a;


-- Restore from the past doesnt work bc same name!
CREATE TABLE table_a_restored CLONE table_a
BEFORE(STATEMENT => '01afae97-3202-0d1b-0002-0ac600014082');

SELECT * FROM table_a_restored;

-- Need to rename the table!
ALTER TABLE table_a RENAME TO table_a_newer;

-- Then the old table can be undropped
UNDROP TABLE table_a;

SELECT * FROM table_a;

