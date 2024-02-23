#Load Different Packages
library(tidytext)
library(textdata)
library(tidyverse)
library(countries)
library(udpipe)
library(dplyr)

#Question 1: Summary Statistics and Code for Plot

#Open text file in the directory 
path <- "/Users/yashwiniselvaraj/Desktop/Winter 2024/Data Programming in R/Problem Sets/Problem Set 3/"
public_health_data <- read_file(paste0(path,"vol101_1_publichealthroundup.txt"))
glimpse(public_health_data)

#Clean Text File: Tokenize Words, Take out Stop Words, Count Frequency (n) each work appears 
public_health_data_df <- data.frame(text = public_health_data)
data("stop_words")
cleaned_data <- public_health_data_df  %>%
  unnest_tokens(word_tokens, text, token = "words") %>% #Tokenize words
  anti_join(stop_words, by = c("word_tokens" = "word")) %>% #Take out Stop Words 
  group_by(word_tokens) %>% 
  count(word_tokens, sort = TRUE) %>% #Count the frequency (n) each word tokens appears in the textfile
  filter(is.na(as.numeric(word_tokens))) #removes any word tokens that is only a number 

#Sentiment Analysis by 'Unnesting Tokens'
#Load Sentiment Measures
afinn_sentiment <- get_sentiments("afinn") %>% 
  rename(afinn = value)
bing_sentiment <- get_sentiments("bing") %>% 
  rename(bing = sentiment)
nrc_sentiment <- get_sentiments("nrc")%>% 
  rename(nrc = sentiment)

#Merge cleaned textfile with 'Afinn' Sentiment Measure
sentiment_analysis <- cleaned_data %>%
  left_join(afinn_sentiment, by = c("word_tokens" = "word"))

#A.Sentiment Analysis of the Textual Data Using 'Afinn'

print(sum(!is.na(sentiment_analysis$afinn)))

#1.Of the 406 observations, only 44 observations have 'afinn' sentiment scores available. 

sentiment_analysis %>% 
  filter(!is.na(afinn)) %>% #filter out observations with missing afinn scores 
  group_by(afinn) %>% 
  count(afinn, sort = TRUE)%>% #count the total number of observations (n) within each afinn measure (-5 to 5)
  arrange(desc(n)) #arrange count (n) based on highest to lowest 

#2. Evaluating the spread of afinn sentiment scores, considering 20 words of the
#44 words (close to 50%) have a moderately negative sentiment score of '-2', 
#it demonstrates the overall text has more of a moderately negative sentiment. 

print(summary(sentiment_analysis$afinn, na.rm=TRUE)) #summary statistics 

#3.Evaluating the summary statistics, a mean value of '-0.6364' and median value 
#of '-2.0' further corroborates our above analysis that a substantial majority of 
#observations in this 'public health round up' text
#carry a relatively negative sentiment.In addition, the interquartile range Q1 i.e. 
#'-2' and Q3 i.e. '-1', further highlight overall text is skewed towards a more 
#moderately negative sentiment. 

#Plot 1
plot_1 <- ggplot(data = filter(sentiment_analysis, !is.na(afinn))) +
  geom_histogram(aes(x = afinn), stat = "count", color = "darkred") +
  scale_x_continuous(n.breaks = 7)+
  scale_y_continuous(limits=c(0,44))+ #y-axis is from 0 to 44 because there are a total of 44 words with afinn sentiment scores
  labs(title = "Afinn Sentiment Analysis of Public Health Roundup Text: \n January 2023",
       x = "Afinn Sentiment Score", y = "Frequency",
       caption = "Remark: Only Observations with Available Afinn Values \n was included and then analysed")+
  theme(
    plot.title = element_text(margin = margin(b = 10), size = 13, hjust = 0.5,
                              color = "black", face = "bold"),
    axis.title.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 10, face = "bold"),
    plot.caption = element_text(margin = margin(t = 10), hjust = 1))

plot(plot_1)
#Citation:
#https://stackoverflow.com/questions/73985627/how-to-make-axis-title-bold-and-change-the-font-size-simultaneously

#Merge cleaned textfile with 'Bing' Sentiment Measure
sentiment_analysis <- cleaned_data %>%
  left_join(bing_sentiment, by = c("word_tokens" = "word"))

#B.Sentiment Analysis of the Textual Data Using 'Bing'

print(sum(!is.na(sentiment_analysis$bing)))

#1.Of the 406 observations, only 45 words have 'bing' sentiment scores available. 

#Summary Statistics 'Bing'
output_bing <- sentiment_analysis %>% 
  filter(!is.na(bing)) %>% #filter out observations with missing 'bing'sentiment score 
  group_by(bing) %>%
  count(bing, sort = TRUE)%>%  #counts the total number of observations (n) within the two categories (negative vs positive) of the 'bing' measure
  arrange(desc(n)) %>% #arrange count (n) based on highest to lowest 
  pivot_wider(names_from = bing, values_from = n) %>% #make each category into a separate column
  mutate(total_observations = negative + positive, #calculate summary statistics: difference in values, proportions of negative vs positive sentiments
         diff_between_observations = negative - positive,
         prop_negative = round(negative /total_observations, 3),
         prop_positive = round(positive /total_observations, 3)) %>% 
  pivot_longer(cols = negative:prop_positive, names_to = "bing", values_to = "n")

print(output_bing)

#2. Evaluating the summary statistics, there are more words in the public health text with negative
#sentiments (approx 71%) in contrast to words with positive sentiments (approx 29%), further
#corroborating the 'afinn' sentiment analysis that the total observations is skewed towards a more
#negative sentiment. 

