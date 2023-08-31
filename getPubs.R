#########
# This script will get the publications from pubmed and save them as a bib file
# It was created following RefManageR manual:
# https://arxiv.org/pdf/1403.2036v1.pdf
#########
# Load libraries
renv::restore()

require(RefManageR)

# Remove potential erros in refecences
sanity_check <- function(entries) {
  for (i in seq_along(entries)) {

    ## Escape % in abstracts
    if (grepl("%", entries[[i]]$abstract)) {
      entries[[i]]$abstract <- gsub("%", "\\%", entries[[i]]$abstract,
                                    fixed = TRUE)
    }

    ## If month is string convert to number
    if (is.character(entries[[i]]$month)) {
      entries[[i]]$month <- match(entries[[i]]$month, month.abb)
    }

    ## Stardardize my name by removing accents
    if (any(grepl("González-Colín", entries[[i]]$author))) {
      idx <- grep("González-Colín", entries[[i]]$author)
      entries[[i]]$author[idx] <- person("Cristian", "Gonzalez-Colin")
    }

  }
  return(entries)
}

# Remove duplicates by title if one of them is a bioRxiv preprint
remove_duplicates <- function(entries) {
  titles <- unlist(entries$title)
  dupt <- titles[duplicated(titles)]
  for (d in dupt) {
    idx <- which(titles == dupt)
    if (length(idx) > 2) stop("Check references, more than 2 duplicates.\n")
    ## If one of the duplicates is a bioRxiv preprint, remove it
    biorx <- grep("bioRxiv", entries[[idx]]$journal)
    entries <- entries[-idx[biorx]]
  }
  return(entries)
}

# Get publications from pubmed
search_pubmed <- function(term) {
  pubs <- ReadPubMed(term, database = "PubMed")
  ## Check for potential errors
  pubs <- sanity_check(pubs)
  ### Check for duplicates
  pubs <- remove_duplicates(pubs)
  ### Save them as a bib file
  citations <- toBiblatex(pubs)
  ## Correct accentuation in authors
  citations <- gsub("a'", "'", citations)
  writeLines(citations, "citations.bib")
}


search_pubmed("Cristian Gonzalez-Colin")