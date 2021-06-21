#!/bin/bash
#SBATCH --job-name=cultivar-db
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

WD=/users/home/cat3/projects/haliea
cd $WD

# ----- CREATE ANVIO DB -----
conda activate anvio-master

CULTIVAR="data/cultivar-genomes/*.fna"
for f in $CULTIVAR
do
  echo "Processing $f file..."
  spname=$(echo $f | cut -f 3 -d "/" | cut -f 1 -d ".")
  anvi-script-reformat-fasta $f \
    -o data/cultivar-genomes/$spname.fa \
    --simplify-names

  anvi-gen-contigs-database -f data/cultivar-genomes/$spname.fa \
  -o data/cultivar-genomes/$spname.db -T 8

done
