#########
# This script will get the publications from pubmed and save them as a bib file
# It was created following RefManageR manual:
# https://arxiv.org/pdf/1403.2036v1.pdf
#########
# Load libraries
renv::restore()

require(RefManageR)

# Get publications from pubmed
pubs <- ReadPubMed("Cristian Gonzalez-Colin", database = "PubMed")
citations <- toBiblatex(pubs)
writeLines(citations, "citations.bib")