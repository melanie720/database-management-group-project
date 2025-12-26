if not exists (select * from sys.databases where name = 'BizTravelDB')
    create database BizTravelDB
go

use BizTravelDB
go

------------------------------------
------------- DOWN -----------------
------------------------------------

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_client_ven_pref_vendor_id')
    alter table client_vendor_preference drop constraint fk_client_ven_pref_vendor_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_client_ven_pref_client_id')
    alter table client_vendor_preference drop constraint fk_client_ven_pref_client_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_trips_hotel_bk_id')
    alter table trips drop constraint fk_trips_hotel_bk_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_trips_car_bk_id')
    alter table trips drop constraint fk_trips_car_bk_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_trips_train_bk_id')
    alter table trips drop constraint fk_trips_train_bk_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_trips_flight_bk_id')
    alter table trips drop constraint fk_trips_flight_bk_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_trips_traveler_id')
    alter table trips drop constraint fk_trips_traveler_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_car_bookings_vendor_id')
    alter table rental_car_bookings drop constraint fk_car_bookings_vendor_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_rental_car_bk_traveler_id')
    alter table rental_car_bookings drop constraint fk_rental_car_bk_traveler_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_hotel_bookings_vendor_id')
    alter table hotel_bookings drop constraint fk_hotel_bookings_vendor_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_hotel_bk_traveler_id')
    alter table hotel_bookings drop constraint fk_hotel_bk_traveler_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_train_bookings_vendor_id')
    alter table train_bookings drop constraint fk_train_bookings_vendor_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_train_bk_traveler_id')
    alter table train_bookings drop constraint fk_train_bk_traveler_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_flight_bookings_vendor_id')
    alter table flight_bookings drop constraint fk_flight_bookings_vendor_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_flight_bk_traveler_id')
    alter table flight_bookings drop constraint fk_flight_bk_traveler_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_ratings_rating_for')
    alter table ratings drop constraint fk_ratings_rating_for
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_ratings_rating_submitted_by')
    alter table ratings drop constraint fk_ratings_rating_submitted_by
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_call_ticket_id')
    alter table calls drop constraint fk_call_ticket_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_call_to_traveler')
    alter table calls drop constraint fk_call_to_traveler
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_call_to_agent')
    alter table calls drop constraint fk_call_to_agent
go  

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_call_from_traveler')
    alter table calls drop constraint fk_call_from_traveler
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_call_from_agent')
    alter table calls drop constraint fk_call_from_agent
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_traveler_company_id')
    alter table travelers drop constraint fk_traveler_company_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_travel_agent_client_group_id')
    alter table travel_agents drop constraint fk_travel_agent_client_group_id
go

if exists (select * from information_schema.table_constraints
    where constraint_name = 'fk_client_comp_client_group_id')
    alter table client_companies drop constraint fk_client_comp_client_group_id
go

drop table if exists client_vendor_preference
go

drop table if exists trips
go

drop table if exists rental_car_bookings
go

drop table if exists hotel_bookings
go

drop table if exists train_bookings
go

drop table if exists flight_bookings
go

drop table if exists vendors
go

drop table if exists ratings
go

drop table if exists calls
go

drop table if exists tickets
go

drop table if exists travelers
go

drop table if exists travel_agents
go

drop table if exists client_companies
go

drop table if exists client_groups
go

------------------------------------
-------------- UP ------------------
------------------------------------

-- Creating Tables.

-- Client Groups
create table client_groups (
    client_group_id int identity not null,
    client_group_name char(1) not null,
    constraint u_client_groups_group_name unique(client_group_name),
    constraint pk_client_group_id primary key(client_group_id)
)
go  

-- Client Companies
create table client_companies (
    client_comp_id int identity not null,
    client_comp_name varchar(150) not null,
    client_comp_group_id int not null,
    constraint pk_client_comp_id primary key (client_comp_id),
    constraint u_client_comp_name unique(client_comp_name),
    constraint fk_client_comp_client_group_id foreign key (client_comp_group_id) references client_groups(client_group_id)
)
go

-- Travel Agents
Create table travel_agents (
    travel_agent_id int identity not null,
    travel_agent_first_name varchar(50) not null,
    travel_agent_last_name varchar(50) not null,
    travel_agent_email varchar(100) not null,
    travel_agent_avg_call_time decimal (5,2) null,
    travel_agent_avg_rating decimal (3,2) null,
    travel_agent_avg_callbk_freq int null,
    travel_agent_standing varchar(60) null,
    travel_agent_client_group_id int not null,
    constraint pk_travel_agent_id primary key (travel_agent_id),
    constraint u_travel_agent_email unique(travel_agent_email),
    constraint fk_travel_agent_client_group_id foreign key (travel_agent_client_group_id) references client_groups(client_group_id)
)
go

-- Travelers
create table travelers (
    traveler_id int identity not null,
    traveler_first_name varchar(50) not null,
    traveler_last_name varchar(50) not null,
    traveler_company int not null,
    traveler_email varchar(100) not null,
    traveler_number varchar(15) not null,
    constraint pk_traveler_id primary key (traveler_id),
    constraint fk_traveler_company_id foreign key (traveler_company) references client_companies(client_comp_id),
    constraint u_traveler_email unique(traveler_email),
    constraint u_traveler_number unique(traveler_number)
)
go

-- Tickets
create table tickets (
    ticket_id int identity not null,
    ticket_created_date date not null,
    ticket_traveler int not null,
    constraint pk_ticket_id primary key (ticket_id)
)
go

-- Calls
create table calls (
    call_id int identity not null,
    call_date date not null,
    call_length_in_mins int not null,
    call_reason varchar(255) null,
    call_from_agent int null,
    call_from_traveler int null,
    call_to_agent int null,
    call_to_traveler int null,
    call_ticket_id int not null,
    constraint pk_call_id primary key (call_id),
    constraint fk_call_from_agent foreign key (call_from_agent) references travel_agents (travel_agent_id),
    constraint fk_call_from_traveler foreign key (call_from_traveler) references travelers (traveler_id),
    constraint fk_call_to_agent foreign key (call_to_agent) references travel_agents (travel_agent_id),
    constraint fk_call_to_traveler foreign key (call_to_traveler) references travelers (traveler_id),
    constraint fk_call_ticket_id foreign key (call_ticket_id) references tickets (ticket_id)
)
go

-- Ratings
create table ratings (
    rating_id int identity not null,
    rating_date_submitted date not null,
    rating_value int not null,
    rating_comments varchar(255) null,
    rating_submitted_by int not null,
    rating_for int not null,
    constraint pk_rating_id primary key (rating_id),
    constraint fk_ratings_rating_submitted_by foreign key (rating_submitted_by) references travelers(traveler_id),
    constraint fk_ratings_rating_for foreign key (rating_for) references travel_agents(travel_agent_id),
    constraint ck_rating_value check (rating_value between 1 and 5)
)
go

