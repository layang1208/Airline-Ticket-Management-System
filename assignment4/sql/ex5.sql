#1
#Select those clients who are in the booking list and find the sVIP members (who has points over 80000)
SELECT c.username, c.points
FROM Client c, Booking b
WHERE c.username = b.username
GROUP BY c.username, c.points
HAVING c.points > 80000
ORDER BY c.points DESC;


#2
# Given a departure place and specific departure date, find any qualified flight schedule with seats currently available
SELECT f.flightNo, fs.departureAirportIATA, fs.arrivalAirportIATA, f.departureDate, f.arrivalDate, fs.departureTime, 
fs.arrivalTime, (f.totalNumSeats - f.numSeatsSold) AS seatsAvailable, fs.seatPrice
FROM FlightSchedule fs, Flight f 
WHERE f.flightNo = fs.flightNo	
		AND f.departureDate = '2020-05-03'
        AND fs.departureAirportIATA = 'YYZ' AND fs.arrivalAirportIATA = 'MDT'
GROUP BY f.flightNo, fs.departureAirportIATA, fs.arrivalAirportIATA, f.departureDate, f.arrivalDate, fs.departureTime, 
fs.arrivalTime, f.numSeatsSold, seatsAvailable, fs.seatPrice
ORDER By seatsAvailable ASC;

#3
# Given a passenger name, find the confirmation number, bookingStatus and transactionDate related to a passenger
SELECT confirmationNo, bookingStatus, transactionDate
FROM Booking
WHERE confirmationNo IN (SELECT confirmationNo
						FROM Ticket 
                        WHERE travelDocument IN (SELECT travelDocument
												FROM Passenger
                                                WHERE firstName= 'Libby' AND lastName='Gallagher'));
											
#4
#Find the total number of passenger a client booked, and the total amount money they have paid
SELECT c.username, SUM(b.transactionAmount) AS totalAmountPaid,  COUNT(p.travelDocument) AS numOfPassengerBooked
FROM Passenger p, Client c, Booking b, Ticket t
WHERE c.username = b.username
		AND b.confirmationNo = t.confirmationNo
        AND t.travelDocument = p.travelDocument
GROUP BY c.username
ORDER BY totalAmountPaid DESC;

#5
#Find the most popular booking route ( tickets sold most), and its ticket price for a user
SELECT t.flightNo, COUNT(t.flightNo) AS numTicketSold,fs.departureAirportIATA, fs.arrivalAirportIATA, fs.seatPrice
FROM Ticket t, FlightSchedule fs
WHERE fs.flightNo = t.flightNo      
GROUP BY t.flightNo, fs.departureAirportIATA, fs.arrivalAirportIATA
ORDER BY numTicketSold DESC;


#6
#Select a list of flights as well as its flight schedule, who takes the longest distance route between a time period
SELECT fs.*, r.distance
FROM FlightSchedule fs, Route r
WHERE EXISTS (
		SELECT DISTINCT flightNo
		FROM Flight
		WHERE departureDate >= '2020-05-03' 
			AND departureDate <= '2020-05-06'
			AND fs.flightNo = Flight.flightNo)
    AND fs.departureAirportIATA = r.departureAirportIATA
    AND fs.arrivalAirportIATA = r.arrivalAirportIATA
    AND r.distance = (
		SELECT MAX(r.distance)
		FROM FlightSchedule fs, Route r
		WHERE flightNo IN (
			SELECT DISTINCT flightNo
			FROM Flight 
			WHERE departureDate >= '2020-05-03' 
				AND departureDate <= '2020-05-06')
				AND fs.departureAirportIATA = r.departureAirportIATA
				AND fs.arrivalAirportIATA = r.arrivalAirportIATA);



                                                
			



