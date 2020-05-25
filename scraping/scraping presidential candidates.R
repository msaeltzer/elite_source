#------------#
#### Head ####
# by: Aleksandra Butneva, 25.05.2020
# Web scraping from Ballotpedia - presidential candidates
#------------#
# Clear matrix #
#------------#
rm(list = ls())


#library(tidyverse)
library(dplyr)
library(readxl)
library(stringr)
library(xml2)    
library(rvest)
library(htmlwidgets)

## Store url
url<-read_html("https://ballotpedia.org/List_of_registered_2020_presidential_candidates")

## Scrape basic information ##

person_html <- html_nodes(url, xpath = '//td[(((count(preceding-sibling::*) + 1) = 1) and parent::*)]') # scrape names

name <-html_text(person_html) # read it as text into R


party_html <- html_nodes(url, xpath = '//tr//*[(((count(preceding-sibling::*) + 1) = 2) and parent::*)]') # scrape names

party <-html_text(party_html) # read it as text into R

df<-as.data.frame(name) # create a data frame
df$name<-as.character(df$name)
df <- df[-c(1:7),]
df<-as.data.frame(df)
df <- df[-c(1076:1097),]
df<-as.data.frame(df)


df2<-as.data.frame(party)
df2$party<-as.character(df2$party)
df2<- df2[-c(1:8),]
df2<-as.data.frame(df2)
df2 <- df2[-c(1076:1102),]
df2<-as.data.frame(df2)

df<-df %>% mutate(party=df2$df2)
names(df)[1] <- "name"

write.csv(df, "Presidential_candidates.csv")