-- Vendors
create table vendors (
    vendor_id int identity not null,
    vendor_name varchar(100) not null,
    vendor_type varchar(15) not null,
    constraint pk_vendor_id primary key (vendor_id),
    constraint u_vendors_vendor_name unique(vendor_name),
    constraint ck_vendor_type check (vendor_type in ('Airline', 'Train', 'Hotel', 'Rental Company'))
)
go

-- Flight Bookings
create table flight_bookings (
    flight_bk_id int identity not null,
    flight_bk_tk_num varchar(50) not null,
    flight_bk_traveler int not null,
    flight_bk_current_loc varchar(100) not null,
    flight_bk_dest varchar(100) not null,
    flight_bk_dpt_date date not null,
    flight_bk_arrival_date date not null,
    flight_bk_tk_price decimal (6,2),
    flight_vendor_id int not null,
    constraint pk_flight_bk_id primary key (flight_bk_id),
    constraint u_flight_bk_tk_num unique (flight_bk_tk_num),
    constraint fk_flight_bk_traveler_id foreign key (flight_bk_traveler) references travelers(traveler_id),
    constraint fk_flight_bookings_vendor_id foreign key (flight_vendor_id) references vendors(vendor_id)
)
go

-- Train Bookings
create table train_bookings (
    train_bk_id int identity not null,
    train_bk_tk_num varchar(50) not null,
    train_bk_traveler int not null,
    train_bk_current_loc varchar(100) not null,
    train_bk_dest varchar(100) not null,
    train_bk_dpt_date date not null,
    train_bk_arrival_date date not null,
    train_bk_tk_price decimal (6,2) not null,
    train_vendor_id int not null,
    constraint pk_train_bk_id primary key (train_bk_id),
    constraint u_train_bk_tk_num unique (train_bk_tk_num),
    constraint fk_train_bk_traveler_id foreign key (train_bk_traveler) references travelers(traveler_id),
    constraint fk_train_bookings_vendor_id foreign key (train_vendor_id) references vendors(vendor_id)
)
go

-- Hotel Bookings
create table hotel_bookings (
    hotel_bk_id int identity not null,
    hotel_bk_num varchar (50) not null,
    hotel_bk_traveler int not null,
    hotel_chk_in_date date not null,
    hotel_chk_out_date date not null,
    hotel_price decimal (6,2) not null,
    hotel_vendor_id int not null,
    constraint pk_hotel_bk_id primary key (hotel_bk_id),
    constraint u_hotel_bk_num unique (hotel_bk_num),
    constraint fk_hotel_bk_traveler_id foreign key (hotel_bk_traveler) references travelers(traveler_id),
    constraint fk_hotel_bookings_vendor_id foreign key (hotel_vendor_id) references vendors(vendor_id)
)
go

-- Rental Car Bookings
create table rental_car_bookings (
    rental_car_bk_id int identity not null,
    rental_car_bk_num varchar(50) not null,
    rental_car_bk_traveler int not null,
    rental_pickup_date date not null,
    rental_return_date date not null,
    rental_price decimal (6,2) not null,
    rental_car_vendor_id int not null,
    constraint pk_rental_car_bk_id primary key (rental_car_bk_id),
    constraint u_rental_car_bk_num unique (rental_car_bk_num),
    constraint fk_rental_car_bk_traveler_id foreign key (rental_car_bk_traveler) references travelers(traveler_id),
    constraint fk_car_bookings_vendor_id foreign key (rental_car_vendor_id) references vendors(vendor_id)
)
go

-- Trips
Create table trips (
    trip_id int identity not null,
    trip_created_date date not null,
    trip_traveler_id int not null,
    trip_flight_bk_id int null,
    trip_train_bk_id int null,
    trip_car_bk_id int null,
    trip_hotel_bk_id int null,
    constraint pk_trip_id primary key (trip_id),
    constraint fk_trips_traveler_id foreign key (trip_traveler_id) references travelers(traveler_id),
    constraint fk_trips_flight_bk_id foreign key (trip_flight_bk_id) references flight_bookings(flight_bk_id),
    constraint fk_trips_train_bk_id foreign key (trip_train_bk_id) references train_bookings(train_bk_id),
    constraint fk_trips_car_bk_id foreign key (trip_car_bk_id) references rental_car_bookings(rental_car_bk_id),
    constraint fk_trips_hotel_bk_id foreign key (trip_hotel_bk_id) references hotel_bookings(hotel_bk_id)
)
go

-- Client Vendor Preferences
Create table client_vendor_preference (
    client_pref_client_id int not null,
    client_pref_vendor_id int not null,
    constraint pk_client_ven_pref_client_id primary key (client_pref_client_id, client_pref_vendor_id),
    constraint fk_client_ven_pref_client_id foreign key (client_pref_client_id) references client_companies(client_comp_id),
    constraint fk_client_ven_pref_vendor_id foreign key (client_pref_vendor_id) references vendors(vendor_id)
)
go

-- Inserting Initial Data.

-- 1. Client Groups
INSERT INTO client_groups (client_group_name) VALUES
('A'), ('B'), ('C'), ('D');

-- 2. Client Companies
INSERT INTO client_companies (client_comp_name, client_comp_group_id) VALUES
-- IDs 1 - 5 -- Group A
('AuraStream Solutions', 1),
('Quantum Leap Analytics', 1),
('Evergreen Dynamics Corp.', 1),
('Nexus Financial Group', 1),
('Acme Corp', 1),
-- IDs 6 - 10 -- Group B
('Blue Ridge Logistics', 2),
('Zenith Media Works', 2),
('TerraNova Ventures', 2),
('The Stellar Collective', 2),
('Mega Global', 2),
-- IDs 11 - 15 -- Group C
('Ironclad Security Systems', 3),
('Apex Innovations Lab', 3),
('Harbor View Design', 3),
('Tech Innovate', 3),
('Global Catalyst Partners', 3),
-- IDs 16 - 20 -- Group D
('Veridian HealthTech', 4),
('Precision Crafting Guild', 4),
('Echo Point Software', 4),
('Summit Retail Network', 4),
('Finance First', 4);

-- 3. Travel Agents
INSERT INTO travel_agents (travel_agent_first_name, travel_agent_last_name, travel_agent_email, travel_agent_client_group_id) VALUES
('Alice', 'Smith', 'alice.s@biztravel.com', 1),
('Charlie', 'Brown', 'charlie.b@biztravel.com', 1),
('Liam', 'Chen', 'liam.chen@biztravel.com', 1),
('Bob', 'Johnson', 'bob.j@biztravel.com', 2),
('Noah', 'Garcia', 'noah.garcia@biztravel.com', 2),
('Emma', 'Smith', 'emma.smith@biztravel.com', 2),
('Diana', 'Prince', 'diana.p@biztravel.com', 3),
('Elijah', 'Jones', 'elijah.jones@biztravel.com', 3),
('Ava', 'Brown', 'ava.brown@biztravel.com', 3),
('Ethan', 'Hunt', 'ethan.h@biztravel.com', 4),
('Olivia', 'Patel', 'olivia.patel@biztravel.com', 4);

