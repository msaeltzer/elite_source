---
  title: "Session IV"
author: "Marius Saeltzer"
date: "4 M?rz 2019"
output: html_document
---
  
  ```{r}
#install.packages('knitr')
```

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# The Twitter API

First, we need an API key. Since they are private property, I will not put them online. 
To do so, create a twitter account and go to twitter Apps. there, you can apply for a developer's account.

Once you got it, you can create an app, which get you 4 tokens.

You can simply put in the API keys im the arguments provided by the help function for create_token.

I safe my tokens in a dropbox placed csv file. You will not be able to use mine.

```{r}
# install.packages('rtweet')

if(!require('rtweet')){install.packages('rtweet')}

library(rtweet)

create_token(app='',
             '',
             '',
             '',
             ''
             ,access_token = NULL)



create_token(app='hellobundestag',
             'BRweN016Pbetc1Un6c4Sa4eSN',
             'SomWdxCJgUAgsKNr1yekuCTaNoxBrKYYOvb1x0Lv2nXz8ByNwd',
             '907615723790520320-YA5JzmHqOoQ9pYlhOna4W1JK1DtHgYb',
             'SBwMJgPSfKwdosjqOfXuiASpPPdwSSSLb3TLfte9iyYG2'
             ,access_token = NULL)


```

Once we have a twitter ID, we can look up tweets:


### Search Tweets

The easiest way is to use twitter like google. It allows you to search the last 18000 tweets containing a keyword.

```{r}
rt <- search_tweets(
  "Bundestag", n = 3200, include_rts = FALSE
)

```

```{r}
hist(rt$created_at,breaks='hours',main='what you get',xlab='time')

```

Let's look what people aroung as doing. We can condition the data not just on terms, but also on Geolocation.

```{r}
s<-search_tweets(q='*',n=10000, 
                 geocode = " 49.48643,8.50635,10mi",include_rts = F)

```

Let's see what we got:

```{r}

table(s$location)

```


So how comprehensive is this information?

```{r}
sum(is.na(s$location))

sum(s$location=='')

```

This data is mostly based on location data, but in some cases on so called geotags. First we have to get the data out of the list

```{r}
l<-lapply(s$geo_coords, unlist)
l<-lapply(l,as.numeric)
s$long<-unlist(lapply(l,'[[',1))
s$lat<-unlist(lapply(l,'[[',2))
sum(is.na(s$long)==F)
```
But only 128 gave their actual position

```{r}

data.frame(table(is.na(long)==F,s$source))

```

We see that mainly foursquare and instagram unsers post actual positions. 


### User Based Search

You have no idea about the sampling when using the search tweets functions. 

```{r}

acc<-lookup_users('c_lindner')

```



A more stable way to collect data is by downloading timelines of users.

For a single account, you can simply use 

```{r}
input<-c('c_lindner')

g<-get_timeline(input,3000,check=FALSE)
```


API Restrictions

Twitter places two major restrictions on API usage. First, you can only get the last 3200 tweets. Second, the number of accesses is restricted by a maximum number of calls per minute. 

With a single Key, it takes about 24 hours to get all tweets by the Bundestag. This is ok, but sometimes, we need more data like attributes of all followers. To keep looking after your rate limit is exceeded, you can use an argument of all the twitter functions. For 3200 tweets this doesn't matter, but once you look for a larger number, you might want to do this. 
                          
                          ```{r}
                          
                          
                          g<-get_timeline(input,3000,retryonratelimit=T)
                          
                          ```
                          You can also pass a vector of names to the functions, but be aware that 1) all data gets stored into the same data frame and 2) in longer operations, you might have your computer online for a long while, making the risk of crash and subsequent data loss very real. If you are planning to do your own large scale data operations, I will provide you with code to safely and automatically collect data. But that is higher level programming. 



Let's check what we can do with the data. Before, we analyzed the distribution over time. Let's see what we can do with more fine grained account data. First, we put this in a little nicer form: you can ignore the next chunk as we just recode the dates to look more pretty in ggplot2.

