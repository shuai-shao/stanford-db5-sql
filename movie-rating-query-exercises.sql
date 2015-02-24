#Schema: 

#Movie ( mID, title, year, director ) 
#English: There is a movie with ID number mID, a title, a release year, and a director. 

#Reviewer ( rID, name ) 
#English: The reviewer with ID number rID has a certain name. 

#Rating ( rID, mID, stars, ratingDate ) 
#English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

#Q1. Find the titles of all movies directed by Steven Spielberg. 
SELECT title 
FROM Movie
WHERE director = 'Steven Spielberg'

#Q2.Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
SELECT DISTINCT year 
FROM   movie 
       JOIN rating 
         ON movie.mid = rating.mid 
WHERE  stars = 4 
        OR stars = 5 
ORDER  BY year 

#Q3.Find the titles of all movies that have no ratings. 
SELECT title 
FROM   Movie 
       LEFT JOIN Rating
       ON Movie.mID = Rating.mID
WHERE  stars IS NULL 

#Q4.Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT name 
FROM   Reviewer 
       LEFT JOIN Rating
       ON Reviewer.rID = Rating.rID
WHERE  ratingDate IS NULL 

#Q5.Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
SELECT name,
       title, 
       stars,
       ratingDate
FROM   Movie
       JOIN Rating
       ON Movie.mID = Rating.mID
       JOIN Reviewer
       ON Reviewer.rID = Rating.rID
ORDER BY name,
         title,
         stars

#Q6.For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
SELECT name, title
FROM   (SELECT r1.rID, 
               r1.mID
        FROM   Rating r1 
               JOIN Rating r2 
               ON r1.rID = r2.rID
                  AND r1.mID = r2.mID
                  AND r1.stars < r2.stars
                  AND r1.RatingDate < r2.RatingDate)c
       JOIN Movie 
         ON c.mID = Movie.mID
       JOIN Reviewer 
         ON c.rID = Reviewer.rID

#Q7.For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
SELECT title,
       MAX(stars)
FROM   Rating 
       JOIN Movie
         ON Rating.mID = Movie.mID
GROUP BY title

#Q8.For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
SELECT title,
       MAX(stars) - MIN(stars)
FROM   Rating 
       JOIN Movie
         ON Rating.mID = Movie.mID
GROUP BY title
ORDER BY MAX(stars) - MIN(stars) DESC, title

#Q9.Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
SELECT AVG(star1) -AVG(star2)
FROM   (SELECT title,
       year,
       AVG(stars) star1
FROM   Rating 
       JOIN Movie
         ON Rating.mID = Movie.mID
WHERE year < 1980
GROUP BY title)x1
JOIN
(SELECT title,
       year,
       AVG(stars) star2
FROM   Rating 
       JOIN Movie
         ON Rating.mID = Movie.mID
WHERE year > 1980
GROUP BY title)x2
