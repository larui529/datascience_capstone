
# load required libraries -------------------------------------------------

suppressMessages(c(library(ANLP),
                 library(dplyr),
                 library(tidytext),
                 library(doParallel),
                 library(tidyverse)))
#--------------------------------------------------------------------------




# read-in data and create a sample data -----------------------------------

blogs <- readTextFile("final/en_US/en_US.blogs.txt", encoding = "UTF-8")
news <- readTextFile("final/en_US/en_US.news.txt", encoding = "UTF-8")
twitter <- readTextFile("final/en_US/en_US.twitter.txt", encoding = "UTF-8")

merged_data <- c(blogs, news, twitter)
length(merged_data)

set.seed(1234)
sampled_data <- sampleTextData(merged_data, 0.05)
length(sampled_data)

rm(blogs, news, twitter)
#--------------------------------------------------------------------------





# clean and filter profane words ------------------------------------------

## my function for profane words ##
my_stopwords <- function() {
  swear <- readLines("swearWords.txt", encoding = "UTF-8")
  bad <- readLines("bad-words.txt", encoding = "UTF_8")
  no_meaning <- readLines("no_meaning.txt")
  c(swear, bad, no_meaning)
}

cleaned_data <- sampled_data %>% 
  removeWords(my_stopwords()) %>%
  cleanTextData()
#--------------------------------------------------------------------------




# convert the corpus back to a dataframe ----------------------------------

tidied_corpus <- cleaned_data %>%
  tidy() %>%
  select(text)
#-------------------------------------------------------------------------




# generate tokens ---------------------------------------------------------

remove_function <- function(doc, n = 3) {
  dplyr::filter(doc, freq >= n)
}


generate_tokens <- function(doc, token = 1, remove = 3) {
  doc %>%
    unnest_tokens(word, text, token = "ngrams", n = token) %>% 
    count(word) %>%
    rename(freq = n) %>%
    filter(freq >= remove) %>%
    arrange(desc(freq))
}

unigram <- generate_tokens(tidied_corpus, token = 1)

bigram <- generate_tokens(tidied_corpus, token = 2)

trigram <- generate_tokens(tidied_corpus, token = 3, remove = 2)

tetragram <- generate_tokens(tidied_corpus, token = 4, remove = 2)

quintugram <- generate_tokens(tidied_corpus, token = 5, remove = 2)
#--------------------------------------------------------------------------





# create test and train datasets ------------------------------------------

## function to create the training datasets
# by the functions

train_gram <- function(data) {
rows <- sample(nrow(data), ceiling(nrow(data) * 0.9)) ## define "rows" to be used
  as.data.frame(data[rows, ])
}

## function to create the testing dataset ##
test_gram <- function(data) {
rows <- sample(nrow(data), ceiling(nrow(data) * 0.9)) ## define "rows" to be used
  as.data.frame(data[- rows, ])
}

# splitting the ngrams into train and test datasets
unigram_train <- train_gram(unigram)
bigram_train <- train_gram(bigram)
trigram_train <- train_gram(trigram)
tetragram_train <- train_gram(tetragram)
quintugram_train <- train_gram(quintugram)

unigram_test <- test_gram(unigram)
bigram_test <- test_gram(bigram)
trigram_test <- test_gram(trigram)
tetragram_test <- test_gram(tetragram)
quintugram_test <- test_gram(quintugram)
#--------------------------------------------------------------------------




# prediction model ---------------------------------------------------------

ngram_models <- list(quintugram_train, 
                     tetragram_train, 
                     trigram_train, 
                     bigram_train, 
                     unigram_train)



# save model --------------------------------------------------------------

saveRDS(ngram_models, "./output/shiny/prediction_model")
