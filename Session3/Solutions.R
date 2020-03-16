


# Task 1
x<-cbind(c(1,0,0,0),
         c(0,1,0,0),
         c(0,0,1,0),
         c(0,0,0,1))

solution<-list(x)

# task2
t2<-c()
t2[1]<-dim(x)
t2[2]<-class(x)
t2[3]<-is.numeric(x)
v<-t2
solution[[2]]<-v

#task 3

x<-c(3,2,T,T)

# 

paste("There are about", 5*5,"students in this course.")


save(solution,file="solution.Rdata")