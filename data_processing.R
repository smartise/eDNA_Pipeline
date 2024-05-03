

#set a Cran mirror 
options(repos = c(CRAN = "https://cloud.r-project.org"))

# List of required packages
required_packages <- c("dplyr")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  } else {
    library(pkg, character.only = TRUE)
  }
}

TaxID_names <- read.delim("output.tsv") 
TaxID_names <- TaxID_names[, c(2,10,11, 15, 17, 19, 21, 23, 25)]

blast=read.csv("Blast_res.txt", header = F, sep = "\t", dec = ".")
colnames(blast)=c("ASV", "qlen", "GIAccNum", "slen", "Ali_length", "Gaps", "Qcovs", "Pident", "Taxid")
blast$AccNum=do.call(rbind, strsplit(as.character(blast$GIAccNum), "\\|"))[,4]
# Keeping only alignments with at least 99% of query cover
blast=blast[blast$Qcovs>=99,]

TaxID_names$Taxid <- as.character(TaxID_names$Taxid)
blast$Taxid <- as.character(blast$Taxid)

final_doc<- blast %>%
  left_join(.,TaxID_names,by=c("Taxid"))

final_doc=as.data.table(final_doc)
final_doc <- final_doc[,"MaxIdent":=max(Pident), by=ASV]
final_doc=final_doc[final_doc$Pident>=(final_doc$MaxIdent-1),]


writeLines(as.character(final_doc), "Final.txt")