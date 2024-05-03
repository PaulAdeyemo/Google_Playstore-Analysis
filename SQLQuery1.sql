CREATE DATABASE google_playstore;
USE google_playstore;
/*=========================================================== identifying null_values========================================================*/
SELECT *
FROM googleplaystore
WHERE App IS NULL
OR Category IS NULL
OR Rating IS NULL
OR Reviews IS NULL
OR Size IS NULL
OR Installs IS NULL
OR Type IS NULL
OR Price IS NULL
OR Content_Rating IS NULL
OR Genres IS NULL
OR Last_updated IS NULL
OR Current_Ver IS NULL
OR Android_Ver IS NULL
/*===========================================================Removing Null Values=============================================================*/
 SELECT *
DELETE FROM googleplaystore
WHERE App IS NULL
OR Category IS NULL
OR Rating IS NULL
OR Reviews IS NULL


OR Size IS NULL
OR Installs IS NULL
OR Type IS NULL
OR Price IS NULL
OR Content_Rating IS NULL
OR Genres IS NULL
OR Last_updated IS NULL
OR Current_Ver IS NULL
OR Android_Ver IS NULL

SELECT *
FROM googleplaystore

SELECT *
FROM googleplaystore_user_reviews
ORDER BY App DESC

/*============================================================== CALCULATING NPS ======================================================================*/
-- get the total rating
-- get the percentage of promoters
-- get the percentage of detractors
-- calculate nps=%promoters - %detractors

---------------------------------------------------------------- total rating ---------------------------------------------------------------------------
-----------------------------------METHOD 1-----------------------------------------
SELECT  app,(SELECT COUNT(Rating)
FROM googleplaystore 
WHERE Rating <> 'Nan'
) AS number_of_Review,
 CASE 
WHEN TRY_CAST(Rating AS FLOAT) >=1 AND TRY_CAST(Rating AS FLOAT) <=1.9 THEN 1
WHEN TRY_CAST(Rating AS FLOAT)>= 2 AND TRY_CAST(Rating AS FLOAT) <= 2.9 THEN 2
WHEN TRY_CAST(Rating AS FLOAT) >=3 AND TRY_CAST(Rating AS FLOAT) <= 3.9 THEN 3
WHEN TRY_CAST(Rating AS FLOAT) >=4 AND TRY_CAST(Rating AS FLOAT) <= 4.9 THEN 4
ELSE 5
END AS rating_STAR
FROM googleplaystore 
WHERE Rating <> 'NAN'
GROUP BY Rating, app
-------------------------------------METHOD 2----------------------------------------
SELECT COUNT(Rating)
FROM googleplaystore 
WHERE Rating <> 'Nan'

------------------------------------------------------------promoter calculation-------------------------------------------------------------------------
SELECT count(Rating) AS PROMOTER
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=4 AND TRY_CAST(Rating AS FLOAT) <=5 


----------------------------------------------------------Detractor calculation--------------------------------------------------------------------------
SELECT count(Rating) AS DETRACTOR
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=1 AND TRY_CAST(Rating AS FLOAT) <=2.9

----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
 CASE 
WHEN TRY_CAST(Rating AS FLOAT) >=4 AND TRY_CAST(Rating AS FLOAT) <=5 THEN 'Promoter'
WHEN TRY_CAST(Rating AS FLOAT) >=3 AND TRY_CAST(Rating AS FLOAT) <=3.9  THEN 'Passive'
ELSE 'Detractor'
END AS n
FROM googleplaystore 
WHERE Rating <> 'NAN' 
GROUP BY Rating

/*=======================================sub query=================================*/
SELECT distinct
(SELECT count(TRY_CAST (Rating AS FLOAT)) AS PROMOTER
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=4 AND TRY_CAST(Rating AS FLOAT) <=5 ) AS PROMOTER,

(SELECT count(TRY_CAST(Rating AS FLOAT)) AS DETRACTOR
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=1 AND TRY_CAST(Rating AS FLOAT) <=2.9) AS DETRACTOR,

(SELECT count(Rating) AS PASSIVE
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=3 AND TRY_CAST(Rating AS FLOAT) <=3.9) AS PASSIVE,

(SELECT COUNT(TRY_CAST(Rating AS FLOAT)) AS TOTAL_RATING
FROM googleplaystore 
WHERE Rating <> 'Nan') AS TOTAL_RATING
FROM googleplaystore 

SELECT Category,COUNT(Rating) AS Total_Rating
FROM googleplaystore 
WHERE Rating <> 'Nan'
GROUP BY Category
ORDER BY Total_Rating DESC

/*===============================================================================*/
SELECT count(Rating) AS PASSIVE
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=3 AND TRY_CAST(Rating AS FLOAT) <=3.9

