###################################
########Linear Regression##########
###################################

#Include all the relevant libraries


library(caret)  
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

#Load the snails data
data <- read_excel("Snails.xlsx", sheet = 1)

#Creating Dummy Variable
#data$TypeM <- ifelse(data$Type == 'M',1,0)
#data$TypeI <- ifelse(data$Type == 'I',1,0)
#data$TypeF <- ifelse(data$Type == 'F',1,0)

#Splitting the data
set.seed(1)
index <- sample(1:nrow(data), 0.7*nrow(data),replace = FALSE)
TrainigData<- data[index,]
TestingData<- data[-index,]

#Linear Regression 
model.lm <- lm(log(Rings) ~ .+log(ShellWeight)+I(ShellWeight^4) -(Type+ShellWeight+Diameter), data= TrainigData)
summary(model.lm)
predict.lm<- exp(predict(model.lm, newdata=TestingData))
RSS <- sum((TestingData$Rings-predict.lm)^2)
TSS <- sum((mean(TestingData$Rings)-TestingData$Rings)^2)
r.square.lm<- 1-(RSS/TSS) 

plot(predict.lm,TestingData$Rings)

#Cross Validation 
train.control.loocv <- trainControl(method = "LOOCV")
train.control.kfold <- trainControl(method = "cv",number = 10)

#K-fold
model.lm.kfold <- train(log(Rings) ~ .+log(ShellWeight)+I(ShellWeight^4)+ -(Type+ShellWeight+Diameter), data= data, method='lm',trControl=train.control.kfold)
model.lm.kfold

#LOOCV 
model.lm.loocv <- train(log(Rings) ~ .+log(ShellWeight)+I(ShellWeight^4) -(Type+ShellWeight+Diameter), data= data, method='lm',trControl=train.control.loocv)
model.lm.loocv


