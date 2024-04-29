########################
###  primer removing using of COI using Cutadapt  ###
########################

echo "###################removing the primers######################@"

cutadapt -g TTTCTGTTGGTGCTGATATTGCCHACWAAYCATAAAGATATYGG --revcomp -o Without_Primers.fasta Sequences.fasta
cutadapt -g ACTTGCCTGTCGCTCTATCTTCAWACTTCVGGRTGVCCAAARAATCA --revcomp -o Without_Primers2.fasta Without_Primers.fasta

# Doing the blast over NCBI data base (it can take a while)

echo "##################Doing the blast over NCBI data base (it can take a while)####################"

blastn -query Without_Primers2.fasta -db nt -remote -out Blast_res.txt -outfmt "6 qseqid qlen sseqid slen length gaps qcovs pident staxids" -perc_identity 99

# recovering the identity of each tax ID and putting it into a tsv file (this can also take a while)

echo "########recovering the identity of each tax ID and putting it into a tsv file (this can also take a while)###########"

datasets summary taxonomy taxon $(<Blast_res.txt) --as-json-lines | dataformat tsv taxonomy --template tax-summary > output.tsv




