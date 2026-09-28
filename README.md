# Hotel Reservation Operations Analytics

## Project Overview

This project analyzes hotel reservation and operations data using MySQL. The SQL script explores booking demand, guest booking behaviour, stay performance, staff performance, room performance, revenue, and operational issues.

The project was developed and executed using **MySQL 8.0 / MySQL Workbench**.

## Author

**Harshini Valeti**

## Objectives

- OBJECTIVE 1: DATABASE SETUP AND TABLE CREATION
- OBJECTIVE 2: DATABASE EXPLORATION AND DATA VALIDATION
- OBJECTIVE 3: UNDERSTANDING BOOKING DEMAND
- OBJECTIVE 4: ANALYSING GUEST BOOKING BEHAVIOUR
- OBJECTIVE 5: STAY PERFORMANCE AND HOTEL OPERATIONS
- OBJECTIVE 6: STAFF AND ROOM PERFORMANCE
- OBJECTIVE 7: IDENTIFYING OPERATIONAL ISSUES
- OBJECTIVE 8: FINAL BUSINESS SUMMARY

## Database Tables

The project uses the following tables:

- `hotels`
- `guests`
- `staff`
- `rooms`
- `bookings`
- `stays`

## Analysis Performed

### Booking Demand
- Compared booking volumes across hotels.
- Analyzed booking channels and their revenue contribution.
- Examined requested room types.
- Analyzed booking demand by year and month.
- Compared booking value and total revenue across hotels.

### Guest Booking Behaviour
- Compared booking activity by guest type.
- Analyzed revenue across guest types and loyalty tiers.
- Compared bookings by guest city.
- Calculated average booking value by guest type.
- Identified high-value guests using total booking spend.

### Stay Performance and Operations
- Analyzed stays by status.
- Calculated average nights stayed and average stay duration.
- Compared stay volume across hotels.
- Examined service-request activity.
- Compared stay performance by room type.

### Staff and Room Performance
- Analyzed staff counts by department.
- Compared average staff ratings by department.
- Measured stay workload handled by staff members.
- Reviewed room records by hotel.
- Compared booking revenue by requested room type.
- Calculated average room prices by room type and hotel.

### Operational Issues
- Reviewed stay-status distributions.
- Calculated hotel-level cancellation/no-show rates where included in the script.
- Identified stays with unusually high service-request counts.
- Examined staff workload.
- Checked inactive staff associations with stays.
- Compared service-request levels across hotels.

### Final Business Summary

The final query provides an overall snapshot containing:
- Total hotels
- Total guests
- Total staff
- Total rooms
- Total bookings
- Total stays
- Total booking revenue
- Average nights stayed

## SQL Concepts Used

- `SELECT`
- `WHERE`
- `JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `ORDER BY`
- `COUNT`
- `SUM`
- `AVG`
- `ROUND`
- `CASE`
- `DISTINCT`
- `Subqueries`

## Tools Used

- **MySQL 8.0**
- **MySQL Workbench**
- **SQL**
- **Git**
- **GitHub**

## Project Structure

```text
hotel-reservation-analytics/
├── Hotel_Reservation_Analytics.sql
└── README.md
```

## How to Run

1. Install MySQL 8.0 and MySQL Workbench.
2. Open `Hotel_Reservation_Analytics.sql` in MySQL Workbench.
3. Select the project database as specified in the script.
4. Execute the setup/data-loading sections when required.
5. Run the analysis queries section by section.
6. Review the results in the MySQL Workbench result grids.

## Project Outcome

The project demonstrates how SQL can be used to analyze hotel reservation data and produce business-oriented insights related to booking demand, guest behaviour, revenue, stays, staff workload, room performance, and operational patterns.

## Author

**Harshini Valeti**
