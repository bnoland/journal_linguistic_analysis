# Compute summary statistics on the CohMetrix output.
# TODO: Only handles ScienceDirect stuff for now.

library(tidyverse)

# Read in the data ----------------------------------------------------------------------------

# Data directories.
data_dir <- "data"
cohmetrix_dir <- file.path(data_dir, "science_direct", "cohmetrix_output")

data_file_list <- list.files(cohmetrix_dir)
data_list <- list()
for (file in data_file_list) {
    path <- file.path(cohmetrix_dir, file)
    data <- read_csv(path)
    data <- data %>% select(-TextID)  # Get rid of column with file paths.
    
    # Strip off the file extension to get the data year -- used as identifier below.
    key <- tools::file_path_sans_ext(file)
    data_list[[key]] <- data
}

# Compute summary statistics ------------------------------------------------------------------

# Returns summary statistics for each variable in the form of a data frame.
summary_stats <- function(data) {
    data %>% map(function(col) {
        tibble(
            mean = mean(col),
            median = median(col),
            sd = sd(col),
            min = min(col),
            max = max(col)
        )
    }) %>% bind_rows(.id = "variable")
}

old_data <- data_list[c("1997", "1998", "1999")]
new_data <- data_list[c("2015", "2016", "2017")]

old_stats <- summary_stats(bind_rows(old_data))
new_stats <- summary_stats(bind_rows(new_data))

diff_stats <- left_join(new_stats, old_stats, by = "variable", suffix = c("_new", "_old")) %>%
    mutate(
        mean_diff = mean_new - mean_old,
        median_diff = median_new - median_old
    )

path <- file.path(data_dir, "diff_stats.csv")
write_csv(diff_stats, path)
