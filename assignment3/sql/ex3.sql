# INSERT type 1: without explicit column list
INSERT INTO Airline VALUES
(
	'AC',
    'Air Canada'
);

SELECT * FROM Airline;

# INSERT type 2: with explicit column list
INSERT INTO Passenger (travelDocument, firstName, lastName)
	VALUES ('M0001-1998', 'Boyi', 'Ma');

SELECT * FROM Passenger;

# INSERT type 3: INSERT using SELECT 
INSERT INTO Client (username, password)
	SELECT 'bma62', CONCAT(travelDocument, '-password')
    FROM Passenger
    WHERE firstName = 'Boyi'
		AND lastName = 'Ma';

SELECT * FROM Client;
