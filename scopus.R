library(rscopus)
library(tidyverse)

res <- scopus_search(query = "ISSN(2214-367X) AND PUBYEAR BEF 2010")
entries <- gen_entries_to_df(res$entries)$df

as_tibble(entries)

#smaller_entries <- head(entries, n = 2)
smaller_entries <- entries %>% slice(1)

abstract_info_list <- lapply(smaller_entries[["prism:doi"]], function(doi) {
    res <- abstract_retrieval(doi, identifier = "doi")
    View(res)
    abstract <- res[["content"]][["abstracts-retrieval-response"]][["coredata"]][["dc:description"]]
    Sys.sleep(0.5)
    data.frame(doi = doi, abstract = abstract)
})

abstract_info_list

abstract_info <- do.call(rbind, abstract_info_list)
