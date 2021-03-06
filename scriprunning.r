## I have removed the secret key due to privacy concerns. Kindly drop an email to Sai-Santhi-Sree-Kumar.Medicherla@hsrw.org for the keys.


install.packages("twitteR")
install.packages("ROAuth")
install.packages("stringr")
install.packages("RCurl")
install.packages("dplyr")
install.packages("string")
install.packages(c("devtools", "rjson", "bit64", "httr"))
install.packages("openssl")
install.packages("httpuv")
install.packages("tibble")
install.packages("tidyverse")
install.packages("scales")

library(tidyverse)
library(tibble)
library(twitteR)
library(purrr)
library(plyr)
library(dplyr)
require('ROAuth')
require('httr')
require('RCurl')
require('curl')
library(stringr)
library(openssl)
library(httpuv)

###Step 1 - Load the positive and negative words

pos.words = scan('C:/users/**/R/Sentiment analysis/positive.txt', what='character',comment.char=';')
neg.words = scan('C:/users/**/Documents/R/Sentiment analysis/negative.txt',what='character',comment.char=';')

#Step 2 - Connecting to twitter:

consumerKey <- ""
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerSecret <- ""
accessToken <- ""
accessTokenSecret <- ""

twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=reqURL,accessURL=accessURL,
                             authURL=authURL)

#Setting up the twitter connection
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)


#Step 3 - Running the algorithm

score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(string)
  scores <- laply(sentences, function(sentence, pos.words, neg.words) {
    sentence <- gsub('[[:punct:]]',"", sentence)
    sentence <- gsub('[[:cntrl:]]',"", sentence)
    sentence <- gsub('\\d+', "", sentence)
    sentence <- tolower(sentence)
    word.list <- str_split(sentence, '\\s+')
    words <- unlist(word.list)
    pos.matches <- match(words, pos.words)
    neg.matches <- match(words, neg.words)
    pos.matches <- !is.na(pos.matches)
    neg.matches <- !is.na (neg.matches)
    score <- sum(pos.matches)- sum(neg.matches)
    return(score)
  }, pos.words, neg.words, .progress=.progress)
  scores.df <- data.frame(score=scores, text=sentences)
  return(scores.df)
}


#Step 4 - Streaming Real Madrid and Barcalona Tweets
tweet1 <- userTimeline('@barcalona',n=100)
tweet2 <- userTimeline('@realmadriden',n=100)


#Step 6 - Converting them to DF
tweet_df <- tbl_df(map_df(tweet1, as.data.frame))
tweet2_df <- tbl_df(map_df(tweet2, as.data.frame))


#Step 7 - Checking the tweets
tweet_df$text
tweet2_df$text


#Step 8 - Getting the Score

bscore <- score.sentiment(tweet_df$text,pos.words,neg.words,.progress='text')
rscore <- score.sentiment(tweet2_df$text,pos.words,neg.words,.progress='text')


#Step 9 - Plotting
hist(rscore$score)
hist(bscore$score)





