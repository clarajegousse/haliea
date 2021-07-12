#!/bin/bash
#SBATCH --job-name=pan-genome
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

anvi-pan-genome -g 04-pan/HALIEA-GENOMES.db \
                --project-name "Halieaceae_Pan" \
                --output-dir 04-pan/HALIEA \
                --num-threads 8 \
                --minbit 0.5 \
                --mcl-inflation 10 #--use-ncbi-blast


# anvi-display-pan -g HALIEA-GENOMES.db -p HALIEA/Halieaceae_Pan-PAN.db --server-only -P 8080
