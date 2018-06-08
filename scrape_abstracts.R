library(rscopus)
library(tidyverse)

# Import the journal info ---------------------------------------------------------------------

path <- file.path("data", "journal_info.csv")
journals <- read_csv(path, col_types = "ccii")

# Scrape the abstracts ------------------------------------------------------------------------

# Restrict to only a few journals for now.
journals <- journals %>% filter(issn == "0967-070X")

# Scrape the abstracts from a single journal in a given year range.
scrape_journal_abstracts <- function(issn, first_year, last_year) {
    # Form the Scopus search query string.
    # The +/- 1 in the year components is to simplify the query. 
    query_string <- str_c("ISSN(", issn, ") AND PUBYEAR AFT ", first_year - 1,
                          " AND PUBYEAR BEF ", last_year + 1)
    
    # Perform a Scopus search query and put the entries obtained in a data frame.
    response <- scopus_search(query = query_string)
    articles <- gen_entries_to_df(response$entries)$df
    
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

# The earliest year to scrape.
min_year <- 1993

for (i in 1:nrow(journals)) {
    issn <- journals$issn[i]
    first_year <- max(journals$first_year[i], min_year)
    last_year <- journals$last_year[i]
    
    articles <- scrape_journal_abstracts(issn, first_year, last_year)
    
    dois <- articles[["prism:doi"]]
    abstracts <- dois %>%
        map(function(doi) {
            abstract <- scrape_article_abstract(doi)
            # Restrict to 5 requests per second.
            Sys.sleep(0.2)
            abstract
        }) %>%
        bind_rows()
    
    # Write the abstract data for this journal to disk.
    path <- file.path("data", str_c(issn, ".csv"))
    write_csv(abstracts, path)
    
    # Restrict to 5 requests per second.
    Sys.sleep(0.2)
}
