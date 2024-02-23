#Load Different Packages
library(tidytext)
library(textdata)
library(tidyverse)
library(udpipe)
library(dplyr)
library(rvest)
library(SnowballC)

#Question 2
web_scraping_function <- function(input_month, input_year) {
  i <- 0 
  all_links_url <- list() #empty list to input URL and dates that satisfy the condition of the while loop
  logical_condition_loop <- TRUE
  
  while( logical_condition_loop) {
    #Convert the URL to a HTML text
    african_region_who_data <- read_html(paste0('https://www.afro.who.int/news/news-releases?page=', i)) 
    #value of index i is similiar to that of page number so that can be concatenated with the unique website url
    
    #Extract URLs from WHO Website
    africa_who_data_url <-  african_region_who_data %>% 
      html_elements("a") %>% #common element among website titles
      html_attr("href") #attain url
    

    #Extract Texts from WHO Website
    africa_who_data_text <- african_region_who_data %>% 
      html_elements("a") %>% #common element among website titles
      html_text()  #attain only text
    

    # Check if links are just from the 10 articles on each page
    condition <-  africa_who_data_url[grepl('Read more', africa_who_data_text)]
    #'Read More' is a common factor in all 10 articles in each of the 42 pages, so the grepl function will
    #be used to check if 'Read More' is available in all texts, and then that 
    #url will be merged with the primary website url
    relevant_links <- paste0('https://www.afro.who.int',condition)
    #if condition is satisfied, the url obtained is concatenated with unique website url 
    
    #Extract Article Dates
    africa_who_data_dates<-african_region_who_data %>% 
      html_elements(".date") %>% 
      html_text() %>% 
      gsub('\n', '', .) %>% #removes line breaks
      str_trim() %>% #removes white-spaces
      as.Date(., format = "%d %B %Y") #% B displays 'full month' within a date and since that is the format used in the website, it is ideal
    #Citations: 
    #https://stackoverflow.com/questions/21781014/remove-all-line-breaks-enter-symbols-from-the-string-using-r
    #https://rdrr.io/cran/stringr/man/str_trim.html
    #https://www.r-bloggers.com/2013/08/date-formats-in-r/
    

    # Save all Extracted URLS and corresponding Dates in a new Dataframe
    url_tibble <- data.frame("Dates" = africa_who_data_dates, "Links" = relevant_links)
    
    url_tibble <-  url_tibble %>% 
      filter(Dates >= as.Date(paste(input_year, input_month, 01, sep = "-"))) 
    #Filter for dates that are only higher than the input year and input month 
    
    all_links_url[[i + 1]] <-  url_tibble
    #Save extracted URLS and corresponding dates to list defined earlier
    
    # Set a condition where any article from before September 2023 is not downloaded by setting the While loop = False when that occurs 
    if(!all(africa_who_data_dates >= as.Date(paste(input_year, input_month, 01, sep = "-")))) {
       logical_condition_loop <- FALSE
    }
    i <- i + 1
  }
  all_links_url <- do.call(rbind,  all_links_url) #collapse list() into a dataframe
  #Citations:https://www.r-bloggers.com/2023/05/the-do-call-function-in-r-unlocking-efficiency-and-flexibility/
  
  #Create a New File to Save Dataframe - 'all_links_url'
  path <- "/Users/yashwiniselvaraj/Desktop/Winter 2024/Data Programming in R/Problem Sets/Problem Set 3/African_Region_Textfile/"
  
  #Save and Download Article URLs and Corresponding Dates into a Dataframe in CSV format
  file_path <- file.path(path, "africa_whodata.csv")
  write.csv( all_links_url, file_path, row.names = FALSE)
  
  for(i in 1:nrow(all_links_url)){
    
    compiled_scraped_text <- read_html(all_links_url$Links[i])
    
    #Extract main body of text from the article
    scraped_text_links <- compiled_scraped_text %>% 
      html_elements(".col-md-9 .field--item > p") %>% #extracts just the main body of text
      html_text() 
    
    #Citation:
    #https://posit.co/blog/rvest-easy-web-scraping-with-r/
      
    #Save and Download Scraped Text File As Separate '.txt' Files
    path <- "/Users/yashwiniselvaraj/Desktop/Winter 2024/Data Programming in R/Problem Sets/Problem Set 3/African_Region_Textfile/"
    name_of_the_files <- paste0("africa-whodata", i, ".txt") #name of document after its download
    folder_path <-file.path(path,name_of_the_files) #specifies folder path and name of document
    writeLines(scraped_text_links,folder_path) #save to a '.txt' file format
    close(file(folder_path)) 
    
    #Citations:ChatGPT question:recommended method to close connections to a file? 
    #https://www.rdocumentation.org/packages/ursa/versions/3.10.4/topics/close
    
  }
}

september_text <- web_scraping_function(09, 2023)
