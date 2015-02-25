Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema: 

Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

Q1  (1/1 point)
Find the names of all students who are friends with someone named Gabriel. 
SELECT name 
FROM   Highschooler
       JOIN Friend
         ON Highschooler.ID = Friend.ID2
WHERE  ID1
       IN 
       (SELECT ID 
        FROM   Highschooler 
        WHERE  name = 'Gabriel'
       )

Q2  (1/1 point)
For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM   Likes
       JOIN Highschooler h1
         ON Likes.ID1 = h1.ID
       JOIN Highschooler h2
         ON Likes.ID2 = h2.ID
WHERE  h1.grade - h2.grade >=2

Q3  (1/1 point)
For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
SELECT DISTINCT h1.name, h1.grade, h2.name, h2.grade
FROM   Likes l1 
       JOIN Highschooler h1
         ON l1.ID1 = h1.ID
         OR l1.ID2 = h1.ID
       JOIN Likes l2
         ON l1.ID1 = l2.ID2
         AND L1.ID2 = l2.ID1
       JOIN Highschooler h2
         ON l2.ID1 = h2.ID
         OR l2.ID2 = h2.ID
WHERE  h1.name < h2.name

Q4  (1/1 point)
Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
SELECT name,
       grade
FROM   Highschooler 
WHERE  ID NOT IN 
(SELECT ID1
FROM   Likes
UNION 
SELECT ID2 
FROM   Likes)

Q5  (1/1 point)
For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
SELECT a.name, 
       a.grade,
       b.name,
       b.grade
FROM   Highschooler a 
       JOIN Likes l
         ON a.ID = l.ID1
       JOIN Highschooler b
         ON b.ID = l.ID2
WHERE l.ID2 NOT IN 
      (SELECT ID1
       FROM   Likes)
       
Q6  (1/1 point)
Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
SELECT DISTINCT h.name,
       h.grade
FROM   Highschooler h
       JOIN Friend f
         ON h.ID = f.ID1
WHERE  f.ID1 NOT IN 
       (SELECT DISTINCT ID1 
        FROM   Friend 
               JOIN Highschooler h1
                 ON ID1 = h1.ID
               JOIN Highschooler h2 
                 ON ID2 = h2.ID
        WHERE h1.grade != h2.grade
        )
ORDER BY h.grade, h.name

Q7  (1/1 point)
For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
SELECT a.name,
       a.grade,
       b.name,
       b.grade,
       c.name,
       c.grade
FROM   Highschooler a 
       JOIN Friend f1
         ON a.ID = f1.ID1
       JOIN Friend f2
         ON f1.ID2 = f2.ID1
       JOIN Highschooler c
         ON c.ID = f1.ID2
       JOIN Highschooler b
         ON b.ID = f2.ID2
WHERE  f2.ID2 NOT IN (SELECT ID2 FROM Friend WHERE ID1 = f1.ID1)
AND    f2.ID2 IN (SELECT ID2 FROM Likes WHERE ID1 = f1.ID1)

Q8  (1/1 point)
Find the difference between the number of students in the school and the number of different first names. 
SELECT COUNT(ID) - COUNT(DISTINCT name)
FROM   Highschooler

Q9  (1/1 point)
Find the name and grade of all students who are liked by more than one other student. 
SELECT name, grade 
FROM   Likes
       JOIN Highschooler 
         ON ID = ID2
GROUP BY ID2
HAVING
COUNT( DISTINCT ID1)>1
