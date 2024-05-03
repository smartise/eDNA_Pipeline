input="$1"

if [ $# -eq 0 ]; then
    echo "Error: Please provide the input file name."
    exit 1
fi

########################
###  primer removing using of COI using Cutadapt  ###
########################

echo "###################removing the primers######################@"

cutadapt -g TTTCTGTTGGTGCTGATATTGCCHACWAAYCATAAAGATATYGG --revcomp -o Without_Primers.fasta $input
cutadapt -g ACTTGCCTGTCGCTCTATCTTCAWACTTCVGGRTGVCCAAARAATCA --revcomp -o Without_Primers2.fasta Without_Primers.fasta

# Doing the blast over NCBI data base (it can take a while)

echo "################################################################"
echo "###Doing the blast over NCBI data base (it can take a while)####"
echo "################################################################"

blastn -query Without_Primers2.fasta -db nt -remote -out Blast_res.txt -outfmt "6 qseqid qlen sseqid slen length gaps qcovs pident staxids" -qcov_hsp_perc 99

# recovering the identity of each tax ID and putting it into a tsv file (this can also take a while)

echo "#############################################################################"
echo "###       transforming the blast res to be readable for datasets         ####"
echo "#############################################################################"

Rscript Remove_lowquery.R

echo "#############################################################################"
echo "###Recovering the identity of each tax ID and putting it into a tsv file ####"
echo "###                         This can also take a while                   ####"
echo "#############################################################################"

datasets summary taxonomy taxon $(<species_identification.txt) --as-json-lines | dataformat tsv taxonomy --template tax-summary > output.tsv

echo "#############################################################################"
echo "###                fusing the blast and the Taxid dictionary             ####"
echo "#############################################################################"

Rscript data_processing.R

