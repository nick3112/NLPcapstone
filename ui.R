

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Nick's NLP Text Predicter"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("words",
                   "Number of words to predict:",
                   min = 1,
                   max =5,
                   value = 5,
                   step=1),
       
       br(),
       br(),
       em("Documentation for this web page can be found at:"),
       tags$a(href="https://nick3112.github.io/NLPcapstone/Presentation.html", "github.io/Presentation.html"),
       br(),
       br(),
       em("Information about how the predictor was built is at:"),
       tags$a(href="https://nick3112.github.io/NLPcapstone/Interim_Report.html", "github.io/Interim_Report.html")
       
    ),
    
    # the description, input and text predictor
    mainPanel(
      p("To use the text predictor, the steps are:"),
      p("1. Select the number of words to predict using the slider (1 shows the best word, 5 shows the 5 best words)"),
      p("2. Type into the input box"),
      p("3. The predictor will update and show you the predictions.  The most likely options are higher up in the table"),
            
       h3("Input Text to Predict"),
       tags$textarea(id="inputText", rows=3, cols=90),
       HTML("<br>"),
       HTML("<br>"),
      
       h3("Next Word"),
       HTML("<br>"),
       #column(1,offset=1,tableOutput('outputTable'))
       tableOutput('outputTable')
      

    )
  )
))
