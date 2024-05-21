-- First, we created backup table to have a copy of the original (allows restoring in case of any accidental data loss or corruption)

SELECT * 
INTO Mentorness.dbo.Hotel_Reservation2
FROM Mentorness.dbo.Hotel_Reservation

SELECT * FROM Mentorness..Hotel_Reservation2

-- Second we will check if there are any duplicates to remove 

WITH duplicate_cte AS(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY [Booking_ID]
	  ,[lead_time]
      ,[arrival date]
      ,[market_segment_type]
      ,[booking_status] ORDER BY [Booking_ID])AS row_num
FROM Mentorness.dbo.Hotel_Reservation2
)
SELECT DISTINCT  [Booking_ID], row_num FROM duplicate_cte
WHERE row_num > 1

-- There is no duplicate -- 

---- Standardizing  data -------
SELECT * FROM Mentorness.dbo.Hotel_Reservation2

-- Changing the booking status from "Not Canceled" to "Confirmed"

SELECT Booking_status FROM Mentorness.dbo.Hotel_Reservation2
WHERE Booking_status LIKE '%Not%'


UPDATE Mentorness.dbo.Hotel_Reservation2
SET Booking_status = 'Confirmed'
WHERE Booking_status LIKE '%Not%'

-------------------------------------

------ changing the "arrival_date" data type from text to DATE

UPDATE Mentorness.dbo.Hotel_Reservation2
SET arrival_date = CONVERT(DATE, arrival_date, 105)

-- Adding a new column called [Arrival Date] and copy the date values to it

ALTER TABLE Mentorness.dbo.Hotel_Reservation2
ADD [Arrival date] Date


UPDATE Mentorness.dbo.Hotel_Reservation2
SET [Arrival date] = arrival_date

SELECT arrival_date
INTO [Arriving date]
FROM mentorness.dbo.Hotel_Reservation2

-- Removing the old unused column -- (It is strongly advised to prioritize the creation of a backup database before proceeding with any actions)


-- Drop the original column
ALTER TABLE mentorness.dbo.Hotel_Reservation2
DROP COLUMN [arrival_date]

--Adjusting the data type of each column to a more appropriate one.

ALTER TABLE  mentorness.dbo.Hotel_Reservation2
ALTER COLUMN NO_of_children int

ALTER TABLE  mentorness.dbo.Hotel_Reservation2
ALTER COLUMN NO_of_adults int

ALTER TABLE  mentorness.dbo.Hotel_Reservation2
ALTER COLUMN NO_of_weekend_nights int

ALTER TABLE  mentorness.dbo.Hotel_Reservation2
ALTER COLUMN NO_of_week_nights int


-- Add a new decimal column to replace the avg_price_per_room which is varchar

ALTER TABLE Mentorness.dbo.hotel_reservation2
ADD [Avg Price Per Room] DECIMAL(10, 2)

-- Update the new column with converted values

UPDATE Mentorness.dbo.Hotel_Reservation2
SET [avg price per room] = CAST(avg_price_per_room AS DECIMAL(10, 2))

-- Drop the old varchar column
ALTER TABLE Mentorness.dbo.hotel_reservation2
DROP COLUMN [Avg_Price_Per_Room];

-- Rename the new column to Avg_price
EXEC sp_rename 'Mentorness.dbo.hotel_reservation2.[avg price per room]', 'avg_price_per_room', 'COLUMN';

-------- To do list:  -- here we go --

-- 1. What is the total number of reservations in the dataset?

SELECT COUNT (*) AS [Total Number of Reservations]
FROM mentorness.dbo.Hotel_Reservation2 

-- 1. What is the total number of reservations in the dataset? ("Confirmed" Only This time to prove my Attention to details skill :)


SELECT COUNT (*) AS [Total Number of Confirmed Reservations]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [booking_status] = 'Confirmed'

SELECT COUNT (*) AS [Total Number of Canceled Reservations]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [booking_status] != 'Confirmed'

--2. Which meal plan is the most popular among guests?

SELECT TOP 3
    [type_of_meal_plan] AS [Meal Plan],
    COUNT(*) AS [Reservation Count]
