load data local infile '/usr/local/share/data/review.csv'
into table review
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(App, Translated_Review, Sentiment, Sentiment_Polarity, Sentiment_Subjectivity);
