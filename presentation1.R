# This file contains steps to process initial data for the Report Rubric
# THe initial data is pre-processed in Python script tknz.py

## load libraries and basic functions ------
library(ggplot2); library(dplyr)

getTheMost <- function(df,N) {
    require(dplyr)
    df <- df %>%
        arrange(desc(count))
    if (N > nrow(df)) stop() else return(df[1:N,])
}

reduceCount <- function(df,C) {
    require(dplyr)
    df %>%
        filter(count>C)
}

# get data for word count --------
twitter <- read.csv("data/twitter.csv",header = FALSE,col.names = c("word","count"))
news <- read.csv("data/news.csv", header = FALSE,col.names = c("word","count"))
blogs <- read.csv("data/blogs.csv", header = FALSE,col.names = c("word","count"))

twitter$type <- "Twitter"
news$type <- "News"
blogs$type <- "Blogs"


data_full <- rbind(twitter,news,blogs) 

hist(data_full[data_full$count>100000,"count"])

N = 50
data <- rbind(getTheMost(twitter,N),getTheMost(news,N),getTheMost(blogs,N)) 

data$word <- factor(data$word, levels = data$word[order(data$count, decreasing = TRUE)])
pl <- ggplot(data=data,aes(x=word,y=count, color=factor(type), group=factor(type))) +
    geom_line(size=1) + theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) 

png("word_counts.png",800,300)
print(pl)
dev.off()



### incremental percentage analysis --------
TOT <- sum(data_full$count)

incr <- data_full %>%
    filter(count>2) %>%
    group_by(word) %>%
    summarise(cnt=sum(count), P=sum(count)/TOT) %>%
    ungroup() %>%
    arrange(desc(cnt)) %>%
    mutate(csum=cumsum(cnt), csumpct =cumsum(cnt)/TOT )

incr50pc <- incr[incr$csumpct<0.501,]
incr90pc <- incr[incr$csumpct<0.901,]

## n-grams ------
 # bigrams
b_twitter <- read.csv("data/bigram_twitter.csv",header = FALSE,col.names = c("words","count"))
b_news <- read.csv("data/bigram_news.csv", header = FALSE, col.names = c("words","count"))
b_blogs <- read.csv("data/bigram_blogs.csv", header = FALSE, col.names = c("words","count"))
b_twitter$type <- "Twitter"
b_news$type <- "News"
b_blogs$type <- "Blogs"



N = 50
b_data <- rbind(getTheMost(b_twitter,N),getTheMost(b_news,N),getTheMost(b_blogs,N)) 

b_data$words <- factor(b_data$words, levels = b_data$words[order(b_data$count, decreasing = TRUE)])
pl <- ggplot(data=b_data,aes(x=words,y=count, color=factor(type), group=factor(type))) +
    geom_line(size=1) + theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) 

png("bigram_counts.png",1000,200)
print(pl)
dev.off()

CN <- 150
b_data <- rbind(reduceCount(b_twitter,CN), reduceCount(b_news,CN),reduceCount(b_blogs,CN))

# trigrams

t_twitter <- read.csv("data/trigram_twitter.csv",header = FALSE,col.names = c("words","count"))
t_news <- read.csv("data/trigram_news.csv", header = FALSE, col.names = c("words","count"))
t_blogs <- read.csv("data/trigram_blogs.csv", header = FALSE, col.names = c("words","count"))
t_twitter$type <- "Twitter"
t_news$type <- "News"
t_blogs$type <- "Blogs"

N = 50
t_data <- rbind(getTheMost(t_twitter,N),getTheMost(t_news,N),getTheMost(t_blogs,N)) 

t_data$words <- factor(t_data$words, levels = t_data$words[order(t_data$count, decreasing = TRUE)])
pl <- ggplot(data=t_data,aes(x=words,y=count, color=factor(type), group=factor(type))) +
    geom_line(size=1) + theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) 

png("trigram_counts.png",1000,200)
print(pl)
dev.off()

