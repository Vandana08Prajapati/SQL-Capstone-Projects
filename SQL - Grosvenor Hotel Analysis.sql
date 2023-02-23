# Create a database of the hotel named "Grosvenor"

create database hoteldb; 		
use hoteldb; 

------------------------------------------Creating and Inserting Table and Records-------------------------------------------------------
create table Hotel         											# creating table for Hotel
(hotel_no char(10) NOT NULL Primary key,
hotel_name varchar(20) NOT NULL,
address varchar(50) NOT NULL );

INSERT INTO `Hotel` (`hotel_no`, `hotel_name`, `address`) values 
('H111','Grosvenor Hotel', 'London'),
('H112','BlueOrchid Hotel', 'Australia'),
('H113','The Taj Hotel', 'India');

create table Room         											# creating table for Hotel Rooms
( Room_no varchar(10) NOT NULL ,
 hotel_no char(10) NOT NULL,
 hotel_type char(10) NOT NULL,
 Price decimal(5,2) NOT NULL,
 primary key (Room_no, hotel_no),
 foreign key (hotel_no) REFERENCES hotel(hotel_no) );
 
 INSERT INTO `Room`(`Room_no`,`hotel_no`,`hotel_type`,`Price`) Values 
 ('101','H111','S','72.00'),
 ('102','H111','D','112.50'),
 ('103','H111','S','77.00'),
 ('104','H111','D','120.00'),
 ('105','H111','D','150.00'),
 ('101','H112','S','70.00'),
 ('102','H112','F','120.50'),
 ('103','H112','S','80.50'),
 ('101','H113','F','120.00'),
 ('104','H113','S','95.50');
 
  create table Guest 														# creating table of Guests lists
( guest_no char(4) NOT NULL primary key,
guest_Name varchar(30) NOT NULL,
address varchar(50) NOT NULL);

INSERT INTO `Guest`(`guest_no`,`guest_name`,`address`) VALUES 
('G111','John Smith','London'),
('G112','Robin Kate', 'Australia'),
('G113','Kelvin Jon','London'),
('G114','James Smith','London'),
('G115','Robert Mark','Australia'),
('G116','Ramesh Kumar','India'),
('G117','Marina','India'),
('G118','Christina joyce','India'),
('G119','Mathew David','Australia'),
('G120','Kishor Kumar','India');

create table Booking  													# creating table for Hotel Bookings
 ( hotel_no char(10) NOT NULL , 
 guest_no char(4) NOT NULL,
 Date_from datetime NOT NULL,
 Date_to datetime NOT NULL,
 Room_no char(10) NOT NULL,
 primary key (hotel_no, guest_no), 
foreign key (Room_no, hotel_no) REFERENCES Room(Room_no, hotel_no) );

INSERT INTO `Booking`(`hotel_no`,`guest_no`,`Date_from`,`Date_to`,`Room_no`) VALUES
('H111','G111','2022-06-22','2022-06-26','101'),
('H111','G112','2022-07-18','2022-07-25','102'),
('H111','G113','2021-12-21', '2021-12-26','103'),
('H111','G114','1999-08-10', '1999-08-16','104'),
('H111','G115','1997-05-10', '1997-05-15','105'),
('H112','G116','2016-01-04', '2016-01-08','101'),
('H112','G117','2015-11-20', '2015-11-24','102'),
('H111','G118','2000-01-01', '2000-01-01','103'),
('H113','G119','2020-02-11', '2020-02-15','101'),
('H113','G120','2022-07-15', '2022-07-25','104');

# Updating the price of the Room table 
UPDATE Room													#updating the original price by 1.05 using update and SET keyword
SET Price = Price*1.05;

Create table booking_old       								# creating a new table of old bookings
(hotel_no char(4) NOT NULL,
guest_no char(4) NOT NULL,
Date_from datetime NOT NULL,
Date_to datetime NOT NULL,
Room_no varchar(4) NOT NULL,
primary key (hotel_no, guest_no), 
foreign key (Room_no, hotel_no) REFERENCES Room(Room_no, hotel_no) );

INSERT INTO booking_old(select * from Booking         	#inserting the booking of before 1st January 2000 to a new table booking_old
where Date_to < '2000-01-01');    

Delete from Booking where Date_to < '2000-01-01';      #Deleting the booking records of before 1st Jan 2000

 -----------------------------------------------------------SIMPLE QUERIES ---------------------------------------------------------------
 
 # Q1. List full details of all hotels.
 Select * from Hotel;
 
 #Q2.  List full details of all hotels in London.
 Select * from Hotel
 where address = 'London';
 
 #Q3. List the names and addresses of all guests in London, alphabetically ordered by name.
SELECT guest_name, address
FROM Guest
WHERE address = 'London'
ORDER BY guest_name;			 	#order by used to sort the record by guest_name using asc order
 
 #Q4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.
SELECT * FROM Room
WHERE price < 40 AND hotel_type IN ('D', 'F')     	# AND operator used to check both the conditions of price and hotel room type
ORDER BY price;

