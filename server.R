#loading libraries

if (!require(wordcloud)) {
        require(devtools)
        install.packages(wordcloud)
        library(wordcloud)
        }

#
#loading prepared data
load("p-data")

# build word clouds for each bank
mywords = rownames(tdm)
# defining colour pallette for wordcloud
pal <- brewer.pal(9,"BuGn")
pal <- pal[-(1:4)]


shinyServer
(function(input, output) 
{
        
        
                output$bank <- renderText({input$bank})
                #reading sliders values, reactive - min. frequency and max words
                minfrequency <- reactive(
                        {
                        as.numeric(input$min.f)
                        })
                maxwords <- reactive(
                        {
                        as.numeric(input$max.w)
                        })
                
                # getting column with words frequency for selected bank
                myfreq <- reactive({
                        subset(tdm, colname=input$bank, select=input$bank)
                                                        
                        })
                
                # word clour output
                output$cloud <- renderPlot ({wordcloud(words=mywords, freq=myfreq(), min.freq=minfrequency(), 
                                  max.words=maxwords(), colors=pal)})       
        
}
)