SELECT count(Rating) AS DETRACTOR
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=1 AND TRY_CAST(Rating AS FLOAT) <=2.9

SELECT 
(SELECT count(Rating) AS PROMOTER
FROM googleplaystore 
WHERE Rating <> 'Nan' AND TRY_CAST(Rating AS FLOAT) >=4 AND TRY_CAST(Rating AS FLOAT) <=5 )
/
(SELECT COUNT(Rating) AS TOTAL_RATING
FROM googleplaystore 
WHERE Rating <> 'Nan')
FROM googleplaystore 

SELECT *
FROM googleplaystore_user_reviews




/*====================================================== Overview of entire data set===============================================*/

/*===================================================== total category =============================================================*/
SELECT COUNT(DISTINCT Category) AS TOTAL_CATEGORY
FROM googleplaystore

/*==================================================== average rating =============================================================*/
SELECT ROUND(avg(TRY_CAST(rating AS FLOAT)),3) AS AVERAGE_RATING
FROM googleplaystore

SELECT avg(try_cast( Rating as float)) as average
from googleplaystore

/*=================================================== total apps=================================================================*/
SELECT COUNT(DISTINCT App) AS Total_apps
FROM googleplaystore

/*================================================== total genres ==============================================================*/
SELECT COUNT(DISTINCT Genres) AS Total_genre
FROM googleplaystore

/*============================================== most downloaded apps =========================================================*/
SELECT 
app,
Count(App) as number_apps
FROM googleplaystore
GROUP BY app
order by number_apps desc

/*======================================  explore apps categories and counts ==================================================*/
SELECT 
category,
COUNT(App) AS total_app
FROM googleplaystore
GROUP BY category
ORDER BY total_app DESC

/*================================= Find the apps with the highest number of reviews. =========================================*/
SELECT App,(SELECT COUNT(Rating)
FROM googleplaystore 
WHERE Rating <> 'Nan') AS total_rating,
SUM(TRY_CAST(Reviews AS INT)) AS Q
FROM googleplaystore
GROUP BY App
ORDER BY Q DESC

/*======================================= Calculate the average rating for each app category ===================================*/
SELECT  category,
Round(avg(TRY_CAST(Rating AS FLOAT)),2) as average_rating
FROM googleplaystore
GROUP BY Category 
ORDER BY average_rating DESC


/*============================Identify the app categories with the highest total number of installs ===========================*/
SELECT
app,
SUM(CAST(REPLACE(SUBSTRING(Installs,1,PATINDEX('%[^0-9]%',installs + ' ') -1),',',' ') AS INT)) AS Total_install
FROM googleplaystore
GROUP BY app
ORDER BY Total_install DESC 

/*========================= Analyze the average sentiment polarity and sentiment subjectivity of user reviews for each app category ===============================*/
SELECT 
category,
Round(AVG(TRY_CAST(sentiment_polarity AS FLOAT)),2) AS average_sentiment_polarity,
Round(AVG(TRY_CAST(Sentiment_Subjectivity AS FLOAT)),2) AS average_sentiment_subjectivity
FROM googleplaystore
JOIN googleplaystore_user_reviews
ON googleplaystore.App = googleplaystore_user_reviews.App
GROUP BY category
ORDER BY average_sentiment_subjectivity DESC



/*==================== Provide the distribution of sentiments across different app categories. ==============================*/

SELECT 
Category,
Sentiment,
COUNT(*) AS total_sentiment
FROM googleplaystore
JOIN googleplaystore_user_reviews
ON googleplaystore.App = googleplaystore_user_reviews.App
WHERE Sentiment <> 'nan'
GROUP BY Category,Sentiment
ORDER BY total_sentiment DESC

-------------------------------------------------

SELECT 
googleplaystore_user_reviews.App,
Round(AVG(TRY_CAST(sentiment_polarity AS FLOAT)),2) AS average_sentiment_polarity,
Round(AVG(TRY_CAST(Sentiment_Subjectivity AS FLOAT)),2) AS average_sentiment_subjectivity
FROM googleplaystore
JOIN googleplaystore_user_reviews
ON googleplaystore.App = googleplaystore_user_reviews.App
GROUP BY googleplaystore_user_reviews.app
ORDER BY average_sentiment_subjectivity DESC

/* ============================== AVERAGE POLARITY DISTRIBUTION OF APPS BY THE REVIEWS===================================*/

SELECT C.App,Round(aVG(TRY_CAST(sentiment_polarity AS FLOAT)) ,2) AS Average_polarity,SUM(TRY_CAST(Reviews AS BIGINT)) AS Reviews
FROM googleplaystore_user_reviews AS C
JOIN googleplaystore AS R
ON C.App = R.App
WHERE Reviews <> 'NAN' AND Sentiment_Polarity <> 'Nan'
GROUP BY C.APP
ORDER BY Reviews DESC


