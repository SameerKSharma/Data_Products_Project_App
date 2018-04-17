
library(shiny) # shiny library

# begining of ui component ?
ui<-fluidPage(
  
  fluidRow(
    column(12,
           "Model Selection Panel",
           
           sidebarLayout(
             sidebarPanel(
               h3('choose the model'),
               # the actioButton called rpart which is the name of the variable you need to use in the server component
               actionButton('rpart', label = 'Decision Tree',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rf', label = 'Random Forest', icon("tree-conifer", lib="glyphicon"),
                            style="color: #fff; background-color: #33cc33; border-color: #2e6da4"),
              actionButton('lda',label='LDA',icon("random,lib=glyphicon"),
                           style="color:#fff; background-color: #ffa500; border-color: #2e6da4"),
                  
               actionButton('svm', label = 'SupportVectorMachine', icon("random", lib="glyphicon"),
                            style="color: #fff; background-color: #ffa500; border-color: #2e6da4"),
               
               
               # the training sample split you allow the user to control on your model
               numericInput("ratio", "training sample in %", value=50/100, min = 50/100, max = 90/100, step=0.1)
             ),
             # this is how you create many "tabs" in the finishing 
             mainPanel(
               
               tabsetPanel( 
                            tabPanel("first 5 rows of the dataframe", verbatimTextOutput("head")), 
                            tabPanel("model result", tableOutput("result")), 
                            tabPanel("model plot", plotOutput('plot')),
                            tabPanel("model summary", verbatimTextOutput('summary'))
               )
             )
           )))
)
