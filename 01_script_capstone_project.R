#'---
#' title: 'Data Science capstone project'
#' author: "Balogun Stephen Taiye"
#' date: "22, November 2016"
#' output: github_document
#' ---

#' ### John Hopkins Bloomberg School of Public Health Data Science  ###
#' ### Capstone project #############


#' # download file -----------------------------------------------------------
#+ "global options"
knitr::opts_chunk$set(message = FALSE, warning = FALSE, tidy = TRUE, 
                      collapse = TRUE)

library(downloader)

fileURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/
Coursera-SwiftKey.zip"

if (!file.exists("Coursera-SwiftKey.zip")) {
  download(fileURL)
  unzip("Coursera-SwiftKey.zip")
}
#' #-----------------------------------------------------------------------



#' # read-in the data ------------------------------------------------
con1 <- file(description = "final/en_US/en_US.blogs.txt", open = "r")
blogs <- readLines(con1, encoding = "UTF-8")  
close(con1)

con2 <- file(description = "final/en_US/en_US.news.txt", open = "r")
set.seed(1235)
news <- readLines(con2, encoding = "UTF-8")
close(con2)

con3 <- file(description = "final/en_US/en_US.twitter.txt", open = "r")
set.seed(1236)
twitter <- readLines(con3, encoding = "UTF-8") 
close(con3)
#' #------------------------------------------------------------------------



#' # sample the data using 5% and 10% sample sizes ---------------------------
set.seed(1234)
twitter_half <- sample(twitter, (1/200 * length(twitter)))
set.seed(1234)
twitter_one <- sample(twitter, (1/100 * length(twitter)))

set.seed(1234)
blogs_half <- sample(blogs, (1/200 * length(blogs)))
set.seed(1234)
blogs_one <- sample(blogs, (1/100 * length(blogs)))

set.seed(1234)
news_half <- sample(news, (1/200 * length(news)))
set.seed(1234)
news_one <- sample(news, (1/100 * length(news)))
#' #---------------------------------------------------------------------------



#' # write the sample into a document and read it as corpus ------------------
if (!file.exists("sample_text")) {
  dir.create("sample_text")
  writeLines(twitter_half, "sample_text/twitter_half")
  writeLines(twitter_one, "sample_text/twitter_one")

  writeLines(news_half, "sample_text/news_half")
  writeLines(news_one, "sample_text/news_one")
  
  writeLines(blogs_half, "sample_text/blogs_half")
  writeLines(blogs_one, "sample_text/blogs_one")
}

#' #---------------------------------------------------------------------- 

# remove files no longer needed -------------------------------------------
rm(blogs, blogs_half, blogs_one,
   news, news_half, news_one,
   twitter, twitter_half, twitter_one)
#' #-------------------------------------------------------------------------
