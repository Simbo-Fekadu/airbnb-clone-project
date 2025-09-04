# AirBnB Database Seed Data

This directory contains the SQL scripts to populate the AirBnB database with sample data.

## Files

- **seed.sql**: SQL script to insert sample Users, Properties, Locations, Bookings, Payments, Reviews, and Messages.
- **README.md**: This documentation file.

## Overview of Sample Data

The sample data includes:

1. **Users**: Guests, Hosts, and Admins.
2. **Locations**: Structured address data for properties.
3. **Properties**: Listings created by hosts.
4. **Bookings**: Reservations made by guests.
5. **Payments**: Payments linked to bookings.
6. **Reviews**: Guest reviews of properties.
7. **Messages**: Direct communication between users.

## Running the Seed Script

1. Ensure your database is set up and the schema (`schema.sql`) has been executed.
2. Navigate to this directory:

   ```bash
   cd database-script-0x02
   ```

3. Run the seed script in your database:

### PostgreSQL

```bash
psql -U <username> -d <database> -f seed.sql
```

### MySQL

```bash
mysql -u <username> -p <database> < seed.sql
```

## Notes

- UUIDs are generated for primary keys.
- Foreign key constraints ensure referential integrity.
- Data reflects realistic scenarios (multiple users, bookings, payments, etc.).
- This seed data is intended for development/testing purposes only.

## Next Steps

- Add more sample properties/bookings for testing scalability.
- Include variations in locations, payment methods, and booking statuses.
- Optionally create a script to reset the database before reseeding.
