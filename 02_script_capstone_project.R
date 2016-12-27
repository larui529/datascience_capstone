
# loading libraries -------------------------------------------------------
suppressMessages(c(library(tidyverse),
                   library(doParallel),
                   library(tidytext),
                   library(stringr),
                   library(qdap), 
                   library(tm)))

registerDoParallel(makeCluster(4))
# -------------------------------------------------------------------------



# reads in the corpus ---------------------------------------------------
file_directory <- file.path(".", "sample_text")
file_directory
dir(file_directory)
docs <- VCorpus(DirSource(file_directory, encoding = "UTF-8"), 
                readerControl = list(language = "en"))
# -------------------------------------------------------------------------



# exploring the corpus ----------------------------------------------------
summary(docs)
sapply(docs[1:3], meta)

## function to view the top 6 lines of each of the documents
view_doc <- function(x, n = 6)  {
  output <- vector("character")
  for (i in seq_along(x)) {            # 2. sequence
    output[i] <- list(head(as.character(x[[i]]), n))  # 3. body
  }
  output
}

view_doc(docs)
#--------------------------------------------------------------------------



# text preprocessing ------------------------------------------------------
## i came up with a list of words I think don't make sense after scanning 
## through the documents
my_stopwords <- function() {
  swear <- readLines("swearWords.txt", encoding = "UTF-8")
  bad <- readLines("bad-words.txt", encoding = "UTF_8")
  no_meaning <- readLines("no_meaning.txt")
  c(swear, bad, no_meaning)
}

my_stop_words <- my_stopwords()

preprocess <- function(doc) {
  doc %>%
    tm_map(content_transformer(str_to_lower)) %>%
    tm_map(content_transformer(replace_symbol)) %>%
    tm_map(content_transformer(replace_abbreviation)) %>%
    tm_map(content_transformer(replace_contraction)) %>%
    tm_map(removePunctuation) %>% 
    tm_map(removeNumbers) %>% 
    tm_map(stripWhitespace) %>%
    tm_map(removeWords, my_stop_words)
}

prep_doc <- preprocess(docs)
view_doc(prep_doc)
#--------------------------------------------------------------------------



#-----------------------------------------------------------------------------



# write corpus back to documents for further preprocessing -------------------
if (!file.exists("processed_doc")) {
  dir.create("processed_doc")
  writeCorpus(prep_doc, "./processed_doc")
}
#-----------------------------------------------------------------------------    


# remove documents no longer needed ---------------------------------------
rm(docs, prep_doc)
#--------------------------------------------------------------------------