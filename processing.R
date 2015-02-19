#activating packages

require(tm)

#defining constants
directory <-"data" # should contain files with Twitter data only, file with names should be in root directory

#reading terms from a special file (in root project directory)
terms<- read.csv("terms.csv", header = TRUE)

#load data from CSV files. Files should be in 'data' sub-directory

filenames <- list.files(directory)        
l <-length(filenames); #note that we expect l (number of filenames be equalt to number of elements in terms)
m <- list()
text<-vector()
for (i in 1:l)
{
        m[[i]] <- read.csv(paste0(directory,  "/", filenames[i]), header = TRUE) 
        
}

#extract text
text <- list()
for (i in 1:l)
{
t = m[[i]]
text[[i]] <- as.character(t$text)
} 

#cleaning the text, define special funtion
clean.tweets <- function (rowtext)
{
        # First we will remove retweet entities from the stored tweets (text)
        rowtext = gsub("(RT|via)((?:\\b\\W*@\\w+)+)","", rowtext)
        # Then remove all “@people”
        rowtext = gsub("@\\w+", "", rowtext) 
        # Then remove all the punctuation
        rowtext = gsub("[[:punct:]]", "", rowtext)
        # Then remove numbers, we need only text for analytics
        rowtext = gsub("[[:digit:]]", "", rowtext)
        # then remove html links, which are not required for sentiment analysis
        rowtext = gsub("http\\w+", "", rowtext)
        # finally, we remove unnecessary spaces (white spaces, tabs etc)
        rowtext = gsub("[ \t]{2,}", "", rowtext)
        rowtext = gsub("^\\s+|\\s+$", "", rowtext)
}

# apply this function to our data
for (i in 1:l)
{
text[[i]]<-clean.tweets(text[[i]])        
}

# define "tolower error handling" function 
try.error = function(x)
{
        # create missing value
        y = NA
        # tryCatch error
        try_error = tryCatch(tolower(x), error=function(e) e)
        # if not an error
        if (!inherits(try_error, "error"))
                y = tolower(x)
        # result
        return(y)
}
# lower case using try.error with sapply 
# and remove NAs in some_txt
for (i in 1:l)
{

text[[i]] = sapply(text[[i]], try.error)
some_txt = text[[i]]
some_txt = some_txt[!is.na(some_txt)]
text[[i]] = some_txt
names(text[[i]]) = NULL
}

#Join texts in a vector for each term
v.text <- matrix(ncol=2, nrow=l)
all <- vector()
for (i in 1:l)
{
v.text [i,1]<-as.character(terms[i,2])
v.text [i,2]<-paste(text[[i]], collapse=" ")
all <-rbind(all, v.text[i,2])
}

# remove stop-words
more.words <- tolower(as.character(terms$terms))
all = removeWords(all, c(stopwords("english"),as.character(terms$terms),more.words))

# create corpus
corpus = Corpus(VectorSource(all))

# create term-document matrix
tdm = TermDocumentMatrix(corpus)

# convert as matrix
tdm = as.matrix(tdm)

# add column names
colnames(tdm) = terms$terms

#saving processed data
save(tdm, all, file='p-data')