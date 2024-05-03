# Google_Playstore-Analysis
## Exploring App Store: Sentiment Analysis and Insights into Rating, Reviews and Net Promoter Score of Apps and its Category.
## Project Objective
The goal of this analysis is  to analyze the Google Play Store Apps dataset to derive insights into the app market and  to understand the factors that contribute to an app's success, including its user ratings, reviews, category and user sentiments towards apps by analyzing the user reviews dataset.  

The ultimate objective is to provide recommendations for app developers to enhance their app's performance and user satisfaction.

### Data Source 
The data source is attached in the repository contains the user reviews and ratings from 2014-2018.

### Tools
1. SQL server to uncover Insights.
2. Power BI for visualization.

### Data Cleaning Process
The following were done for the process using SQL server;

1. Data Loading and Inspection.
2. Handling Missing Values.
3. Duplicate Record Removal.
4. Data Validation.

### Exploratory Data Analysis
- Calculating App's Net Promoter Score (N.P.S.) using user's rating
   
   ``` sql
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
```

