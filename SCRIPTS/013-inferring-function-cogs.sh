#!/bin/bash
#SBATCH --job-name=cogs
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

anvi-run-hmms -c $WD/HALIEA-CONTIGS.db --just-do-it -num-threads 10
anvi-run-ncbi-cogs -c $WD/HALIEA-CONTIGS.db -num-threads 10 --sensitive
anvi-run-kegg-kofams -c $WD/HALIEA-CONTIGS.db --num-threads 10
anvi-run-pfams -c $WD/HALIEA-CONTIGS.db -T 10

anvi-db-info HALIEA-CONTIGS.db

# anvi-export-functions -c $WD/HALIEA-CONTIGS.db \
# 	--annotation-sources COG20_CATEGORY,COG20_PATHWAY,KEGG_Module,KOfam,Pfam -o function.txt
