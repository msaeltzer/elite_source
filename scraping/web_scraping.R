#Web scraping from ballotpedia

library(tidyverse)
library(readxl)
library(stringr)

library(xml2)    
library(rvest)

setwd("./scraping") # set working directory

my_data <- read_excel("group_1_dataset.xlsx") #load excel data inro R
df = as.data.frame(my_data) # convert to a data frame

df[36:46] <- NULL #remove unnecessary variables
#recode(df$ballotpedia.org[1]=="https://ballotpedia.org/Don_Young_(Alaska)")
#url <- df$ballotpedia.org
url<- "https://ballotpedia.org/Don_Young_(Alaska)"

#Reading the HTML code from the website

df$Education<-NA

for(i in 1:nrow(df)){
  
  Sys.sleep(6)  
  
  webpage <- tryCatch(read_html(df$ballotpedia.org[i]),error=function(e){"e"})
  if(webpage=="e"){next}
  
  #Using CSS selectors to scrape the biography section
  biography_data_html <- html_nodes(webpage,'.person')
  
  #Converting biography to text
  biography_data <- html_text(biography_data_html)
  
  head(biography_data)
  
  #Data-Preprocessing: removing \t
  biography_data<-gsub("\t","",biography_data)
  
  #Data-Preprocessing: removing \n
  biography_data<-gsub("\n","",biography_data)
  
  #Data-Preprocessing:  separate education
  education_data<-gsub("University.*", "University",biography_data)
  education_data<-gsub(".*Education", "",education_data)
  
  #Data-Preprocessing:  add spaces
  education_data <-gsub("([a-z])([A-Z])", "\\1 \\2", education_data) #before capital letters
  
  if(length(education_data)==0){
    print(i) 
    print("I found nothing here, please check me")
    next}
  
  
  df$Education[i]<-education_data 
   #Data-Preprocessing:  separate profession
  profession_data<-gsub("Contact.*", "",biography_data)
  profession_data<-gsub(".*Profession", "", profession_data)
  
  #Data-Preprocessing:  add spaces
  profession_data <-gsub("([a-z])([A-Z])", "\\1 \\2",  profession_data) #before capital letters
  
  if(length(profession_data)==0){
    print(i) 
    print("I found nothing here, please check me")
    next}
  
  
  df$Profession[i]<-profession_data 
  
  #Data-Preprocessing:  separate religion
  religion_data<-gsub("Profession.*", "",biography_data)
  profession_data<-gsub(".*Religion", "", religion_data)
  
  #Data-Preprocessing:  add spaces
  religion_data <-gsub("([a-z])([A-Z])", "\\1 \\2",  religion_data) #before capital letters
  
  if(length(profession_data)==0){
    print(i) 
    print("I found nothing here, please check me")
    next}
  
  
  df$Religion[i]<-religion_data 
}
