# Youtube-SQL-EDA
Exploratory Data Analysis of Youtube data From Kaggle Using MySQL

In this project I have done Exploratory Data analysis using Youtube Stattistics and Comment data From Kaggle.
Link to the data : https://www.kaggle.com/datasets/advaypatil/youtube-statistics?resource=download&select=videos-stats.csv

### About the data
videos-stats.csv:

Title: Video Title.
Video ID: The Video Identifier.
Published At: The date the video was published in YYYY-MM-DD.
Keyword: The keyword associated with the video.
Likes: The number of likes the video received. If this value is -1, the likes are not publicly visible.
Comments: The number of comments the video has. If this value is -1, the video creator has disabled comments.
Views: The number of views the video got.

comments.csv:

Video ID: The Video Identifier.
Comment: The comment text.
Likes: The number of likes the comment received.
Sentiment: The sentiment of the comment. A value of 0 represents a negative sentiment, while values of 1 or 2 represent neutral and positive sentiments respectively.

### Brief summary of process
First I imported data into MySQL database using Python Jupyter notebook. Process of doing so is shown in the **"Youtube Statistics and Comments data to MySQL.ipynb"** file above.

Then I performed Exploratory data analysis using SQL JOINs, CTEs and GROUP BY to look into the data. This is shown in **"Youtube_EDA.sql"** above
