# loading libraries -------------------------------------------------------
suppressMessages(c(library(tidyverse),
                   library(doParallel),
                   library(tidytext),
                   library(stringr),
                   library(qdap), 
                   library(tm)))

registerDoParallel(makeCluster(4))


# read-in documents -------------------------------------------------------
con1 <- file(description = "processed_doc/twitter_half.txt", open = "r")
twitter_half <- readLines(con1)  
close(con1)

con2 <- file(description = "processed_doc/twitter_one.txt", open = "r")
twitter_one <- readLines(con2)
close(con2)

con3 <- file(description = "processed_doc/news_half.txt", open = "r")
news_half <- readLines(con3) 
close(con3)

con4 <- file(description = "processed_doc/news_one.txt", open = "r")
news_one <- readLines(con4) 
close(con4)

con5 <- file(description = "processed_doc/blogs_half.txt", open = "r")
blogs_half <- readLines(con5) 
close(con5)

con6 <- file(description = "processed_doc/blogs_one.txt", open = "r")
blogs_one <- readLines(con6) 
close(con6)
#------------------------------------------------------------------------



# converts the character data to dataframe --------------------------------
twitter_half <- data_frame(source = "twitter", 
                      line = 1:length(twitter_half), 
                      text = twitter_half)
twitter_one <- data_frame(source = "twitter", 
                        line = 1:length(twitter_one), 
                        text = twitter_one)
blogs_half <- data_frame(source = "blogs", 
                    line = 1:length(blogs_half), 
                    text = blogs_half)
blogs_one <- data_frame(source = "blogs", 
                      line = 1:length(blogs_one), 
                      text = blogs_one)
news_half <- data_frame(source = "news", 
                   line = 1:length(news_half), 
                   text = news_half)
news_one <- data_frame(source = "news", 
                     line = 1:length(news_one), 
                     text = news_one)

docs_half <- bind_rows(twitter_half, blogs_half, news_half)

docs_one <- bind_rows(twitter_one, blogs_one, news_one)

## remove files no longer needed (i.e. twitter_half to news_one)
rm(twitter_half, twitter_one, blogs_half, blogs_one, news_half, news_one)
#----------------------------------------------------------------------------



# function to process some strings ----------------------------------------
to_strings <- function(x) {
  x %>%
    str_replace("teamifollowback", "team i follow back") %>%
    str_replace("sweetiepiez", "sweet pie") %>%
    str_replace("jonathantaylorthomas", "jonathan taylor thomas") %>%
    str_replace("thru", "through") %>%
    str_replace("tvmovies", "television movies") %>%
    str_replace("tv", "television") %>%
    str_replace("shortlived", "short lived")
}

docs_half$text <- to_strings(docs_half$text)

docs_one$text <- to_strings(docs_one$text)
#---------------------------------------------------------------------------



# tokenization -----------------------------------------------
tokenize_data <- function(data) {
  token1 <- data %>%
  unnest_tokens(word, text, token = "ngrams", n = 1) %>% 
  mutate(word = str_extract(word, "[^\\d]+")) %>%
  drop_na() %>%
  ungroup
token1$gram <- "unigram"

token2 <- data %>%
  unnest_tokens(word, text, token = "ngrams", n = 2) %>% 
  mutate(word = str_extract(word, "[^\\d]+")) %>%
  drop_na() %>%
  ungroup
token2$gram <- "bigram"

token3 <- data %>%
  unnest_tokens(word, text, token = "ngrams", n = 3) %>% 
  mutate(word = str_extract(word, "[^\\d]+")) %>%
  drop_na() %>%
  ungroup
token3$gram <- "trigram"

token4 <- data %>%
  unnest_tokens(word, text, token = "ngrams", n = 4) %>% 
  mutate(word = str_extract(word, "[^\\d]+")) %>%
  drop_na() %>%
  ungroup
token4$gram <- "tetragram"
bind_rows(token1, token2, token3, token4)
}
#--------------------------------------------------------------------------



# generate tokens ---------------------------------------------------------
token_half <- tokenize_data(docs_half)
token_one <- tokenize_data(docs_one)
#--------------------------------------------------------------------------



# save the tokens for further use -----------------------------------------
saveRDS(token_half, "half_percent_sample")
saveRDS(token_one, "half_percent_sample")
#--------------------------------------------------------------------------



# cleaning up -------------------------------------------------------------
rm(list = ls())
#--------------------------------------------------------------------------
