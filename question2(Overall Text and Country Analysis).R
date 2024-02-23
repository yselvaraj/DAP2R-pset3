#Question 2
library(tidytext)
library(textdata)
library(tidyverse)
library(countries)
library(udpipe)
library(dplyr)
library(readr)
library(countries)

#Part 2
#A. Load the Directory
setwd("/Users/yashwiniselvaraj/Desktop/Winter 2024/Data Programming in R/Problem Sets/Problem Set 3/African_Region_Textfile/")

#Make a Empty List and Save all 30 textfiles in it 
combine_text <-  list() #empty list to store all 30 textfiles 

for(i in 1:30){ #reads each fo the 30 textfiles in the set directory and saves it into the empty list above
  combine_text[[i]] <- read_delim(paste0("africa-whodata", i, ".txt"),
                                     col_names = F, delim = ",,,,", col_types = cols())
                                     
}

#Collapse the List into a Flat Dataframe 
combine_text <- do.call(rbind,combine_text)

# B. Cleaned Textfile
data("stop_words")
africa_who_data <- combine_text %>% 
  rename(text = X1) %>% 
  unnest_tokens(word_tokens, text, token = "words") %>% #Tokenize words
  anti_join(stop_words, by = c("word_tokens" = "word")) %>% #Take out Stop Words 
  group_by(word_tokens) %>% 
  count(word_tokens, sort = TRUE) %>% #count frequency of occurrence of each observation in the compiled text
  filter(is.na(as.numeric(word_tokens)))#removes any word tokens that is only a number 


#C. Sentiment Analysis of Overall Text by 'Unnesting Tokens' Method
#Load Sentiment Measures
afinn_sentiment <- get_sentiments("afinn") %>% 
  rename(afinn = value)
bing_sentiment <- get_sentiments("bing") %>% 
  rename(bing = sentiment)

#Merge cleaned textfile with 'Afinn' Sentiment Measure
sentiment_analysis2 <- africa_who_data  %>%
  left_join(afinn_sentiment, by = c("word_tokens" = "word"))

#A.Sentiment Analysis of the Textual Data Using 'Afinn'

print(sum(!is.na(sentiment_analysis2$afinn)))

#1.Of the 2781 observations, only 236 observations have 'afinn' sentiment scores available. 

sentiment_analysis2%>% 
  filter(!is.na(afinn)) %>% #filter out observations with missing afinn scores 
  group_by(afinn) %>% 
  count(afinn, sort = TRUE)%>% #count the total number of observations (n) within each afinn measure (-5 to 5)
  arrange(desc(n)) #arrange count (n) based on highest to lowest 

#2. Evaluating the spread of afinn sentiment scores, considering 86 words of the
#236 (close to 36%) words have a moderately positive sentiment score of '2'followed by a sentiment score of'1'
#taking second place, it demonstrates the overall text has more of a moderately positive sentiment. 

print(summary(sentiment_analysis2$afinn, na.rm=TRUE)) #summary statistics 

#3.Evaluating the summary statistics, a mean value of '0.661' and median value 
#of '1.0' further corroborates our above analysis that majority of observations
#within the compiled WHO text until September 2023, carry a relatively positive sentiment. 
#In addition, the interquartile range Q1 i.e. '-1' and Q3 i.e. '-2', further highlight 
#overall text is skewed towards a more moderately positive sentiment. 

#Plot 1
plot_1 <- ggplot(data = filter(sentiment_analysis2, !is.na(afinn))) +
  geom_histogram(aes(x = afinn), stat = "count", color = "darkred") +
  scale_x_continuous(n.breaks = 7)+
  scale_y_continuous(limits=c(0,100))+
  labs(title = "Afinn Sentiment Analysis of African Region \n WHO Data: Present - September 2023",
       x = "Afinn Sentiment Score", y = "Frequency",
       caption = "Remark: Only Observations with Available Afinn Values \n was included and then analysed")+
  theme(
    plot.title = element_text(margin = margin(b = 10), size = 13, hjust = 0.5,
                              color = "black", face = "bold"),
    axis.title.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 10, face = "bold"),
    plot.caption = element_text(margin = margin(t = 10), hjust = 1))

plot(plot_1)

#Merge cleaned textfile with 'Bing' Sentiment Measure
sentiment_analysis2 <-  africa_who_data %>%
  left_join(bing_sentiment, by = c("word_tokens" = "word"))

#B.Sentiment Analysis of the Textual Data Using 'Bing'

print(sum(!is.na(sentiment_analysis2$bing)))

#1.Of the 2781 observations, only 273 words have 'bing' sentiment scores available. 

