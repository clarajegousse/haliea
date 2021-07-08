#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/00-tara-metagenomes

iu-gen-configs samples.txt -o $WD/01-qc-tara-metagenomes

for sample in `awk '{print $1}' $WD/00-tara-metagenomes/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
	echo '''#!/bin/bash
	#SBATCH --job-name=qc-'$sample'
	#SBATCH -p normal
	#SBATCH --time=3-00:00:00
	#SBATCH --mail-type=ALL
	#SBATCH --mail-user=cat3@hi.is
	#SBATCH -N 1
	#SBATCH --ntasks-per-node=1

	echo $HOSTNAME
	source /users/home/cat3/.bashrc
	conda activate anvio-master
	WD=/users/home/cat3/projects/haliea
	cd $WD/00-tara-metagenomes
	iu-filter-quality-minoche $WD/01-qc-tara-metagenomes/'$sample'.ini --ignore-deflines
	''' > $WD/01-qc-tara-metagenomes/$sample'-qc-pbs.sh'
done