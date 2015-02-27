#Question 1
#For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
SELECT a.name, a.grade, b.name, b.grade, c.name, c.grade
FROM    Likes l1 
               JOIN Likes l2 
                   ON l1.ID2 = l2.ID1
               JOIN Highschooler a 
                   ON a.ID = l1.ID1
               JOIN Highschooler b
                   ON b.ID = l1.ID2
               JOIN Highschooler c
                   ON c.ID = l2.ID2
WHERE a.name != c.name
 
#Question 2
#Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
SELECT name, grade
FROM    Highschooler 
WHERE  ID NOT IN ( SELECT ID1 
                                  FROM    Friend 
                                                 JOIN  Highschooler h1
                                                     ON h1.ID = ID1
                                                 JOIN  Highschooler h2
                                                     ON h2.ID = ID2
                                  WHERE  h1.grade = h2.grade)
                                  
#Question 3
#What is the average number of friends per student? (Your result should be just one number.) 
SELECT AVG(num) 
FROM   (SELECT ID1, 
               COUNT(ID2) AS num
        FROM    Friend
        GROUP BY ID1)

#Question 4
#Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
SELECT COUNT(DISTINCT f1.ID2) + COUNT(DISTINCT f2.ID2)
FROM    Friend f1 
               JOIN Friend f2
                 ON f1.ID2 = f2.ID1
WHERE  f1.ID1 = (SELECT ID 
                 FROM    Highschooler 
                 WHERE  name = 'Cassandra')
AND    f1.ID1 != f2.ID2

#Question 5
#Find the name and grade of the student(s) with the greatest number of friends. 
SELECT name, grade 
FROM    Highschooler 
WHERE  ID IN (SELECT ID1
                         FROM    Friend
                         GROUP BY ID1
                         HAVING COUNT(ID2) = (SELECT COUNT(ID2)
                                              FROM    Friend
                                              GROUP BY ID1
                                              ORDER BY COUNT(ID2) DESC
                                              LIMIT 1)
              )


               
