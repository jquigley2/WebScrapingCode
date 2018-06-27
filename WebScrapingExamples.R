library(tidyverse)
library(rvest)
library(stringr)
library(viridis)


#---------------------------
# SCRAPE DATA FROM CrueltyFreeInvesting.org
#---------------------------

df.lithium <- read_html("https://en.wikipedia.org/wiki/Lithium") %>%
  html_nodes("table") %>%
  .[[9]] %>%
  html_table() %>%
  as.tibble()



# INSPECT
df.lithium


  
  #Loading the rvest package
  library('rvest')
  #Loading dplyr to allow piping
  library(dplyr)
  
  #Specifying the url for desired website to be scraped
  url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'
  
  #Reading the HTML code from the website
  webpage <- read_html(url)
  
  #Using CSS selectors to scrape the rankings section
  #Piping allows you to sequentially filter
  
  #In this case, we have to isolate the left-hand table:
  rank_data_html <- html_nodes(webpage, '.cfi_left_comp_list') %>%
    #Then select the "company-symbol" from that left-hand table:
          html_nodes('.company-symbol')
  
  #Converting the ranking data to text
  rank_data <- html_text(rank_data_html)
  
  #Let's have a look at the rankings
  head(rank_data)
  tail(rank_data)
  
  df.crueltyfree <- as.data.frame(rank_data)
  
  # INSPECT
  df.crueltyfree
  