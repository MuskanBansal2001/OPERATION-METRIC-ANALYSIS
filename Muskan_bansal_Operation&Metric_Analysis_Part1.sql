/* CASE STUDY 1
Table-1: job_data
job_id: unique identifier of jobs
actor_id: unique identifier of actor
event: decision/skip/transfer
language: language of the content
time_spent: time spent to review the job in seconds
org: organization of the actor
ds: date in the yyyy/mm/dd format. It is stored in the form of text and we use presto to run. no need for date function
*/ 
SELECT * FROM job_data;
/*
QUESTION 1: Number of jobs reviewed: Amount of jobs reviewed over time.
Your task: Calculate the number of jobs reviewed per hour per day for November 2020?
*/
select sum(time_spent)/3600 as jobs_reviewed
from job_data
where ds between '2020-11-01' and '2020-11-30' group by ds limit 1;
/*
QUESTION 2: Throughput: It is the no. of events happening per second.
Your task: Let’s say the above metric is called throughput.
Calculate 7 day rolling average of throughput? For throughput,
do you prefer daily metric or 7-day rolling and why?
*/ 
/* To find the throughput, I will prefer daily metric and find it's average,
7 day rolling average is preferred for the graph as it will have less
fluctuations and with larger amout of data, daily metric is not viable for the visualisation.
BUT, here since the data is small, I will go with daily metric. And I don't have enough data
to find a 7-day rolling average*/
INSERT INTO job_data(ds) values('2020-12-01');
select ds, count(event) as jobs_reviewed, avg(100*(time_spent)/3600) over(order by ds rows between 6 preceding and current 
row) as sevennDay_rolling_average 
from job_data group by ds limit 6;
/*
QUESTION 3: Percentage share of each language: Share of each language for different contents.
Your task: Calculate the percentage share of each language in the last 30 days?
*/
select language, count(*) as number_of_jobs from job_data where ds between '2020-11-01' and '2020-11-30' group by language;
select language, number_of_jobs, 100*(number_of_jobs/8) as percentage_share from (select language, count(language) as number_of_jobs from
job_data where ds between '2020-11-01' and '2020-11-30' group by language) as alias;
/*
QUESTION 4: Duplicate rows: Rows that have the same value present in them.
Your task: Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?
*/

SELECT * FROM job_data INNER JOIN (SELECT job_id,language FROM job_data GROUP BY job_id,language
HAVING COUNT(job_id) >1) temp where job_data.language= temp.language;
