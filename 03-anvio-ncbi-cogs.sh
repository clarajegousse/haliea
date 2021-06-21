#!/bin/bash
#SBATCH --job-name=ncbi-cogs
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1


CONTIGSDB="data/cultivar-genomes/*.db"
for cdb in $CONTIGSDB
do
  echo "Processing $cdb ..."
  anvi-run-ncbi-cogs -c $cdb -T 8 --sensitive
done
