-- ============================================
-- PROJECT: HOTEL RESERVATION OPERATIONS ANALYTICS
-- ============================================
-- Step1: Create and select the project Database
CREATE DATABASE hotel_reservation_analytics;

USE hotel_reservation_analytics;
SELECT DATABASE();

-- ============================================
-- OBJECTIVE 1: DATABASE SETUP AND TABLE CREATION
-- ============================================

CREATE TABLE hotels (
    hotel_id VARCHAR(10) PRIMARY KEY,
    hotel_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    star_rating INT,
    total_rooms INT,
    opened_date DATE
);

CREATE TABLE guests (
    guest_id VARCHAR(10) PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    guest_type VARCHAR(50),
    preferred_room_type VARCHAR(50),
    loyalty_tier VARCHAR(50),
    account_since VARCHAR(20)
);

CREATE TABLE staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    hire_date DATE,
    rating DECIMAL(3,2),
    department VARCHAR(100),
    is_active VARCHAR(10)
);

CREATE TABLE rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    hotel_id VARCHAR(10) NOT NULL,
    room_type VARCHAR(50),
    floor_number INT,
    max_occupancy INT,
    price_per_night DECIMAL(10,2),
    is_active VARCHAR(10),

    CONSTRAINT fk_rooms_hotels
        FOREIGN KEY (hotel_id)
        REFERENCES hotels(hotel_id)
);

CREATE TABLE bookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    guest_id VARCHAR(10) NOT NULL,
    hotel_id VARCHAR(10) NOT NULL,
    booking_date VARCHAR(20),
    room_type_requested VARCHAR(50),
    booking_channel VARCHAR(50),
    nights_booked INT,
    total_amount DECIMAL(12,2),

    CONSTRAINT fk_bookings_guests
        FOREIGN KEY (guest_id)
        REFERENCES guests(guest_id),

    CONSTRAINT fk_bookings_hotels
        FOREIGN KEY (hotel_id)
        REFERENCES hotels(hotel_id)
);

CREATE TABLE stays (
    stay_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10) NOT NULL,
    room_id VARCHAR(10),
    staff_id VARCHAR(10),
    check_in_date DATE,
    check_out_date DATE,
    status VARCHAR(50),
    nights_stayed INT,
    service_requests INT,
    stay_duration_hrs INT,

    CONSTRAINT fk_stays_bookings
        FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id),

    CONSTRAINT fk_stays_rooms
        FOREIGN KEY (room_id)
        REFERENCES rooms(room_id),

    CONSTRAINT fk_stays_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
);

SHOW TABLES;

SELECT
    TABLE_NAME
FROM information_schema.tables
WHERE table_schema = 'hotel_reservation_analytics';

SELECT COUNT(*) AS total_hotels
FROM hotels;

SELECT *
FROM hotels
LIMIT 5;

SELECT 'hotels' AS table_name, COUNT(*) AS total_rows FROM hotels
UNION ALL
SELECT 'guests', COUNT(*) FROM guests
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'stays', COUNT(*) FROM stays;

SELECT * FROM hotels LIMIT 5;
SELECT * FROM guests LIMIT 5;
SELECT * FROM staff LIMIT 5;
SELECT * FROM rooms LIMIT 5;
SELECT * FROM bookings LIMIT 5;
SELECT * FROM stays LIMIT 5;


SELECT 
    g.guest_id,
    g.guest_name,
    b.booking_id,
    b.total_amount
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
LIMIT 10;

SELECT
    h.hotel_name,
    r.room_id,
    r.room_type
FROM hotels h
JOIN rooms r
    ON h.hotel_id = r.hotel_id
LIMIT 10;

SELECT
    b.booking_id,
    b.booking_channel,
    s.stay_id,
    s.status
FROM bookings b
JOIN stays s
    ON b.booking_id = s.booking_id
LIMIT 10;

-- ============================================
-- OBJECTIVE 2 : DATABASE EXPLORATION AND DATA VALIDATION
-- ============================================

