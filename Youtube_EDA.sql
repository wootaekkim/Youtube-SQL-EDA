USE youtube;

-- EDA of Youtube Comments and Statistics dataset imported from Kaggle
-- https://www.kaggle.com/datasets/advaypatil/youtube-statistics?resource=download&select=videos-stats.csv

-- videos-stats.csv:
-- This file contains some basic information about each video,
-- such as the title, likes, views, keyword, and comment count.

-- comments.csv:
-- For each video in videos-stats.csv, comments.csv contains the top ten most relevant comments 
-- as well as said comments' sentiments and likes.
SELECT * FROM Comments;

SELECT * FROM YoutubeStats;

-- Start with Youtube Statistics

# number of youtube videos for each keyword
SELECT 
    Keyword, COUNT(Title) AS count
FROM
    YoutubeStats
GROUP BY Keyword
ORDER BY count DESC;

#global max, min, avg of likes, comment, views
SELECT
	MAX(Likes) AS MaxLikes,
    MIN(Likes) AS MinLikes,
    AVG(Likes) AS AvgLikes,
    MAX(Comment) AS MaxComment,
    MIN(Comment) AS MinComment, 
    AVG(Comment) AS AvgComment,
    MAX(Views) AS MaxViews,
    MIN(Views) AS MinViews,
    AVG(Views) AS AvgViews
FROM YoutubeStats;

# max, min, average number of views for each keyword
SELECT
	Keyword,
	MAX(Views) As MaxViews,
    MIN(Views) AS MinViews,
    AVG(Views) AS AvgViews
FROM YoutubeStats
GROUP BY Keyword; 

# max, min, average of likes for each keyword
SELECT
	Keyword,
    MAX(Likes) AS MaxLikes,
    MIN(Likes) AS MinLikes,
    AVG(Likes) AS AvgLikes
FROM YoutubeStats
GROUP BY Keyword;

# max, min, average of Comment for each keyword
SELECT
	Keyword,
    MAX(Comment) AS MaxComment,
    MIN(Comment) AS MinComment,
    AVG(Comment) AS AvgComment
FROM YoutubeStats
GROUP BY Keyword;

# video titles with highest number of likes for each keyword
SELECT
	Keyword,
	Title,
    VideoID,
    m.Likes AS Likes
FROM
	YoutubeStats AS y
		JOIN
	(SELECT
		MAX(Likes) AS Likes
	FROM 
		YoutubeStats
	GROUP BY Keyword) AS m ON y.Likes = m.Likes
    ORDER BY m.Likes DESC;
    
# Same as above using CTE
WITH max_likes AS (
SELECT MAX(Likes) AS Likes
FROM YoutubeStats
GROUP BY Keyword)
SELECT
	Keyword,
	Title,
    VideoID,
    m.Likes AS Likes
FROM YoutubeStats AS y
		JOIN
	max_likes AS m ON y.Likes = m.Likes
ORDER BY m.Likes DESC;

    
# video titles with highest number of Comments for each keyword
SELECT
	Keyword,
	Title,
    VideoID,
    m.Comment AS Comment
FROM
	YoutubeStats AS y
		JOIN
	(SELECT
		MAX(Comment) AS Comment
	FROM 
		YoutubeStats
	GROUP BY Keyword) AS m ON y.Comment = m.Comment
    ORDER BY m.Comment DESC;
    
# video titles with highest number of Comments for each keyword
SELECT
	Keyword,
	Title,
    VideoID,
    m.Views AS Views
FROM
	YoutubeStats AS y
		JOIN
	(SELECT
		MAX(Views) AS Views
	FROM 
		YoutubeStats
	GROUP BY Keyword) AS m ON y.Views = m.Views
    ORDER BY m.Views DESC;

# Add year column
ALTER TABLE YoutubeStats
ADD PublishYear INT;

UPDATE YoutubeStats
SET PublishYear  = YEAR(PublishedAt);

# videos with max likes each year
SELECT
	PublishYear,
    MAX(Likes) As Likes
FROM
	YoutubeStats
GROUP BY PublishYear
ORDER BY PublishYear ASC;

SELECT
	m.PublishYear,
    Title,
    Keyword,
    m.Likes AS Likes
FROM YoutubeStats AS y
		JOIN
	(SELECT
	PublishYear,
    MAX(Likes) As Likes
FROM
	YoutubeStats
GROUP BY PublishYear) AS m ON y.PublishYear = m.PublishYear
ORDER BY m.PublishYear ASC;

