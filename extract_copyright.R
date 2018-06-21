library(tidyverse)

path <- file.path("data", "0967-070X_all.csv")
abstracts <- read_csv(path)

str_view_all(abstracts$abstract, "(©|\\(C\\)).*$")
#str_view_all(abstracts$abstract, "^.*(©|\\(C\\))")

pattern <- "©\\s*\\d{4}\\s*(Elsevier Ltd|The Authors|The Author)*\\.?\\s*"

str_view_all(abstracts$abstract, pattern)
str_remove(abstracts$abstract, pattern)
