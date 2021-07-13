#!/bin/bash
#SBATCH --job-name=anvi-run-haliea
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
mkdir -p $WD/SUMMARIES

anvi-run-hmms -c $WD/HALIEA-CONTIGS.db -T 10 --also-scan-trnas
anvi-run-pfams -c $WD/HALIEA-CONTIGS.db -T 10
anvi-run-ncbi-cogs -c $WD/HALIEA-CONTIGS.db -T 10  --sensitive

anvi-export-gene-calls -c $WD/HALIEA-CONTIGS.db --list-gene-callers

anvi-export-gene-calls -c $WD/HALIEA-CONTIGS.db \
	--gene-caller 'prodigal' \
	-o $WD/SUMMARIES/gene_calls_summary.txt

anvi-export-gene-calls -c $WD/HALIEA-CONTIGS.db \
	--gene-caller 'Ribosomal_RNA_16S' -o $WD/03-haliea-db-summaries/Ribosomal_RNA_16S_summary.txt