# videos with max View each year
SELECT
	PublishYear,
    MAX(Views) As Views
FROM
	YoutubeStats
GROUP BY PublishYear
ORDER BY PublishYear ASC;

SELECT
	m.PublishYear,
    Title,
    Keyword,
    m.Views AS Views
FROM YoutubeStats AS y
		JOIN
	(SELECT
	PublishYear,
    MAX(Views) As Views
FROM
	YoutubeStats
GROUP BY PublishYear) AS m ON y.PublishYear = m.PublishYear
ORDER BY m.PublishYear ASC;
    
# videos with max Comment each year
SELECT
	PublishYear,
    MAX(Comment) As Comment
FROM
	YoutubeStats
GROUP BY PublishYear
ORDER BY PublishYear ASC;

SELECT
	m.PublishYear,
    Title,
    Keyword,
    m.Comment AS Comment
FROM YoutubeStats AS y
		JOIN
	(SELECT
	PublishYear,
    MAX(Comment) As Comment
FROM
	YoutubeStats
GROUP BY PublishYear) AS m ON y.PublishYear = m.PublishYear
ORDER BY m.PublishYear ASC;

# Showing which keyword gives highes number of likes each year
SELECT
	PublishYear,
    Keyword,
	MAX(Likes) AS Likes
FROM YoutubeStats
GROUP BY PublishYear, Keyword
ORDER BY PublishYear ASC, MAX(Likes) DESC;

SELECT
	m.PublishYear AS PublishYear,
    m.Keyword AS Keyword,
    m.Likes AS Likes,
    Title
FROM YoutubeStats AS y
		JOIN
		(SELECT
	PublishYear,
    Keyword,
	MAX(Likes) AS Likes
FROM YoutubeStats
GROUP BY PublishYear, Keyword) AS m ON m.Likes = y.Likes
ORDER BY PublishYear ASC, M.Likes DESC;

-- Now onto Comments
SELECT * FROM Comments;

#Total Number of Comments and comments with each sentiment
SELECT
	COUNT(Comment) CommentCount,
    COUNT(CASE WHEN Sentiment = 1 THEN 1 END) AS OneCount,
    COUNT(CASE WHEN Sentiment = 2 THEN 1 END) AS TwoCount,
    COUNT(CASE WHEN Sentiment = 0 THEN 1 END) AS ZeroCount
FROM Comments;

# Number of comments for each video
SELECT
	VideoID,
    Count(Comment) AS NumComment
FROM Comments
GROUP BY VideoID
ORDER BY COUNT(Comment) DESC;

# count of comment and comment of each sentiment (0, 1, 2) for each video
SELECT
	VideoID,
    COUNT(Comment) AS CommentCount,
    COUNT(CASE WHEN Sentiment = 1 THEN 1 END) AS OneCount,
    COUNT(CASE WHEN Sentiment = 2 THEN 1 END) AS TwoCount,
    COUNT(CASE WHEN Sentiment = 0 THEN 1 END) AS ZeroCount
FROM Comments
GROUP BY VideoID;

# Count of comments of each sentiment including 
# each video's tite, publish year, and number of likes
SELECT
	Title,
    PublishYear,
    m.VideoID AS VideoID,
    OneCount,
    TwoCount,
    ZeroCount,
    Likes
FROM YoutubeStats As y
		JOIN
	(SELECT
	VideoID,
    COUNT(CASE WHEN Sentiment = 1 THEN 1 END) AS OneCount,
    COUNT(CASE WHEN Sentiment = 2 THEN 1 END) AS TwoCount,
    COUNT(CASE WHEN Sentiment = 0 THEN 1 END) AS ZeroCount
FROM Comments
GROUP BY VideoID) AS m ON m.VideoID = y.VideoID;

# show positive-neutral comment to negative comment ratio for each video
WITH sentiment_count AS (
SELECT
	VideoID,
    COUNT(Comment) AS CommentCount,
	COUNT(CASE WHEN Sentiment = 1 OR Sentiment = 2 THEN 1 END) AS positive_neutral,
    COUNT(CASE WHEN Sentiment = 0 THEN 1 END) AS negative
FROM Comments
GROUP BY VideoID)
SELECT 
	Title,
	s.VideoID,
	positive_neutral/negative AS Positive_neutral_to_negative_ratio,
	CommentCount
FROM sentiment_count AS s
		JOIN
	YoutubeStats AS y ON y.VideoID = s.VideoID
ORDER BY positive_neutral/negative DESC;