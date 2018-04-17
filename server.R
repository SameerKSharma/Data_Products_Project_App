# remember to inmport all the libraries you need for your machine learning models and plots
library(rpart)				        # Popular decision tree algorithm
#library(rattle)					# Fancy tree plot
library(rpart.plot)				# Enhanced tree plots
library(RColorBrewer)				# Color selection for fancy tree plot
library(party)					# Alternative decision tree algorithm
library(partykit)				# Convert rpart object to BinaryTree
library(tree) # good to have but not necessary
library(xtable) # good to have
library(e1071) # your suppose vector machine model
library(randomForest) # your randomforest model?
library(caret)  # for lda
data(iris)

server<- function(input,output, session){
  set.seed(1234)
  observe({
    r<-as.numeric(input$ratio)
    ind <- sample(2, nrow(iris), replace = TRUE, prob=c(r,1-r))
    trainset = iris[ind==1,]
    testset = iris[ind==2,]
    
    # decision tree action button
    observeEvent(input$rpart, {
      ml_rpart<-rpart(trainset$Species~.,method='class',data=trainset,control=rpart.control(minsplit=10,cp=0))
      model_pred<-predict(ml_rpart, testset, type="class")
      output$result<-renderTable({
        table(model_pred, testset$Species)    })
      output$summary <- renderPrint(summary(ml_rpart))
      output$plot <- renderPlot({
        prune.fit<-prune(ml_rpart, cp=0.001)
        # prune the treefirst then plot the pruned tree 
        plot(prune.fit, uniform=TRUE, 
             main="Pruned Classification Tree for iris data")
        text(prune.fit, use.n=TRUE, all=TRUE, cex=.8)
      })
    })
    #random forest action button
    observeEvent(input$rf, {
      require(randomForest)
      rf.fit<-with(trainset, randomForest(Species~., data=trainset, importance=TRUE, ntree=400))
      rf.pred<- predict(rf.fit, testset)
      output$result<-renderTable({
        
        table(rf.pred, testset$Species)   })
      output$summary <- renderPrint(summary(rf.fit))
      output$plot <- renderPlot({
        varImpPlot(rf.fit, main="Random Forest model fit, importance of the parameters")
        importance(rf.fit)
      })
    })
    #LDA
    observeEvent(input$lda, {
      require(caret)
      lda.fit<-train(Species~.,data=trainset)
      lda.pred<- predict(lda.fit, testset)
      output$result<-renderTable({
        
        table(lda.pred, testset$Species)   })
      output$summary <- renderPrint(summary(lda.fit))
      output$plot <- renderPlot({
        plot(lda.pred,testset$Species)
      })
    })
    # svm action button
    observeEvent(input$svm, {
      require(e1071)
      attach(iris)
      x <- subset(iris, select=-Species)
      y <- Species
      svm_model <- svm(Species ~ ., data=iris)
      svm_model1 <- svm(x,y)
      pred <- predict(svm_model1,x)
      output$result<-renderTable({
        table(pred,y) })
      output$summary <- renderPrint(summary(svm_model1))
      output$plot <- renderPlot({
        plot(svm_model, iris, Petal.Width ~ Petal.Length,
             slice = list(Sepal.Width = 3, Sepal.Length = 4))
      })
    })
    
    #print dataframe's sample head
    output$head <- renderPrint({
      head(testset, 5)
    })
  })
}


