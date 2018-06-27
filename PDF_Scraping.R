library(tabulizer)
library(pdftables)
library(dplyr)

# Location of WARN notice pdf file
location <- 'http://www.edd.ca.gov/jobs_and_training/warn/WARN-Report-for-7-1-2016-to-10-25-2016.pdf'

# Extract the table
out <- extract_tables(location)

# Location of WARN notice pdf file
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
