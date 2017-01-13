tweets = LOAD '/usr/local/hadoop/pig_project/demo.csv' USING PigStorage(',');

extract_details = FOREACH tweets GENERATE $0 as id,$1 as text;

tokens = foreach extract_details generate id,text,FLATTEN(TOKENIZE(text)) As word;

dictionary = load '/usr/local/hadoop/pig_project/AFINN.txt' using PigStorage('\t') AS(word:chararray,rating:int);

word_rating = join tokens by word left outer, dictionary by word;

describe word_rating;

rating = foreach word_rating generate tokens::id as id,tokens::text as
text, dictionary::rating as rate;
describe rating;


word_group = group rating by (id,text);
 

avg_rate = foreach word_group generate group, AVG(rating.rate) as tweet_rating;

negative_tweets = filter avg_rate by tweet_rating<=0;

STORE negative_tweets INTO '/usr/local/hadoop/pig_project/jan9/negative.csv' USING PigStorage(',');


