
# setting required libraries
if (!require(twitteR)) {
        require(devtools)
        install_github("twitteR", username="geoffjentry")
        library(twitteR)
}

# web authentication below, currently not in use
# setup_twitter_oauth("consumer_key", "consumer_secret")

#auth with all parameters, actual keys need to be inserted to get data from twitter
setup_twitter_oauth("consumer_key", "consumer_secret", "access_token", "access_secret")
nt <- 1000 #number of tweats to extract
location <- as.character("-21.9,133.45,3000km") # for future use
#defining and saving search terms and keywords
keywords <- c("Westpac", "NAB", "CBA OR Commbank","ANZ")
colnames <- c("Westpac", "NAB", "CBA","ANZ" )

n_cols <- length(colnames)
terms <- data.frame(terms=colnames, keywords=keywords, stringsAsFactors= FALSE)
write.csv(terms, file="terms.csv")

for (i in 1:n_cols)
{
        #search in twitter
        temp.data <- searchTwitter(keywords[i], n=nt, lang='en')
        #convert to dataframe
        temp.dframe <- twListToDF(temp.data)
        #save to file
        write.csv(temp.dframe, file=paste0(colnames[i],".csv"))
        
}