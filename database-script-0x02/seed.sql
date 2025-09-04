-- seed.sql
-- Sample data population for AirBnB Database

-- Insert Users
insert into "User" (
   user_id,
   first_name,
   last_name,
   email,
   password_hash,
   role
) values ( gen_random_uuid(),
           'Alice',
           'Johnson',
           'alice@example.com',
           'hashed_pw_1',
           'guest' ),( gen_random_uuid(),
                       'Bob',
                       'Smith',
                       'bob@example.com',
                       'hashed_pw_2',
                       'host' ),( gen_random_uuid(),
                                  'Carol',
                                  'Lee',
                                  'carol@example.com',
                                  'hashed_pw_3',
                                  'admin' );

-- Insert Locations
insert into location (
   location_id,
   country,
   city,
   address,
   postal_code
) values ( gen_random_uuid(),
           'USA',
           'New York',
           '123 Broadway',
           '10001' ),( gen_random_uuid(),
                       'France',
                       'Paris',
                       '45 Rue de Rivoli',
                       '75001' );

-- Insert Properties (owned by Bob)
insert into property (
   property_id,
   host_id,
   name,
   description,
   location_id,
   pricepernight
) values ( gen_random_uuid(),
           (
              select user_id
                from "User"
               where email = 'bob@example.com'
           ),
           'Central Park Apartment',
           'A cozy apartment near Central Park.',
           (
              select location_id
                from location
               where city = 'New York'
           ),
           150.00 ),( gen_random_uuid(),
                      (
                         select user_id
                           from "User"
                          where email = 'bob@example.com'
                      ),
                      'Eiffel Tower View',
                      'Beautiful flat with a view of the Eiffel Tower.',
                      (
                         select location_id
                           from location
                          where city = 'Paris'
                      ),
                      200.00 );

-- Insert Booking (Alice books Central Park Apartment)
insert into booking (
   booking_id,
   property_id,
   user_id,
   start_date,
   end_date,
   status
) values ( gen_random_uuid(),
           (
              select property_id
                from property
               where name = 'Central Park Apartment'
           ),
           (
              select user_id
                from "User"
               where email = 'alice@example.com'
           ),
           '2025-09-10',
           '2025-09-15',
           'confirmed' );

-- Insert Payment
insert into payment (
   payment_id,
   booking_id,
   amount,
   payment_method
) values ( gen_random_uuid(),
           (
              select booking_id
                from booking
               where start_date = '2025-09-10'
           ),
           750.00,
           'credit_card' );

-- Insert Review
insert into review (
   review_id,
   property_id,
   user_id,
   rating,
   comment
) values ( gen_random_uuid(),
           (
              select property_id
                from property
               where name = 'Central Park Apartment'
           ),
           (
              select user_id
                from "User"
               where email = 'alice@example.com'
           ),
           5,
           'Amazing place, highly recommend!' );

-- Insert Message
insert into message (
   message_id,
   sender_id,
   recipient_id,
   message_body
) values ( gen_random_uuid(),
           (
              select user_id
                from "User"
               where email = 'alice@example.com'
           ),
           (
              select user_id
                from "User"
               where email = 'bob@example.com'
           ),
           'Hi Bob, I’m excited about my upcoming stay!' );