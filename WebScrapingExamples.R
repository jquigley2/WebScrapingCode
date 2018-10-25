install.packages(c("tidyverse", "rvest"))
library(tidyverse)
library(rvest)
library(stringr)
library(viridis)

#---------------------------
# SCRAPE DATA FROM CrueltyFreeInvesting.org
#---------------------------
#Define the page
url <- "http://crueltyfreeinvesting.org/"

#Read the page
CrueltyFreePage <- read_html(url)

#Extract tickers from the CSS, determined by using SelectorGadget
(html_nodes(CrueltyFreePage, ".cfi_left_comp_list .company-symbol b"))

AnimalExploiters <- html_text((html_nodes(CrueltyFreePage, ".cfi_left_comp_list .company-symbol b")))

as.data.frame(AnimalExploiters)

library(tidyverse)
Tibble_AnimalExploiters <- as_tibble(AnimalExploiters)

  
#Let's have a look at the rankings
head(Tibble_AnimalExploiters)
tail(Tibble_AnimalExploiters)
  
# INSPECT
Tibble_AnimalExploiters
  
################### Different Example ############################  
  
# Install the package and load it
install.packages("rvest")
library(rvest)
#https://cran.r-project.org/web/packages/rvest/rvest.pdf

  
# Define the URL and download the HTML page with read_html
url1 <- "https://ideas.repec.org/top/top.person.alldetail.html"
page1 <- read_html(url1)
  
# To extract pieces out of the HTML page as a table format, use html_table
table1 <- html_table(page1)
  
# To extract pieces of the HTML page using css selectors, use html_nodes
# The following line extract information inside the <a> selector.
name_economist <- html_nodes(page1,"#left-cols a")
  
# Extract attributes, text and tag with html_text
name_economist <- html_text(name_economist)
  
# Create a data frame with data.frame
name_economist <- data.frame(name_economist)


#################### Some Exercises ################################
#https://www.r-bloggers.com/harvesting-data-from-the-web-with-rvest-exercises/

# Exercise 1
#Read the HTML content of the following URL with a variable called webpage:
install.packages('rvest')
library(rvest)

url <-   "https://money.cnn.com/data/us_markets/" #don't forget the quotes!
webpage <- read_html(url)
#useful to open this web page in your browser.

#Exercise 2
#Get the session details (status, type, size) of the above mentioned URL.
?html_session
html_session(url)

#Exercise 3
#Extract all of the sector names from the “Stock Sectors” table (bottom left of the web page.)
?html_text #Extract attributes, text and tag name from htm
?html_nodes #Extract pieces out of HTML documents using XPath and css selectors
#https://selectorgadget.com/
#If you have't used css selectors before, work your way through the fun tutorial at http://flukeout.github.io/
html_text(html_nodes(webpage, "#wsod_sectorPerformance .wsod_firstCol"))

#Exercise 4
#Extract all of the “3 Month % Change” values from the “Stock Sectors” table.
html_text(html_nodes(webpage, "#wsod_sectorPerformance .wsod_aRight"))

#Exercise 5
#Extract the table “What’s Moving” (top middle of the web page) into a data-frame.
?html_table #Parse an html table into a data frame

a <- html_nodes(webpage, "div table")[[1]]
a
b <- html_node(webpage,"div #wsod_whatsMoving")
b
table2 <- html_table(html_nodes(webpage, "div table")[[1]])

table2 <- html_table(html_node(webpage,"div #wsod_whatsMoving"))

#Exercise 6
#Re-construct all of the links from the first column of the “What’s Moving” table.
#Hint: the base URL is “https://money.cnn.com”
html_nodes(webpage, "td .wsod_symbol")

html_attr(html_nodes(webpage, "td .wsod_symbol"), "href")

?paste0
paste0("https://money.cnn.com", html_attr(html_nodes(webpage, "td .wsod_symbol"), "href"))

#Exercise 7
#Extract the titles under the “Latest News” section (bottom middle of the web page.)
html_nodes(webpage, ".HeadlineList a")

html_text(html_nodes(webpage, ".HeadlineList a"))

#Exercise 8
#To understand the structure of the data in a web page, it is often useful to know what the 
#underlying attributes are of the text you see.
#Extract the attributes (and their values) of the HTML element that holds the timestamp 
#underneath the “What’s Moving” table.
timestamp <- (html_nodes(webpage, ".wsod_disclaimer span"))

html_attrs(timestamp)

#Exercise 9
#Extract the values of the blue percentage-bars from the “Trending Tickers” table (bottom right of the web page.)
#Hint: in this case, the values are stored under the “class” attribute.
bars <- html_nodes(webpage, ".bars")

html_attr(bars, "class")

#Exercise 10
#Get the links of all of the “svg” images on the web page.
html_nodes(webpage, ".logo-cnn")

html_attr(html_nodes(webpage, ".logo-cnn"), "src")


######Other musings
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



################# Extract from a PDF ###################
#https://datascienceplus.com/extracting-tables-from-pdfs-in-r-using-the-tabulizer-package/

install.packages("tabulizer")

library(tabulizer)
library(dplyr)

#Set location of the pdf file:
location <- "https://assets2.hrc.org/files/assets/resources/CEI-2018-FullReport.pdf?_ga=2.211247381.1222537572.1540495430-444890937.1539119897"

#Extract the table:
?extract_tables
out <- extract_tables(location)

#Bind the individual tables into one (in this case, tables 40-75 are the relevant tables):
?do.call
?rbind
final <- do.call(rbind, out[-length(out)])
final <- do.call(rbind, out[40:75]) #these are the relevant tables

#We'd have to map the numbers in the columns to points, as these are just decoded symbols in the tables:




