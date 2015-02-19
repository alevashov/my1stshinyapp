pal <- brewer.pal(9,"BuGn")
pal <- pal[-(1:4)]
wordcloud(words=words, freq=freq, min.freq=1, max.words=200, colors=pal)
renderPlot({
        wordcloud(words=words, freq=freq, min.freq=1, max.words=200, 
                  colors=pal)
})