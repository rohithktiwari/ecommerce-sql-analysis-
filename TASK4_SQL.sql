CREATE DATABASE TASK;
USE TASK;


-- All Tables
SELECT * FROM ad_events;
SELECT * FROM ADS;
SELECT * FROM CAMPAIGNS;
SELECT * FROM USERS;


#Querying & Filtering
#1 - List all campaigns that ended in the year 2025
SELECT END_DATE FROM CAMPAIGNS
WHERE YEAR(END_DATE) = '2025';



#2 - Retrieve all users from Japan aged between 25 and 40.
SELECT * FROM USERS 
WHERE COUNTRY = 'Japan' AND user_age BETWEEN 25 AND 40
ORDER BY user_age ASC;



#3 Show all ad events that occurred during the Evening on a Monday.
SELECT * FROM ad_events
where day_of_week = 'Monday' AND time_of_day = 'Evening';


-----------------------------------------------------------------------------------------

#Joins & Relationships
#- Get the names of campaigns along with the platforms used in their ads.
SELECT 
		C.campaign_id,
        C.name,
        A.ad_platform,
        A.target_interests,
        A.ad_type,
        C.total_budget,
        C.duration_days
FROM CAMPAIGNS C
INNER JOIN ADS A
ON C.campaign_id = A.campaign_id;
        
        
#- List users who interacted with ads via a 'Click' event. Show their age and location. 
      
SELECT 
		U.user_id,
        U.user_age,
        U.location
FROM USERS U 
INNER JOIN AD_EVENTS A
ON U.user_id = A.user_id
WHERE  A.event_type = 'Click';


#- Find which campaigns had ads targeting the '18-24' age group and 'fashion' interest.

SELECT 
		C.campaign_id,
        C.name,
        C.duration_days,
        C.total_budget,
        A.target_age_group AS age_group,
        A.target_interests AS interests
FROM CAMPAIGNS C 
INNER JOIN ADS A 
ON C.campaign_id = A.campaign_id
WHERE A.target_age_group = '18-24' AND A.target_interests = 'fashion' OR A.target_interests LIKE '%fashion%' ;

-------------------------------------------------------------------------------------------


#📊 Aggregations & Grouping
#Count how many events occurred per day of the week.
SELECT COUNT(*) AS TOTAL_EVENTS,day_of_week
FROM AD_EVENTS
GROUP BY day_of_week
ORDER BY day_of_week ASC;


#Calculate the average age of users per country.
SELECT COUNTRY, ROUND(AVG(user_age),2) AS AVERAGE_AGE
FROM USERS
GROUP BY COUNTRY;

#Find the total budget spent on campaigns targeting 'Impression' interest.
SELECT 
        C.name,
		SUM(C.total_budget) AS TOTAL_BUDGET,
        A.target_interests
FROM CAMPAIGNS C
INNER JOIN ADS A
ON C.campaign_id = A.campaign_id
WHERE A.target_interests = 'Impression'
GROUP BY C.NAME;

-------------------------------------------------------------------------------------

#Subqueries & Views
-- #CREATING VIEW

CREATE VIEW show_target_interests_ad_pleatforms as
select ad_platform,target_interests
from ads;
 
select * from show_target_interests_ad_pleatforms;       


       
#-Find users who have interacted with more than 3 different ads.
select u.user_id,
	   u.ad_id,
       u.event_type
from AD_EVENTS u 
where user_id in (
SELECT USER_ID FROM AD_EVENTS
GROUP BY USER_ID 
HAVING COUNT(distinct AD_ID) > 3);



#- Which ad platform has the highest number of 'Share' events?
SELECT 
		A.ad_platform,
        COUNT(*) AS SHARE_COUNT
FROM ADS A
INNER JOIN AD_EVENTS AE
ON A.ad_id = AE.ad_id
WHERE AE.event_type = 'Share'
GROUP BY A.AD_PLATFORM
ORDER BY  SHARE_COUNT DESC;

-----------------------------------------------------------------------------------------


#CREATING INDEXING 
CREATE INDEX USER_AGE
ON USERS(USER_AGE);

CREATE INDEX total_budget
ON CAMPAIGNS(total_budget);

--------------------------------------------------------------------------------
-- EXTRA QUERIES AND ADDING COLUMNS AND OTHER EXTRA STUFFS

set sql_safe_updates = 0;


alter table ad_events  add campaign_id int first;

insert into ad_events (campaign_id)
select campaign_id from CAMPAIGNS;
       
update ad_events a
join CAMPAIGNS c on a.campaign_id = c.campaign_id
set a.campaign_id = c.campaign_id;


SELECT * FROM ad_events;
SELECT * FROM ADS;
SELECT * FROM CAMPAIGNS;
SELECT * FROM USERS;






























SELECT event_type, COUNT(*) AS EVENT_TYPE
FROM AD_EVENTS
where day_of_week = 'Monday' AND time_of_day = 'Evening'
GROUP BY event_type;SELECT * FROM USERS LIMIT 0, 50000