#Summary Statistics 'Bing'
output_bing2 <- sentiment_analysis2 %>% 
  filter(!is.na(bing)) %>% #filter out observations with missing 'bing'sentiment score 
  group_by(bing) %>%
  count(bing, sort = TRUE)%>%  #counts the total number of observations (n) within the two categories (negative vs positive) of the 'bing' measure
  arrange(desc(n)) %>% #arrange count (n) based on highest to lowest 
  pivot_wider(names_from = bing, values_from = n) %>% #make each category into a separate column
  mutate(total_observations = negative + positive, #calculate summary statistics: difference in values, proportions of negative vs positive sentiments
         diff_between_observations = positive - negative,
         prop_negative = round(negative /total_observations, 3),
         prop_positive = round(positive /total_observations, 3)) %>% 
  pivot_longer(cols = positive:prop_positive, names_to = "bing", values_to = "n")

print(output_bing2)

#2. Evaluating the summary statistics, there are more words in the compiled WHO text with positive
#sentiments i.e., 164(approx 60%) in contrast to words with negative sentiments i.e., 109 (approx 40%), further
#corroborating the above 'afinn' sentiment analysis that the total observations is skewed towards a more
#positive sentiment. 

#Plot 2
plot_2 <- output_bing2 %>%
  filter(bing %in% c("prop_negative", "prop_positive")) %>%
  #filter 'bing' column to include only proportions data
  ggplot(aes(x = bing, y = n)) + 
  geom_histogram(stat = "identity", color = "darkred") +
  scale_y_continuous(limits = c(0, 1))+
  scale_x_discrete(labels=c('Negative', 'Positive'))+
  labs(title = "Bing Sentiment Analysis of African Region \n WHO Data: Present - September 2023",
       x = "Bing Sentiment Score",y = "Proportion",
       caption = "Remark: Only Observations with Available Bing Values \n was included and then analysed")+
  theme(
    plot.title = element_text(margin = margin(b = 10), size = 12, hjust = 0.5,
                              color = "black", face = "bold"),
    axis.title.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 10, face = "bold"),
    plot.caption = element_text(margin = margin(t = 10), hjust = 1))

plot(plot_2)




#Part 3: Country Sentiment Analysis 
#A. Identify All Countries in the WHO Dataset
#Sentiment Analysis of a Country 
cleaned_text <- combine_text %>% 
  rename(text = X1) %>% 
  mutate(doc_id = row_number()) #Assign Document ID for each of the textfiles compiled

#Citations
#https://stackoverflow.com/questions/75416848/problem-with-mutate-when-trying-to-create-a-line-id-column

#Tokenize and Pull Lemmas
parsed_text <- udpipe(cleaned_text, "english")

data("stop_words")
who_data_lemmas <- parsed_text %>% 
 filter(upos != 'PUNCT' & lemma != "'s") %>% #removes punctuation and apostrophe s 
 anti_join(stop_words, by = c('lemma'= 'word')) #removes stop words

#Identify All Countries in the WHO Dataset
countries_africa <-who_data_lemmas %>% 
  select(lemma, upos) %>% 
  filter(upos == "PROPN") #filter all proper nouns 

countries <- data.frame(lemma = countries::list_countries())  #make list of countries in library 'countries' into a dataframe

#Citation
#ChatGPT question: How to convert a list within library into a dataframe?
#Answer: data.frame(colname = countries::list()) 

print(countries_data <- countries_africa %>% 
  inner_join(countries,by = "lemma") %>% 
  select(lemma) %>% 
  unlist() %>% 
  unique())

#There are 34 countries in specific talked about in this Data set. 'Zambia' will be chosen for the
#country sentiment analysis



#B. Zambia Sentiment Analysis
#Extract all Tokens that Reference Zambia 
print(who_data_lemmas %>%
  filter(token == "Zambia")) #attain token-id for Zambia

zambia_tokens <-who_data_lemmas %>%
  filter(head_token_id %in% c(79, 54, 1, 29, 19)) %>% #filter for head token id which gives only lemmas that reference Zambia
  select("sentence_id", "token_id", "token", "lemma","upos","head_token_id","dep_rel") %>% 
  filter(!(upos %in% c('PUNCT', 'PART')) & lemma != "'s") %>% #removes punctuation, parts, and apostrophe s 
  anti_join(stop_words, by = c('lemma'= 'word')) #remove stop words

#Sentiment Analysis of Zambia using the 'Bing' Sentiment Measure
cleaned_zambia <- zambia_tokens %>% 
  select("lemma") %>% 
  rename(word = "lemma")

bing_sentiment <- get_sentiments("bing") %>% 
  rename(bing = sentiment)

bing_zambia <- cleaned_zambia %>% 
  left_join(bing_sentiment, by = c("word" = "word")) #merge to get bing sentiment analysis for lemmas
  
print(sum(!is.na(bing_zambia$bing)))
#Of the 633 observations that reference Zambia, only 69 words have 'bing' sentiment scores available. 