-- Q1: Count the total number of guests?
SELECT COUNT(*) AS total_guests
FROM guests;

-- Q2: Count the total number of bookings?
SELECT COUNT(*) AS total_bookings
FROM bookings;

-- Q3: Count the total number of stays?
SELECT COUNT(*) AS total_stays
FROM stays;

-- Q4: List the distinct room types available in the rooms table?
SELECT DISTINCT room_type
FROM rooms;

-- Q5: Identify staff activity statuses and count active staff members?
SELECT DISTINCT is_active
FROM staff;

SELECT COUNT(*) AS active_staff
FROM staff
WHERE is_active = 'Yes';

-- Q6: List the distinct booking channels used?
SELECT DISTINCT booking_channel
FROM bookings;

-- Q7: Calculate the total booking amount (revenue)?
SELECT SUM(total_amount) AS total_booking_amount
FROM bookings;

-- Q8: Calculate the average number of nights booked?
SELECT AVG(nights_booked) AS average_nights_booked
FROM bookings;

-- ============================================
-- BUSINESS ANALYSIS QUERIES
-- ============================================

-- ============================================
-- OBJECTIVE 3: UNDERSTAND BOOKING DEMAND
-- ============================================

-- Q1: Which hotels receive the most bookings?
SELECT 
    h.hotel_id,
    h.hotel_name,
    COUNT(b.booking_id) AS total_bookings
FROM hotels h
LEFT JOIN bookings b
    ON h.hotel_id = b.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_bookings DESC;

-- Q2: Which booking channels generate the most bookings?

SELECT 
    booking_channel,
    COUNT(booking_id) AS total_bookings
FROM bookings
GROUP BY booking_channel
ORDER BY total_bookings DESC;

-- Q3: Which booking channels generate the highest revenue?

SELECT 
    booking_channel,
    SUM(total_amount) AS total_revenue
FROM bookings
GROUP BY booking_channel
ORDER BY total_revenue DESC;

-- Q4: Which room types are requested most frequently?

SELECT 
    room_type_requested,
    COUNT(booking_id) AS total_requests
FROM bookings
GROUP BY room_type_requested
ORDER BY total_requests DESC;

-- Q5: How does booking demand change from year to year?

SELECT 
    YEAR(STR_TO_DATE(booking_date, '%d-%m-%Y')) AS booking_year,
    COUNT(booking_id) AS total_bookings
FROM bookings
GROUP BY booking_year
ORDER BY booking_year;

-- Q6: How many bokkings are made in each month?

SELECT 
    YEAR(STR_TO_DATE(booking_date, '%d-%m-%Y')) AS booking_year,
    MONTH(STR_TO_DATE(booking_date, '%d-%m-%Y')) AS booking_month,
    COUNT(booking_id) AS total_bookings
FROM bookings
GROUP BY booking_year, booking_month
ORDER BY booking_year, booking_month;

-- Q7: What are the bokking count,average booking value, and total revenue for each hotel?

SELECT 
    h.hotel_name,
    COUNT(b.booking_id) AS total_bookings,
    AVG(b.total_amount) AS average_booking_value,
    SUM(b.total_amount) AS total_revenue
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_revenue DESC;

-- ============================================
-- OBJECTIVE 4: ANALYSING GUEST BOOKING BEHAVIOUR
-- ============================================

-- Q1: Which guest types make the most bookings?
SELECT 
    g.guest_type,
    COUNT(b.booking_id) AS total_bookings
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.guest_type
ORDER BY total_bookings DESC;

-- Q2: Which guest types generate the most revenue?
SELECT 
    g.guest_type,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.guest_type
ORDER BY total_revenue DESC;

-- Q3: How does revenue vary across loyality tiers?
SELECT 
    g.loyalty_tier,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.loyalty_tier
ORDER BY total_revenue DESC;

