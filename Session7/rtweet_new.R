

install.packages("rtweet")

library(rtweet)

rtweet::create_token(app = "presscrape2020",
"UiAifHyM6xafhqKiKLJd5rJAC",
"pICpvowgKp8ueSfJZVhrkuwFhsmNQISJfyXUNsJKTiIKw5BwlQ",
"907615723790520320-YNHGzaptkKAawJK9VuzoNI1HvFKwdFO",
"ZXVJWTwR4jGv7VDGIiw83Pekz8Y13xwOWbABQq9QqVZTE")


donald<-rtweet::get_timeline("realdonaldtrump",n=3200,)


?lookup_users()


d1<-search_users("realdonaldtrump")





