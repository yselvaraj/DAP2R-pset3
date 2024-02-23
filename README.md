# Data Skills 2 - R
## Winter Quarter 2024

## Homework 3
## Due: February 22 before midnight on GitHub Classroom

Note that there is a lot of flexibility in how you approach these questions and what your final results will look like.  Being comfortable with that sort of assignment is an explicit course goal; real-world research is much more likely to come with open-ended assignments rather than explicit direction to start with X and accomplish exactly Y.  Use short comments (1-3 lines max) to explain any choices that you think need explaining.  Remember wherever possible to focus on "why" in your comments, and not "what". As usual, include a README file describing the code and output.

__Question 1 (30%):__ You are working as a research assistant at a think tank that works on global public health.  The senior researcher you work for tries to follow the Public Health Roundup from [the WHO Bulletin](https://www.who.int/publications/journals/bulletin), but they have been too busy lately to keep up with it.. They ask you to read in the January 2023 report (from the text file included in the repo, also available [here]([https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9795377/) and parse it using natural language processing:

Describe the sentiment of the article, and show which countries are discussed in the article.

Output to save to your repo for this question:
  * question1.R file with the code - summary statistics can be displayed with print or View
  * question1_plot_X.png file for the plots you generate (a minimum of 2, a maximum of 4)

Part 1: Summary of Outcome from Question 1
A.Afinn Sentiment Analysis Results:
1.Evaluating the spread of afinn sentiment scores, considering 20 words of the 44 words (close to 50%) have a moderately negative sentiment score of '-2' sentiment score, it demonstrates the overall text has more of a moderately negative sentiment. 
2.Evaluating the summary statistics, a mean value of '-0.6364' and median value of '-2.0' further corroborates our above analysis that a substantial majority of 
observations in this public health round up text carry a relatively negative sentiment.In addition, the interquartile range Q1 i.e. '-2' and Q3 i.e. '-1', further highlight overall text is skewed towards a more negative sentiment. 
B.Bing Sentiment Analysis Results:
Evaluating the summary statistics, there are more words in the public health text with negative sentiments (approx 71%) in contrast to words with positive sentiments (approx 29%), further corroborating the 'afinn' sentiment analysis that the total observations is skewed towards a more negative sentiment. 
C.NRC Sentiment Analysis Results:
Evaluating the output of the nrc sentiment measure, it slightly conflicts the earlier 'bing' and 'afinn' sentiment measures as it depicts a marginally 
higher presence of observations with positive sentiments (0.047) in contrast to observations with negative sentiments (0.03).However, further analysis 
also depicts some level of overlap as frequency of observations in ranges of negative emotions i.e. fear, anticipation,sadness, disgust (79) is more than the frequency within positive emotions i.e.trust, joy, surprise (52). 

Final Remark:The Public Health Roundup Text has an overall negative sentiment measure and evaluating the degree of this sentiment, it can be inferred there a moderate negative sentiment. This is corroborated by both the 'bing' and 'afinn' sentiment measures. 

Part 2: Countries are discussed in the article.
Countries discussed were Oman, Switzerland, Sudan, Uganda, Kenya

__Question 2 (70%) -- UPDATED 2/13:__ Your senior researcher is very happy with the results you achieved on the most recent report, so they ask you to help them with sentiment analysis for WHO news releases from [WHO Africa](https://www.afro.who.int/news/news-releases?page=0). Create a function that uses basic web scraping to access the news releases back to a certain date. This function should take as input a month and a year, and scrape all news releases from today back to that month (including that month). It should then download and save the scraped text from the article as a separate .txt file. Make sure to remove any extraneous information beyond text: pictures, links, contact information, etc.

Use your function to pull all news releases back to September 2023.

Now, analyze the overall sentiment of the WHO Africa News Releases from September 2023 to today, as well as the sentiment about a particular country of your choice. 

Part 2: A. Overall Text Sentiment Analysis
The 'Afinn' and 'Bing' Sentiment Analysis were utilised for this section. The sentiment analysis was done in two ways: 
1. by 'unnesting tokens' (both afinn and bing sentiment analysis was done)
2. at a lemma level (only bing sentiment analysis was done)
Both methods revealed, the text has more number of observations with positive sentiment in contrast to observations 
with negative sentiment, which illustrates the WHO textfiles have a positive sentiment overall. 

Part 2: B. Country Analysis
There are 34 countries in specific talked about in this Data set. I chose the country Zambia to analyse. 
Zambia Analysis using 'Bing' Sentiment Measure:
Of the 633 observations that reference Zambia, only 69 words have 'bing' sentiment scores available. 
There are 37 observations with negative sentiments and 32 observations with positive sentiments.
Evaluating the 'bing' sentiment measure, there are just a few more observations referencing Zambia with 
negative sentiments (approx 54%), in contrast to observations with positive sentiments (approx 46%), 
indicating a slightly more overall negative sentiment for the country Zambia in contrast to overall text. 

Output to save to your repo for this question:
  * question2.R file with the code - summary statistics can be displayed with print or View
  * A file (or collection of text documents) of the text from the reports that you scraped.
  * question2_plot_X.png files for the plot(s) you generate (a minimum of 2, a maximum of 4)
  
  
  
  