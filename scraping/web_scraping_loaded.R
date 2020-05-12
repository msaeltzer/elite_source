#Web scraping from ballotpedia

library(tidyverse)
library(readxl)
library(stringr)

library(xml2)    
library(rvest)

setwd("./scraping") # set working directory

my_data <- read.csv("group_1_dataset_merged.csv",stringsAsFactors = F,sep="\t") #load data 

df = as.data.frame(my_data) # convert to a data frame



#df[36:46] <- NULL #remove unnecessary variables if working with full version
#Reading the HTML code from the website


dir.create("profile_pages")

list.files()

datnames<-c("Base salary","Net worth","Last elected","Next election","Associate","Bachelor's"      
   ,"Service / branch","Years of service","Religion","Profession" )


dat<-matrix(nrow=nrow(df),ncol=length(datnames))
dat.frame<-as.data.frame(dat)


names(dat.frame)<-datnames

df$twitter1<-NA
df$twitter2<-NA



for(i in 1:nrow(df)){
  
  rm(twitter)
  rm(h2)
  rm(links)
  rm(webpage)
  rm(wbpge)
  rm(content)
  rm(keys)
  rm(data)
  rm(value)
  
  
    print(i)
  #webpage <- tryCatch(read_html(df$ballotpedia.org[i]),error=function(e){"e"})
  #if(webpage=="e"){next}
  
  pagename<-paste0("./profile_pages/",df$First.Name[i],"_",df$Name[i],".txt")
  
  webpage <- tryCatch(read_html(pagename),error=function(e){"e"})
  if(webpage=="e"){next}

  #Using CSS selectors to scrape the biography section

  content<-xml_nodes(webpage,xpath='//*[@id="mw-content-text"]')
  
  
  ## Content paragraph
  par1<-xml_nodes(webpage,xpath='//*[@id="mw-content-text"]/p[2]')
  if(length(par1)>0){
  df$content[i]<-html_text(par1)
  links<-xml_nodes(webpage,xpath='//*[@id="mw-content-text"]/p[2]/a')
  df$District_link[i]<-links[grepl("District",links)][1]
  }
  
  ## Content Box 
  
  h2<-xml_nodes(webpage,xpath='//*[@class="infobox person"]')
  
  
  #Extract Twitter links
  box<-html_children(h2) # extract all the elements from the box 
  box<-xml_nodes(h2,xpath='//*[contains(@class,"widget-row")]')
  
  links<-lapply(box,function(x) html_attr(xml_node(x,"a"),"href"))
  
  twitter<-unlist(links)[grepl("twitter",unlist(links))]
  if(!is.null(twitter)){
  if(length(twitter)>1){
    df$twitter1[i]<-twitter[1]
    df$twitter2[i]<-twitter[2]
  }else{df$twitter1[i]<-twitter[1]}
  }  
  #children
  #silblings 
  
 #   
  keys<-xml_children(h2)
  key<-lapply(keys,xml_children)
  
  data<-lapply(key,html_text)
  data<-data[lapply(data,length)>1]
  
  if(length(data)<1){print("no table found")
    next}
  
  key<-c()
  value<-c()

  for(k in 1:length(data)){
  
    if(length(data[[k]])>1){
    key[k]<-data[[k]][1]
    value[k]<-data[[k]][2]
  }else{key[k]<-data[[k]]
  value[k]<-NA}
  }
  
  value<-gsub("\\n","",value)
  value<-gsub("\\t","",value)
  
  key<-gsub("\\n","",key)
  key<-gsub("\\t","",key)
  
  for(j in 1:length(names(dat.frame))){
  if(names(dat.frame)[j]%in%key){dat.frame[i,j]<-as.character(value[which(key%in%names(dat.frame)[j])])}
  }

  
}



sav<-dat.frame

nrow(df)
nrow(dat.frame)



write.csv(df,"updated.csv")