-- 4. Travelers (IDs 1-4)
INSERT INTO travelers (traveler_first_name, traveler_last_name, traveler_company, traveler_email, traveler_number) VALUES
-- Group A -- Travelers 1 - 15
('William', 'Parker', 1, 'william.parker@aurasol.com', '555-0117'),
('Matthew', 'Cox', 1, 'matthew.cox@aurasol.com', '555-0123'),
('Emily', 'Carter', 1, 'emily.carter@aurasol.com', '555-0110'),
('Chloe', 'Wright', 2, 'chloe.wright@quantum.com', '555-0102'),
('Jacob', 'Green', 2, 'jacob.green@quantum.com', '555-0105'),
('Daniel', 'Hall', 2, 'daniel.hall@quantum.com', '555-0107'),
('Mia', 'Scott', 3, 'mia.scott@everdyn.com', '555-0104'),
('Harper', 'Adams', 3, 'harper.adams@everdyn.com', '555-0108'),
('Samuel', 'Nelson', 3, 'samuel.nelson@everdyn.com', '555-0109'),
('Sofia', 'Turner', 4, 'sofia.turner@nexus.com', '555-0114'),
('Evelyn', 'Evans', 4, 'evelyn.evans@nexus.com', '555-0118'),
('Joseph', 'Edwards', 4, 'joseph.edwards@nexus.com', '555-0119'),
('David', 'Lee', 5, 'david.l@acme.com', '555-1234'),
('Avery', 'Perez', 5, 'avery.perez@acme.com', '555-0112'),
('Benjamin', 'Phillips', 5, 'benjamin.phillips@acme.com', '555-0115'),
-- Group B -- Travelers 16 - 30
('David', 'Flores', 6, 'david.flores@blueridge.com', '555-0121'),
('Grace', 'Ramirez', 6, 'grace.ramirez@blueridge.com', '555-0122'),
('James', 'Roberts', 6, 'james.roberts@blueridge.com', '555-0113'),
('Lily', 'Ross', 7, 'lily.ross@zenith.com', '555-0126'),
('Hannah', 'Perry', 7, 'hannah.perry@zenith.com', '555-0130'),
('Zoe', 'Gomez', 7, 'zoe.gomez@zenith.com', '555-0124'),
('Julian', 'Powell', 8, 'julian.powell@terranova.com', '555-0129'),
('Jaxon', 'Rivera', 8, 'jaxon.rivera@terranova.com', '555-0135'),
('Christopher', 'Long', 8, 'christopher.long@terranova.com', '555-0131'),
('Leo', 'Morales', 9, 'leo.morales@stellar.com', '555-0141'),
('Owen', 'Bennett', 9, 'owen.bennett@stellar.com', '555-0145'),
('Wesley', 'Shaw', 9, 'wesley.shaw@stellar.com', '555-0153'),
('Emily', 'Chen', 10, 'emily.c@mega.com', '555-5678'),
('Aria', 'Gray', 10, 'aria.gray@mega.com', '555-0136'),
('Dylan', 'Hayes', 10, 'dylan.hayes@mega.com', '555-0137'),
-- Group C -- Travelers 31 - 45
('Adrian', 'Howard', 11, 'adrian.howard@ironcladsec.com', '555-0149'),
('Nora', 'Gibson', 11, 'nora.gibson@ironcladsec.com', '555-0150'),
('Penelope', 'Fisher', 11, 'penelope.fisher@ironcladsec.com', '555-0146'),
('Hazel', 'Bailey', 12, 'hazel.bailey@apexinn.com', '555-0142'),
('Isaac', 'Bell', 12, 'isaac.bell@apexinn.com', '555-0143'),
('Stella', 'Cook', 12, 'stella.cook@apexinn.com', '555-0144'),
('Ryan', 'Foster', 13, 'ryan.foster@harbor.com', '555-0133'),
('Madison', 'Ward', 13, 'madison.ward@harbor.com', '555-0134'),
('Gabriel', 'Rogers', 13, 'gabriel.rogers@harbor.com', '555-0127'),
('Frank', 'Taylor', 14, 'frank.t@tech.com', '555-9012'),
('Ruby', 'Jensen', 14, 'ruby.jensen@tech.com', '555-0154'),
('Miles', 'Wagner', 14, 'miles.wagner@tech.com', '555-0155'),
('Ethan', 'Reed', 15, 'ethan.reed@glocat.com', '555-0101'),
('Elena', 'Richardson', 15, 'elena.richardson@glocat.com', '555-0148'),
('Lucy', 'Dean', 15, 'lucy.dean@glocat.com', '555-0152'),
-- Group D -- Travelers 46 - 60
('Alexander', 'King', 16, 'alexander.king@veridian.com', '555-0103'),
('Abigail', 'Baker', 16, 'abigail.baker@veridian.com', '555-0106'),
('Michael', 'Mitchell', 16, 'michael.mitchell@veridian.com', '555-0111'),
('Scarlett', 'Coleman', 17, 'scarlett.coleman@precguild.com', '555-0128'),
('Victoria', 'Hughes', 17, 'victoria.hughes@precguild.com', '555-0132'),
('Layla', 'Brooks', 17, 'layla.brooks@precguild.com', '555-0138'),
('Jonah', 'Pierce', 18, 'jonah.pierce@echosoft.com', '555-0151'),
('Grace', 'Lane', 18, 'grace.lane@echosoft.com', '555-0156'),
('Connor', 'Murphy', 18, 'connor.murphy@echosoft.com', '555-0147'),
('Eleanor', 'Sanders', 19, 'eleanor.sanders@summitretail.com', '555-0140'),
('Amelia', 'Stewart', 19, 'amelia.stewart@summitretail.com', '555-0120'),
('Andrew', 'Barnes', 19, 'andrew.barnes@summitretail.com', '555-0125'),
('Grace', 'Miller', 20, 'grace.m@finance.com', '555-3456'),
('Carter', 'Washington', 20, 'carter.washington@finance.com', '555-0139'),
('Charlotte', 'Campbell', 20, 'charlotte.campbell@finance.com', '555-0116');

-- 5. Vendors
INSERT INTO vendors (vendor_name, vendor_type) VALUES
-- Airline: 1 - 6
('Global Wings Airlines', 'Airline'),
('SkyJet Carriers', 'Airline'),
('Oceanic Air Transport', 'Airline'),
('AeroSwift Lines', 'Airline'),
('StarLink Aviation', 'Airline'),
('Horizon Commuter', 'Airline'),
-- Train: 7 - 12
('Continental Rail Express', 'Train'),
('Highland Scenic Trains', 'Train'),
('MetroTransit Lines', 'Train'),
('Iron Horse Rail Services', 'Train'),
('Pacific Standard Railway', 'Train'),
('Urban Glide Transit', 'Train'),
-- Hotel: 13 - 18
('The Grand Summit Hotel', 'Hotel'),
('Oasis Bay Resorts', 'Hotel'),
('Executive Stay Suites', 'Hotel'),
('The Gilded Key Inn', 'Hotel'),
('Coastal Comfort Lodges', 'Hotel'),
('Zen Garden Hostels', 'Hotel'),
-- Rental Company: 19 - 24
('Velocity Car Rentals', 'Rental Company'),
('Premier Fleet Leasing', 'Rental Company'),
('Gecko Mobility Solutions', 'Rental Company'),
('DriveRight Autos', 'Rental Company'),
('QuickTrip Vans', 'Rental Company'),
('Elite Wheels Hire', 'Rental Company');