-- Q4: Which guest cities account for the most bookings?
SELECT 
    g.city,
    COUNT(b.booking_id) AS total_bookings
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.city
ORDER BY total_bookings DESC
LIMIT 10;

-- Q5: What is the average booking value for each guest type?
SELECT 
    g.guest_type,
    ROUND(AVG(b.total_amount), 2) AS average_booking_value
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.guest_type
ORDER BY average_booking_value DESC;

-- Q6: Which guests have the highest total booking spend ?
SELECT 
    g.guest_id,
    g.guest_name,
    g.guest_type,
    g.loyalty_tier,
    COUNT(b.booking_id) AS total_bookings,
    ROUND(SUM(b.total_amount), 2) AS total_spent
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY 
    g.guest_id,
    g.guest_name,
    g.guest_type,
    g.loyalty_tier
ORDER BY total_spent DESC
LIMIT 10;

-- ============================================
-- OBJECTIVE 5: STAY PERFORMANCE & HOTEL OPERATIONS
-- ============================================

-- Q1: How many stays fall into each status category?
SELECT 
    status,
    COUNT(stay_id) AS total_stays
FROM stays
GROUP BY status
ORDER BY total_stays DESC;

-- Q2: What is the average number of nights per stay?
SELECT 
    ROUND(AVG(nights_stayed), 2) AS average_nights_stayed
FROM stays;

-- Q3: What is the average stay duration in hours?
SELECT 
    ROUND(AVG(stay_duration_hrs), 2) AS average_stay_duration_hours
FROM stays;

-- Q4: Which hotels records the highest number of stays?
SELECT 
    h.hotel_name,
    COUNT(s.stay_id) AS total_stays
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_stays DESC;

-- Q5: Which hotels have the longest average stay?
SELECT 
    h.hotel_name,
    ROUND(AVG(s.nights_stayed), 2) AS average_nights_stayed
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY average_nights_stayed DESC;

-- Q6: Which stays have the highest number of service requests?
SELECT 
    s.stay_id,
    s.booking_id,
    s.service_requests,
    s.nights_stayed,
    s.status
FROM stays s
ORDER BY s.service_requests DESC
LIMIT 10;

-- Q7: What is the average service-requests for each stay status?
SELECT 
    status,
    ROUND(AVG(service_requests), 2) AS average_service_requests
FROM stays
GROUP BY status
ORDER BY average_service_requests DESC;

-- Q8: Which room types have the longest average stays?
SELECT 
    r.room_type,
    COUNT(s.stay_id) AS total_stays,
    ROUND(AVG(s.nights_stayed), 2) AS average_nights_stayed
FROM stays s
JOIN rooms r
    ON s.room_id = r.room_id
GROUP BY r.room_type
ORDER BY average_nights_stayed DESC;

-- ============================================
-- OBJECTIVE 6: STAFF AND ROOM PERFORMANCE
-- ============================================

-- Q1: How many staff members work in  each department?
SELECT 
    department,
    COUNT(staff_id) AS total_staff
FROM staff
GROUP BY department
ORDER BY total_staff DESC;

-- Q2: What is the average staff rating in each department?
SELECT 
    department,
    ROUND(AVG(rating), 2) AS average_staff_rating
FROM staff
GROUP BY department
ORDER BY average_staff_rating DESC;

-- Q3: How many stays and has each staff member handled?
SELECT 
    st.staff_id,
    st.staff_name,
    st.department,
    COUNT(s.stay_id) AS total_stays_handled
FROM staff st
LEFT JOIN stays s
    ON st.staff_id = s.staff_id
GROUP BY 
    st.staff_id,
    st.staff_name,
    st.department
ORDER BY total_stays_handled DESC;

-- Q4: Which staff members handled the most stays?
SELECT 
    st.staff_id,
    st.staff_name,
    st.department,
    COUNT(s.stay_id) AS total_stays_handled
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id
GROUP BY 
    st.staff_id,
    st.staff_name,
    st.department
ORDER BY total_stays_handled DESC
LIMIT 10;

