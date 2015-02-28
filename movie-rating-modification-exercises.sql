#Question 1
#Add the reviewer Roger Ebert to your database, with an rID of 209.
INSERT INTO Reviewer
VALUES (209, 'Roger Ebert')

#Question 2
#Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.
INSERT INTO Rating
SELECT Rating.rID, Movie.mID, 5, NULL
FROM    Reviewer JOIN Rating ON Reviewer.rID = Rating.rID AND name = 'James Cameron'
                              JOIN Movie
                              
#Question 3
#For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)

UPDATE Movie 
SET year = year + 25
WHERE mID IN (SELECT mID
                           FROM    Rating 
                           GROUP BY mID 
                            HAVING AVG(stars) >= 4)
                            
#Question 4
#Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
DELETE FROM Rating
WHERE mID IN (SELECT DISTINCT mID FROM Movie WHERE year < 1970 OR year> 2000) AND stars < 4