-- 6. Flight Bookings
INSERT INTO flight_bookings (flight_bk_tk_num, flight_bk_traveler, flight_bk_current_loc, flight_bk_dest, flight_bk_dpt_date, flight_bk_arrival_date, flight_bk_tk_price, flight_vendor_id) VALUES
('F5001', 34, 'JFK', 'LAX', '2026-11-10', '2026-11-10', 450.75, 4),
('F5002', 59, 'MIA', 'LHR', '2026-11-15', '2026-11-16', 980.50, 5),
('F5003', 20, 'SFO', 'BOS', '2026-12-01', '2026-12-01', 320.00, 3),
('F5004', 4, 'ORD', 'SEA', '2026-12-05', '2026-12-05', 285.99, 6),
('F5005', 41, 'DFW', 'SYD', '2026-12-12', '2026-12-13', 1550.00, 6),
('F5006', 31, 'ATL', 'DEN', '2027-01-08', '2027-01-08', 390.25, 2),
('F5007', 5, 'PHX', 'EWR', '2027-01-20', '2027-01-20', 415.50, 4),
('F5008', 11, 'IAD', 'CDG', '2027-02-03', '2027-02-04', 1120.90, 4),
('F5009', 25, 'DTW', 'MCO', '2027-02-14', '2027-02-14', 305.10, 2),
('F5010', 58, 'LAS', 'HNL', '2027-03-01', '2027-03-01', 675.00, 6),
('F5011', 24, 'DTW', 'MCO', '2027-02-14', '2027-02-14', 398.10, 4),
('F5012', 26, 'LAS', 'HNL', '2027-03-01', '2027-03-01', 125.00, 3);

-- 7. Hotel Bookings
INSERT INTO hotel_bookings (hotel_bk_num, hotel_bk_traveler, hotel_chk_in_date, hotel_chk_out_date, hotel_price, hotel_vendor_id) VALUES
('H5031', 34, '2027-11-10', '2027-11-18', 450.00, 16),
('H5032', 59, '2027-12-01', '2027-12-05', 720.80, 17),
('H5033', 19, '2027-12-20', '2027-12-27', 1250.00, 18),
('H5034', 4, '2028-01-05', '2028-01-10', 899.50, 15),
('H5037', 41, '2028-03-01', '2028-03-08', 950.00, 18),
('H5035', 32, '2028-01-25', '2028-01-28', 315.00, 14),
('H5036', 5, '2028-02-14', '2028-02-16', 290.75, 17),
('H5039', 10, '2028-04-05', '2028-04-07', 220.50, 14),
('H5040', 25, '2028-04-18', '2028-04-23', 555.40, 15),
('H5038', 58, '2028-03-20', '2028-03-24', 680.99, 16),
('H5041', 24, '2028-03-20', '2028-03-24', 672.99, 17),
('H5042', 26, '2028-03-20', '2028-03-24', 701.99, 14);

-- 8. Rental Car Bookings
INSERT INTO rental_car_bookings (rental_car_bk_num, rental_car_bk_traveler, rental_pickup_date, rental_return_date, rental_price, rental_car_vendor_id) VALUES
('R5021', 34, '2027-06-20', '2027-06-25', 280.00, 24),
('R5027', 59, '2027-09-15', '2027-09-19', 245.00, 21),
('R5022', 19, '2027-07-01', '2027-07-08', 455.50, 19),
('R5023', 4, '2027-07-15', '2027-07-17', 110.99, 21),
('R5024', 41, '2027-07-28', '2027-08-04', 399.00, 24),
('R5025', 32, '2027-08-10', '2027-08-13', 195.75, 19),
('R5031', 24, '2027-10-25', '2027-11-01', 256.00, 23),
('R5026', 5, '2027-08-25', '2027-09-03', 580.40, 19),
('R5028', 10, '2027-09-29', '2027-10-01', 99.50, 20),
('R5029', 25, '2027-10-10', '2027-10-14', 315.25, 22),
('R5030', 58, '2027-10-25', '2027-11-01', 410.00, 24);

-- 9. Train Bookings
INSERT INTO train_bookings (train_bk_tk_num, train_bk_traveler, train_bk_current_loc, train_bk_dest, train_bk_dpt_date, train_bk_arrival_date, train_bk_tk_price, train_vendor_id) VALUES
-- Use this to test adding a segment to trip -- traveler_id 59/trip_id 2.
('T5011', 59, 'NYC', 'BOS', '2027-03-15', '2027-03-15', 85.00, 9),
('T5012', 43, 'CHI', 'DEN', '2027-03-22', '2027-03-22', 120.50, 7),
('T5013', 27, 'WAS', 'PHI', '2027-04-01', '2027-04-01', 60.99, 9),
('T5014', 51, 'LAX', 'SEA', '2027-04-10', '2027-04-10', 210.00, 7),
('T5015', 32, 'SAC', 'RENO', '2027-04-18', '2027-04-18', 75.25, 8),
('T5016', 39, 'MIA', 'ORL', '2027-05-05', '2027-05-05', 145.75, 8),
('T5017', 19, 'DAL', 'AUS', '2027-05-12', '2027-05-12', 92.50, 10),
('T5018', 47, 'ATL', 'CHA', '2027-05-25', '2027-05-25', 188.00, 12),
('T5019', 10, 'DET', 'CLE', '2027-06-02', '2027-06-02', 55.00, 9),
('T5020', 13, 'PDX', 'EUG', '2027-06-15', '2027-06-15', 165.40, 8);

-- 10. Trips
INSERT INTO trips (trip_created_date, trip_traveler_id, trip_flight_bk_id, trip_train_bk_id, trip_car_bk_id, trip_hotel_bk_id) VALUES
('2026-11-01', 34, 1, NULL, 1, 1),
('2026-11-05', 59, 2, NULL, 2, 2),
('2026-11-20', 19, NULL, 7, 3, 3),
('2026-11-25', 4, 4, NULL, 4, 4),
('2026-12-02', 41, 5, NULL, 5, 5),
('2027-12-27', 32, NULL, 5, 6, 6),
('2027-01-10', 5, 7, NULL, 7, 7),
('2027-01-24', 10, NULL, 9, 8, 8),
('2027-02-08', 25, 9, NULL, 9, 9),
('2027-02-26', 58, 10, NULL, 10, 10);

