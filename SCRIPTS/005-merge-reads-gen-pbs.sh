#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/DATA-SAMPLES

for sample in `ls | grep "QUALITY_PASSED_R1.fastq.gz" | cut -f 1 -d "-"`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
	echo '''#!/bin/bash
#SBATCH --job-name=merge-'$sample'
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output='$sample'-merge-pbs.%j.out
#SBATCH --error='$sample'-merge-pbs.%j.err

echo $HOSTNAME
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD/DATA-SAMPLES

sample='$sample'
R1=$sample-QUALITY_PASSED_R1.fastq.gz
R2=$sample-QUALITY_PASSED_R2.fastq.gz

flash $R1 $R2 -x 0.05 -m 20 -M 150 -z -o '$sample' 2>&1 | tee flash.log

''' > $WD/DATA-SAMPLES/$sample'-merge-pbs.sh'
done
