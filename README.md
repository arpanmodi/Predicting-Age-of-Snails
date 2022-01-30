# Predicting-Age-of-Snails
I created three regression models to predict the age (Rings) of snails based on other characteristics. Determining the age of a snail is generally a tedious process; by creating an accurate regression based on easily gathered characteristics, age can be estimated quickly. In this project, my primary concern is accurate predictions (not interpretability). I have also suggested a final model to use to estimate age; the selection process is based upon  K-fold validation.

#Exploratory Data Analysis 

•	From the above data analysis, we can see that there are no NA values in our dataset 😊
•	The shape of the data has 3500 rows and 9 columns.
•	All the values are integers except the column ‘Type’ which has 3 factor levels namely – ‘M’,’F’ & ‘I’. 
•	There are two data points which has Height = 0 which means it’s a faulty entry. 
•	There is very high collinearity in the datasets given as evident from the pairs plot. 


The following three models I have selected:
1. Linear Regression Model
2. Lasso Regression Model
3. Neural Network Model



Linear Regression:

Initially for my base model, I used regsubsets from leaps library to help me evaluate the best predictors to be included in my model. Based on the value of nvmax, it selects the number of variables. After finalizing the base model, I did a couple of transformations on the predictors as well as on the response top get to the best model. I first checked the plot of each of the predictors with response (Rings) and tried to find the insights from the plot. This visualization helped me make decision on the type of transformation to be carried out on my model. I found a lot of variances in ShellWeight and LongestShell when plotted against Rings and hence carried out log transformation. 

We can see from the summary of the model created that, the p-value of each of the predictor is < 0.05 which means we can reject the null hypothesis and we can include the predictors in the model. So, I’m getting adjusted r square value on the training data as 63% which means that my model can explain ~ 63% variability in the dataset. Also, if I calculate the testing r square using validation set approach, I’m getting it as 56.9%. This tells us that on the testing data my linear model can capture 56.9% variability which is any time better when we compare it to the mean value. 


Lasso Regression:

Lasso regression is a type of linear regression with data shrinkage. This type of regression is well suited for models that shows high collinearity. I have used k-fold validation (cv.glmnet) to find the best value of lambda to be used in my model. So basically, lambda is the tunning parameter which controls the strength of the penalty term. As lambda increases, bias increases and as lambda decreases variance increases. After building the model using the best lambda, I get the following value of each coefficient. Here, we can see that – LongestShell coef is reduced to zero.

Using k-fold, the best lambda value I’m getting is 0.0069. Using the same value and building the model, I’m getting testing r square value as 56.77 %. 


Neural Networks: 

Neural network is a complex machine learning algorithm. It has multiple hidden layers and activation function. Each node and its preceding nodes are connected by variable weight matrix. 
Here, first I’m creating a dummy variable for Type namely- TypeM, TypeI and TypeF. The best practice is to normalize the data, so I have normalized the data set and then performed split into testing and training. For my neural network model, I’m using two hidden layers. The first hidden layer has 5 nodes, and the second hidden layer has 1 node. I have carefully chosen the number of nodes and number of hidden layers after a lot of exploratory analysis using k-fold validation on neural networks.
The testing r square which I got using neural net is 58.65%. The testing r square is calculated after un-normalizing the data that we initially normalized for accurate results. 
 
Best Model: Linear Regression :

I have chosen my best model to be a linear regression 

Validation method	Model	Test Rsquare 
K Fold	Neural Network 	58.88
K Fold	Lasso	53.84
K Fold	Linear Regression	63.65


Using the validation set approach, I tried to figure out the testing r.square for each of my models (linear model, lasso, ridge, random forest, boosting, neural networks) – but there is a lot of variability in testing r.square as the dataset changes each time while doing sample(). So, for a fair comparison I used 10-Fold cross validation to compare all my models. The best part of cross validation is that it uses all of the data points for testing and training and hence reduces the variability in the testing r.square. We can use LOOCV as well, but that it more computational expensive. I tried using both LOOCV and K-fold and ended up getting a similar estimate. So, to save my computational power I used K-fold cross validation approach to validate my models. 

I have used caret library to use the train function which helps me do cross validation. From snapshot below you can see the estimate r.square I’m getting is 63.6 % for the linear model. 
For the lasso regression, I’m getting the following results. We can see that the maximum value of estimated r.square is 53.849 which is for alpha = 1 and lambda = 0.004 – this suggests us that lasso model is better than ridge because we are getting the best r.square for alpha = 1. 
For the neural network model, I have manually created a loop which will help me calculate 10-fold cross validation results for even comparison. From the snap below, we can see that the estimated r.square value is 58.856 % 

 




So, based on the estimate r.square from k-fold cross validation across all the models, I concluded that linear regression model explains the most variability which means it has the best test r.square value and least MSE. This helps me to choose my best model. 