-- 11. Tickets
INSERT INTO tickets (ticket_created_date, ticket_traveler) VALUES
('2026-01-10', 14), ('2026-01-15', 3), ('2026-01-20', 7), ('2026-02-05', 1),
('2026-02-15', 10), ('2026-02-20', 15), ('2026-03-01', 6), ('2026-03-05', 11),
('2026-03-10', 17), ('2026-03-15', 29), ('2026-04-01', 21), ('2026-04-10', 28),
('2026-05-01', 18), ('2026-05-10', 25), ('2026-05-15', 30), ('2026-06-01', 32),
('2026-06-05', 40), ('2026-06-10', 36), ('2026-06-15', 45), ('2026-07-01', 35),
('2026-07-10', 42), ('2026-08-01', 43), ('2026-08-05', 31), ('2026-08-10', 44),
('2026-09-01', 47), ('2026-09-10', 55), ('2026-10-01', 46), ('2026-10-10', 48),
('2026-10-15', 49), ('2026-10-20', 50);

-- 12. Calls
INSERT INTO calls (call_date, call_length_in_mins, call_reason, call_from_agent, call_from_traveler, call_to_agent, call_to_traveler, call_ticket_id) VALUES
-- Agent 1 -- Group 1 -- Travelers 1 - 15
('2026-01-10', 8, 'Initial flight request', NULL, 14, 1, NULL, 1),
('2026-01-10', 6, 'Proposed itinerary details', 1, NULL, NULL, 14, 1),
('2026-01-11', 15, 'Discussed hotel options', NULL, 14, 1, NULL, 1),
('2026-01-11', 3, 'Booking confirmed', 1, NULL, NULL, 14, 1),

('2026-01-15', 10, 'Inquiry about visa requirements', NULL, 3, 1, NULL, 2),

('2026-01-20', 5, 'Rental car confirmation follow-up', 1, NULL, NULL, 7, 3),
('2026-01-20', 9, 'Requested upgrade to business class', NULL, 7, 1, NULL, 3),
('2026-01-20', 13, 'Upgrade approved and payment details', 1, NULL, NULL, 7, 3),
('2026-01-21', 4, 'Final documentation delivery confirmation', NULL, 7, 1, NULL, 3),      

-- Agent 2  -- Group 1 -- Travelers 1 - 15
('2026-02-05', 10, 'Initial inquiry on destination', NULL, 1, 2, NULL, 4),
('2026-02-05', 5, 'Follow-up with options', 2, NULL, NULL, 1, 4),
('2026-02-06', 18, 'Selected flights and hotel', NULL, 1, 2, NULL, 4),
('2026-02-06', 2, 'Payment confirmation needed', 2, NULL, NULL, 1, 4),
('2026-02-06', 4, 'Payment details provided', NULL, 1, 2, NULL, 4),
('2026-02-07', 3, 'Ticket issued and documents sent', 2, NULL, NULL, 1, 4),

('2026-02-15', 7, 'Request for change of travel dates', NULL, 10, 2, NULL, 5),
('2026-02-16', 12, 'Date change options presented', 2, NULL, NULL, 10, 5),

('2026-02-20', 5, 'Passport validity check', 2, NULL, NULL, 15, 6),
('2026-02-20', 3, 'Confirmed passport status', NULL, 15, 2, NULL, 6),
('2026-02-21', 10, 'Discussed dining preferences for cruise', 2, NULL, NULL, 15, 6),
('2026-02-22', 6, 'Finalized dining time', NULL, 15, 2, NULL, 6),
('2026-02-22', 2, 'Pre-check-in email sent', 2, NULL, NULL, 15, 6),

-- Agent 3  -- Group 1 -- Travelers 1 - 15
('2026-03-01', 7, 'Clarification on hotel check-in time', NULL, 6, 3, NULL, 7),

('2026-03-05', 4, 'Reminder about required passport scan', 3, NULL, NULL, 11, 8),      

-- Agent 4  -- Group 2 -- Travelers 16 - 30  
('2026-03-10', 11, 'Request to modify rental car size', NULL, 17, 4, NULL, 9),

('2026-03-15', 6, 'Confirmation of flight itinerary change', 4, NULL, NULL, 29, 10),  

-- Agent 5  -- Group 2 -- Travelers 16 - 30
('2026-04-01', 9, 'Initial luxury cruise inquiry', NULL, 21, 5, NULL, 11),
('2026-04-01', 12, 'Presented cabin options and pricing', 5, NULL, NULL, 21, 11),
('2026-04-02', 7, 'Request to add shore excursions', NULL, 21, 5, NULL, 11),
('2026-04-02', 3, 'Excursion cost confirmation', 5, NULL, NULL, 21, 11),
('2026-04-03', 4, 'Final payment processed confirmation', NULL, 21, 5, NULL, 11),
('2026-04-03', 2, 'Sent final booking documents', 5, NULL, NULL, 21, 11),

('2026-04-10', 10, 'Request for pet travel policy details', NULL, 28, 5, NULL, 12),
('2026-04-11', 6, 'Provided policy summary and fee structure', 5, NULL, NULL, 28, 12),
('2026-04-11', 5, 'Proceeding with pet reservation', NULL, 28, 5, NULL, 12),

-- Agent 6  -- Group 2 -- Travelers 16 - 30
('2026-05-01', 7, 'Questions about group discount eligibility', NULL, 18, 6, NULL, 13),
('2026-05-01', 10, 'Confirmed discount and presented itinerary draft', 6, NULL, NULL, 18, 13),
('2026-05-02', 5, 'Requested change to outbound flight time', NULL, 18, 6, NULL, 13),
('2026-05-02', 3, 'Change confirmed; re-issued invoice', 6, NULL, NULL, 18, 13),
('2026-05-03', 2, 'Inquiry on airport transfers', NULL, 18, 6, NULL, 13),

('2026-05-10', 8, 'Pre-travel check for required documents', 6, NULL, NULL, 25, 14),
('2026-05-10', 4, 'Confirmed document status', NULL, 25, 6, NULL, 14),

('2026-05-15', 11, 'Urgent need to rebook connecting flight', NULL, 30, 6, NULL, 15),
('2026-05-15', 7, 'Presented new flight options and layover details', 6, NULL, NULL, 30, 15),
('2026-05-15', 3, 'Approved rebooking option', NULL, 30, 6, NULL, 15),
('2026-05-15', 2, 'Sent new electronic ticket link', 6, NULL, NULL, 30, 15),

-- Agent 7  -- Group 3 -- Travelers 31 - 45
('2026-06-01', 9, 'Inquiry about frequent flyer points', NULL, 32, 7, NULL, 16),

('2026-06-05', 5, 'Initial contact to confirm trip details', 7, NULL, NULL, 40, 17),
('2026-06-05', 10, 'Requesting specific hotel room type', NULL, 40, 7, NULL, 17),
('2026-06-05', 3, 'Internal vendor availability check', NULL, 40, 7, NULL, 17),
('2026-06-06', 4, 'Room type confirmed and price adjustment', 7, NULL, NULL, 40, 17),
('2026-06-06', 6, 'Final payment authorization', NULL, 40, 7, NULL, 17),
('2026-06-06', 2, 'Final documents sent notification', 7, NULL, NULL, 40, 17),