FROM
    mentorness.dbo.Hotel_Reservation2 
GROUP BY
    [type_of_meal_plan]
ORDER BY
    [Reservation Count] DESC;

--3. What is the average price per room for reservations involving children?

SELECT
    AVG([Avg Price Per Room]) AS [Average Price Per Room]
FROM
    mentorness.dbo.Hotel_Reservation2 
WHERE
    [no_of_children] > 0

--4. How many reservations were made for the year 20XX (replace XX with the desired year)? --> xx = 18

SELECT COUNT(*) AS [Booking_ID]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE YEAR([Arrival Date]) = 2018 

--4. How many "Confirmed" reservations were made for the year 20XX (replace XX with the desired year)? --> xx = 18 


SELECT COUNT(*) AS [Booking_ID]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE YEAR([Arrival Date]) = 2018 AND [booking_status] = 'Confirmed'

--5. What is the most commonly booked room type? (Including the "Canceled" reservations)

SELECT TOP 6 [room_type_reserved], COUNT(*) AS ReservationCount
FROM mentorness.dbo.Hotel_Reservation2 
GROUP BY [room_type_reserved]
ORDER BY ReservationCount DESC;

--5. What is the most commonly booked room type? (Confirmed reservations only)

SELECT TOP 6 [room_type_reserved], COUNT(*) AS ReservationCount
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [booking_status] = 'Confirmed'
GROUP BY [room_type_reserved]
ORDER BY ReservationCount DESC

--6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?

SELECT COUNT(*) AS [Weekend Reservations]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [no_of_weekend_nights] > 0;

--6. How many "Confirmed" reservations fall on a weekend (no_of_weekend_nights > 0)?

SELECT COUNT(*) AS [Weekend Reservations]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [no_of_weekend_nights] > 0 AND [booking_status] = 'Confirmed'

--7. What is the highest and lowest lead time for reservations?

SELECT MAX(lead_time) AS [Highest Lead Time], MIN(lead_time) AS [Lowest Lead Time]
FROM mentorness.dbo.Hotel_Reservation2 

--7. What is the highest and lowest lead time for "Confirmed" reservations?

SELECT MAX(lead_time) AS [Highest Lead Time], MIN(lead_time) AS [Lowest Lead Time]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [no_of_weekend_nights] > 0 AND [booking_status] = 'Confirmed'

--8.What is the most common market segment type for reservations?

SELECT TOP 5 [market_segment_type], COUNT(*) AS [Reservation Count]
FROM mentorness.dbo.Hotel_Reservation2 
GROUP BY [market_segment_type]
ORDER BY [Reservation Count] DESC

--9.How many reservations have a booking status of "Confirmed"? 

SELECT COUNT(*) AS [Confirmed Reservations]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [booking_status] = 'Confirmed'

--10. What is the total number of adults and children across all reservations?

SELECT SUM([no_of_adults]) AS [Total Adults], SUM([no_of_children]) AS [Total Children]
FROM mentorness.dbo.Hotel_Reservation2

--11. What is the average number of weekend nights for reservations involving children?

SELECT AVG(no_of_weekend_nights) AS [Average Weekend Nights With Children]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [no_of_children] > 0 

--12. How many reservations were made in each month of the year? (Basic)

SELECT MONTH([Arrival date]) AS [Reservation Month], COUNT(*) AS [Reservation Count]
FROM mentorness.dbo.Hotel_Reservation2 
GROUP BY MONTH([Arrival date])
ORDER BY [Reservation Month]

--12. How many "Confirmed" reservations were made in each month of the year? 

SELECT MONTH([Arrival date]) AS [Reservation Month], COUNT(*) AS [Reservation Count]
FROM mentorness.dbo.Hotel_Reservation2 
WHERE [booking_status] = 'Confirmed'
GROUP BY MONTH([Arrival date])
ORDER BY [Reservation Month]

