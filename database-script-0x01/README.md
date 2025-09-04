# Seed Data for AirBnB Database

This document provides example SQL statements to populate the schema with **sample data** for testing.

## Users

```sql
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, role)
VALUES
  (gen_random_uuid(), 'Alice', 'Johnson', 'alice@example.com', 'hashed_pw_1', 'guest'),
  (gen_random_uuid(), 'Bob', 'Smith', 'bob@example.com', 'hashed_pw_2', 'host'),
  (gen_random_uuid(), 'Carol', 'Lee', 'carol@example.com', 'hashed_pw_3', 'admin');
```

## Locations

```sql
INSERT INTO Location (location_id, country, city, address, postal_code)
VALUES
  (gen_random_uuid(), 'USA', 'New York', '123 Broadway', '10001'),
  (gen_random_uuid(), 'France', 'Paris', '45 Rue de Rivoli', '75001');
```

## Properties

```sql
-- Assume Bob (host) is the second user
INSERT INTO Property (property_id, host_id, name, description, location_id, pricepernight)
VALUES
  (gen_random_uuid(), (SELECT user_id FROM "User" WHERE email = 'bob@example.com'),
   'Central Park Apartment', 'A cozy apartment near Central Park.',
   (SELECT location_id FROM Location WHERE city = 'New York'),
   150.00),

  (gen_random_uuid(), (SELECT user_id FROM "User" WHERE email = 'bob@example.com'),
   'Eiffel Tower View', 'Beautiful flat with a view of the Eiffel Tower.',
   (SELECT location_id FROM Location WHERE city = 'Paris'),
   200.00);
```

## Bookings

```sql
-- Assume Alice (guest) books Central Park Apartment
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, status)
VALUES
  (gen_random_uuid(),
   (SELECT property_id FROM Property WHERE name = 'Central Park Apartment'),
   (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
   '2025-09-10', '2025-09-15', 'confirmed');
```

## Payments

```sql
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES
  (gen_random_uuid(),
   (SELECT booking_id FROM Booking WHERE start_date = '2025-09-10'),
   750.00, 'credit_card');
```

## Reviews

```sql
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES
  (gen_random_uuid(),
   (SELECT property_id FROM Property WHERE name = 'Central Park Apartment'),
   (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
   5, 'Amazing place, highly recommend!');
```

## Messages

```sql
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
  (gen_random_uuid(),
   (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
   (SELECT user_id FROM "User" WHERE email = 'bob@example.com'),
   'Hi Bob, I’m excited about my upcoming stay!');
```
