# Introduction

📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

# Tools I Used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- SQL: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- PostgreSQL: The chosen database management system, ideal for handling the job posting data.
- Visual Studio Code: My go-to for database management and executing SQL queries.
- Git & GitHub: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Anlysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
job_id,
name AS company_name,
job_title,
job_location,
job_schedule_type,
salary_year_avg,
job_posted_date
FROM
	job_postings_fact AS jp
LEFT JOIN company_dim AS cd ON jp.company_id = cd.company_id
WHERE
	job_title_short = 'Data Analyst' AND
	job_location = 'Anywhere' AND
	salary_year_avg IS NOT NULL
ORDER BY
	salary_year_avg DESC
LIMIT 10;
```

Here's the breakdown of the top data analyst jobs in 2023:

- Wide Salary Range: Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- Diverse Employers: Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- Job Title Variety: There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![Top Paying Data Analyst Jobs](/assets/1.png)
_Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results_

### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_data_analyst_jobs AS (
    SELECT
        jp.job_id,
        cd.name AS company_name,
        jp.job_title,
        jp.job_location,
        jp.job_schedule_type,
        jp.salary_year_avg,
        jp.job_posted_date
    FROM job_postings_fact AS jp
    LEFT JOIN company_dim AS cd
        ON jp.company_id = cd.company_id
    WHERE jp.job_title_short = 'Data Analyst'
      AND jp.job_location = 'Anywhere'
      AND jp.salary_year_avg IS NOT NULL
    ORDER BY jp.salary_year_avg DESC
    LIMIT 10
)
SELECT
	    td.*,
        sd.skills
FROM skills_job_dim sjd
INNER JOIN top_data_analyst_jobs AS td ON td.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
ORDER BY td.salary_year_avg DESC;
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- SQL is leading with a bold count of 8.
- Python follows closely with a bold count of 7.
- Tableau is also highly sought after, with a bold count of 6. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

![Top 10 Skills for Data Analyst Jobs](/assets/2.png)
_Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results_

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
sd.skills,
COUNT(sjd.skill_id ) AS demand_count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst'
--WHERE jpf.job_title_short ILIKE 'Data Analyst'
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 5;
```

Here's the breakdown of the most demanded skills for data analysts in 2023

- SQL and Excel remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- Programming and Visualization Tools like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
| :------- | :----------: |
| SQL      |     7291     |
| Excel    |     4611     |
| Python   |     4330     |
| Python   |     3745     |
| Power BI |     2609     |

_Table of the demand for the top 5 skills in data analyst job postings_

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
	sd.skills,
	ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact jpf
INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
WHERE
	jpf.job_title_short = 'Data Analyst' AND
	jpf.salary_year_avg IS NOT NULL AND
	jpf.job_location = 'Anywhere'
GROUP BY sd.skills
ORDER BY avg_salary DESC
LIMIT 25;
```

Here's a breakdown of the results for top paying skills for Data Analysts:

- High Demand for Big Data & ML Skills: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- Software Development & Deployment Proficiency: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- Cloud Computing Expertise: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skills        | Average Salary ($) |
| :------------ | :----------------- |
| pyspark       | 208,172            |
| bitbucket     | 189,155            |
| couchbase     | 160,515            |
| watson        | 160,515            |
| datarobot     | 155,486            |
| gitlab        | 154,500            |
| swift         | 153,750            |
| jupyter       | 152,777            |
| pandas        | 151,821            |
| elasticsearch | 145,000            |

_Table of the average salary for the top 10 paying skills for data analysts_

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql

WITH skills_demand AS (
  -- CTE แรก: นับจำนวนงาน (demand) ต่อ skill
  SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
  FROM job_postings_fact AS jpf
  INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
  INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
  WHERE
    jpf.job_title_short = 'Data Analyst'   -- เฉพาะตำแหน่ง Data Analyst
    AND jpf.salary_year_avg IS NOT NULL    -- ต้องมีเงินเดือนระบุ
    AND jpf.job_work_from_home = TRUE      -- เฉพาะ remote jobs
  GROUP BY sd.skill_id, sd.skills
),

average_salary AS (
  -- CTE สอง: หาเงินเดือนเฉลี่ยของแต่ละ skill
  SELECT
    sd.skill_id,
    sd.skills,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
  FROM job_postings_fact AS jpf
  INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
  INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
  WHERE
    jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_work_from_home = TRUE
  GROUP BY sd.skill_id, sd.skills
)

-- Join สอง CTE เข้าด้วยกัน
SELECT
  d.skill_id,
  d.skills,
  d.demand_count,   -- จำนวนงานที่ต้องการสกิลนี้
  a.avg_salary      -- ค่าเฉลี่ยเงินเดือน
FROM skills_demand d
JOIN average_salary a
  ON d.skill_id = a.skill_id
WHERE d.demand_count > 10   -- filter: เอาเฉพาะสกิลที่มี demand มากกว่า 10
ORDER BY
  a.avg_salary DESC,        -- เรียงลำดับก่อนตามเงินเดือนเฉลี่ย
  d.demand_count DESC       -- แล้วค่อยตามจำนวน demand
LIMIT 25;
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
| :------- | :--------- | :----------- | :----------------- |
| 8        | go         | 27           | 115,320            |
| 234      | confluence | 11           | 114,210            |
| 97       | hadoop     | 22           | 113,193            |
| 80       | snowflake  | 37           | 112,948            |
| 74       | azure      | 34           | 111,225            |
| 77       | bigquery   | 13           | 109,654            |
| 76       | aws        | 32           | 108,317            |
| 4        | java       | 17           | 106,906            |
| 194      | ssis       | 12           | 106,683            |
| 233      | jira       | 20           | 104,918            |

_Table of the most optimal skills for data analyst sorted by salary_

Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- High-Demand Programming Languages: Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- Cloud Tools and Technologies: Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- Business Intelligence and Visualization Tools: Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- Database Technologies: The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

1. Top-Paying Data Analyst Jobs: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. Skills for Top-Paying Jobs: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. Most In-Demand Skills: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. Skills with Higher Salaries: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. Optimal Skills for Job Market Value: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

# Conclusions

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
