#Question 1
#Find the names of all reviewers who rated Gone with the Wind. 
SELECT DISTINCT name
FROM Movie m JOIN Rating rt ON m.mID = rt.mID JOIN Reviewer re ON re.rID = rt.rID
WHERE title = 'Gone with the Wind''

#Question 2
#For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
SELECT name, title, stars
FROM Movie m JOIN Rating rt ON m.mID = rt.mID JOIN Reviewer re ON re.rID = rt.rID
WHERE director = name

#Question 3
#Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
SELECT name AS names
FROM Reviewer 
UNION
SELECT title AS names
FROM Movie
ORDER BY names

#Question 4
#Find the titles of all movies not reviewed by Chris Jackson.
SELECT DISTINCT title 
FROM   Movie
WHERE mID NOT IN ( SELECT  mID
                   FROM    Rating rt
                           JOIN Reviewer re
                             ON rt.rID = re.rID
                   WHERE  re.name = 'Chris Jackson' )
            
#Question 5
#For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT re1.name, re2.name
FROM Rating rt1
           JOIN Rating rt2  
               ON rt1.mID = rt2.mID 
           JOIN Reviewer re1
               ON rt1.rID = re1.rID
           JOIN Reviewer re2
               ON rt2.rID = re2.rID
WHERE re1.name < re2.name

#Question 6
#For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM   Movie
             JOIN Rating
                 ON Movie.mID = Rating.mID
             JOIN Reviewer
                 ON Reviewer.rID = Rating.rID
WHERE stars = (SELECT MIN(stars) 
               FROM   Rating)

#Question 7
#List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
SELECT title, AVG(stars)
FROM    Movie 
              JOIN Rating
                  ON Movie.mID = Rating.mID
GROUP BY title
ORDER BY AVG(stars) DESC, title

#Question 8
#Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
SELECT name
FROM  Reviewer
            JOIN Rating
                ON Reviewer.rID = Rating.rID
GROUP BY name
HAVING COUNT(*) >=3

#Question 9
#Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
SELECT title, director 
FROM    Movie
WHERE director IN (SELECT director 
                                 FROM    Movie 
                                 GROUP BY director 
                                 HAVING COUNT(title) > 1)
ORDER BY director, title

#Question 10
#Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
SELECT title, AVG(stars) AS ave
FROM    Movie
              JOIN Rating
                  ON Movie.mID = Rating.mID
GROUP BY title 
ORDER BY ave DESC
LIMIT 1

#Question 11
#Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
SELECT title, AVG(stars)
FROM    Movie
              JOIN Rating
                  ON Movie.mID = Rating.mID
GROUP BY title 
HAVING AVG(stars) = (
SELECT AVG(stars) 
FROM    Movie
              JOIN Rating
                  ON Movie.mID = Rating.mID
GROUP BY title 
ORDER BY AVG(stars)
LIMIT 1)

#Question 12
#For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT director, title,MAX(stars)
FROM   Movie
             JOIN Rating
                 ON Movie.mID = Rating.mID
             JOIN Reviewer
                 ON Reviewer.rID = Rating.rID
GROUP BY director 
HAVING director IS NOT NULL

        
                           
