# loading libraries -------------------------------------------------------
suppressMessages(c(library(tidyverse),
                   library(doParallel),
                   library(tidytext),
                   library(stringr),
                   library(caret)))

registerDoParallel(makeCluster(4))

#######################sample five percent################################

# load-in datasets --------------------------------------------------------
token_five <- readRDS("five_percent_sample")
#--------------------------------------------------------------------------


# split data from n =2 to n = 4 -------------------------------------------
bigram_five <- token_five %>%
  filter(gram == "bigram") %>% 
  select(word) %>%
  separate(word, c("word1", "outcome"), sep = " ")

trigram_five <- token_five %>%
  filter(gram == "trigram") %>%
  select(word) %>% 
  separate(word, c("word1", "word2", "outcome"), sep = " ")

tetragram_five <- token_five %>%
  filter(gram == "tetragram") %>%
  select(word) %>%
  separate(word, c("word1", "word2", "word3", "outcome"), sep = " ")
  
#--------------------------------------------------------------------------




# create training dataset -------------------------------------------------
intrain <- function (data) {
  createDataPartition(y = data$outcome, 
                      p = 0.6, 
                      list = FALSE)
}

intrain_bigram <- intrain(bigram_five)
intrain_trigram <- intrain(trigram_five)
intrain_tetragram <- intrain(tetragram_five)

training_bigram <- bigram_five[intrain_bigram, ]
training_trigram <- trigram_five[intrain_trigram, ]
training_tetragram <- tetragram_five[intrain_tetragram, ]
#----------------------------------------------------------------------------



# create testing data -----------------------------------------------------
testing_bigram <- bigram_five[-intrain_bigram, ]
testing_trigram <- trigram_five[-intrain_trigram, ]
testing_tetragram <- tetragram_five[-intrain_tetragram, ]
#--------------------------------------------------------------------------




# divide testing data into test and validation sets -----------------------
intest <- function(data) {
  createDataPartition(y = data$outcome,
                      p = 0.5,
                      list = FALSE)
}

intest_bigram <- intest(testing_bigram)
intest_trigram <- intest(testing_trigram)
intest_tetragram <- intest(testing_tetragram)
#---------------------------------------------------------------------------



# testing data ------------------------------------------------------------
test_bigram <- testing_bigram[intest_bigram, ]
test_trigram <- testing_trigram[intest_trigam, ]
test_tetragram <- testing_tetragram[intest_tetragram, ]

valid_bigram <- testing_bigram[-intest_bigram, ]
valid_trigram <- testing_trigram[-intest_trigram, ]
valid_tetragram <- testing_tetragram[-intest_tetragram, ]
#---------------------------------------------------------------------------




# fit models  -------------------------------------------------------------
model1 <- function(fit) {
  train(outcome ~ ., data = fit, method = "rf", trControl = trc)
}

model2 <- function(fit) {
  train(outcome ~ ., data = fit, method = "gbm", verbose = FALSE)
}
  
modelfit1_bigram <- model1(training_bigram)
modelfit2_bigram <- model2(training_bigram)

modelfit1_trigram <- model1(training_trigram)
modelfit2_trigram <- model2(training_trigram)

modelfit1_tetragram <- model1(training_tetragram)
modelfit2_tetragram <- model2(training_tetragram)


##########################sample ten percent###############################

# load-in datasets --------------------------------------------------------
token_ten <- readRDS(token_ten, "token_ten")
#--------------------------------------------------------------------------



# split data from n =2 to n = 4 -------------------------------------------
bigram_ten <- token_ten %>%
  select(word, gram) %>%
  filter(gram == bigram)

trigram_ten <- token_ten %>%
  select(word, gram) %>%
  filter(gram == trigram)

tetragram_ten <- token_ten %>%
  select(word, gram) %>%
  filter(gram == tetragram)
#---------------------------------------------------------------------------



# separate the ngrams into component words --------------------------------
bigrams_ten_sep <- bigram_ten %>%
  separate(gram, c("word1", "word2"), sep = " ")

trigram_ten_sep <- trigram_ten %>%
  separate(gram, c("word1", "word2", "word3"), sep = " ")

tetragram_ten_sep <- tetragram_ten %>%
  separate(gram, c("word1", "word2", "word3", "word4"), sep = " ")
#---------------------------------------------------------------------------
