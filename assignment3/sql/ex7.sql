# Create View #1
# Create a view that only a specific user can view own booking history
CREATE VIEW `PersonalHistory`
AS SELECT *
   FROM Booking
   WHERE username = 'ana83';

# Test for response
SELECT * FROM personalhistory
ORDER BY transactionDate;

# Create View #2
# Create a boarding information view for a given pair: confirmation number, ticket number on ticket
CREATE VIEW `BoardingInfomation` AS
SELECT t.ticketNo, t.confirmationNo, t.travelDocument, t.seatNo, t.flightNo, t.departureDate, p.firstName, p.lastName
FROM Ticket t, Passenger p
WHERE t.travelDocument = p.travelDocument
      AND t.confirmationNo = '25'
      AND t.ticketNo = '50';

# Test for response
SELECT * FROM boardinginfomation;

# Create View #3
# Create a view for flight in next 15 days
# this function here selects a specific date for test
# For the future, when we are able to get up-to-date data
# this function can be used with CURDATE() to get flights in the next 15 days
CREATE VIEW `FlightForDate` (flightNo, departureDate, arrivalDate, totalNumSeats, numSeatsSold) AS
SELECT flightNo, departureDate, arrivalDate, totalNumSeats, numSeatsSold
FROM Flight
WHERE departureDate >= '2020-11-01'
      AND departureDate <= '2020-11-15'
      AND flightNo = '1B77';

# Test for response
SELECT * FROM flightfordate;
