load data local infile '/usr/local/share/data/app.csv'
into table app
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(App, Category, Rating, Reviews, Size, Installs, Type, Price, `Content Rating`, Genres, `Last Updated`, `Current Ver`, `Android Ver`);