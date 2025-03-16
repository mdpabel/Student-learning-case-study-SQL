# Student Learning SQL Queries

This repository contains SQL queries for analyzing student learning data. The queries cover various aspects of student performance, engagement, and course preferences.

## Dataset

The dataset used for this case study is **`student-learning-case-study.csv`**.

## Table: `student_learning`

### Queries

#### 1. Identify all undergraduate students and display their ID, gender, and course.

```sql
SELECT student_id, gender, course_name
FROM student_learning
WHERE education_level = 'Undergraduate';
```

#### 2. Fetch details of female students who spent over 300 minutes on videos and have a high possibility of dropping out.

```sql
SELECT *
FROM student_learning
WHERE gender = 'Female' AND time_spent_on_videos > 300 AND dropout_likelihood = TRUE;
```

#### 3. Identify students who have either taken Machine Learning or Data Science courses and have attempted at least two quizzes or scored over 60 in quizzes. Sort by least forum participation.

```sql
SELECT *
FROM student_learning
WHERE course_name IN ('Machine Learning', 'Data Science')
AND (quiz_attempts > 1 OR quiz_scores > 60)
ORDER BY forum_participation ASC;
```

#### 4. Count the number of students who prefer learning through visuals.

```sql
SELECT COUNT(*) FROM student_learning WHERE learning_style = 'Visual';
```

#### 5. Retrieve the minimum and maximum exam scores of students with the highest assignment completion rate.

```sql
SELECT MIN(final_exam_score), MAX(final_exam_score)
FROM student_learning
WHERE assignment_completion_rate = (SELECT MAX(assignment_completion_rate) FROM student_learning);
```

#### 6. Calculate the average age of all postgraduate or undergraduate female students who took a cybersecurity course and either had high engagement or preferred learning through writing or actively participated in at least 20 forums. Return as a whole number.

```sql
SELECT SPLIT_PART(AVG(age), '.', 1) AS avg_age
FROM student_learning
WHERE education_level IN ('Undergraduate', 'Postgraduate')
AND gender = 'Female'
AND course_name = 'Cybersecurity'
AND (engagement_level = 'High' OR learning_style LIKE '%Writing%' OR forum_participation >= 20);
```

#### 7. Identify male postgraduate or female undergraduate students with final scores over 90, labeling them accordingly.

```sql
SELECT student_id,
CASE WHEN gender = 'Male' THEN 'Master degree' ELSE 'Bachelor degree' END AS degree
FROM student_learning
WHERE ((gender = 'Male' AND education_level = 'Postgraduate')
OR (gender = 'Female' AND education_level = 'Undergraduate'))
AND final_exam_score > 90;
```

#### 8. Calculate the average time spent on watching videos based on education level for students with even-numbered ages, rounded to one decimal place.

```sql
SELECT education_level, ROUND(AVG(time_spent_on_videos), 1) AS avg_mins
FROM student_learning
WHERE age % 2 = 0
GROUP BY education_level;
```

#### 9. Identify the most popular male and female students among teachers based on exam scores and assignment completion rates.

```sql
SELECT *
FROM student_learning
WHERE (gender = 'Male'
AND final_exam_score = (SELECT MAX(final_exam_score) FROM student_learning WHERE gender = 'Male')
AND assignment_completion_rate = (SELECT MAX(assignment_completion_rate) FROM student_learning WHERE gender = 'Male'))
OR (gender = 'Female'
AND final_exam_score = (SELECT MAX(final_exam_score) FROM student_learning WHERE gender = 'Female')
AND assignment_completion_rate = (SELECT MAX(assignment_completion_rate) FROM student_learning WHERE gender = 'Female'));
```

#### 10. Count male, female, and other students who never participated in a forum, had minimal quiz attempts, and low engagement.

```sql
SELECT
SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male,
SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female,
SUM(CASE WHEN gender = 'Other' THEN 1 ELSE 0 END) AS other
FROM student_learning
WHERE forum_participation = 0
AND quiz_attempts = (SELECT MIN(quiz_attempts) FROM student_learning)
AND engagement_level = 'Low';
```

#### 11. Count students enrolled in Python, Machine Learning, and Data Science courses.

```sql
SELECT course_name, COUNT(*)
FROM student_learning
WHERE course_name IN ('Machine Learning', 'Python Basics', 'Data Science')
GROUP BY course_name;
```

#### 12. Identify courses taken by more than 2000 students.

```sql
SELECT course_name, COUNT(*) AS total_students
FROM student_learning
GROUP BY course_name
HAVING COUNT(*) > 2000;
```

#### 13. Determine the preferred course and learning style of students over 40 years old.

```sql
SELECT * FROM (
    SELECT course_name
    FROM student_learning
    WHERE age > 40
    GROUP BY course_name
    ORDER BY COUNT(*) DESC
    LIMIT 1
)

UNION

SELECT * FROM (
    SELECT learning_style
    FROM student_learning
    WHERE age > 40
    GROUP BY learning_style
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
```

#### 14. Provide a summary of all courses with student count segregated by gender.

```sql
SELECT course_name,
SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
SUM(CASE WHEN gender = 'Other' THEN 1 ELSE 0 END) AS other_count
FROM student_learning
GROUP BY course_name;
```

#### 15. Identify the most popular courses among different age groups (15-25, 26-40, >40).

```sql
SELECT course_name,
SUM(CASE WHEN age BETWEEN 15 AND 25 THEN 1 ELSE 0 END) AS "15-25",
SUM(CASE WHEN age BETWEEN 26 AND 40 THEN 1 ELSE 0 END) AS "26-40",
SUM(CASE WHEN age > 40 THEN 1 ELSE 0 END) AS ">40"
FROM student_learning
GROUP BY course_name
ORDER BY "15-25" DESC, "26-40" DESC, ">40" DESC;
```

## License

This repository is open for educational and analytical purposes. Feel free to use and modify the queries as needed.
