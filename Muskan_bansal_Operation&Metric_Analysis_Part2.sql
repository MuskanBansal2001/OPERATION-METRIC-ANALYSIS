/*
Case Study 2 (Investigating metric spike)
The structure of the table with the definition of each column that you must work on is present in the project image
*/
/*
Table-1: users
This table includes one row per user, with descriptive information about that user’s account.
Table-2: events
This table includes one row per event, where an event is an action that a user has taken. These events include login events, messaging events, search events, events logged as users progress through a signup funnel, events around received emails.
Table-3: email_events
This table contains events specific to the sending of emails. It is similar in structure to the events table above.
Use the dataset attached in the Dataset section below the project images then answer the questions that follows
*/
show databases;
use metric_spike;
show tables;
/*QUESTION 1: User Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service.
Your task: Calculate the weekly user engagement?*/
select event_type, event_name, extract(month from occurred_at) as week,
count(distinct user_id) as Weekly_Active_Users from table_2_events
group by event_type, event_name, week;

/*QUESTION 2: User Growth: Amount of users growing over time for a product.
Your task: Calculate the user growth for product?*/
select extract(day from created_at) as Day,
count(*) as All_Users, count(case when activated_at is not null then user_id
else null end) as Activated_Users from table_1_users group by 1 order by 1;

/*QUESTION 3: Weekly Retention: Users getting retained weekly after signing-up for a product.
Your task: Calculate the weekly retention of users-sign up cohort?*/
with signup_cohort as
(select company_id, date(created_at) as signup_week from table_1_users)
select signup_week,
count(distinct signup_cohort.company_id) as Total_SignUps,
count(distinct table_2_events.user_id) as retained_users,
count(distinct table_2_events.user_id)/count(distinct signup_cohort.company_id) as Retained_Rate
from signup_cohort
left join table_2_events on table_2_events.user_id = signup_cohort.company_id
group by 1 order by 1;

/*QUESTION 4: Weekly Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service weekly.
Your task: Calculate the weekly engagement per device?*/
with weekly_engagement as (select user_id, device, extract(week from occurred_at)
as week, count(*) as Engagement from table_2_events group by user_id, device,
week order by user_id, device, week)
select device, week, sum(engagement) as weekly_engagement from weekly_engagement
group by device, week;

/*QUESTION 5: Email Engagement: Users engaging with the email service.
Your task: Calculate the email engagement metrics?*/
select count(distinct user_id) as User,
Date_Format("occurred_at", "%U") as Week,
count(case when action = 'sent_weekly_digest' then user_id else not null end) as Weekly_Emails,
count(case when action = 'sent_reengagement_email' then user_id else not null end) as reengagement_emails,
count(case when action = 'email_open' then user_id else not null end) as email_opens,
count(case when action = 'email_clickthrough' then user_id else not null end) as email_clickthroughs
from table_3_email_events group by action;