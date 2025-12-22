-- Demos to test database functionality and to see a few user stories in action.
-- To clearly see results, run each demo individually.

use BizTravelDB
go 

-- 1.1 Verify Average Call Time function.
select
    travel_agent_id as agent_ID,
    travel_agent_first_name as agent_firstname,
    travel_agent_last_name as agent_lastname,
    dbo.f_travel_agent_avg_call_time(travel_agent_id) as avg_call_length_in_mins
from travel_agents

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

-- 2.1 Verify Average Agent Rating function.
select
    travel_agent_id as agent_ID,
    travel_agent_first_name as agent_firstname,
    travel_agent_last_name as agent_lastname,
    dbo.f_travel_agent_avg_rating(travel_agent_id) as avg_travel_agent_rating
from travel_agents

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

-- 3.1 Verify Average Callback Frequency function.
select
    travel_agent_id as agent_id,
    travel_agent_first_name as agent_firstname,
    travel_agent_last_name as agent_lastname,
    dbo.f_travel_agent_avg_cb_freq(travel_agent_id) as avg_agent_cb_freq
from travel_agents
go

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

-- 4.1 Verify calls table trigger works after inserting using 2 scenarios.

-- Scenario #1: Invalid call is inserted.
-- Should get a custom error and see that call insert was rolled back.

-- This call insert in invalid because there is a value for call_from_agent and call_from_traveler.
select count(call_id) as number_calls_in_table_before
    from calls
go

insert into calls (call_date, call_length_in_mins, call_reason, call_from_agent, call_from_traveler, call_to_agent, call_to_traveler, call_ticket_id) values
('2027-10-31', 15, 'Booking Hotel', 42, 42, 9, null, 27)
go

select count(call_id) as number_calls_in_table_after
    from calls
go

-- Scenario #2: Valid call inserts.
-- Should see an update in travel_agent stats.

select count(call_id) as number_calls_in_table_before
    from calls
go

select travel_agent_id, travel_agent_avg_call_time as avg_call_time_before, travel_agent_avg_callbk_freq as avg_callbk_freq_before
    from travel_agents
    where travel_agent_id = 10 or travel_agent_id = 6
go

insert into calls (call_date, call_length_in_mins, call_reason, call_from_agent, call_from_traveler, call_to_agent, call_to_traveler, call_ticket_id) values
('2027-10-28', 14, 'Trip Confirmation', null, 55, 10, null, 26),
('2027-10-28', 5, 'Booking Train', null, 55, 10, null, 26),
('2027-10-28', 3, 'Returning missed call.', 6, null, null, 18, 13)
go

select count(call_id) as number_calls_in_table_after
    from calls
go

select travel_agent_id, travel_agent_avg_call_time as avg_call_time_after, travel_agent_avg_callbk_freq as avg_callbk_freq_after
    from travel_agents
    where travel_agent_id = 10 or travel_agent_id = 6
go

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

-- 5.1 Verify ratings table trigger works after inserting.
select travel_agent_id, travel_agent_avg_rating, travel_agent_standing
    from travel_agents
    where travel_agent_id = 3 or travel_agent_id = 10 or travel_agent_id = 7
go

insert into ratings (rating_date_submitted, rating_value, rating_comments, rating_submitted_by, rating_for) values
('2025-10-23', 5, 'Excellent service, very helpful.', 14, 3),
('2025-10-22', 4, 'Okay service, decently helpful.', 48, 10),
('2025-10-21', 1, 'Agent didn''t know what they were doing.', 33, 7)
go

select top 3* from ratings order by rating_id desc
go

select travel_agent_id, travel_agent_avg_rating, travel_agent_standing
    from travel_agents
    where travel_agent_id = 3 or travel_agent_id = 10 or travel_agent_id = 7
go

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

-- 6.1 Verify create trip/add segment procedure works using 3 scenarios.

-- Scenario #1: Creating a trip.
-- Traveler 24 has a flight (11), hotel (11), and car (7) segment.
-- We will create a trip with the hotel segment here...

select * from trips
go

exec p_add_trip_segment @trip = null, @traveler = 24, @flight = null, @train = null, @car = null, @hotel = 11;
go

select * from trips
go

-- Scenario #2: Attempting to edit an existing trip.
-- This should error out to demonstrate the custom error handling.
-- Attempting to change the traveler of trip_id 4.

exec p_add_trip_segment @trip = 4, @traveler = 2, @flight = null, @train = null, @car = 2, @hotel = null;
go

