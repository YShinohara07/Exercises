/** Create, Insert, Alter, Update, Delete **/
CREATE TABLE clothes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    design TEXT);
    
INSERT INTO clothes (type, design)
    VALUES ("dress", "pink polka dots");
INSERT INTO clothes (type, design)
    VALUES ("pants", "rainbow tie-dye");
INSERT INTO clothes (type, design)
    VALUES ("blazer", "black sequin");

ALTER TABLE clothes ADD price INTEGER default 0;
SELECT * FROM clothes;

UPDATE clothes SET price=10 WHERE id=1;
UPDATE clothes SET price=20 WHERE id=2;
UPDATE clothes SET price=30 WHERE id=3;
SELECT * FROM clothes;

INSERT INTO clothes (type, design, price) VALUES ('pants','black','100');
SELECT * FROM clothes;

DROP TABLE clothes;
DELETE FROM cd.members WHERE memid NOT IN (SELECT DISTINCT memid FROM cd.bookings);

/** Extracting timestamp information **/
SELECT facid, SUM(slots) AS "Total Slots"
FROM cd.bookings
WHERE extract('month' from starttime)=9 AND extract('year' from starttime)=2012
GROUP BY facid
ORDER BY "Total Slots";