#Q5. List the bookings for which no date_to has been specified.
SELECT * FROM booking WHERE Date_to IS NULL;

-------------------------------------------AGGREGATE FUNCTIONS----------------------------------------------------------------------------

#Q1. How many hotels are there?
Select Count(*) from Hotel;

#Q2. What is the average price of a room?
SELECT AVG(Price) FROM Room;

#Q3. What is the total revenue per night from all double rooms?
SELECT SUM(Price) FROM Room 
WHERE hotel_type = 'D';

#Q4. How many different guests have made bookings for August ?
SELECT COUNT(DISTINCT guest_no)   # Count the total number of different guest made booking using distinct keyword
FROM Booking
WHERE Date_from like '%-08-%' ;    # like operator used to match the pattern ..here to match the August month pattern

-------------------------------------------------------Subqueries and Joins---------------------------------------------------------------

#Q1. List the price and type of all rooms at the Grosvenor Hotel.
SELECT Price, hotel_type
FROM Room
WHERE hotel_no = (SELECT hotel_no FROM Hotel WHERE hotel_name = 'Grosvenor Hotel');

#Q2. List all guests currently staying at the Grosvenor Hotel.
SELECT * FROM Guest
WHERE guest_no = (SELECT guest_no FROM Booking
WHERE Date_from <= CURRENT_DATE AND Date_to >= CURRENT_DATE AND hotel_no = (SELECT hotel_no FROM Hotel
WHERE hotel_name = 'Grosvenor Hotel'));

#Q3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the room, if the room is occupied.
select guest_name ,r.* from Room r
NATURAL JOIN Booking b 
NATURAL JOIN Guest g 
NATURAL JOIN hotel h 
WHERE hotel_no='H111'
Order by room_no;


-- Select guest_name, r.* From Room r
-- LEFT JOIN ( select g.guest_Name, h.hotel_no, b.Room_no
-- FROM Guest g, Booking b, Hotel h
-- WHERE g.guest_no = b.guest_no AND b.hotel_no = h.hotel_no AND 
-- h.hotel_name = 'Grosvenor Hotel' AND h.hotel_no='H111' AND
-- b.Date_from <= current_date AND b.Date_to >= current_date) AS curr_booking
-- ON r.hotel_no = curr_booking.hotel_no AND r.Room_no = curr_booking.Room_no;

#Q4. What is the total income from bookings for the Grosvenor Hotel today?
SELECT SUM(price) FROM booking b, room r, hotel h
WHERE (b.date_from <= CURRENT_DATE AND
b.date_to >= CURRENT_DATE) AND
r.hotel_no = h.hotel_no AND r.room_no = b.room_no;

#Q5. List the rooms that are currently unoccupied at the Grosvenor Hotel.
SELECT * FROM room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h
WHERE (date_from <= CURRENT_DATE AND date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no AND hotel_name = 'Grosvenor Hotel');

#Q6. What is the lost income from unoccupied rooms at the Grosvenor Hotel?
SELECT SUM(price) FROM Room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h 
WHERE (date_from <= CURRENT_DATE AND
date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no AND hotel_name = 'Grosvenor Hotel');

----------------------------------------------------GROUPING------------------------------------------------------------------------------

#Q1. List the number of rooms in each hotel.
SELECT hotel_no, COUNT(room_no) AS count FROM Room
GROUP BY hotel_no;

#Q2. List the number of rooms in each hotel in London.
SELECT h.hotel_no, address , COUNT(Room_no) AS Room_Count
FROM Hotel h, Room r
WHERE r.hotel_no = h.hotel_no
AND address = 'London'
GROUP BY hotel_no;

#Q3. What is the average number of bookings for each hotel in August ?
SELECT  AVG(X) as Aug_Avg_Booking FROM      #correct
(SELECT hotel_no, COUNT(hotel_no) AS X
FROM booking b
WHERE (b.date_from like'%-08-%' AND b.date_to like '%-08-%')
GROUP BY hotel_no) AS Anotherthing;

#Q4. What is the most commonly booked room type for each hotel in London?
SELECT hotel_type, COUNT(*) AS RoomType     # correct 
FROM Hotel H, Room R
WHERE H.address = 'London' AND H.Hotel_no = R.Hotel_No
GROUP BY hotel_type
ORDER BY RoomType DESC;
 
-- SELECT type, MAX(y)
-- FROM (SELECT type, COUNT(type) AS y
-- FROM booking b, hotel h, room r
-- WHERE r.roomno = b.roomno AND
-- r.hotelno = b.hotelno AND
-- b.hotelno = h.hotelno AND city = 'London'
-- GROUP BY type);

 #Q5. What is the lost income from unoccupied rooms at each hotel today?
SELECT hotel_no, SUM(Price) FROM Room r
WHERE room_no NOT IN
(SELECT room_no FROM Booking b, Hotel h
WHERE (date_from <= CURRENT_DATE AND Date_to >= CURRENT_DATE) AND b.hotel_no = h.hotel_no)
GROUP BY hotel_no;



 



 



 



