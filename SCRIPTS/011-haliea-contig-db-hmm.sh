#!/bin/bash
#SBATCH --job-name=haliea-hmm
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=haliea-hmm.%j.out
#SBATCH --error=haliea-hmm.%j.err

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/HALIEA-DB

FILES=$WD'/HALIEA-DB/'*.db
for f in $FILES
do
	#echo "Processing $f file..."
	anvi-run-hmms -c $f -I Ribosomal_RNA_16S -T 6 --just-do-it
	anvi-run-hmms -c $f -I Ribosomal_RNA_23S -T 6 --just-do-it
	anvi-run-hmms -c $f -I Ribosomal_RNA_5S -T 6 --just-do-it
	anvi-run-hmms -c $f -I Bacteria_71 -T 6 --just-do-it
done
