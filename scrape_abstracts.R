library(rscopus)
library(tidyverse)

# Import the journal info ---------------------------------------------------------------------

journals <- read_csv("journal_info.csv", col_types = "ccii")

# Scrape the abstracts ------------------------------------------------------------------------

# Narrow down the journal set.
#journals <- journals %>% filter(issn == "0967-070X")

# Scrape the abstracts from a single journal in a given year range.
scrape_journal_abstracts <- function(issn, first_year, last_year) {
    # Form the Scopus search query string.
    # The +/- 1 in the year components is to simplify the query.
    query_string <- str_c("ISSN(", issn, ") AND PUBYEAR AFT ", first_year - 1,
                          " AND PUBYEAR BEF ", last_year + 1)
    
    # Perform a Scopus search query and put the entries obtained in a data frame.
    response <- scopus_search(query = query_string)
    articles <- gen_entries_to_df(response$entries)$df
    
    # Indicate a retrieval error (e.g., the result set was empty).
    if (!is_null(articles$error))
        return(NULL)
    
    as_tibble(articles)
}

# Scrape the abstract of a single article.
scrape_article_abstract <- function(doi) {
    # Perform the abstract retrieval.
    response <- abstract_retrieval(doi, identifier = "doi")
    
    coredata <- response[["content"]][["abstracts-retrieval-response"]][["coredata"]]
    
    # Extract the pertinent information from the response.
    title <- coredata[["dc:title"]]
    abstract <- coredata[["dc:description"]]
    date <- coredata[["prism:coverDate"]]
    doi <- coredata[["prism:doi"]]
    issn <- coredata[["prism:issn"]]
    pub <- coredata[["prism:publicationName"]]
    
    info <- list(
        title = title,
        abstract = abstract,
        date = date,
        doi = doi,
        issn = issn,
        pub = pub
    )
    
    # Replace any missing values with NAs.
    info <- info %>% map(~ ifelse(is_null(.), NA, .))
    
    as_tibble(info)
}

# The year range to scrape.
first_year <- 2015
last_year <- 2017

data_dir <- file.path("data", "data_new")

for (i in 1:nrow(journals)) {
    issn <- journals$issn[i]
    
    articles <- scrape_journal_abstracts(issn, first_year, last_year)
    if (is_null(articles))
        next
    
    dois <- articles[["prism:doi"]]
    dois <- dois[!is.na(dois)]
    abstracts <- dois %>%
        map(function(doi) {
            abstract <- scrape_article_abstract(doi)
            # Restrict to 5 requests per second.
            Sys.sleep(0.2)
            abstract
        }) %>%
        bind_rows()
    
    # Write the abstract data for this journal to disk.
    path <- file.path(data_dir, str_c(issn, ".csv"))
    write_csv(abstracts, path)
    
    # Restrict to 5 requests per second.
    Sys.sleep(0.2)
}
