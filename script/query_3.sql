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