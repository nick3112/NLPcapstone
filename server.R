library(shiny)
library(tm)
library(data.table)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  #1. load the functions for prediction (includes the loading of the dataset)
  source("predicter.r")

  #2. now use the input text, number of words to predict to creat the prediction
    #. at the end we will output the results in a Table of predictions
  output$outputTable <- renderTable({predict(input$inputText,input$words)},colnames=FALSE)

})
