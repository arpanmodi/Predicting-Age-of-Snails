###################################
#####Lasso Regression##############
###################################

library(caret)  #K-fold cross validation 
library(leaps)
library(ISLR)
library(FNN)
library(boot)
library(randomForest)
library(corrplot)
library(gbm)
library(glmnet)
library(ggplot2)
library(dplyr)
library(GGally)
library(faraway)
library("readxl")

#Load the data from the excel file
data <- read_excel("Snails.xlsx", sheet = 1)

#Splitting the data
set.seed(1)
index <- sample(1:nrow(data), 0.7*nrow(data),replace = FALSE)
TrainigData<- data[index,]
TestingData<- data[-index,]

#Find out the optiminum lambda value using cross validation approach
cv.out <- cv.glmnet(x=as.matrix(TrainigData[,-c(1,9)]),y=TrainigData$Rings,alpha=1)
plot(cv.out)
best.lambda <- cv.out$lambda.min

#Build a model using the best lambda value
lasso.reg.model <- glmnet(x=as.matrix(TrainigData[,-c(1,9)]),y=TrainigData$Rings,alpha=1,lambda = best.lambda)
lasso.predict <- predict(lasso.reg.model,s=best.lambda, newx= as.matrix(TestingData[,-c(1,9)]))
rss.lasso <- sum((lasso.predict-TestingData$Rings)^2)
tss.lasso <- sum((mean(TestingData$Rings)-TestingData$Rings)^2)
r.square.lasso <- 1- (rss.lasso/tss.lasso)


coef(lasso.reg.model)
#In the coefficient of model created , none of the coeff are shrunk to zero. This means, no predictors was completely dropped from the model. 


#K-Fold Cross Validation
train.control.kfold <- trainControl(method = "cv",number = 10)
lasso.kfold.reg <- train(Rings ~.,data=data,method='glmnet',tCOntrol=train.control.kfold)
lasso.kfold.reg