('2026-06-10', 12, 'Need to cancel trip due to emergency', NULL, 36, 7, NULL, 18),
('2026-06-11', 5, 'Processed cancellation request', NULL, 40, 7, NULL, 18),
('2026-06-11', 8, 'Confirmed refund amount and timeline', 7, NULL, NULL, 36, 18),

('2026-06-15', 7, 'Follow-up on booking expiration warning', 7, NULL, NULL, 45, 19),
('2026-06-15', 4, 'Authorized payment immediately', NULL, 45, 7, NULL, 19),
('2026-06-16', 6, 'Discussed preferred seating options', 7, NULL, NULL, 45, 19),
('2026-06-16', 3, 'Selected window seats', NULL, 45, 7, NULL, 19),
('2026-06-17', 2, 'Sent flight check-in details', 7, NULL, NULL, 45, 19),

-- Agent 8  -- Group 3 -- Travelers 31 - 45
('2026-07-01', 5, 'Confirmation of preferred seating', 8, NULL, NULL, 35, 20),
('2026-07-02', 14, 'Requested pre-paid baggage fee inclusion', NULL, 35, 8, NULL, 20),
('2026-07-02', 2, 'Checked fee with airline vendor', NULL, 35, 8, NULL, 20),
('2026-07-03', 7, 'Baggage fee added and payment confirmed', 8, NULL, NULL, 35, 20),

('2026-07-10', 11, 'Urgent inquiry about missed connection options', NULL, 42, 8, NULL, 21),

-- Agent 9  -- Group 3 -- Travelers 31 - 45
('2026-08-01', 5, 'Initial contact to review itinerary details', 9, NULL, NULL, 43, 22),
('2026-08-01', 9, 'Requested specific hotel floor preference', NULL, 43, 9, NULL, 22),
('2026-08-02', 3, 'Preference confirmed with hotel', 9, NULL, NULL, 43, 22),

('2026-08-05', 12, 'Inquiry about extending trip duration', NULL, 31, 9, NULL, 23),
('2026-08-05', 4, 'Checked availability for new return date', 9, NULL, NULL, 31, 23),
('2026-08-06', 7, 'Provided options and cost for extension', 9, NULL, NULL, 31, 23),
('2026-08-06', 5, 'Approved extension and provided new payment method', NULL, 31, 9, NULL, 23),
('2026-08-07', 3, 'Processed new payment and rebooked flight', NULL, 31, 9, NULL, 23),
('2026-08-07', 2, 'New itinerary confirmed and sent', 9, NULL, NULL, 31, 23),

('2026-08-10', 10, 'Requesting information on airport lounge access', NULL, 44, 9, NULL, 24),
('2026-08-11', 6, 'Provided lounge access policy and booking details', 9, NULL, NULL, 44, 24),

-- Agent 10  -- Group 4 -- Travelers 46 - 60
('2026-09-01', 5, 'Initial contact to review flight options', 10, NULL, NULL, 47, 25),
('2026-09-01', 12, 'Selected specific flights and discussed hotels', NULL, 47, 10, NULL, 25),
('2026-09-02', 3, 'Checked hotel rate availability', 10, NULL, NULL, 47, 25),
('2026-09-02', 8, 'Confirmed hotel booking and total price', 10, NULL, NULL, 47, 25),
('2026-09-03', 4, 'Provided final payment authorization', NULL, 47, 10, NULL, 25),
('2026-09-04', 2, 'Sent finalized e-tickets and confirmation', 10, NULL, NULL, 47, 25),

('2026-09-10', 15, 'Requesting assistance with multi-city rail pass', NULL, 55, 10, NULL, 26),
('2026-09-11', 5, 'Researched best rail pass options', 10, NULL, NULL, 55, 26),
('2026-09-11', 10, 'Presented pass options and booking steps', 10, NULL, NULL, 55, 26),
('2026-09-12', 3, 'Authorized purchase of selected rail pass', NULL, 55, 10, NULL, 26),

-- Agent 11  -- Group 4 -- Travelers 46 - 60
('2026-10-01', 9, 'Inquiry about visa assistance services', NULL, 46, 11, NULL, 27),
('2026-10-01', 5, 'Provided visa form requirements and costs', 11, NULL, NULL, 46, 27),
('2026-10-02', 12, 'Reviewed filled-out visa application details', NULL, 46, 11, NULL, 27),
('2026-10-03', 2, 'Submitted application to vendor', NULL, 46, 11, NULL, 27),
('2026-10-03', 3, 'Visa processing confirmation', 11, NULL, NULL, 46, 27),

('2026-10-10', 8, 'Urgent notification of flight schedule change', 11, NULL, NULL, 48, 28),

('2026-10-15', 6, 'Question about travel insurance policy limits', NULL, 49, 11, NULL, 29),
('2026-10-16', 10, 'Explained policy coverage and upgrade option', 11, NULL, NULL, 49, 29),
('2026-10-17', 4, 'Authorized insurance upgrade payment', NULL, 49, 11, NULL, 29),
('2026-10-17', 2, 'Insurance upgrade confirmed', 11, NULL, NULL, 49, 29),

('2026-10-20', 11, 'Trouble accessing online itinerary portal', NULL, 50, 11, NULL, 30),
('2026-10-20', 3, 'Logged support ticket for portal access issue', NULL, 50, 11, NULL, 30),
('2026-10-21', 5, 'Provided temporary password and verified access', 11, NULL, NULL, 50, 30);

-- 13. Ratings
INSERT INTO ratings (rating_date_submitted, rating_value, rating_comments, rating_submitted_by, rating_for) VALUES
('2026-01-12', 5, 'Quickly handled my complex requests and followed up promptly.', 14, 1),
('2026-01-16', 1, NULL, 3, 1),
('2026-01-22', 5, 'Went above and beyond to get my business class upgrade!', 7, 1),

('2026-02-08', 3, 'Helpful, but took a while to confirm the payment.', 1, 2),
('2026-02-17', 4, 'Handled the date change efficiently.', 10, 2),
('2026-02-23', 2, NULL, 15, 2),

('2026-03-02', 4, 'Good clarification on hotel details.', 6, 3),
('2026-03-06', 5, 'Very proactive with the passport scan reminder.', 11, 3),

('2026-03-11', 5, NULL, 2, 2),
('2026-03-11', 1, NULL, 17, 4),
('2026-03-11', 5, NULL, 2, 2),
('2026-03-16', 4, 'Quick confirmation of the flight change.', 13, 4),

('2026-04-05', 5, 'Excellent guidance on the luxury cruise booking and excursions.', 21, 5),
('2026-04-12', 4, NULL, 28, 5),

('2026-05-04', 3, 'Needed several calls to finalize the itinerary changes.', 18, 6),
('2026-05-11', 5, 'Smooth pre-travel check.', 25, 6),
('2026-05-16', 4, 'Very responsive during the urgent rebooking.', 30, 6),

