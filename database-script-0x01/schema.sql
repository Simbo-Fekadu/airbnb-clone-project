-- schema.sql
-- AirBnB Database Schema
-- Based on 3NF normalized design

-- 1. User table
create table "User" (
   user_id       uuid primary key,
   first_name    varchar not null,
   last_name     varchar not null,
   email         varchar unique not null,
   password_hash varchar not null,
   phone_number  varchar,
   role          varchar not null check ( role in ( 'guest',
                                           'host',
                                           'admin' ) ),
   created_at    timestamp default current_timestamp
);

-- 2. Location table
create table location (
   location_id uuid primary key,
   country     varchar not null,
   city        varchar not null,
   address     varchar not null,
   postal_code varchar,
   latitude    decimal,
   longitude   decimal
);

-- 3. Property table
create table property (
   property_id   uuid primary key,
   host_id       uuid not null
      references "User" ( user_id ),
   name          varchar not null,
   description   text not null,
   location_id   uuid not null
      references location ( location_id ),
   pricepernight decimal not null,
   created_at    timestamp default current_timestamp,
   updated_at    timestamp default current_timestamp
);

-- 4. Booking table
create table booking (
   booking_id  uuid primary key,
   property_id uuid not null
      references property ( property_id ),
   user_id     uuid not null
      references "User" ( user_id ),
   start_date  date not null,
   end_date    date not null,
   status      varchar not null check ( status in ( 'pending',
                                               'confirmed',
                                               'canceled' ) ),
   created_at  timestamp default current_timestamp
);

-- 5. Payment table
create table payment (
   payment_id     uuid primary key,
   booking_id     uuid not null
      references booking ( booking_id ),
   amount         decimal not null,
   payment_date   timestamp default current_timestamp,
   payment_method varchar not null check ( payment_method in ( 'credit_card',
                                                               'paypal',
                                                               'stripe' ) )
);

-- 6. Review table
create table review (
   review_id   uuid primary key,
   property_id uuid not null
      references property ( property_id ),
   user_id     uuid not null
      references "User" ( user_id ),
   rating      integer not null check ( rating >= 1
      and rating <= 5 ),
   comment     text not null,
   created_at  timestamp default current_timestamp
);

-- 7. Message table
create table message (
   message_id   uuid primary key,
   sender_id    uuid not null
      references "User" ( user_id ),
   recipient_id uuid not null
      references "User" ( user_id ),
   message_body text not null,
   sent_at      timestamp default current_timestamp
);

-- Indexes for performance
create index idx_user_email on
   "User" (
      email
   );
create index idx_property_host on
   property (
      host_id
   );
create index idx_booking_property on
   booking (
      property_id
   );
create index idx_payment_booking on
   payment (
      booking_id
   );