#Plot 2
plot_2 <- output_bing %>%
  filter(bing %in% c("prop_negative", "prop_positive")) %>%
  #filter 'bing' column to include only proportions data
  ggplot(aes(x = bing, y = n)) + 
  geom_histogram(stat = "identity", color = "darkred") +
  scale_y_continuous(limits = c(0, 1))+
  scale_x_discrete(labels=c('Negative', 'Positive'))+
  labs(title = "Bing Sentiment Analysis of Public Health Roundup Text: \n January 2023",
       x = "Bing Sentiment Score",y = "Proportion",
       caption = "Remark: Only Observations with Available Bing Values \n was included and then analysed")+
  theme(
    plot.title = element_text(margin = margin(b = 10), size = 12, hjust = 0.5,
                              color = "black", face = "bold"),
    axis.title.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 10, face = "bold"),
    plot.caption = element_text(margin = margin(t = 10), hjust = 1))

plot(plot_2)

#Citations
#https://ggplot2.tidyverse.org/reference/scale_discrete.html
#https://stackoverflow.com/questions/75837190/ggplot-bold-how-can-i-make-bold-the-values-in-the-axis-bold

#Merge cleaned textfile with 'Bing'NRC Sentiment Measure
sentiment_analysis <- cleaned_data %>%
  left_join(nrc_sentiment, by = c("word_tokens" = "word"))

#C.Sentiment Analysis of the Textual Data Using 'Bing'

print(sum(!is.na(sentiment_analysis$nrc)))

#1.Of the 406 observations, 221 observations in total (some repeated) have 'nrc'
#sentiment scores available. 

nrc_score <- sentiment_analysis %>% #summary statistics 1
  filter(!is.na(nrc)) %>% #filter out observations with missing nrc scores 
  group_by(nrc) %>%
  count(nrc, sort = TRUE) %>% #count total number of observations(n) corresponding to each 'nrc' category
  arrange(desc(n)) #arrange total count(n) based on highest to lowest 

print(nrc_score)

print(nrc_score %>% #summary statistics 2
  pivot_wider(names_from = nrc, values_from = n) %>% #make each category into a separate column
  mutate(across(positive:surprise, ~round ( ./sum(positive:surprise), 3))) %>% #calculates proportion of each category (scale of 0 to 1) within dataset 
  pivot_longer(cols = positive:surprise, names_to = "nrc", values_to = "n")) #turns categories back into a column and values into another 'n'
    
#2.Evaluating the output of the nrc sentiment measure, it slightly conflicts the earlier 'bing' and 'afinn'
#sentiment measures as it depicts a marginally higher presence of observations with positive sentiments (0.047) in contrast
#to observations with negative sentiments (0.03).However, further analysis also depicts some level of overlap
#as frequency of observations in ranges of negative emotions i.e. fear, anticipation,
#sadness, disgust (79) is more than the frequency within positive emotions i.e.trust, joy, surprise (52). 

#Citation:
#https://stackoverflow.com/questions/68656809/mutating-across-multiple-columns-to-create-percent-score-in-r

#Plot 3 
plot_3 <- ggplot(data = filter(sentiment_analysis, !is.na(nrc))) +
  geom_histogram(aes(x = fct_infreq(nrc)), stat = "count", color = "darkred") +
  scale_x_discrete(guide = guide_axis(angle=45))+
  labs(title = "NRC Sentiment Analysis of Public Health Roundup Text: \n January 2023",
       x = "NRC Sentiment Score",y = "Frequency",
       caption = "Remark: Only Observations with Available NRC Values \n was included and then analysed")+
  theme(
    plot.title = element_text(margin = margin(b = 10), size = 12, hjust = 0.5,
                              color = "black", face = "bold"),
    axis.title.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 10, face = "bold"),
    plot.caption = element_text(margin = margin(t = 10), hjust = 1))

plot(plot_3)

#Plot Citations:
#https://stackoverflow.com/questions/52938858/reversed-use-of-fct-infreq-in-ggplot2

#Final Remark:The Public Health Roundup Text has an overall negative sentiment measure and evaluating
#the degree of this sentiment, it can be inferred there a moderate negative sentiment. This
#is corroborated by both the 'bing' and 'afinn' sentiment measures. 

#Citations:
#https://bookdown.org/psonkin18/berkshire/sentiment.html
#https://www.tidytextmining.com/sentiment

#Countries Discussed in the article
parsed <- udpipe(public_health_data, "english") #Tokenize and Pull Lemmas

#Extract List of Proper Nouns in Text 
countries_who_data <- parsed %>% 
  select(lemma, upos) %>% 
  filter(upos == "PROPN")

countries <- data.frame(lemma = countries::list_countries()) #make list of countries in library 'countries' into a dataframe

who_data_countries <- countries_who_data %>% 
  inner_join(countries,by = "lemma") #only merge similiar lemmas between the two datasets
  
print(who_data_countries %>% 
  select(lemma) %>% 
  unlist() %>% #makes into one vector
  unique())#extract only unique country names within the dataset

# Countries discussed in the article were Oman, Switzerland, Sudan, Uganda, Kenya

#Checks country name strings
is_country(c("Oman","Switzerland","Sudan","Uganda", "Kenya", 7), fuzzy_match = FALSE) 

#Citations
#https://cran.r-project.org/web/packages/countries/vignettes/dealing_with_names.html
#https://cran.r-project.org/web/packages/countries/readme/README.html
#ChatGPT question: How to convert a list within library into a dataframe?
#Answer: data.frame(colname = countries::list()) 

