/** MYSQL Exercise Log: From recent to oldest **/

-- Practicing Joins
-- https://www.hackerrank.com/challenges/placements/problem?isFullScreen=true
SELECT s.Name
    FROM Students s
        JOIN Friends f ON f.ID=s.ID
        JOIN Packages p ON p.ID=s.ID
        JOIN Packages fp ON fp.ID=f.Friend_ID
    WHERE fp.Salary > p.Salary
    ORDER BY fp.Salary;

 
--Having a duplicates of the highest only
--Attempt 1
SELECT
    h.hacker_id,
    h.name,
    CASE WHEN c.challenge_created != MAX(c.challenge_created)
         THEN c.challenge_created
         ELSE c.challenge_created
         END AS challenge_created
    FROM Hackers h
        JOIN (
            /** Non-unique count values **/
            SELECT hacker_id, COUNT(challenge_id) as challenge_created
            FROM Challenges
            GROUP BY hacker_id) c
        ON h.hacker_id = c.hacker_id
        JOIN (
            /** Unique count values **/
            SELECT DISTINCT challenge_created
            FROM (
            SELECT hacker_id, COUNT(challenge_id) as challenge_created
            FROM Challenges
            GROUP BY hacker_id) ) u
    ORDER BY challenge_created DESC, h.hacker_id;
 
--Solution
/* these are the columns we want to output */
select c.hacker_id, h.name ,count(c.hacker_id) as c_count
    /* this is the join we want to output them from */
    from Hackers as h inner join Challenges as c on c.hacker_id = h.hacker_id
    /* after they have been grouped by hacker */
    group by c.hacker_id
    /* but we want to be selective about which hackers we output having is required (instead of where) for filtering on groups */
    having 

        /* output anyone with a count that is equal to... */
        c_count = 
            /* the max count that anyone has */
            (SELECT MAX(temp1.cnt)
            from (SELECT COUNT(hacker_id) as cnt
                from Challenges
                group by hacker_id
                order by hacker_id) temp1)

        /* or anyone who's count is in... */
        or c_count in 
            /* the set of counts... */
            (select t.cnt
            from (select count(*) as cnt 
                from challenges
                group by hacker_id) t
            /* who's group of counts... */
            group by t.cnt
            /* has only one element */
            having count(t.cnt) = 1)

    /* finally, the order the rows should be output */
    order by c_count DESC, c.hacker_id

--Self Joining based on range of dates
--Solution
SELECT s.Start_Date, MIN(e.End_Date)
    FROM (
        SELECT a.Start_Date 
        FROM Projects A LEFT JOIN Projects t ON a.Start_Date=t.End_Date
        WHERE t.End_Date IS NULL) s
    JOIN (
        SELECT a.End_Date
        FROM Projects A LEFT JOIN Projects t ON a.End_Date= t.Start_Date
        WHERE t.Start_Date IS NULL) e
    ON s.Start_Date < e.End_Date
    GROUP BY s.Start_Date
    ORDER BY DATEDIFF(MIN(e.End_Date), s.Start_Date), s.Start_Date

--Joining based on range conditions
--Solution:
SELECT CASE WHEN Grade<8 THEN NULL ELSE Name END AS Name, Grade, Marks
    FROM Students s JOIN Grades g ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
    ORDER BY Grade DESC, Name, Marks

--Unique outputs after ordering
--Solution 1: (Worked, but incorrect answer) I did not understand what the question was asking for.
SELECT ply.hacker_id, ply.name
    FROM Submissions inpt 
        JOIN Hackers    ply ON inpt.hacker_id=ply.hacker_id    
        JOIN Challenges cha ON inpt.challenge_id=cha.challenge_id
        JOIN Difficulty lvl ON cha.difficulty_level=lvl.difficulty_level 
    WHERE 
        ply.hacker_id IN (SELECT hacker_id FROM submissions GROUP BY hacker_id HAVING COUNT(hacker_id)>1) AND
        inpt.score = lvl.score
    GROUP BY ply.hacker_id, ply.name
    ORDER BY COUNT(ply.hacker_id) DESC, ply.hacker_id