```{r,echo=FALSE}
library(stringr)
library(qdapRegex)
library(dplyr)
data<-g
tweetvariation<-function(data){
  data$day<-as.POSIXct(strptime(sub("\ .*","",    data$created_at),"%Y-%m-%d"))
  data$hour<- sub(".*\ ","", data$created_at)
  # data$hour_lab<- as.character(sub(".*\ ","", data$created_at))
  data$quoted_created_at<-as.POSIXct(strptime(sub("\ .*","", data$quoted_created_at),"%Y-%m-%d"))
  data$retweet_created_at<-as.POSIXct(strptime(sub("\ .*","", data$retweet_created_at),"%Y-%m-%d"))
  
  return(data) 
}

g<-tweetvariation(g)
```


Now we plot the data. The plots below are among the most popular ones in R, they are called ggplots and come from the tidyverse. 

We plot how our case study Christian Lindner behaves across the day and what devices he uses.

```{r}
library(tidyverse)
daytime<-ggplot(g, aes(x=as.POSIXct(hour, format="%H:%M:%S"),fill=source))
daytime +scale_x_datetime(labels = function(x) format(x, format = "%H:%M"))+
  labs(x="Tageszeit", y="tweets", fill="Ger?t")+
  geom_histogram(binwidth = 3600)
```
As you can see, this makes sense. The Web Client use is more dependent on the daily schedule with a lunch break and a brief period after working ours.

Let's do a super basic text operation: regular expressions. Christian Lindner marks his personally written Tweets with CL and Tweets by his team TL. We will make use of this by splitting the set using a first regular expression and plotting our figure for both subsets.

```{r}

g$real_lindner<-ifelse(grepl('CL',g$text),1,0)

g1<-g[g$real_lindner==1,]
g0<-g[g$real_lindner==0,]


daytime<-ggplot(g, aes(x=as.POSIXct(hour, format="%H:%M:%S"),fill=source))
daytime +scale_x_datetime(labels = function(x) format(x, format = "%H:%M"))+
        labs(x="Tageszeit", y="tweets", fill="Ger?t")+
        geom_histogram(binwidth = 3600)


daytime<-ggplot(g1, aes(x=as.POSIXct(hour, format="%H:%M:%S"),fill=source))
daytime +scale_x_datetime(labels = function(x) format(x, format = "%H:%M"))+
        labs(x="Tageszeit", y="tweets", fill="Ger?t")+
        geom_histogram(binwidth = 3600)

```
Well it seems like 1) Lindners team posts more consistent and earlier in the day while Christian Lindner posts a lot less in the evening.

This is just looking at the Meta data. We will dive deeper into this kind of information later on. Let's now oberserve the second interesting character of Twitter: Networks

### Get Networks

Creating networks from twitter data is on the one hand trivial, on the other time consuming. 

Rtweet provides us with two very simple interpretations of the follower relationsship: follwers and friends. As we discussed, friends tell us something about the preferences of the account: your friends decide what kind of input you get on your timeline. Your followers however can be considered your audience. For politicians, these relationships can be interpreted as seeing the followers as potential voters and friends as either news sources or affiliated accounts. You spend attention to add followers to an account and get ready to comment, retweet and reply. 

Let us reuse the account of c_lindner we scraped using the lookup_users function: 
  
  ```{r}
acc$followers_count

acc$friends_count
```

He has a lot more followers than friends. Let's take a look.

```{r}

f<-get_followers('c_lindner',n=1000)


## here you can see that you can put in the friends count we got from his account and just put it in the function to get all his friends

f1<-get_friends('c_lindner',n=acc$friends_count)

```

As you can see, we only get user IDs. To get more info, we can quickly get the data using lookup users. Now we get a full data set.

```{r}

friends<-lookup_users(f1$user_id)
```

Let's look who he follows more closely and sort by their respective followers count.



```{r}
friends<-friends[order(friends$followers_count,decreasing = T),]
head(friends$screen_name,10)
``` 
```{r}

friends$fdp<-grepl('FDP',friends$description,ignore.case = T)

barplot(table(friends$fdp),col=c('grey','yellow'))
```


Now, that's not so many, right? But let's see if they are overrepresented given their activity.
```{r}

friends$fdp1<-ifelse(friends$fdp==T,2,1)
plot(log(friends$followers_count),log(friends$statuses_count),col=c('grey','yellow')[friends$fdp1],cex=c(0.5,1)[friends$fdp1],pch=c(5,19)[friends$fdp1],ylab='Activity',xlab='Followers')

```

It seems like activity and followership are not the reason why he follows them. So why? 
  
  Next steps:
  
  Analyzing twitter data:
  
  Text Analysis or Follower Analysis?
  