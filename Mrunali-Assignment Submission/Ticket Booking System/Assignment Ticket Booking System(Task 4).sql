--Task 4
SELECT * FROM Venues;
SELECT * FROM Bookings;
SELECT * FROM Customers;
SELECT * FROM Events;

--1) Calculate the Average Ticket Price for Events in Each Venue Using a Subquery.
SELECT (SELECT AVG(ticket_price) 
        FROM Events 
	    WHERE Events.venue_id=Venues.venue_id) AS Average_Ticket,
		venue_name
From Venues

--2) Find Events with More Than 50% of Tickets Sold using subquery.
--without subquery
SELECT event_id, event_name, total_seats, available_seats,
       (total_seats - available_seats) AS tickets_sold
FROM Events
WHERE (total_seats - available_seats) >= (total_seats / 2);

--with subquery
SELECT event_name, total_seats, available_seats,
      (total_seats - available_seats) AS tickets_sold
FROM Events
WHERE (total_seats - available_seats) >= (SELECT (total_seats / 2));

--3) Calculate the Total Number of Tickets Sold for Each Event.
SELECT event_id, event_name,
      (total_seats - available_seats) AS tickets_sold
FROM Events;

--4) Find Users Who Have Not Booked Any Tickets Using a NOT EXISTS Subquery.
SELECT customer_id,customer_name
FROM Customers c
WHERE NOT EXISTS 
(SELECT b.customer_id 
FROM Bookings b
WHERE b.customer_id=c.customer_id
);

--5) List Events with No Ticket Sales Using a NOT IN Subquery.
SELECT event_id,event_name
FROM Events
WHERE event_id NOT IN(
	SELECT event_id 
	FROM Bookings);


--6) Calculate the Total Number of Tickets Sold for Each Event Type Using a Subquery in the FROM Clause.
SELECT event_type,
	  SUM(tickets_sold) AS Total_ticket_sold
FROM (
	 SELECT event_type, (total_seats - available_seats) AS tickets_sold
	 FROM Events
	 ) AS Sales
GROUP BY event_type;

--7) Find Events with Ticket Prices Higher Than the Average Ticket Price Using a Subquery in the WHERE Clause.
SELECT AVG(ticket_price) AS Avg_ticket_price
FROM Events;

SELECT event_id, event_name,ticket_price
FROM Events
WHERE ticket_price>(SELECT AVG(ticket_price) AS Avg_ticket_price FROM Events );

--8) Calculate the Total Revenue Generated by Events for Each User Using a Correlated Subquery.
SELECT c.customer_id, 
       c.customer_name,
       (SELECT SUM(e.ticket_price * b.num_tickets)
        FROM Bookings b
        JOIN Events e ON b.event_id = e.event_id
        WHERE b.customer_id = c.customer_id) AS total_revenue
FROM Customers c;

--9) List Users Who Have Booked Tickets for Events in a Given Venue Using a Subquery in the WHERE Clause.
SELECT c.customer_id, 
       c.customer_name
FROM Customers c
WHERE c.customer_id IN (
    SELECT b.customer_id
    FROM Bookings b
    JOIN Events e ON b.event_id = e.event_id
    WHERE e.venue_id = 5
);

--10) Calculate the Total Number of Tickets Sold for Each Event Category Using a Subquery with GROUP BY.
--(same as 6)
SELECT event_type, 
       SUM(tickets_sold) AS total_tickets_sold
FROM (SELECT event_type, 
             (total_seats - available_seats) AS tickets_sold
      FROM Events
      ) AS Sales
GROUP BY event_type;

--11) Find Users Who Have Booked Tickets for Events in each Month Using a Subquery with DATE_FORMAT.
SELECT c.customer_id, 
       c.customer_name, 
       FORMAT(e.event_date, 'yyyy-MM') AS event_month
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
JOIN Events e ON b.event_id = e.event_id
GROUP BY c.customer_id, c.customer_name, FORMAT(e.event_date, 'yyyy-MM');

--12) Calculate the Average Ticket Price for Events in Each Venue Using a Subquery
SELECT v.venue_id, 
       v.venue_name, 
       (SELECT AVG(e.ticket_price) 
        FROM Events e 
        WHERE e.venue_id = v.venue_id) AS average_ticket_price
FROM Venues v;