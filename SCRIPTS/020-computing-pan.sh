#!/bin/bash
#SBATCH --job-name=computing-pan
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=020-computing-pan.%j.out
#SBATCH --error=020-computing-pan.%j.err
echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD

anvi-gen-genomes-storage -i internal-genomes.txt \
                         -o HALIEA-PAN-GENOMES.db

anvi-pan-genome -g HALIEA-PAN-GENOMES.db \
   --minbit 0.5 \
   --mcl-inflation 2 \
   -n HALIEA-METAPANGENOME \
   -o HALIEA-METAPANGENOME -T 6

      #--use-ncbi-blast \

anvi-display-pan -p HALIEA-METAPANGENOME/HALIEA-METAPANGENOME-PAN.db \
               -g HALIEA-PAN-GENOMES.db --server-only -P 8080

	anvi-summarize -p HALIEA-METAPANGENOME/HALIEA-METAPANGENOME-PAN.db \
               -g HALIEA-PAN-GENOMES.db \
               -C genes \
               -o HALIEA-PAN-SUMMARY
