library(tidyverse)

# Journal data --------------------------------------------------------------------------------

# TODO: Maybe export this to a CSV file?
journals <- tribble(
    ~title,                                                                ~issn,       ~first_year, ~last_year,
    #---------------------------------------------------------------------|------------|----------|----------
    # Elsevier journals
    "Accident Analysis & Prevention",                                      "0001-4575", 1969,      2017,
    "Analytic Methods in Accident Research",                               "2213-6657", 2014,      2017,
    "Case Studies on Transport Policy",                                    "2213-624X", 2013,      2017,
    # TODO: Can't find direct info about this journal on Scopus site.
    "Economics of Transportation",                                         "2212-0122", 2012,      2017,
    # TODO: This journal has info for a few earlier years (but not sequential).
    "Journal of Air Transport Management",                                 "0969-6997", 1997,      2017,
    "Journal of Rail Transport Planning & Management",                     "2210-9706", 2011,      2017,
    "Journal of Transport & Health",                                       "2214-1405", 2013,      2017,
    "Journal of Transport Geography",                                      "0966-6923", 1993,      2017,
    # TODO: Can't find direct info about this journal on Scopus site.
    "Research in Transportation Business & Management",                    "2210-5395", 2011,      2017,
    # TODO: This journal has info for a few earlier years (but not sequential).
    "Research in Transportation Economics",                                "0739-8859", 2004,      2017,
    "Transport Policy",                                                    "0967-070X", 1993,      2017,
    # TODO: This journal has info for a few earlier years (but not sequential).
    "Transportation Research Part A: Policy and Practice",                 "0965-8564", 1992,      2017,
    "Transportation Research Part B: Methodological",                      "0191-2615", 1979,      2017,
    "Transportation Research Part C: Emerging Technologies",               "0968-090X", 1993,      2017,
    "Transportation Research Part D: Transport and Environment",           "1361-9209", 1996,      2017,
    "Transportation Research Part E: Logistics and Transportation Review", "1366-5545", 1997,      2017,
    "Transportation Research Part F: Traffic Psychology and Behaviour",    "1369-8478", 1998,      2017,
    "Travel Behaviour and Society",                                        "2214-367X", 2014,      2017,
    
    # Springer journals
    # Note: These journals have two ISSNs: one for print, one for online.
    "Transportation",                                                      "0049-4488", 1972,      2017,
    
    # Taylor & Francis journals
    # Note: These journals have two ISSNs: one for print, one for online.
    "International Journal of Sustainable Transportation",                 "1556-8318", 2007,      2017,
    "Mobilities",                                                          "1745-0101", 2006,      2017,
    "Traffic Injury Prevention",                                           "1538-9588", 2002,      2017,
    "Transport Reviews",                                                   "0144-1647", 1981,      2017,
    "Transportmetrica A: Transport Science",                               "2324-9935", 2013,      2017,
    "Transportmetrica B: Transport Dynamics",                              "2168-0566", 2013,      2017
)

# Export the data -----------------------------------------------------------------------------

path <- file.path("data", "journal_info.csv")
write_csv(journals, path)
