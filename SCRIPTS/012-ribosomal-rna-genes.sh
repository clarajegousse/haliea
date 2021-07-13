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
cd $WD

# Archaea_76, Bacteria_71, Protista_83,
# Ribosomal_RNA_12S, Ribosomal_RNA_16S,
# Ribosomal_RNA_18S, Ribosomal_RNA_23S,
# Ribosomal_RNA_28S, Ribosomal_RNA_5S.

anvi-run-hmms -c HALIEA-CONTIGS.db \
  -I Ribosomal_RNA_12S -T 10

anvi-run-hmms -c HALIEA-CONTIGS.db \
  -I Ribosomal_RNA_16S -T 10

anvi-run-hmms -c HALIEA-CONTIGS.db \
  -I Ribosomal_RNA_18S -T 10

anvi-run-hmms -c HALIEA-CONTIGS.db \
  -I Ribosomal_RNA_23S -T 10

anvi-run-hmms -c HALIEA-CONTIGS.db \
 -I Ribosomal_RNA_28S -T 10

anvi-run-hmms -c HALIEA-CONTIGS.db \
 -I Bacteria_71 -T 10 --also-scan-trnas

anvi-summarize -c HALIEA-CONTIGS.db --just-do-it

anvi-get-sequences-for-hmm-hits -c HALIEA-CONTIGS.db \
	--hmm-source Ribosomal_RNA_16S \
	--gene-name Bacterial_16S_rRNA \
	-o HALIEA-rRNAs.fa
sed -i '' 's/>.*contig:/>/g' HALIEA-rRNAs.fa
sed -i '' 's/|.*$//g' HALIEA-rRNAs.fa

anvi-script-reformat-fasta HALIEA-rRNAs.fa \
-o temp && mv temp HALIEA-rRNAs.fa

mkdir rRNAs

grep '>' HALIEA-rRNAs.fa > deflines.txt

for i in `cat deflines.txt`
do
   grep -A 1 "$i$" HALIEA-rRNAs.fa > rRNAs/$i.fa
   echo ''
done

cd rRNAs

for i in *.fa
do
    anvi-gen-contigs-database -f $i \
                              -o $i.db \
                              --skip-gene-calling \
                              --skip-mindful-splitting
done

# generate an external genomes file
echo -e "name\tcontigs_db_path" > external-genomes.txt

for i in *.db
do
    echo $i | awk 'BEGIN{FS="."}{print $1 "\t" $0}'
done >> external-genomes.txt

anvi-compute-ani -e external-genomes.txt \
                 -o ani \
                 -T 6
