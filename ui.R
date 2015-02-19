load("p-data")
shinyUI(pageWithSidebar(
  headerPanel("Comparing Big 4 Australian banks tweets"),
  sidebarPanel(
    selectInput(inputId="bank", label = "Select Big 4 bank", choices=colnames(tdm)),
    h4('Set word cloud parameters'),
    sliderInput("min.f", "Minimal frequence of the word to be counted", 
                min=1, max=10, value=3, step=1),
    sliderInput("max.w", "Maximum number of words to display", 
                min=50, max=300, value=150, round= TRUE),
    submitButton("Update my wordcloud!"),
    p("Please be patient, it takes some time to build the word cloud"),
    br(),
    h2("Project description"),
    p("This app analyses tweets about 4 biggest Australian banks (Big 4"),
    p("The tweets were collected by a separate R script in mid February 2015 based on simple keyword
      search using Twitter API (with twitterR package). 
      Collected tweets were pre-processed be another separate R script - cleaned and repacked to corpus 
      (tm package used). The data was saved in R data file and this file is loaded by this Shiny app."),
    em("App was inspired by the article of Gaston Sanchez - "),
    a("Comparison Wordcloud", href="https://sites.google.com/site/miningtwitter/questions/talking-about/wordclouds/comparison-cloud"),
    br(),
    br(),
    p("The app builds word for the bank selected in drop-down control with couple additional parameters 
      set via sliders. Updates require certain time (typically under 30 seconds), so hit to 
      'Update my wordloud' button is required"),
    p("Copyright - Alexander Levashov, 2015"),
    a("Levashov.Biz", href="http://levashov.biz")
  ),
  mainPanel(
    h3('Here is what people tweet about'), h3(textOutput('bank')),
    plotOutput('cloud') 
    )
))