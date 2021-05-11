CREATE SCHEMA `airline-ticket-database` ;

CREATE TABLE Client (
	username VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    PRIMARY KEY (username)
    );

CREATE TABLE Booking (
	confirmationNo BIGINT NOT NULL AUTO_INCREMENT,
    bookingStatus VARCHAR(20) NOT NULL,
    numSeatsBooked SMALLINT NOT NULL,
    numPointsEarned INT NOT NULL,
    transactionDate DATE NOT NULL,
    transactionAmount DECIMAL(10,2) NOT NULL,
	username VARCHAR(100) NOT NULL,
    PRIMARY KEY (confirmationNo),
    FOREIGN KEY (username) REFERENCES Client (username)
    );

# should flags be in the view only? 
CREATE TABLE Airport (
	airportIATA VARCHAR(10) NOT NULL,
    airportName VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    PRIMARY KEY (airportIATA)
    );

CREATE TABLE Airline (
	airlineIATA VARCHAR(10) NOT NULL, 
    airlineName VARCHAR(100) NOT NULL,
    PRIMARY KEY (airlineIATA)
    );

CREATE TABLE Route (
	departureAirportIATA VARCHAR(10) NOT NULL,
    arrivalAirportIATA VARCHAR(10) NOT NULL,
    distance INT NOT NULL, 
    PRIMARY KEY (departureAirportIATA, arrivalAirportIATA),
    FOREIGN KEY (departureAirportIATA) REFERENCES Airport (airportIATA),
	FOREIGN KEY (arrivalAirportIATA) REFERENCES Airport (airportIATA)
    );

CREATE TABLE FlightSchedule (
	flightNo VARCHAR(10) NOT NULL,
    departureAirportIATA VARCHAR(10) NOT NULL,
    arrivalAirportIATA VARCHAR(10) NOT NULL,
    airlineIATA VARCHAR(10) NOT NULL,
    departureWeekday VARCHAR(10) NOT NULL,
    departureTime TIME NOT NULL,
    arrivalWeekday VARCHAR(10) NOT NULL,
    arrivalTime TIME NOT NULL,
    seatPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (flightNo),
    FOREIGN KEY (departureAirportIATA) REFERENCES Route (departureAirportIATA),
	FOREIGN KEY (arrivalAirportIATA) REFERENCES Route (arrivalAirportIATA),
    FOREIGN KEY (airlineIATA) REFERENCES Airline(airlineIATA)
	);

CREATE TABLE Passenger (
	travelDocument VARCHAR(100) NOT NULL,
	firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    PRIMARY KEY (travelDocument)
    );

CREATE TABLE Flight (
	flightNo VARCHAR(10) NOT NULL,
    departureDate DATE NOT NULL,
    arrivalDate DATE NOT NULL,
    totalNumSeats SMALLINT NOT NULL,
    numSeatsSold SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (flightNo, departureDate),
    FOREIGN KEY (flightNo) REFERENCES FlightSchedule (flightNo)
    );

CREATE TABLE Seat (
	seatNo VARCHAR(10) NOT NULL,
    seatStatus VARCHAR(20) NOT NULL,
	flightNo VARCHAR(10) NOT NULL,
    departureDate DATE NOT NULL,
    PRIMARY KEY (seatNo, flightNo, departureDate),
    FOREIGN KEY (flightNo, departureDate) REFERENCES Flight (flightNo, departureDate)
    );

# I had to add ticketNo and use it as PK because the composite PK
# in the original design are not referencing to one same parent table
# and would cause error in MySQL
CREATE TABLE Ticket (
	ticketNo BIGINT NOT NULL AUTO_INCREMENT,
	confirmationNo BIGINT NOT NULL,
    travelDocument VARCHAR(100) NOT NULL,
    seatNo VARCHAR(10) NOT NULL,
    flightNo VARCHAR(10) NOT NULL,
    departureDate DATE NOT NULL,
    PRIMARY KEY (ticketNo),
    FOREIGN KEY (confirmationNo) REFERENCES Booking (confirmationNo),
    FOREIGN KEY (travelDocument) REFERENCES Passenger (travelDocument),
    FOREIGN KEY (seatNo,flightNo,departureDate) 
		REFERENCES Seat (seatNo,flightNo,departureDate)
    );

DESCRIBE Client;
DESCRIBE Booking;
DESCRIBE Airport;
DESCRIBE Airline;
DESCRIBE Route;
DESCRIBE FlightSchedule;
DESCRIBE Passenger;
DESCRIBE Flight;
DESCRIBE Seat;
DESCRIBE Ticket;