('2026-06-02', 1, 'Horrible experience! Please do better.', 32, 7),
('2026-06-07', 4, 'Happy with the specific hotel room reservation.', 40, 7),
('2026-06-12', 1, 'Cancellation process was not clear, very time consuming.', 36, 7),
('2026-06-18', 5, 'Helped secure the preferred seating quickly.', 45, 7),

('2026-07-04', 5, 'Handled the baggage fee addition without issue.', 35, 8),
('2026-07-11', 1, NULL, 42, 8),

('2026-08-03', 4, 'Good follow-up on the hotel preference.', 43, 9),
('2026-08-08', 5, 'Very dedicated to extending my trip, excellent service.', 31, 9),
('2026-08-12', 4, NULL, 44, 9),

('2026-09-05', 4, 'Thorough review of the complex itinerary.', 47, 10),
('2026-09-13', 5, 'Excellent knowledge of multi-city rail passes.', 55, 10),

('2026-10-04', 5, 'Very helpful with the visa documentation.', 46, 11),
('2026-10-11', 3, 'The flight change notification was a bit late.', 48, 11),
('2026-10-18', 2, NULL, 49, 11),
('2026-10-22', 4, 'Resolved my portal access issue quickly.', 50, 11);

-- 14. Client Vendor Preference
INSERT INTO client_vendor_preference (client_pref_client_id, client_pref_vendor_id) VALUES
-- (IDs 1-6 for Airline, 7-12 for Train, 13-18 for Hotel, 19-24 for Rental)
(1, 1), (1, 2), (1, 4), (1, 7), (1, 9), (1, 10), (1, 13), (1, 14), (1, 15), (1, 22), (1, 23), (1, 24),
(2, 4), (2, 5), (2, 6), (2, 12), (2, 11), (2, 10), (2, 17), (2, 14), (2, 15), (2, 19), (2, 21), (2, 22),
(3, 1), (3, 5), (3, 3), (3, 7), (3, 12), (3, 10), (3, 17), (3, 18), (3, 15), (3, 21), (3, 24), (3, 19),
(4, 4), (4, 1), (4, 2), (4, 9), (4, 8), (4, 7), (4, 13), (4, 16), (4, 14), (4, 20), (4, 22), (4, 24),
(5, 1), (5, 2), (5, 3), (5, 7), (5, 8), (5, 9), (5, 13), (5, 14), (5, 15), (5, 19), (5, 20), (5, 21),
(6, 3), (6, 4), (6, 5), (6, 7), (6, 11), (6, 8), (6, 14), (6, 18), (6, 16), (6, 22), (6, 23), (6, 24),
(7, 5), (7, 3), (7, 2), (7, 7), (7, 8), (7, 9), (7, 13), (7, 18), (7, 15), (7, 19), (7, 20), (7, 24),
(8, 4), (8, 5), (8, 6), (8, 10), (8, 11), (8, 12), (8, 16), (8, 17), (8, 18), (8, 22), (8, 23), (8, 19),
(9, 1), (9, 2), (9, 3), (9, 7), (9, 8), (9, 9), (9, 13), (9, 14), (9, 15), (9, 19), (9, 22), (9, 21),
(10, 4), (10, 5), (10, 6), (10, 10), (10, 11), (10, 12),(10, 16), (10, 17), (10, 18), (10, 22), (10, 23), (10, 24),
(11, 1), (11, 2), (11, 3), (11, 7), (11, 8), (11, 9), (11, 13), (11, 14), (11, 15), (11, 19), (11, 20), (11, 21),
(12, 4), (12, 5), (12, 6), (12, 10), (12, 11), (12, 12), (12, 16), (12, 17), (12, 18), (12, 22), (12, 23), (12, 24),
(13, 1), (13, 2), (13, 3), (13, 7), (13, 8), (13, 9), (13, 13), (13, 14), (13, 15), (13, 19), (13, 20), (13, 21),
(14, 4), (14, 5), (14, 6), (14, 10), (14, 11), (14, 12), (14, 16), (14, 17), (14, 18), (14, 22), (14, 23), (14, 24),
(15, 1), (15, 2), (15, 3), (15, 7), (15, 8), (15, 9), (15, 13), (15, 14), (15, 15), (15, 19), (15, 20), (15, 21),
(16, 4), (16, 5), (16, 6), (16, 10), (16, 11), (16, 12), (16, 16), (16, 17), (16, 18), (16, 22), (16, 23), (16, 24),
(17, 1), (17, 2), (17, 3), (17, 7), (17, 8), (17, 9), (17, 13), (17, 16), (17, 15), (17, 19), (17, 20), (17, 21),
(18, 4), (18, 5), (18, 6), (18, 10), (18, 7), (18, 12), (18, 16), (18, 17), (18, 18), (18, 22), (18, 23), (18, 24),
(19, 1), (19, 2), (19, 3), (19, 7), (19, 8), (19, 9), (19, 13), (19, 14), (19, 15), (19, 19), (19, 20), (19, 21),
(20, 3), (20, 5), (20, 6), (20, 10), (20, 9), (20, 12), (20, 16), (20, 17), (20, 18), (20, 22), (20, 21), (20, 24);


-- Creating Data Logic.

-- FUNCTIONS

-- 1. Function for Average Call Time
drop function if exists f_travel_agent_avg_call_time
go

create function f_travel_agent_avg_call_time (
    @call_agent_id int
) returns decimal(5,2) as begin
    declare @avg_call_time decimal (5,2)
    select @avg_call_time = avg(cast(call_length_in_mins as decimal(5,2)))
        from calls
    where call_from_agent = @call_agent_id
        or call_to_agent = @call_agent_id
    return @avg_call_time;
end
go

-- Updating average call time for call data already inserted.
update travel_agents set travel_agent_avg_call_time =  dbo.f_travel_agent_avg_call_time(travel_agent_id)
go


-- 2. Function for Average Agent Rating
drop function if exists f_travel_agent_avg_rating
go

create function f_travel_agent_avg_rating (
    @rating_agent_id int
) returns decimal (3, 2) as begin
    declare @avg_rating decimal(3, 2)
    select @avg_rating = avg(cast(rating_value as decimal(3, 2)))
        from ratings
    where rating_for = @rating_agent_id
    return @avg_rating;
end
go

-- Updating average agent rating for rating data already inserted.
update travel_agents set travel_agent_avg_rating =  dbo.f_travel_agent_avg_rating(travel_agent_id)
go


-- 3. Function for Average Callback Frequency
drop function if exists f_travel_agent_avg_cb_freq
go

create function f_travel_agent_avg_cb_freq (
    @call_agent_id int
) returns int as begin
    declare @callcount int;
    declare @avg_cb int;
    with agent_cb_freq as (
        select count(call_id) - 1 as count
        from calls as c
        join tickets as t on c.call_ticket_id = t.ticket_id
        where c.call_from_traveler = t.ticket_traveler and c.call_to_agent = @call_agent_id
    )
   
    select @avg_cb = avg(count) from agent_cb_freq
 
    return @avg_cb;
