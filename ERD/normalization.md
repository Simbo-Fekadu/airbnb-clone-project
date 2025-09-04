# normalization.md

## Objective

Apply normalization principles to ensure the AirBnB database schema is in **Third Normal Form (3NF)**. This document reviews the schema, identifies redundancies/violations, describes normalization steps taken, and presents the final 3NF-compliant schema with SQL DDL snippets.

---

## Original schema summary

Tables: `User`, `Property`, `Booking`, `Payment`, `Review`, `Message`.

Key attributes that needed review:

- `Property.location` (free-text) — potential repeated or multi-part data
- `Booking.total_price` — derived attribute (nights × pricepernight)

Other tables were already mostly atomic with single-column PKs.

---

## Analysis: potential normalization issues

1. **Derived attribute**: `Booking.total_price` can be computed from `start_date`, `end_date`, and `Property.pricepernight`. Storing derived values introduces update anomalies (if price changes or dates are edited).

2. **Non-atomic / multi-part data**: `Property.location` as a single `VARCHAR` may contain several data points (address, city, country, postal code). This violates the spirit of atomicity and may cause redundant storage across properties in the same city/country.

3. **No transitive dependencies detected** in other tables because each table uses a single-column primary key. However, if `location` remained embedded, attributes like `city`/`country` could create transitive dependencies depending on usage.

---

## Normalization decisions and steps

Applied normalization rules up to **3NF**:

1. **1NF**: The original design already satisfied 1NF — all attributes are atomic and each row unique (UUID PKs).

2. **2NF**: Single-column PKs exist on all tables, so no partial dependencies.

3. **3NF**: Removed transitive and derived dependencies:

   - **Remove `Booking.total_price`**: `total_price` is derived; removed to prevent update anomalies. It can be calculated at read-time or maintained by application logic / a safe denormalized column with triggers if performance requires it.
   - **Normalize `Property.location`** into a separate `Location` table\*\*. This avoids repeating city/country text across properties and enables structured address fields (country, city, address, postal_code, latitude, longitude). `Property` references `Location(location_id)`.

4. **Indexes & Constraints**: Keep unique and FK constraints. Add indexes on commonly queried fields (e.g., `User.email`, `Property.host_id`, `Booking.property_id`, `Payment.booking_id`).

---

## Final 3NF Schema (Tables list)

1. `User`
2. `Location` (new)
3. `Property` (references `Location`)
4. `Booking` (removed `total_price`)
5. `Payment`
6. `Review`
7. `Message`

---

## SQL DDL (3NF-compliant)

Below are example DDL snippets (Postgres-flavored) for the final schema. Adjust types and `ON UPDATE` syntax for your target RDBMS as needed.

```sql
-- 1. User
CREATE TABLE "User" (
  user_id UUID PRIMARY KEY,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  email VARCHAR UNIQUE NOT NULL,
  password_hash VARCHAR NOT NULL,
  phone_number VARCHAR,
  role VARCHAR NOT NULL CHECK (role IN ('guest','host','admin')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Location
CREATE TABLE Location (
  location_id UUID PRIMARY KEY,
  country VARCHAR NOT NULL,
  city VARCHAR NOT NULL,
  address VARCHAR NOT NULL,
  postal_code VARCHAR,
  latitude DECIMAL,
  longitude DECIMAL
);

-- 3. Property
CREATE TABLE Property (
  property_id UUID PRIMARY KEY,
  host_id UUID NOT NULL REFERENCES "User"(user_id),
  name VARCHAR NOT NULL,
  description TEXT NOT NULL,
  location_id UUID NOT NULL REFERENCES Location(location_id),
  pricepernight DECIMAL NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Booking
CREATE TABLE Booking (
  booking_id UUID PRIMARY KEY,
  property_id UUID NOT NULL REFERENCES Property(property_id),
  user_id UUID NOT NULL REFERENCES "User"(user_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status VARCHAR NOT NULL CHECK (status IN ('pending','confirmed','canceled')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Payment
CREATE TABLE Payment (
  payment_id UUID PRIMARY KEY,
  booking_id UUID NOT NULL REFERENCES Booking(booking_id),
  amount DECIMAL NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  payment_method VARCHAR NOT NULL CHECK (payment_method IN ('credit_card','paypal','stripe'))
);

-- 6. Review
CREATE TABLE Review (
  review_id UUID PRIMARY KEY,
  property_id UUID NOT NULL REFERENCES Property(property_id),
  user_id UUID NOT NULL REFERENCES "User"(user_id),
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Message
CREATE TABLE Message (
  message_id UUID PRIMARY KEY,
  sender_id UUID NOT NULL REFERENCES "User"(user_id),
  recipient_id UUID NOT NULL REFERENCES "User"(user_id),
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Recommended indexes
CREATE INDEX idx_user_email ON "User"(email);
CREATE INDEX idx_property_host ON Property(host_id);
CREATE INDEX idx_booking_property ON Booking(property_id);
CREATE INDEX idx_payment_booking ON Payment(booking_id);
```

---

## Notes & Trade-offs

- **Derived values**: `total_price` removed to avoid anomalies. If you need it for reporting or performance, consider a materialized view or storing it with a trigger that keeps it consistent.

- **Location modeling**: Normalizing location helps queries by city/country and avoids repeated text. It adds one extra join for lookups — usually acceptable.

- **Message table**: Keeps sender/recipient as FKs to `User`. This models a many-to-many user messaging relationship without introducing redundant user data.

- **Denormalization**: For read-heavy workloads, controlled denormalization (with triggers) can be added later.

---

## Conclusion

The adjusted schema removes derived attributes and splits multi-part location into a dedicated table. With these changes the schema conforms to **3NF** while keeping referential integrity via foreign keys and useful indexes for performance.

If you want, I can:

- Commit this `normalization.md` into your `alx-airbnb-database` repo (I will need push access or instructions),
- Produce an updated ERD Draw\.io XML reflecting the 3NF schema,
- Generate migration SQL files for a specific RDBMS (Postgres, MySQL, etc.).