-- Scenario #3: Adding segments to an existing trip.
-- This should successfully add the segments.
-- Adding traveler 24's (from scenario #1) flight and car segments.

select * from trips where trip_id = 11
go

exec p_add_trip_segment @trip = 11, @traveler = null, @flight = 11, @train = null, @car = 7, @hotel = null;
go

select * from trips where trip_id = 11
go

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

-- User Stories:

-- User Story #1: "As a client company, I can define preferred vendors for my employees, so that bookings stay within our corporate travel policies."

-- This user story is supported by a bridge table. This is also how we handled multi-valued attributes.
-- Each client has 0 or more preferred vendors | A client_comp_id is connected to several preferred vendor_ids.

-- The following queries show the client_vendor_preference bridge table and the bridging of client_comp_name and vendor_name:

-- Bridge table:
select top 10* from client_vendor_preference
go

-- Some client-vendor preferences:
select client_comp_name, vendor_name, vendor_type
    from client_vendor_preference as cv 
    join client_companies as cc on cc.client_comp_id = cv.client_pref_client_id
    join vendors as v on v.vendor_id = cv.client_pref_vendor_id
go



-- User Story #2: "As an agent supervisor, I can supply the travel agent's ID to view the travel agent's
-- average call time, callback frequency, and rating from callers so that I can monitor their performance over time."

-- This demo includes a procedure that does the following:
-- 1. A travel agent supervisor can supply a client group name to retrieve the overall stats of that client group.
-- 2. A travel agent supervisor can supply a travel agent id to view their stats along with the overall stats of the client group the travel agent supports.

-- Run procedure first.
use BizTravelDB 
go 

drop procedure if exists p_view_stats
go

create procedure p_view_stats(
    @agent_id int = null,
    @client_group char(1) = null
) as begin
    begin try
        begin transaction
        if @agent_id is not null begin 
            select @client_group = client_group_name
                from travel_agents
                join client_groups on travel_agent_client_group_id = client_group_id
                where travel_agent_id = @agent_id;
            
            select
                travel_agent_first_name + ' ' + travel_agent_last_name as travel_agent, client_group_name as client_group,
                travel_agent_avg_call_time as avg_call_time, travel_agent_avg_callbk_freq as avg_callbk_freq, travel_agent_avg_rating as avg_rating
                from travel_agents
                join client_groups on travel_agent_client_group_id = client_group_id
                    where travel_agent_id = @agent_id
            if @@rowcount <> 1 throw 50031, 'Error retrieving travel agent information.', 1
        end

        select distinct top 1 with ties
            client_group_name,
            cast(avg(t.travel_agent_avg_rating) over (partition by c.client_group_name) as decimal(3,2)) as overall_avg_rating_by_group,
            first_value(t.travel_agent_first_name + ' ' + t.travel_agent_last_name) over (order by t.travel_agent_avg_rating desc) as ta_with_highest_rating,
            max(t.travel_agent_avg_rating) over (partition by c.client_group_name) as ta_avg_rating_highest,
            first_value(t.travel_agent_first_name + ' ' + t.travel_agent_last_name) over (order by t.travel_agent_avg_rating) as ta_with_lowest_rating,
            min(t.travel_agent_avg_rating) over (partition by c.client_group_name) as ta_avg_rating_lowest,
            cc.client_comp_name as lowest_rating_client, 
            r.rating_value as rating_value,
            tr.traveler_first_name + ' ' + tr.traveler_last_name as rating_from,
            r.rating_comments as rating_comments
                from travel_agents as t 
                join client_groups as c on t.travel_agent_client_group_id = c.client_group_id
                join client_companies as cc on cc.client_comp_group_id = c.client_group_id
                join travelers as tr on tr.traveler_company = cc.client_comp_id
                join ratings as r on r.rating_submitted_by = tr.traveler_id
                    where client_group_name = @client_group
                    group by r.rating_value, client_group_name, cc.client_comp_name, tr.traveler_first_name, tr.traveler_last_name, r.rating_comments,
                        t.travel_agent_avg_rating, t.travel_agent_first_name, t.travel_agent_last_name
                    order by r.rating_value
        if @@rowcount < 1 throw 50032, 'Error retrieving client group information.', 1
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

-- Execute.
exec p_view_stats @agent_id = 8;

exec p_view_stats @client_group = 'B';

-- Client group stats include:
-- An overall average agent rating.
-- Travel agent with the highest rating and their individual rating.
-- Travel agent with the lowest rating and their individual rating.
-- Client company name(s) that submitted the lowest rating(s) along with the rating value(s), the traveler(s) who submitted, and any rating comments.


