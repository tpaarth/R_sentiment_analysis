# https://www.kaggle.com/rtatman/tutorial-sentiment-analysis-in-r

# load in the libraries we'll need
library(tidyverse)
library(tidytext)
library(glue)
library(stringr)

# get a list of the files in the input directory
setwd('C:/Users/paart/Documents/PGP_BABI/Handouts/Web and Social Media Analytics/sentiment analysis kaggle/input_files/')
files <- list.files()
files

# Let's start with the first file. The first thing we need to do is tokenize it, 
# or break it into individual words.

# stick together the path to the file & 1st file name
fileName <- glue(getwd(),"/",files[1],sep = "")
fileName

# get rid of any sneaky trailing spaces
fileName <- trimws(fileName)
fileName

# read in the new file
fileText <- glue(read_file(fileName))
fileText

# remove any dollar signs (they're special characters in R)
fileText <- gsub(pattern = "\\$",replacement = "",fileText)
fileText

# tokenize
tokens <- data_frame(text = fileText) %>% unnest_tokens(word,input = text)
View(tokens)

# Now that we have a list of tokens, we need to compare them against a list of words with either positive or negative sentiment.
# A list of words associated with a specific sentiment is usually called a "sentiment lexicon".
# Because we're using the tidytext package, we actually already have some of these lists. 
# I'm going to be using the "bing" list, which was developed by Bing Liu and co-authors.

# get the sentiment from the first text: 
tokens %>%
  inner_join(get_sentiments(lexicon = "bing"),by = c("word")) %>% 
  count(sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)
  