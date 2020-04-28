vignette("auth", package = "rtweet")

#install.packages("rtweet")

library(rtweet)

rtweet::create_token(app = "presscrape2020",
"UiAifHyM6xafhqKiKLJd5rJAC",
"pICpvowgKp8ueSfJZVhrkuwFhsmNQISJfyXUNsJKTiIKw5BwlQ")



rtweet::create_token(app = "congresswatch1","B8OBjpVKX6m6CEKnDG1OFFjCG","djD3yWujirTFA270o1QNR70WL0gnGekLkowxUd9nwHmgpHAOFb","907615723790520320-RWwRTkFKupliSuQ82juulcAIcGWzRpF",
"BJVrBLs0IaickfNZd3cAssncQmMXuHw80X3smDjQsZTPv")


donald<-rtweet::get_timeline("realdonaldtrump",n=3200,)
l1<-lookup_users("realdonaldtrump")
l2<-users_data(l1)




d1<-search_users("realdonaldtrump")





