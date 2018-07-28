# Preprocess the abstract data for use with CohMetrix.
# TODO: This only handles citation data from ScienceDirect right now (easy to process, since no
# copyright info to extract).

library(bibtex)

# Data directories.
data_dir <- "data"
input_dir <- file.path(data_dir, "science_direct", "input")
output_dir <- file.path(data_dir, "science_direct", "output")

# Parse the BibTeX entries containing the citation and abstract data.
# An abstract is output to an individual file under the corresponding year directory.
input_files <- list.files(input_dir, full.names = TRUE)
for (file in input_files) {
    bib <- read.bib(file)
    for (entry in bib) {
        abstract <- entry$abstract
        
        # Skip entries with missing abstract data.
        if (is.null(abstract))
            next
        
        output_file <- basename(entry$doi)
        output_path <- file.path(output_dir, entry$year, output_file)
        
        writeLines(abstract, output_path)
    }
}
