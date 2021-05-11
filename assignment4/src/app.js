// set up the project
const express = require('express'); // use express for back end framework
const bodyParser = require('body-parser');
const mysql = require('mysql');
const path = require('path');
const session = require('express-session'); // in order to keep logged-in users' sessions
const cookieParser = require('cookie-parser');
var $ = require("jquery"); // so we can use jQuery functions on the webpage

const app = express();

const port = 5000; //port the server will be running on
const { getHomePage, loginPage, registerPage,
  login, register, logout } = require('./routes/index'); // the basic pages and functions
const { viewProfilePage } = require('./routes/view-profile'); // corresponds to view profile button
const { viewBookingPage, cancelBooking } = require('./routes/view-booking'); //page and function under view booking
const { bookDeparturePage, bookDeparture, bookArrivalPage, bookArrival,
  bookDatePage, bookDate, findDealPage, searchFlightPage, searchSeatPage,
  passengerInfoPage, passengerInfo} = require('./routes/book-flight'); // core pages and functionalities related to flight booking

// create connection, make sure to change the database password to root for this to work properly
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'airline-ticket-database'
});

// connect to database
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('MySQL connected!');
});

//make sure the connected db can be used globally
global.db = db;

// configure the middleware
app.set('port', process.env.port || port); //set port number express uses
app.set('views', __dirname + '/views'); //set views folder for rendering
app.set('view engine', 'ejs'); //use ejs as template editor
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json()); //parse from data client
app.use(express.static(path.join(__dirname, 'public'))); //configure to use public folder

// initialize cookie-parser to allow us access the cookies stored in the browser.
app.use(cookieParser());
// initialize express-session to allow us track the logged-in user sessions.
app.use(session({
  key: 'user_sid',
  secret: 'secret',
  resave: false,
  saveUninitialized: false,
  cookie: {
    expires: 600000
  }
}));

// middleware function to check for logged-in users
function checkSignIn(req, res, next) {
  if (req.session.user) {
    next();     //If session exists, proceed to page
  } else {
    res.redirect('/login') //else, redirect to login
  }
}

//connect routes and views for get requests
app.get('/', checkSignIn, getHomePage); //if user signed in, get home page
app.get('/register', registerPage);
app.get('/login', loginPage);
app.get('/logout', checkSignIn, logout);
app.get('/profile', checkSignIn, viewProfilePage);
app.get('/booking', checkSignIn, viewBookingPage);
app.get('/departure', checkSignIn, bookDeparturePage);
app.get('/arrival', checkSignIn, bookArrivalPage);
app.get('/date', checkSignIn, bookDatePage);
app.get('/deal', checkSignIn, findDealPage);
app.get('/search', checkSignIn, searchFlightPage);
app.get('/flight/:flightNo&:travelDate', checkSignIn, searchSeatPage); // need to pass flightNo as parameter
app.get('/passenger/:seatNo&:seatPrice', checkSignIn, passengerInfoPage); // pass seatNo and seatPrice as parameters
app.get('/cancel/:confirmationNo', checkSignIn, cancelBooking); //pass confirmationNo as parameter

// connect route and views for post requests
app.post('/register', register);
app.post('/login', login);
app.post('/departure', bookDeparture);
app.post('/arrival', bookArrival);
app.post('/date', bookDate);
app.post('/passenger', passengerInfo);
app.post('/deal', findDealPage);

// set the app to listen on the port
app.listen(port, () => {
  console.log(`Server running on port: ${port}`);
});