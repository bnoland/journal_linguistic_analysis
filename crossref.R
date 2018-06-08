library(rcrossref)
library(tidyverse)
library(crminer)

# Journal data --------------------------------------------------------------------------------

journals <- tribble(
    ~title,                                                                ~issn,
    #---------------------------------------------------------------------|------------
    # Elsevier journals
    "Accident Analysis & Prevention",                                      "0001-4575",
    "Analytic Methods in Accident Research",                               "2213-6657",
    "Case Studies on Transport Policy",                                    "2213-624X",
    "Economics of Transportation",                                         "2212-0122",
    "Journal of Air Transport Management",                                 "0969-6997",
    "Journal of Rail Transport Planning & Management",                     "2210-9706",
    "Journal of Transport & Health",                                       "2214-1405",
    "Journal of Transport Geography",                                      "0966-6923",
    "Research in Transportation Business & Management",                    "2210-5395",
    "Research in Transportation Economics",                                "0739-8859",
    "Transport Policy",                                                    "0967-070X",
    "Transportation Research Part A: Policy and Practice",                 "0965-8564",
    "Transportation Research Part B: Methodological",                      "0191-2615",
    "Transportation Research Part C: Emerging Technologies",               "0968-090X",
    "Transportation Research Part D: Transport and Environment",           "1361-9209",
    "Transportation Research Part E: Logistics and Transportation Review", "1366-5545",
    "Transportation Research Part F: Traffic Psychology and Behaviour",    "1369-8478",
    "Travel Behaviour and Society",                                        "2214-367X",
    
    # Springer journals
    # Note: These journals have two ISSNs: one for print, one for online.
    "Transportation",                                                      "0049-4488",
    
    # Taylor & Francis journals
    # Note: These journals have two ISSNs: one for print, one for online.
    "International Journal of Sustainable Transportation",                 "1556-8318",
    "Mobilities",                                                          "1745-0101",
    "Traffic Injury Prevention",                                           "1538-9588",
    "Transport Reviews",                                                   "0144-1647",
    "Transportmetrica A: Transport Science",                               "2324-9935",
    "Transportmetrica B: Transport Dynamics",                              "2168-0566"
)

# Fiddling ------------------------------------------------------------------------------------

journal_info <- cr_journals(issn = "1556-8318", works = TRUE)
journal_info

works_info <- cr_works(dois = journal_info$data$DOI)
#works_info <- cr_works(filter = c(has_full_text = TRUE))
works_info

has_abstract <- cr_works(dois = journal_info$data$DOI, filter = c(has_abstract = TRUE))
has_abstract

links <- crm_links(doi = "10.1080/15568318.2018.1437237", type = "all")

crm_html("https://www.tandfonline.com/doi/pdf/10.1080/15568318.2018.1437237")
