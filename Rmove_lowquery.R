library(data.table)
library(ggplot2)
library(vegan)
library(RColorBrewer)
library(stringr)
library(ade4)

blast=read.csv("Blast_res.txt", header = F, sep = "\t", dec = ".")
colnames(blast)=c("ASV", "qlen", "GIAccNum", "slen", "Ali_length", "Gaps", "Qcovs", "Pident", "Taxid")
blast$AccNum=do.call(rbind, strsplit(as.character(blast$GIAccNum), "\\|"))[,4]
# Keeping only alignments with at least 99% of query cover
blast=blast[blast$Qcovs>=99,]

write.table(blast, "High_query_blast_res.txt", sep = ",", row.names = FALSE)