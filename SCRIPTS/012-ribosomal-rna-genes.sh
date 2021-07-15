#!/bin/bash
#SBATCH --job-name=rrna
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/HALIEA-DB
#
# # Archaea_76, Bacteria_71, Protista_83,
# # Ribosomal_RNA_12S, Ribosomal_RNA_16S,
# # Ribosomal_RNA_18S, Ribosomal_RNA_23S,
# # Ribosomal_RNA_28S, Ribosomal_RNA_5S.
#
# anvi-run-hmms -c $WD/HALIEA-CONTIGS.db -I Ribosomal_RNA_16S -T 6 --just-do-it
# anvi-run-hmms -c $WD/HALIEA-CONTIGS.db -I Ribosomal_RNA_23S -T 6 --just-do-it
# anvi-run-hmms -c $WD/HALIEA-CONTIGS.db -I Ribosomal_RNA_5S -T 6 --just-do-it
# anvi-run-hmms -c $WD/HALIEA-CONTIGS.db -I Bacteria_71 -T 6  --also-scan-trnas --just-do-it
#
# anvi-get-sequences-for-hmm-hits -c HALIEA-CONTIGS.db \
# 	--hmm-source Ribosomal_RNA_16S \
# 	-o HALIEA-rRNAs.fa
# sed -i '' 's/>.*contig:/>/g' HALIEA-rRNAs.fa
# sed -i '' 's/|.*$//g' HALIEA-rRNAs.fa
#
# cat HALIEA-rRNAs.fa | sed 's/>.*contig:/>/g' > HALIEA-16S_rRNAs.fa
#
# sed -i 's/|.*$//g' HALIEA-16S-rRNAs.fa
#
# anvi-script-reformat-fasta HALIEA-16S-rRNAs.fa -o temp && mv temp HALIEA-16S-rRNAs.fa
#
# mkdir 16S-rRNAs
#
# grep '>' HALIEA-16S-rRNAs.fa | cut -f 2 -d ">" > deflines.txt
#
# for i in `cat deflines.txt`
# do
# grep -A 1 "$i$" HALIEA-16S-rRNAs.fa > 16S-rRNAs/$i.fa
# echo ''
# done
#
# cd 16S-rRNAs
#
# for i in *.fa
# do
# anvi-gen-contigs-database -f $i \
# -o $i.db \
# --skip-gene-calling \
# --skip-mindful-splitting
# done
#
#
# cd
# # generate an external genomes file
# echo -e "name\tcontigs_db_path" > external-genomes.txt
#
# for i in *.db
# do
#     echo $i | awk 'BEGIN{FS="."}{print $1 "\t" $0}'
# done >> external-genomes.txt
#
# anvi-compute-genome-similarity -e external-genomes.txt \
#                  -o ani \
#                  -T 6
