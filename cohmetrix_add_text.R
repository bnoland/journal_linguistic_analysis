# Replace the file paths in the CohMetrix output with the abstract text and file names.

library(tidyverse)

# Data directories.
data_dir <- "data"
science_direct_dir <- file.path(data_dir, "science_direct")
abstract_dir <- file.path(science_direct_dir, "output")
cohmetrix_dir <- file.path(science_direct_dir, "cohmetrix_output")
cohmetrix_with_text_dir <- file.path(science_direct_dir, "cohmetrix_output_with_text")

# Read in the data ----------------------------------------------------------------------------

data_file_list <- list.files(cohmetrix_dir)
data_list <- list()
for (file in data_file_list) {
    path <- file.path(cohmetrix_dir, file)
    data <- read_csv(path)
    
    # Strip off the file extension to get the data year -- used as identifier below.
    key <- tools::file_path_sans_ext(file)
    data_list[[key]] <- data
}

# Replace file paths with abstract text and file names ----------------------------------------

for (year in names(data_list)) {
    data <- data_list[[year]]
    
    split <- str_split(data$TextID, "\\\\")
    abstract_file <- split %>% map_chr(function(x) {
        x[[length(x)]]
    })
    
    abstract_text <- abstract_file %>% map_chr(function(file) {
        path <- file.path(abstract_dir, year, file)
        read_file(path)
    })
    
    # Remove the file paths and add in the abstract text and file names.
    data <- data %>% select(-TextID)
    data <- add_column(data, abstract_file, abstract_text, .before = 1)
    
    file <- str_c(year, ".csv")
    path <- file.path(cohmetrix_with_text_dir, file)
    write_csv(data, path)
}
