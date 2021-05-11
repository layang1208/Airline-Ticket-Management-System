// route related to view booking page
module.exports = {
    viewBookingPage: (req, res) =>
    {
        //get username
        let username = req.session.user;

        //query the database for this user's all bookings
        let query =
            "SELECT b.*, t.* " +
            "FROM Booking b, Ticket t " +
            "WHERE b.username='"+username+"' " +
                "AND b.confirmationNo = t.confirmationNo;";
        db.query
        (query, (err, result) =>
            {
                if (err)
                {
                    return res.status(500).send(err);
                }
                else
                {
                    //render page and pass in query result
                    res.render('view-booking.ejs', {bookings: result});
                }
            }
        )
    },

    //cancel booking functionality on the view booking page
    cancelBooking: (req, res) =>
    {
        let username = req.session.user;
        // get confirmationNo of the booking we need to cancel from passed parameter
        let confirmationNo = req.params.confirmationNo;

        // first, update the booking status to cancelled
        var query =
            "UPDATE Booking " +
            "SET bookingStatus = 'Cancelled' " +
            "WHERE confirmationNo = "+confirmationNo+";";
        db.query(query, (err, result) => {
            if (err) return res.status(500).send(err);
        })

        //next, calculate how many points were added for that booking
        query =
            "SELECT transactionAmount " +
            "FROM Booking " +
            "WHERE confirmationNo = "+confirmationNo+";";
        db.query(query, (err, result) => {
            if (err) return res.status(500).send(err);
            let points = Math.round(result[0].transactionAmount * 0.1); //calculate points

            //subtract those points from the user account as this booking is cancelled now
            query =
                "UPDATE Client " +
                "SET points = points - " + points + " "
                "WHERE username = '"+username+"';";
            db.query(query, (err, result) => {
                if (err) return res.status(500).send(err);
            });
        })

        // query for more booking information from ticket
        query = "SELECT * FROM Ticket WHERE confirmationNo = "+confirmationNo+";";
        db.query(query, (err, result) => {
            if (err) return res.status(500).send(err);

            // get the booked flight, date, and seat from this booking
            let seatNo = result[0].seatNo;
            let flightNo = result[0].flightNo;
            let travelDate = result[0].departureDate.toISOString().split('T')[0];

            //reset the booked seat to available as this booking is cancelled
            query =
                "UPDATE Seat " +
                "SET seatStatus = 'Available' " +
                "WHERE seatNo = '"+seatNo+"' " +
                    "AND flightNo = '"+flightNo+"' " +
                    "AND departureDate = '"+travelDate+"';";
            db.query(query, (err, result) => {
                if (err) return res.status(500).send(err);
            });

            //decrement 1 to number of seats sold for that flight as booking is cancelled
            query =
                "UPDATE Flight " +
                "SET numSeatsSold = numSeatsSold - 1 " +
                "WHERE flightNo = '"+flightNo+"' " +
                "AND departureDate = '"+travelDate+"';";
            db.query(query, (err, result) => {
                if (err) return res.status(500).send(err);
                //all operations done redirect to this page again to see updated result
                res.redirect('/booking');
            });
        })
    }
}