print(bing_zambia %>% 
        count(bing, sort = TRUE))#counts the total number of observations (n) within the two categories (negative vs positive) of the bing measure
#There are 37 observations with negative sentiments and 32 observations with positive sentiments.

zambia_summary_stats <- bing_zambia %>% 
  filter(!is.na(bing)) %>% #filter out observations with missing bing scores 
  group_by(bing) %>%
  count(bing, sort = TRUE) %>% 
  pivot_wider(names_from = bing, values_from = n) %>% #make sentiment measures into column format
  mutate(total_sentiment = negative + positive,#find summary statistics (proportions, difference, total values)
         total_difference = negative - positive,
         prop_negative = round(negative /total_sentiment, 3),
         prop_positive = round(positive /total_sentiment, 3)) %>% 
  pivot_longer(cols = negative:prop_positive, names_to = "bing", values_to = "n") #make sentiment measures into row format again

zambia_summary_stats

#Evaluating the 'bing' sentiment measure, there are just a few more observations referencing Zambia with 
#negative sentiments (approx 54%), in contrast to observations with positive sentiments (approx 46%), 
#indicating a slightly more overall negative sentiment for the country Zambia. 


#C.#Overall Text 'Bing' Sentiment Analysis at a 'Lemma' level
bing_sentiment <- get_sentiments("bing") %>% 
  rename(bing = sentiment)

sentiment_analysis3 <-  who_data_lemmas %>% #merge with parsed 'who_data_lemmas'document
  select(lemma) %>% #choose only the 'lemma' column
  rename(word = "lemma") %>% #rename for merging purposes
  left_join(bing_sentiment, by = c("word" = "word"))

#1. 'Bing' Sentiment Analysis Using Lemma
print(sum(!is.na(sentiment_analysis3$bing)))

# Of the 10772 observations, only 1111 words have 'bing' sentiment scores available. 

#Summary Statistics 'Bing'
output_bing3 <- sentiment_analysis3 %>% 
  filter(!is.na(bing)) %>% #filter out observations with missing 'bing'sentiment score 
  group_by(bing) %>%
  count(bing, sort = TRUE)%>%  #counts the total number of observations (n) within the two categories (negative vs positive) of the 'bing' measure
  arrange(desc(n)) %>% #arrange count (n) based on highest to lowest 
  pivot_wider(names_from = bing, values_from = n) %>% #make each category into a separate column
  mutate(total_observations = negative + positive, #calculate summary statistics: difference in values, proportions of negative vs positive sentiments
         diff_difference = positive - negative,
         prop_negative = round(negative /total_observations, 3),
         prop_positive = round(positive /total_observations, 3)) %>% 
  pivot_longer(cols = positive:prop_positive, names_to = "bing", values_to = "n")

print(output_bing3)
#There are 643 observations with positive sentiments and 468 observations with negative sentiments.
#Evaluating the 'bing' sentiment measure, overall the text has a positive sentiment (approx 58%) in 
#contrast to a negative sentiment (42%).This supports the above 'afinn' and 'bing' sentiment analysis that was 
#done instead by 'unnesting tokens', which also depicts the WHO has a positive sentiment overall. 

#Merge both the 'Zambia Bing Sentiment Analysis' and 'Overall Text Bing Analysis at a Lemma level' together
combined_df <- 
  bind_rows(zambia_summary_stats, output_bing3) %>% #bind two dataframes together
  filter(bing %in% c("prop_negative", "prop_positive")) %>% #filter only proportion data for both categories
  mutate(classification = ifelse((bing == "prop_negative" & n == 0.421) | (bing == "prop_positive" & n == 0.579), "Overall_Text", "Zambia")) %>% #create a category
  select(bing, n, classification) 

print(combined_df)
#Citation:
#ChatGPT question: How to create conditions for multiple different values in ifelse?

#Final Plot
zambia_plot <- ggplot(data = combined_df, aes(x = bing, y = n, fill = classification)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(limits = c(0, 1))+
  scale_x_discrete(labels=c('Negative', 'Positive'))+
  scale_fill_manual(values = c("Overall_Text" = "darkred", "Zambia" = "darkgreen")) +
  labs(title = "Zambia Sentiment Analysis: Present - September 2023",
       x = "Bing Sentiment Score",y = "Proportion",
       caption = "Remark: Only Observations with Available Bing Values \n was included and then analysed",
       fill = "Category")+
  theme(
    plot.title = element_text(margin = margin(b = 10), size = 12, hjust = 0.5,
                              color = "black", face = "bold"),
    axis.title.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 10, face = "bold"),
    plot.caption = element_text(margin = margin(t = 10), hjust = 1))

plot(zambia_plot)

#Citation:
#https://ggplot2.tidyverse.org/reference/scale_manual.html

#End of Assignment 
