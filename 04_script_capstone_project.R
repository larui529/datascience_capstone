
# loading libraries -------------------------------------------------------
suppressMessages(c(library(tidyverse),
                   library(doParallel),
                   library(tidytext),
                   library(stringr),
                   library(qdap),
                   library(tm)))

registerDoParallel(makeCluster(4))
#---------------------------------------------------------------------------



# load tokens -------------------------------------------------------------
token_five <- readRDS("five_percent_sample")
token_ten <- readRDS("ten_percent_sample")
#--------------------------------------------------------------------------



# count number of words per ngram of sample size--------------------------
word_count <- function(document) {
  document %>%
    select(word, gram) %>%
    count(gram, word, sort = TRUE) %>%
    rename(count = n)
}

word_five <- word_count(five_token) %>%
  bind_tf_idf(word, gram, count) %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word))))

word_ten <- word_count(ten_token) %>%
  bind_tf_idf(word, gram, count) %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word))))
#----------------------------------------------------------------------------



# plot top 15 words -------------------------------------------------------
top_15 <- function(x) {
  x %>% 
  group_by(gram) %>% 
  top_n(15) %>% 
  ungroup
}

top15_five <- top_15(word_five)
top15_ten <- top_15(word_ten)


my_plot1 <- function(plot) {
  ggplot(plot, aes(word, tf_idf, fill = gram)) +
  geom_bar(alpha = 0.8, stat = "identity", show.legend = FALSE) +
  labs(title = "Highest tf-idf words in sampled data",
       x = NULL, y = "tf-idf") +
  facet_wrap(~gram, ncol = 2, scales = "free") +
  coord_flip()
}

top15_plot1 <- my_plot1(top15_five)
top15_plot2 <- my_plot1(top15_ten)

# count unique words per sample size --------------------------------------
unique_count <- function(doc) {
  doc %>%
    select(word, gram) %>%
    group_by(gram) %>%
    summarise(unique = length(levels(factor(word))))
  }

unique_five <- unique_count(five_token)
unique_ten <- unique_count(ten_token)
#--------------------------------------------------------------------------



# summarise the number of words per document ------------------------------
total_count <- function(word){
  word %>%
  group_by(gram) %>%
    summarise(total_words = sum(count))
    }  

five_total <- total_count(word_five)
ten_total <- total_count(word_ten)

#--------------------------------------------------------------------------




# create a summary table --------------------------------------------------
summary_five <- left_join(five_total, 
                             unique_five, 
                             by = "gram")
summary_five$sample_percent <- "five"

summary_ten <- left_join(ten_total, 
                            unique_ten, 
                            by = "gram")
summary_ten$sample_percent <- "ten"


summary_all <- bind_rows(summary_five,
                     summary_ten)
summary_all$gram <- factor(summary_all$gram, 
                           levels = c("unigram", "bigram", "trigram", "tetragram"))

summary_all <- summary_all %>%
  mutate(ratio = total_words / unique) %>%
  arrange(sample_percent, gram) %>%
  select(sample_percent, gram, unique, total_words, ratio) %>%
  format(digits = 2, nsmall = 2)
DT::datatable(summary)
#----------------------------------------------------------------------------




# save some data ----------------------------------------------------------
saveRDS(word_five, "word_five")
saveRDS(word_ten, "word_ten")
saveRDS(top15_plot1, "top15_plot1")
saveRDS(top15_plot2, "top15_plot2")
saveRDS(summary_all, "summary_all")