--Solution 2:
--Correlated Subqueries
--Group by doesn’t work here because we need the id. One way to go around this is by agg the ID but this doesnt solve the question
SELECT id, age, MIN(coins_needed), power
    FROM Wands w1 JOIN Wands_Property wp1 ON w1.code=wp1.code
    WHERE is_evil=0
    GROUP BY  id, age,  power
    ORDER BY power DESC, age DESC
 
--Solution: This works because they are depends on each other (outer and inner query)
SELECT id, age, coins_needed, power
    FROM Wands w1 JOIN Wands_Property wp1 ON w1.code=wp1.code
    WHERE is_evil = 0 AND
        coins_needed = (SELECT MIN(coins_needed)
                        FROM Wands w2 JOIN Wands_Property wp2 ON w2.code=wp2.code
                        WHERE w2.power = w1.power AND wp2.age = wp1.age)
    ORDER BY power DESC, age DESC
 
--De-bugging Groupby agg
select 
    c.company_code, 
    c.founder, 
    count(distinct l.lead_manager_code), 
    count(distinct s.senior_manager_code), 
    count(distinct m.manager_code),
    count(distinct e.employee_code) 
    from 
        Company c, 
        Lead_Manager l, 
        Senior_Manager s, 
        Manager m, 
        Employee e 
    where 
            c.company_code = l.company_code 
        and l.lead_manager_code=s.lead_manager_code 
        and s.senior_manager_code=m.senior_manager_code 
        and m.manager_code=e.manager_code 
    group by c.company_code, c.founder 
    order by c.company_code;
 
 
--Creating Sentence statements
--Solution 1: (order by isn’t working)
(SELECT CONCAT(Name,"(", SUBSTRING(Occupation, 1, 1),")")
    FROM OCCUPATIONS ORDER BY Name )
    UNION
    (SELECT CONCAT("There are a total of ",COUNT(Occupation)," ",Occupation,"s.")
    FROM OCCUPATIONS
    GROUP BY Occupation
    ORDER BY COUNT(Occupation) ,Occupation)
 
--Solution 2
SELECT CONCAT(Name,"(", SUBSTRING(Occupation, 1, 1),")")
    FROM OCCUPATIONS ORDER BY Name ;
    SELECT CONCAT("There are a total of ",COUNT(Occupation)," ",Occupation,"s.")
    FROM OCCUPATIONS
    GROUP BY Occupation
    ORDER BY COUNT(Occupation) , Occupation;
 
--Order by: End of the string
--Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
--Solution 1:
SELECT Name FROM STUDENTS
    WHERE Marks>75
    ORDER BY SUBSTRING(Name,-3,3), ID
--Alternative Answer:
SELECT NAME FROM STUDENTS WHERE MARKS > 75 ORDER BY RIGHT(NAME, 3), ID ASC;
 
--Regexp: doesnt start or end
--Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
--Solution 1: (Didn’t work)
SELECT DISTINCT CITY FROM STATION
    WHERE CITY REGEXP '^[^aeiou] | [^aeiou]$'
 
--Solution 2
SELECT DISTINCT CITY FROM STATION 
    WHERE SUBSTRING(CITY,1,1) 
    NOT RLIKE "^[AEIUO]" AND
    RIGHT(CITY,1) NOT RLIKE "^[AEIOU]";
    

--Using Length and Union
--Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
--Solution 1: (incorrect)
SELECT name, months*salary AS earnings
    FROM employee
    Group by name
    Having max(earnings)
--Solution 2:
select (salary * months) as earnings, count(*) 
    from employee 
    group by 1 
    order by earnings desc limit 1
 
--Change # using replace and ceil
--Solution 1:
SELECT name FROM Employee WHERE months<10 and salary>2000
 
--Count vs distinct, checking for duplicates
--Total vs. Distinct used for identifying duplicates
--Solution 1: (Error)
SELECT COUNT(CITY) , DISTINCT(CITY), COUNT(CITY) - DISTINCT(CITY) FROM STATION
--Solution 2: (After looking at discussion, Correct)
SELECT COUNT(CITY)-COUNT(DISTINCT(CITY) ) FROM STATION
 
--Learning where (Japan Population)
--Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
--Solution:
SELECT SUM(POPULATION) FROM CITY WHERE COUNTRYCODE = 'JPN'
