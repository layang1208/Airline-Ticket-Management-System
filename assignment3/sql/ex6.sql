# Interesting Data Modification Command: #1
# Insert a result of a query
# Meaning: booking a new flight for user ana83
INSERT INTO Booking
VALUES ('10002',
        'Booked',
        '2',
        (2 * (SELECT seatPrice
             FROM FlightSchedule
             WHERE (flightNo = '0P82')) * 0.1),
        CURDATE(),
        (2 * (SELECT seatPrice
             FROM FlightSchedule
             WHERE (flightNo = '0P82'))),
		'ana83');

# Test for results
SELECT * FROM Booking;


# Interesting Data Modification Command: #2
# Updating a set of tuples
# Meaning: giving bonus points to clients who spent over 40000 dollars on travelling during summer months
SET SQL_SAFE_UPDATES = 0;
UPDATE Client
SET points = points + 500
WHERE (username IN (SELECT username
                    FROM Booking
                    WHERE (transactionDate >= '2020-07-01'
                           AND transactionDate <= '2020-08-31')
                           GROUP BY username
                           HAVING SUM(transactionAmount) >= 40000));
              
# Test for results
SELECT * FROM Client;

# Interesting Data Modification Command: #3
# Modifying seat price for a selected date, using "case" to manage different conditions
# Meaning: increase the seat price when it's close to soldout
# decrease the seat price when the selling rate is low

UPDATE FlightSchedule
SET seatPrice = CASE
WHEN
flightNo IN (SELECT flightNo
                    FROM Flight
                    WHERE (departureDate = '2020-07-01'
                           AND numSeatsSold/totalNumSeats > 0.9))
THEN seatPrice * 1.25
WHEN
flightNo IN (SELECT flightNo
                    FROM Flight
                    WHERE (departureDate = '2020-07-01'
                           AND numSeatsSold/totalNumSeats < 0.2))
THEN seatPrice * 0.8
ELSE seatPrice
END;
              
# Test for results
SELECT * FROM FlightSchedule;