--12. How many reservations were made in each month of the year? (More advanced)


	SELECT
    CASE
        WHEN MONTH([Arrival date]) = 1 THEN 'JAN'
        WHEN MONTH([Arrival date]) = 2 THEN 'FEB'
        WHEN MONTH([Arrival date]) = 3 THEN 'MAR'
        WHEN MONTH([Arrival date]) = 4 THEN 'APR'
        WHEN MONTH([Arrival date]) = 5 THEN 'MAY'
		WHEN MONTH([Arrival date]) = 6 THEN 'JUN'
        WHEN MONTH([Arrival date]) = 7 THEN 'JUL'
        WHEN MONTH([Arrival date]) = 8 THEN 'AUG'
        WHEN MONTH([Arrival date]) = 9 THEN 'SEP'
        WHEN MONTH([Arrival date]) = 10 THEN 'OCT'
        WHEN MONTH([Arrival date]) = 11 THEN 'NOV'
        WHEN MONTH([Arrival date]) = 12 THEN 'DEC'

    END AS [Reservation Month],
    COUNT(*) AS [Reservation Count]
FROM
    mentorness.dbo.Hotel_Reservation2 
GROUP BY
    MONTH([Arrival date])
ORDER BY
    MONTH([Arrival date])

--12. How many "Confirmed" reservations were made in each month of the year?
	SELECT
    CASE
        WHEN MONTH([Arrival date]) = 1 THEN 'JAN'
        WHEN MONTH([Arrival date]) = 2 THEN 'FEB'
        WHEN MONTH([Arrival date]) = 3 THEN 'MAR'
        WHEN MONTH([Arrival date]) = 4 THEN 'APR'
        WHEN MONTH([Arrival date]) = 5 THEN 'MAY'
		WHEN MONTH([Arrival date]) = 6 THEN 'JUN'
        WHEN MONTH([Arrival date]) = 7 THEN 'JUL'
        WHEN MONTH([Arrival date]) = 8 THEN 'AUG'
        WHEN MONTH([Arrival date]) = 9 THEN 'SEP'
        WHEN MONTH([Arrival date]) = 10 THEN 'OCT'
        WHEN MONTH([Arrival date]) = 11 THEN 'NOV'
        WHEN MONTH([Arrival date]) = 12 THEN 'DEC'

    END AS [Reservation Month],
    COUNT(*) AS [Reservation Count]
FROM
    mentorness.dbo.Hotel_Reservation2 
WHERE 
	[booking_status] = 'Confirmed'

GROUP BY
    MONTH([Arrival date])
ORDER BY
    MONTH([Arrival date])

--13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?

SELECT
    [room_type_reserved] AS [Room Type],
    AVG([no_of_week_nights] + [no_of_weekend_nights]) AS [Average Nights]
FROM
    mentorness.dbo.Hotel_Reservation2
GROUP BY
    [room_type_reserved]

--14. For reservations involving children, what is the most common room type, and what is the average price for that room type?

	SELECT TOP 1
    [room_type_reserved] AS [Room Type],
   [Avg Price Per Room] AS AveragePrice
FROM
    mentorness.dbo.Hotel_Reservation2
WHERE
    [no_of_children] > 0
GROUP BY
    [room_type_reserved], [Avg Price Per Room]
ORDER BY
    COUNT(*) DESC
	
-- 15. Find the market segment type that generates the highest average price per room.

SELECT TOP 1
    [market_segment_type] AS [Market Segment Type],
    [Avg Price Per Room] AS [Average Price Per Room]
FROM
    mentorness.dbo.Hotel_Reservation2
GROUP BY
    [market_segment_type], [Avg Price Per Room]
ORDER BY
    [Avg Price Per Room] DESC
	--------------------------------------------------------------------------------------


SELECT [Booking_ID] AS [Booking ID]
      ,[no_of_adults] AS [Number of Adults]
      ,[no_of_children] AS [Number of Children]
      ,[no_of_weekend_nights] AS [Number of Weekend Nights]
      ,[no_of_week_nights] AS [Number of Week Nights]
	  ,[Arrival date]
      ,[type_of_meal_plan] AS [Type of Meal Plan]
      ,[room_type_reserved] AS [Room Type Reserved]
      ,[lead_time] AS [Lead Time]
	  ,[Avg Price Per Room]
      ,[market_segment_type] AS [Market Segment Type]
      ,[booking_status] AS [Booking Status]
		FROM mentorness.dbo.Hotel_Reservation2      