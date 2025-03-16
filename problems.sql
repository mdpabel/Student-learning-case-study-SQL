select * from student_learning;

-- 1. identify all the undergraduate students and display their id, gender & course

select student_id, gender, course_name 
from student_learning 
where education_level = 'Undergraduate';

-- 2. fetch details of female students who spent over 300 mins on videos and have high possiblity of dropping out.

select * 
from student_learning 
where gender = 'Female' and time_spent_on_videos > 300 and dropout_likelihood = true;

-- 3. Identify students who have either taken Machine learning or data science course and have at least attempt couple of quize or have scored over 60 in quiz. Sort data based on least forum participation.

select * 
from student_learning 
where course_name in ('Machine Learning', 'Data Science') and (quiz_attempts > 1 or quiz_scores > 60) 
order by forum_participation asc;

-- 4. How many students prefer learning through visuals

select count(*) from student_learning where learning_style = 'Visual';

-- 5. What is the minimum and maximum exam score by students with the highest assignment completion rate?

select min(final_exam_score), max(final_exam_score) 
from student_learning 
where assignment_completion_rate = (select max(assignment_completion_rate) from student_learning);

-- 6.What is the average age of all Postgraduate or Undergraduate female students who took cybersecurity course and either had high engagement level or preferred learning through writing or actively participated in at least 20 forums. return whole number.

select split_part(avg(age), '.', 1) as avg_age --  round(avg(age), 0)
from student_learning 
where education_level in ('Undergraduate', 'Postgraduate') 
and gender = 'Female' 
and course_name = 'Cybersecurity' 
and (engagement_level = 'High' or learning_style like '%Writing%'  or forum_participation >= 20);

-- 7. Identify all the male postgraduate student or female undergraduate student with final score over 90. Output should contains 2 columns, 1 with the student id amd second column should indicate male postgraduate student as "Master degree" and female undergraduate student as "Bechelor degree"

select student_id,  case when gender = 'Male' then 'Master degree' else 'Bechelor degree' end as degree
from student_learning
where ((gender = 'Male' and education_level = 'Postgraduate')
or (gender = 'Female' and education_level = 'Undergraduate'))
and final_exam_score > 90

--8. What is the average time spent on watching videos based on education level? Consider only those students whose age is an even number. Round the value to a single decimal point.

select education_level, round(avg(time_spent_on_videos), 1) as avg_mins
from student_learning
where age % 2 = 0
group by education_level


-- 9.Identify the most popular male and female student among teachers. Popularity is based on students scoring the highest exam score and highest assignment_completion_rate.

select *
from student_learning
where (gender = 'Male'
and final_exam_score = (select max(final_exam_score) from student_learning where gender = 'Male') 
and assignment_completion_rate = (select max(assignment_completion_rate) from student_learning where gender = 'Male'))
or (gender = 'Female' 
and final_exam_score = (select max(final_exam_score) from student_learning where gender = 'Female')
and assignment_completion_rate = (select max(assignment_completion_rate) from student_learning where gender = 'Female'));


-- 10. How many male, female and other students have never participated in a forum with bare minimun quiz attempts and have low engagement level. Result should be 3 columns, 1 each for each gender.

select 
sum(case when gender = 'Male' then 1 else 0 end) as male,
sum(case when gender = 'Female' then 1 else 0 end) as female,
sum(case when gender = 'Other' then 1 else 0 end) as other
from student_learning
where forum_participation = 0
and quiz_attempts = (select min(quiz_attempts) from student_learning)
and engagement_level = 'Low'

-- 11. How many students have taken python, machine learning and data science course?

select course_name, count(*)
from student_learning
where course_name in ('Machine Learning', 'Python Basics', 'Data Science')
group by course_name


-- 12. Identify the courses that are taken by more than 2000 students.

select course_name, count(*) as total_students
from student_learning
group by course_name
having count(*) > 2000;

-- 13. What is the preferred course and learning style of students over 40 yrs of age.

select * from (select course_name
from student_learning
where age > 40
group by course_name
order by count(*) desc
limit 1
)

union

select * from (select learning_style
from student_learning
where age > 40
group by learning_style
order by count(*) desc
limit 1
)

-- 14. Provide a summary of all the courses. How many students have taken each of them but segregate them based on gender. Output should be 3 columns, course_name, male_count, female_count and other_count.

select course_name, 
sum(case when gender = 'Male' then 1 else 0 end) as male_count,
sum(case when gender = 'Female' then 1 else 0 end) as female_count,
sum(case when gender = 'Other' then 1 else 0 end) as other_count
from student_learning
group by course_name

-- 15. Identify the most popular courses, between the age group of 15-25, 26-40 and >40. Course popularity is based on how many students have taken it. Output should be 3 columns specific to each age group.

select course_name,
sum(case when age between 15 and 25 then 1 else 0 end) as "15-25",
sum(case when age between 26 and 40 then 1 else 0 end) as "26-40",
sum(case when age > 40 then 1 else 0 end) as ">40"
from student_learning
group by course_name
order by "15-25" DESC, "26-40" DESC, ">40" DESC;