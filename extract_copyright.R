library(tidyverse)

path <- file.path("data", "0967-070X_all.csv")
abstracts <- read_csv(path)

# TODO: This is gnarly. Simplify.
# TODO: How to retain the copyright when splitting?
pattern <- "\\s*Â?(Copyright)?\\s*(©|\\(C\\))\\s*\\d{4}\\s*(Elsevier Ltd|Elsevier Science Ltd|Published by Elsevier Science Ltd|Published by Elsevier Ltd|The Authors|The Author)?\\.?\\s*(All right(s?) reserved.)?"
str_view_all(abstracts$abstract, pattern)

abstracts_small <- sample(abstracts)
str_split(abstracts_small$abstract, str_c("(?=(", pattern, "))"))
