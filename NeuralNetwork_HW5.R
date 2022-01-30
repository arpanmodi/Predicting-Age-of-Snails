########################################
#########Neural Networks################
########################################

library(neuralnet)
library(data.table)
library(brnn)
library(readxl)


#Load the data
data <- read_excel("Snails.xlsx", sheet = 1)
#data$Type<- as.factor(data$Type)

#Creating Dummy Variable
data$TypeM <- ifelse(data$Type == 'M',1,0)
data$TypeI <- ifelse(data$Type == 'I',1,0)
data$TypeF <- ifelse(data$Type == 'F',1,0)

set.seed(1)
index <- sample(1:nrow(data), 0.7*nrow(data),replace = FALSE)

#Normalize the data
maxs <- apply(data[,-1], 2, max) 
mins <- apply(data[,-1], 2, min)
scaled <- as.data.frame(scale(data[,-1], center = mins, scale = maxs - mins))
train_ <- scaled[index,]
test_ <- scaled[-index,]


#modelling the algorithm
nn.model.validation <- neuralnet(Rings ~., data=train_, hidden = c(5,1), linear.output = TRUE)
plot(nn.model.validation)
predict.nn <- predict(nn.model.validation, newdata= test_)
predict.nn <- predict.nn*(max(data$Rings)-min(data$Rings))+min(data$Rings)
test.Rings <- (test_$Rings)*(max(data$Rings)-min(data$Rings))+min(data$Rings)

rss.nn <- sum((predict.nn-test.Rings)^2)
tss.nn <- sum((mean(test.Rings)-test.Rings)^2)
r.square.nn <- 1-(rss.nn/tss.nn)
#train.control.kfold <- trainControl(method = "cv",number = 10)
#lasso.kfold.reg <- train(Rings ~.,data=data[,-1],method='brnn',tCOntrol=train.control.kfold)
#lasso.kfold.reg

plot(test.Rings, predict.nn, col='red', pch=20,cex=0.5, ylab = "Predicted Value", xlab = "Actual Value", main="Real vs Predict NN")
abline(0,1)


#K-Fold validation using custom function for creating folds for trainng and testing (here K=10)
ptm <- proc.time()
folds <- trunc(seq(1,nrow(data), length.out=10))
r.square.kfold<-NULL
i<-1
while(i<10){
  
  #Normalize the data
  maxs <- apply(data[,-1], 2, max) 
  mins <- apply(data[,-1], 2, min)
  scaled <- as.data.frame(scale(data[,-1], center = mins, scale = maxs - mins))
  
  index <- folds[i]:folds[i+1]
  train_ <-  scaled[-index,]
  test_ <-  scaled[index,]
  
  nn.model <- neuralnet(Rings ~., data=train_, hidden = c(5,1), linear.output = TRUE)
  
  predict.nn <- predict(nn.model, newdata= test_)
  predict.nn <- predict.nn*(max(data$Rings)-min(data$Rings))+min(data$Rings)
  test.Rings <- (test_$Rings)*(max(data$Rings)-min(data$Rings))+min(data$Rings)
  
  rss.nn <- sum((predict.nn-test.Rings)^2)
  tss.nn <- sum((mean(test.Rings)-test.Rings)^2)
  r.square.nn <- 1-(rss.nn/tss.nn)
  
  r.square.kfold[i]<-r.square.nn
  i<-i+1
}
proc.time()-ptm  
  