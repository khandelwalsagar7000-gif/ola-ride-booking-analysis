create Database Ola;
use Ola;

CREATE TABLE bookings (
    `Date` DATETIME,
    `Time` TIME,
    `Booking_ID` VARCHAR(50),
    `Booking_Status` VARCHAR(100),
    `Customer_ID` VARCHAR(50),
    `Vehicle_Type` VARCHAR(50),
    `Pickup_Location` VARCHAR(255),
    `Drop_Location` VARCHAR(255),
    `V_TAT` DECIMAL(10,2),
    `C_TAT` DECIMAL(10,2),
    `Canceled_Rides_by_Customer` VARCHAR(255),
    `Canceled_Rides_by_Driver` VARCHAR(255),
    `Incomplete_Rides` VARCHAR(50),
    `Incomplete_Rides_Reason` VARCHAR(255),
    `Booking_Value` INT,
    `Payment_Method` VARCHAR(50),
    `Ride_Distance` INT,
    `Driver_Ratings` DECIMAL(3,2),
    `Customer_Rating` DECIMAL(3,2)
);

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/mysql_import/Bookings.csv'
INTO TABLE bookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @Date,
    @Time,
    @Booking_ID,
    @Booking_Status,
    @Customer_ID,
    @Vehicle_Type,
    @Pickup_Location,
    @Drop_Location,
    @V_TAT,
    @C_TAT,
    @Canceled_Rides_by_Customer,
    @Canceled_Rides_by_Driver,
    @Incomplete_Rides,
    @Incomplete_Rides_Reason,
    @Booking_Value,
    @Payment_Method,
    @Ride_Distance,
    @Driver_Ratings,
    @Customer_Rating
)
SET
    `Date` = STR_TO_DATE(NULLIF(@Date,''), '%d-%m-%Y %H:%i'),
    `Time` = NULLIF(@Time,''),
    `Booking_ID` = NULLIF(@Booking_ID,''),
    `Booking_Status` = NULLIF(@Booking_Status,''),
    `Customer_ID` = NULLIF(@Customer_ID,''),
    `Vehicle_Type` = NULLIF(@Vehicle_Type,''),
    `Pickup_Location` = NULLIF(@Pickup_Location,''),
    `Drop_Location` = NULLIF(@Drop_Location,''),
    `V_TAT` = NULLIF(@V_TAT,''),
    `C_TAT` = NULLIF(@C_TAT,''),
    `Canceled_Rides_by_Customer` = NULLIF(@Canceled_Rides_by_Customer,''),
    `Canceled_Rides_by_Driver` = NULLIF(@Canceled_Rides_by_Driver,''),
    `Incomplete_Rides` = NULLIF(@Incomplete_Rides,''),
    `Incomplete_Rides_Reason` = NULLIF(@Incomplete_Rides_Reason,''),
    `Booking_Value` = NULLIF(@Booking_Value,''),
    `Payment_Method` = NULLIF(@Payment_Method,''),
    `Ride_Distance` = NULLIF(@Ride_Distance,''),
    `Driver_Ratings` = NULLIF(@Driver_Ratings,''),
    `Customer_Rating` = NULLIF(@Customer_Rating,'');
    
    SELECT COUNT(*) AS total_rows
FROM bookings;

SELECT *
FROM bookings
LIMIT 10;

SELECT `Date`, `Time`, `Booking_ID`, `Booking_Status`
FROM bookings
LIMIT 10;

#1. Retrieve all successful bookings:
 Create View Successful_Bookings As
SELECT * FROM bookings
WHERE Booking_Status = 'Success';

Select * From Successful_Bookings;

#2. Find the average ride distance for each vehicle type:
Create View ride_distance_for_each_vehicle As
SELECT Vehicle_Type, AVG(Ride_Distance)
As Avg_Distance FROM bookings
GROUP BY Vehicle_Type; 

Select * From ride_distance_for_each_vehicle;

#3. Get the total number of cancelled rides by customers:
Create View cancelled_rides_by_customers As
SELECT COUNT(*) FROM bookings
WHERE Booking_Status = 'Canceled by Customer';

Select * From cancelled_rides_by_customers;


#4. List the top 5 customers who booked the highest number of rides:
Create View the_top_5_customers as
SELECT Customer_ID, COUNT(Booking_ID) as Total_Rides
FROM bookings
GROUP BY Customer_ID
ORDER BY Total_Rides DESC LIMIT 5;

Select * From the_top_5_customers;


#5. Get the number of rides cancelled by drivers due to personal and car-related issues:
Create View cancelled_by_drivers_P_C_Issue as
SELECT COUNT(*) FROM bookings
WHERE Canceled_Rides_by_Driver = 'Personal & Car related issue';

Select * From cancelled_by_drivers_P_C_Issue;

#6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
Create View Max_Min_driver_ratings as
SELECT MAX(Driver_Ratings) as max_rating,
MIN(Driver_Ratings) as min_rating
FROM bookings
WHERE Vehicle_Type = 'Prime Sedan';

Select * From Max_Min_driver_ratings;

#7. Retrieve all rides where payment was made using UPI:
Create View UPI_Payment as
SELECT * FROM bookings
WHERE Payment_Method = 'UPI';

Select * From UPI_Payment;

#8. Find the average customer rating per vehicle type:
Create View customer_rating_per_vehicle as
SELECT Vehicle_Type, AVG(Customer_Rating) as avg_customer_rating
FROM bookings
GROUP BY Vehicle_Type;


#9. Calculate the total booking value of rides completed successfully:
Create View total_successful_Ride_value as 
SELECT SUM(Booking_Value)as total_successful_Ride_value
FROM bookings
WHERE Booking_Status = 'Success';

Select * From total_successful_Ride_value;


#10. List all incomplete rides along with the reason:
Create View Incomplete_Rides_with_Reason as 
SELECT Booking_ID, Incomplete_Rides_Reason
FROM bookings
WHERE Incomplete_Rides = 'Yes';