end
go

-- Updating average callback frequency for call data already inserted.
update travel_agents set travel_agent_avg_callbk_freq =  dbo.f_travel_agent_avg_cb_freq(travel_agent_id)
go


-- TRIGGERS

-- 4. For calls table
-- Confirms inserted call records are valid and updates agent average call time and average callback frequency by calling the functions above.
drop trigger if exists t_call_from_call_to
go

create trigger t_call_from_call_to
    on calls
    after insert
as begin
    declare @rows_inserted int;
    set @rows_inserted = (select count(*) from inserted);
    if (select count(*) from inserted
            where (call_from_agent is not null and call_to_traveler is not null) and (call_from_traveler is null and call_to_agent is null)
            or (call_from_traveler is not null and call_to_agent is not null) and (call_from_agent is null and call_to_traveler is null)) != @rows_inserted begin
    rollback
    ;throw 50005, 'Could not insert into call logs. Fix entry.', 1
    end
    else begin
        declare @current_record int = (select max(call_id) from inserted);
        declare @counter int = @rows_inserted;
        declare @agent int;
        while @counter > 0
        begin
            select @agent =
                case
                    when inserted.call_to_agent is not null then inserted.call_to_agent
                    else inserted.call_from_agent
                end
                from inserted where call_id = @current_record;
       
            update travel_agents
                set travel_agent_avg_call_time = (select dbo.f_travel_agent_avg_call_time(@agent))
                where travel_agent_id = @agent;
           
            update travel_agents
                set travel_agent_avg_callbk_freq = (select dbo.f_travel_agent_avg_cb_freq(@agent))
                where travel_agent_id = @agent;
       
            set @counter = @counter - 1;
            set @current_record = @current_record - 1;
        end
    end
end
go


-- 5. For ratings table.
-- After a rating is inserted, trigger updates agent average rating by calling the function above and updates agent overall standing.
drop trigger if exists t_update_agent_rating
go

create trigger t_update_agent_rating
    on ratings
    after insert
as begin
    declare @current_record int = (select max(rating_id) from inserted);
    declare @counter int = (select count(*) from inserted);
    declare @agent int;


    while @counter > 0
    begin
        select @agent = inserted.rating_for from inserted where rating_id = @current_record;

        update travel_agents
            set travel_agent_avg_rating = (select dbo.f_travel_agent_avg_rating(@agent))
            where travel_agent_id = @agent;
   
        -- This could also be a function.
        update travel_agents
            set travel_agent_standing =
                case
                    when travel_agent_avg_rating <= 2.5 then 'PIP recommended.'
                    when travel_agent_avg_rating > 2.5 and travel_agent_avg_rating < 4 then 'Warning. Performance dropping.'
                    when travel_agent_avg_rating >= 4  then 'Satisfactory performance.'
                end
            where travel_agent_id = @agent;
        
        set @counter = @counter - 1;
        set @current_record = @current_record - 1;
    end
end
go

-- Updating agent overall standing for rating data already inserted.
update travel_agents
    set travel_agent_standing =
        case
            when travel_agent_avg_rating <= 2.5 then 'PIP recommended.'
            when travel_agent_avg_rating > 2.5 and travel_agent_avg_rating < 4 then 'Warning. Performance dropping.'
            when travel_agent_avg_rating >= 4  then 'Satisfactory performance.'
        end
    where travel_agent_id = travel_agent_id;


-- PROCEDURE

-- 6. Procedure for creating a new trip or adding a segment to a trip.
-- Business rule is travel agents are unable to edit a trip, only add to it or create a new one.
drop procedure if exists p_add_trip_segment
go

create procedure p_add_trip_segment (
    @trip as int = null,
    @traveler as int,
    @flight as int,
    @train as int,
    @car as int,
    @hotel as int
) as begin
    begin try
        begin transaction
            if @trip is null begin
                if exists (
                    select * from trips where
                        (trip_flight_bk_id = @flight and trip_flight_bk_id is not null) or
                        (trip_train_bk_id = @train and trip_train_bk_id is not null) or
                        (trip_car_bk_id = @car and trip_car_bk_id is not null) or
                        (trip_hotel_bk_id = @hotel and trip_hotel_bk_id is not null)
                ) begin
                    ;throw 50014, 'This segment is already in use by another trip.', 1
                end
                else begin
                    insert into trips (trip_created_date, trip_traveler_id, trip_flight_bk_id, trip_train_bk_id, trip_car_bk_id, trip_hotel_bk_id)
                        values (getdate(), @traveler, @flight, @train, @car, @hotel)
                    if @@rowcount != 1 throw 50015, 'Could not insert record into trips table.', 1
                end
            end
            else begin
                declare @existing_traveler int = (select trip_traveler_id from trips where trip_id = @trip);
                declare @existing_flight int = (select trip_flight_bk_id from trips where trip_id = @trip);
                declare @existing_train int = (select trip_train_bk_id from trips where trip_id = @trip);
                declare @existing_car int = (select trip_car_bk_id from trips where trip_id = @trip);
                declare @existing_hotel int = (select trip_hotel_bk_id from trips where trip_id = @trip);

                if @traveler is not null and @traveler != @existing_traveler
                throw 50016, 'You cannot change the traveler when updating a trip. Contact admin.', 1

                if @flight is not null and @flight != @existing_flight
                throw 50017, 'You cannot change a segment when updating a trip. Contact admin.', 1
               
                if @train is not null and @train != @existing_train
                throw 50018, 'You cannot change a segment when updating a trip. Contact admin.', 1
               
                if @car is not null and @car != @existing_car
                throw 50019, 'You cannot change a segment when updating a trip. Contact admin.', 1
               
                if @hotel is not null and @hotel != @existing_hotel
                throw 50020, 'You cannot change a segment when updating a trip. Contact admin.', 1

                set @flight = coalesce(@existing_flight, @flight);
                set @train = coalesce(@existing_train, @train);
                set @car = coalesce(@existing_car, @car);
                set @hotel = coalesce(@existing_hotel, @hotel);

                update trips set trip_traveler_id = @existing_traveler, trip_flight_bk_id = @flight, trip_train_bk_id = @train, trip_car_bk_id = @car, trip_hotel_bk_id = @hotel
                    where trip_id = @trip;
                if @@rowcount != 1 throw 50021, 'Error updating trip record.', 1        
            end
        commit
    end try
    begin catch
        throw
        select error_number() as error_number, error_message() as error_message
        print 'Rolling back.'
        rollback
    end catch
end
go

------------------------------------
--------- VERIFY TABLES ------------
------------------------------------

select * from client_groups;
select * from client_companies;
select * from travel_agents;
select * from travelers;
select * from tickets;
select * from calls;
select * from ratings;
select * from vendors;
select * from flight_bookings;
select * from train_bookings;
select * from hotel_bookings;
select * from rental_car_bookings;
select * from trips;
select * from client_vendor_preference;
