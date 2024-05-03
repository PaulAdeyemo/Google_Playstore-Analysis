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
   FROM googleplaystore ```

- Finding the Total Category of App
   ``` sql
   SELECT COUNT(DISTINCT Category) AS TOTAL_CATEGORY
   FROM googleplaystore ```

- Finding the Average Rating of App Category
  ``` sql
   SELECT ROUND(avg(TRY_CAST(rating AS FLOAT)),3) AS AVERAGE_RATING
   FROM googleplaystore```

- Finding the App with the highest number of Reviews
  ``` sql
  SELECT App,(SELECT COUNT(Rating)
  FROM googleplaystore 
  WHERE Rating <> 'Nan') AS total_rating,
  SUM(TRY_CAST(Reviews AS INT)) AS number_of_reviews
  FROM googleplaystore
  GROUP BY App
  ORDER BY number_of_reviews DESC ```

- Analyze the average sentiment polarity and sentiment subjectivity of user reviews for each app category
  ``` sql
  SELECT 
  category,
  Round(AVG(TRY_CAST(sentiment_polarity AS FLOAT)),2) AS average_sentiment_polarity,
  Round(AVG(TRY_CAST(Sentiment_Subjectivity AS FLOAT)),2) AS average_sentiment_subjectivity
  FROM googleplaystore
  JOIN googleplaystore_user_reviews
  ON googleplaystore.App = googleplaystore_user_reviews.App
  GROUP BY category
  ORDER BY average_sentiment_subjectivity DESC```
  
- Provide the distribution of sentiments across different app categories.
  ``` sql
  SELECT 
  googleplaystore_user_reviews.App,
  Round(AVG(TRY_CAST(sentiment_polarity AS FLOAT)),2) AS average_sentiment_polarity,
  Round(AVG(TRY_CAST(Sentiment_Subjectivity AS FLOAT)),2) AS average_sentiment_subjectivity
  FROM googleplaystore
  JOIN googleplaystore_user_reviews
  ON googleplaystore.App = googleplaystore_user_reviews.App
  GROUP BY googleplaystore_user_reviews.app
  ORDER BY average_sentiment_subjectivity DESC ```

- AVERAGE POLARITY DISTRIBUTION OF APPS BY THE REVIEWS
  ``` sql
  SELECT C.App,Round(aVG(TRY_CAST(sentiment_polarity AS FLOAT)) ,2) AS Average_polarity,SUM(TRY_CAST(Reviews AS BIGINT)) AS Reviews
  FROM googleplaystore_user_reviews AS C
  JOIN googleplaystore AS R
  ON C.App = R.App
  WHERE Reviews <> 'NAN' AND Sentiment_Polarity <> 'Nan'
  GROUP BY C.APP
  ORDER BY Reviews DESC ```

### Findings
- 4-5 star Raters contributes to the Promoter often exhibits Positive NPS ,3-3.9 star Raters Contributes to the Passive , 1-2.9 contributes to the Detractors who often exhibit Negative NPS. Promoters had 78.67%,
  Passive Reviewer made 18.27% of the total Reviewer while Detractors Reviewer contributes 3.06% as this could impact Negatively into the number of App downloads and the NPS over the years at large.

- Instagram had the highest number of reviews with approximately 6% of Total number of Reviews, followed by  Whatsapp Messenger contributing 4.3% of the Total number of Reviews. Snapchat had the least number of Reviews out of the TOP 20 App selected contributing 1.4% of Total number of Review.

- In other to improve on the App Store Optimization of these app with low polarity score, It is advisable to improve on working with the Reviews of these users in other to fix what the issue might be going forward.

-  48% of the total App Category has a subjectivity score of >= 0.5 which indicates that this review is subjective. While 52% of the App Category has Subjectivity score less than 0.5 which indicates that the review is objective. However, Across all app Category, the polarity score is less than 0.5  which suggest neutral sentiment. This score actually could ruin the reputation of the app. Therefore it is advisable to engage with the users to further understand the problem and resolve them. They might just need little extra attention to form a more positive opinion.

### Recommendation 
- Written Reviews should be should be encouraged by users other than Numeric star Rating. This would encourage users to write their opinion freely. Although, users would prefer a glance through the aggregated rating without reading the written reviews.
  
- The Total number of Reviews of App across all Category  is 4,814,597,248. Polarity Score of this App may not be sufficient enough to draw a conclusion. Because It is limited in capturing the Nuances, Sarcasm, Humor or mixed feelings of the Reviewers. Therefore, it is advisable to further analyze the subjectivity of the text.
  
- Polarity Score ranges from -1 to 1. Where -1 Indicates a very Negative Sentiment Score, 0 indicates a Neutral Score while 1 indicates a Positive Sentiment Score. Sentiment Score ranges from 0 to 1. Where 0 indicates  a very objective text(based on facts, evidence) while 1 indicates a very subjective text(based on opinions).

