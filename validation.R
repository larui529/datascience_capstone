## a function to help generate predictors by removing n-1 words from the ngrams
## data (in dataframe format), and merge the remaining 4 columns
pred_data <- function(doc) {  ## doc = five_grams
a <- doc %>%
    select(word) %>%
    separate(word, into = paste0("x", 1:5), sep = " ")
b <- a %>% 
  select(- ncol(a)) 
b <- b %>% unite(predictors, 1:ncol(b), sep = " ")
return(b)
}


## predicts the next word based on the predictors generated
view_prediction <- function(x, model) {
  output <- vector("character")
  x <- unlist(x)
  x <- as.character(x)
  for(i in seq_along(x)) {
    output[i] <- predict_Backoff(x[[i]], model)
  }
  output
}

## tests the accuracy of out model on the testing sample
accuracy <- function(test, prediction) { ## test is the fivegram_test data
  ## prediction is the result generated from the view_prediction()
  d <- test %>% select(word) %>% separate(word, into = paste0("x", 1:5), sep = " ")
  d <- d %>% select(ncol(d)) %>% unlist() %>% as.character()
  mean(prediction == d)
}
