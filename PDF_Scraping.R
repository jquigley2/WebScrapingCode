#Example 1:
library(tabulizer)
library(pdftables)
library(dplyr)

# Location of Human Rights Campaign Corporate Equality Index pdf file
location <- 'https://assets2.hrc.org/files/assets/resources/CEI-2018-FullReport.pdf?_ga=2.26671732.819047322.1512683155-686086236.1512683155'

# Extract the table
out <- extract_tables(location)


install.packages("rJava")
library(rJava) # load and attach 'rJava' now
install.packages("devtools")
devtools::install_github("ropensci/tabulizer", args="--no-multiarch")


install.packages("pdftools")
library(pdftools)

download.file("http://arxiv.org/pdf/1403.2805.pdf", "1403.2805.pdf", mode = "wb")
txt <- pdf_text("1403.2805.pdf")

# first page text
cat(txt[1])

# second page text
cat(txt[2])

txt <- pdf_text("http://arxiv.org/pdf/1406.4806.pdf")

# some tables
cat(txt[18])
cat(txt[19])


install.packages("rJava")
install.packages("png")
install.packages("testthat")
install.packages("ghit")
ghit::install_github(c("ropenscilabs/tabulizerjars", "ropenscilabs/tabulizer"))
library("tabulizer")


#Example 2:
# https://www.business-science.io/code-tools/2019/09/23/tabulizer-pdf-scraping.html
#1. Start wtih PDF
#2. tabulizer to extract tables
#3. use tidyverse (dplyr) to clean data into tidy format
#4. visualize trends with ggplot2

#load libraries:
library(rJava)
library(tabulizer)
library(tidyverse)

#Analyze the critical endangered species report: https://github.com/Coopmeister/data_science_r_projects/blob/master/endangered_species.pd
?extract_tables
#return a list of data frames:
endangered_species_scrape <- extract_tables(
  file = "endangered_species.pdf",
  method = "decide",
  output = "data.frame"
)
 #Pluck the first table in the list:
endangered_species_raw_tbl <- endangered_species_scrape %>%
  pluck(1) %>%
  as_tibble()

head(endangered_species_raw_tbl)
#we can see we have some cleaning to do

#Get column names from row 1:
?slice
?pivot
?pivot_longer
?pull
col_names <- endangered_species_raw_tbl %>%
  slice(1) %>% #chooses the first row - which is a type of header in this table
  pivot_longer(cols = everything()) %>% #turn the horizontal table to vertical
  mutate(value = ifelse(is.na(value), "Missing", value)) %>% #replaces the "NA" with "Missing"
  pull(value) #retrieves the contents of the "Value" column

#check result
col_names

#Overwrite names and remove column 1:
endangered_species_renamed_tbl <-  endangered_species_raw_tbl %>%
  set_names(col_names) %>%
  slice(-1)

#check result:
endangered_species_renamed_tbl %>% head() %>% knitr::kable() #generates a very simple table

#we can generate a far nicer table using the formattable package, btw:
install.packages("formattable")
library(formattable)

formattable(endangered_species_renamed_tbl)

#Tidy the data:
endangered_species_final_tbl <- endangered_species_renamed_tbl %>%
  #Remove the columns with all NAs:
  select_if(~ !all(is.na(.))) %>%
  
  #Fix the combo columns:
  separate(col = 'Amphibians Fishes Insects',
           into = c("Amphibians", "Fishes", "Insects"),
           sep = " ") %>%
  
  #Convert to Tidy Long format for viz:
  pivot_longer(cols=-Year, names_to = "species", values_to = "number") %>% #cols is columns to pivot to longer format
  
  #Fix numeric data stored as character
  mutate(number = str_remove_all(number, ",")) %>% #remove any commas from the "number" column
  mutate(number = as.numeric(number)) %>% #convert everything in the "number" column to numeric
  
  #Convert Character Year and Species to Factor
  mutate(Year = as_factor(Year)) %>%
  mutate(species = as_factor(species)) %>%
  
  #Percent by year:
  group_by(Year) %>%
  mutate(percent = number / sum(number)) %>%
  mutate(label = scales::percent(percent)) %>%
  ungroup()

#Show first six rows:
endangered_species_final_tbl %>% head() %>% knitr::kable()

formattable(endangered_species_final_tbl)


#Visualize the Data
endangered_species_final_tbl %>%
  mutate(Year = fct_rev(Year)) %>% #reverses the order of the factor
  
  ggplot(aes(x = Year, y = number, fill = species)) +
  
  #Geoms
  geom_bar(position = position_stack(), stat = "identity", width = .7) + #adds bars
  geom_text(aes(label = label), position = position_stack(vjust = 0.5), size = 2) + #adds numeric labels
  coord_flip() + #flips the chart on its side

  #Theme
  labs(
    title = "Critically Endangered Species",
    y = "#Species added to Critically Endangered List",
    x = "Year"
  ) +
    theme_minimal()
  
#Visualize trends over time by species:
endangered_species_final_tbl %>%
  mutate(Year = fct_rev(Year)) %>% #reverses the order of the factor
  
  #Geom
  ggplot(aes(Year, number, color = species, group=species)) + 
  geom_point() +
  geom_smooth(method = "loess") +
  facet_wrap(~ species, scales = "free_y", ncol = 3) +
  
  #Theme
  expand_limits(y = 0) +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(
    title = "Critically Endangered Species",
    subtitle = "Trends Not Improving... ",
    x = "", y = "Changes of #species in Threatened Category"
  )