-- Q5: How many rooms records are associated with each hotel?
SELECT 
    h.hotel_name,
    COUNT(r.room_id) AS total_rooms
FROM hotels h
LEFT JOIN rooms r
    ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_rooms DESC;

-- Q6: Which requested room types generate the most booking revenue?
SELECT 
    room_type_requested,
    COUNT(booking_id) AS total_bookings,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM bookings
GROUP BY room_type_requested
ORDER BY total_revenue DESC;

-- Q7: What is the average nightly price for each room type?
SELECT 
    room_type,
    ROUND(AVG(price_per_night), 2) AS average_price_per_night
FROM rooms
GROUP BY room_type
ORDER BY average_price_per_night DESC;

-- Q8: Which hotels have the highest average room prices?
SELECT 
    h.hotel_name,
    ROUND(AVG(r.price_per_night), 2) AS average_room_price
FROM hotels h
JOIN rooms r
    ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY average_room_price DESC;

-- ============================================
-- OBJECTIVE 7: IDENTIFYING OPERATIONAL ISSUES
-- ============================================

-- Q1:Count stays by status to review the distrubution of outcomes?
SELECT 
    status,
    COUNT(*) AS total_stays
FROM stays
GROUP BY status
ORDER BY total_stays DESC;

-- Q2:Calculate each hotel's cancellation/no-show rate?
SELECT 
    h.hotel_name,
    COUNT(s.stay_id) AS total_stays,
    SUM(CASE 
        WHEN s.status IN ('Cancelled', 'No Show') THEN 1 
        ELSE 0 
    END) AS problem_stays,
    ROUND(
        100.0 * SUM(CASE 
            WHEN s.status IN ('Cancelled', 'No Show') THEN 1 
            ELSE 0 
        END) / COUNT(s.stay_id),
        2
    ) AS problem_rate_percentage
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY problem_rate_percentage DESC;

-- Q3: find stays with service requests above the overall average?
    SELECT 
    stay_id,
    booking_id,
    service_requests,
    nights_stayed,
    status
FROM stays
WHERE service_requests > (
    SELECT AVG(service_requests)
    FROM stays
)
ORDER BY service_requests DESC;

-- Q4:Identify staff members with the largest recorded stay workloads?
SELECT 
    st.staff_id,
    st.staff_name,
    st.department,
    COUNT(s.stay_id) AS total_stays_handled
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id
GROUP BY 
    st.staff_id,
    st.staff_name,
    st.department
ORDER BY total_stays_handled DESC
LIMIT 10;

-- Q5: Check whether any inactive staff members are linked to stays?
SELECT 
    st.staff_id,
    st.staff_name,
    st.is_active,
    COUNT(s.stay_id) AS stays_handled
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id
WHERE st.is_active = 'No'
GROUP BY 
    st.staff_id,
    st.staff_name,
    st.is_active
ORDER BY stays_handled DESC;

-- Q6: Compare average serviece-request levels across hotels?
SELECT 
    h.hotel_name,
    COUNT(s.stay_id) AS total_stays,
    ROUND(AVG(s.service_requests), 2) AS average_service_requests
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY average_service_requests DESC;

-- ---------------------------------------------
-- OBJECTIVE 8 : FINAL BUSINESS SUMMARY
-- ---------------------------------------------
SELECT
    (SELECT COUNT(*) FROM hotels) AS total_hotels,
    (SELECT COUNT(*) FROM guests) AS total_guests,
    (SELECT COUNT(*) FROM staff) AS total_staff,
    (SELECT COUNT(*) FROM rooms) AS total_rooms,
    (SELECT COUNT(*) FROM bookings) AS total_bookings,
    (SELECT COUNT(*) FROM stays) AS total_stays,
    (SELECT ROUND(SUM(total_amount), 2) FROM bookings) AS total_revenue,
    (SELECT ROUND(AVG(nights_stayed), 2) FROM stays) AS average_nights_stayed;



