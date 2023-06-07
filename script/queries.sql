use dep304_asm2;

select a.Category, sum(r.Sentiment_Polarity) as SUM_Sentiment_Polarity, sum(r.Sentiment_Subjectivity) as SUM_Sentiment_Subjectivity
from app a join review r
    on a.App = r.App
group by a.Category;

with negative as (
    select a.Category, count(*) as negative_count
    from app a join review r on a.App = r.App
    where r.Sentiment = "Negative"
    group by a.Category
),
positive as (
    select a.Category, count(*) as positive_count
    from app a join review r on a.App = r.App
    where r.Sentiment = "Positive"
    group by a.Category
),
neutral as (
    select a.Category, count(*) as neutral_count
    from app a join review r on a.App = r.App
    where r.Sentiment = "Neutral"
    group by a.Category
)
select ng.Category, ng.negative_count as Count_Negative,
       po.positive_count as Count_Positive, nu.neutral_count as Count_Neutral
from negative ng join positive po on ng.Category = po.Category
    join neutral nu on po.Category = nu.Category
group by ng.Category;

with price as (
    select App, cast(replace(app.Price, '$', '') as float) as New_Price
    from app
)
select a.Category,
       count(length(r.Translated_Review) - length(replace(r.Translated_Review, ' ', '')) + 1) as Word_Count,
       avg(p.New_Price)
from app a join review r on a.App = r.App
    join price p on a.App = p.App
group by a.Category
order by Word_Count desc;
