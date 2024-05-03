#set a Cran mirror 
options(repos = c(CRAN = "https://cloud.r-project.org"))

# List of required packages
required_packages <- c("data.table", "ggplot2", "vegan", "RColorBrewer", "stringr", "ade4")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  } else {
    library(pkg, character.only = TRUE)
  }
}

blast=read.csv("Blast_res.txt", header = F, sep = "\t", dec = ".")
colnames(blast)=c("ASV", "qlen", "GIAccNum", "slen", "Ali_length", "Gaps", "Qcovs", "Pident", "Taxid")
blast$AccNum=do.call(rbind, strsplit(as.character(blast$GIAccNum), "\\|"))[,4]
# Keeping only alignments with at least 99% of query cover
blast=blast[blast$Qcovs>=99,]

TaxID <- blast$Taxid
TaxID <- paste(TaxID, collapse = ",")
writeLines(TaxID, "species_identification.txt")

