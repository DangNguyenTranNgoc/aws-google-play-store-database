select a.Category, sum(r.Sentiment_Polarity) as SUM_Sentiment_Polarity, 
       sum(r.Sentiment_Subjectivity) as SUM_Sentiment_Subjectivity
from app a join review r
    on a.App = r.App
group by a.Category;