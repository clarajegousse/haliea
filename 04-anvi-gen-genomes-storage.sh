#!/bin/bash
#SBATCH --job-name=gen-genomes-storage
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

echo -e "name\tcontigs_db_path" > external-genomes.txt
CONTIGSDB="data/cultivar-genomes/*.db"
for cdb in $CONTIGSDB
do
  spname=$(echo $cdb | cut -f 3 -d "/" | cut -f 1 -d "." | sed 's/-/_/')
  echo -e """$spname\t$cdb""" >> external-genomes.txt
done
#cat external-genomes.txt

anvi-gen-genomes-storage -e external-genomes.txt \
  -i internal-genomes.txt \
  -o HALIEA-GENOMES.db \
  --gene-caller 'prodigal'




  
