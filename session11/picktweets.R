

setwd("../twitter/tweets")
tweets<-list.files()

alltweets<-lapply(tweets,readRDS)

all<-do.call(rbind,alltweets)

setwd("../../session11")

save(all,file="tweets.Rdata")

