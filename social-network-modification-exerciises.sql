#Question 1
#It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM Highschooler 
WHERE grade = 12

#Question 2
#If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM Likes 
WHERE
ID1 IN (SELECT l1.ID1 FROM Friend f JOIN Likes l1 ON f.ID1 = l1.ID1 AND f.ID2 = l1.ID2 WHERE l1.ID1 NOT IN (SELECT l2.ID2 FROM Likes l2 WHERE l2.ID1 =l1.ID2))

#Question 3
#For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 
INSERT INTO Friend
SELECT DISTINCT  f1.ID1, f2.ID2 
FROM    Friend f1
               JOIN Friend f2
                   ON f1.ID2 = f2.ID1
WHERE f1.ID1 != f2.ID2
AND f2.ID2 NOT IN (SELECT ID2 
                   FROM    Friend
                   WHERE ID1 = f1.ID1)
