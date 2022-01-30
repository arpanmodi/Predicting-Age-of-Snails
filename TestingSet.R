###############################
#########Best Model ###########
###############################

library(caret)
library("readxl")

#Load the Train data
datatrain <- as.data.frame(read_excel("Snails.xlsx", sheet = 1))

#Load the Test data
datatest <- as.data.frame(read_excel("TestSnails.xlsx"))

#Train the model 
bestmodel.lm <- lm(log(Rings) ~ .+log(ShellWeight)+I(ShellWeight^4) -(Type+ShellWeight+Diameter), data= datatrain)

#Compute the testing r square
bestpredict.lm<- exp(predict(bestmodel.lm, newdata=datatest))
best.RSS <- sum((datatest$Rings-bestpredict.lm)^2)
best.TSS <- sum((mean(datatest$Rings)-datatest$Rings)^2)
best.r.square.lm<- 1-(best.RSS/best.TSS) 
best.r.square.lm



