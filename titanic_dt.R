##### Setting working directory

#setwd('')

##### Loading Libraries 

library(rpart.plot)
library(rpart)
library(smbinning)
library(rattle)
library(caret)


### Loading Dataset

train=read.csv('train.csv')
test=read.csv('test.csv')
train_summary=as.data.frame(smbinning.eda(train))
train$Pclass=as.factor(train$Pclass)
train$Age[is.na(train$Age)]=median(train$Age,na.rm=T)

### copying original dataset

train1=train

######### Selecting relevant columns

train[,c(4,9,11)]=NULL

######
train$Survived=as.factor(train$Survived)
train$SibSp=as.integer(train$SibSp)
selected_cols=colnames(train)[c(3:9)]
fmla=as.formula(paste("Survived ~",paste(selected_cols, collapse= "+")))
#control = rpart.control(minsplit=10,cp=0.01)
tree_1 <- rpart(fmla,data=train,method="class")
fancyRpartPlot(tree_1)
train_predict=predict(tree_1,train,type="class")
confusionMatrix(train_predict,train$Survived)






 