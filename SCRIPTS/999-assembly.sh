#!/bin/bash
#SBATCH --job-name=assemblies
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=assembly.%j.out
#SBATCH --error=assembly.%j.err

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD


DATADIR=/users/home/cat3/projects/haliea/DATA-SAMPLES
OUTDIR=/users/home/cat3/projects/haliea/ASSEMBLIES
SMP=TARA_030
MIN_CONTIG_SIZE=1000
NUM_THREADS=12

megahit -1 $DATADIR/$SMP-QUALITY_PASSED_R1.fastq.gz \
 -2 $DATADIR/$SMP-QUALITY_PASSED_R2.fastq.gz \
 --min-contig-len 1000 \
 -m 0.85 \
 -o $OUTDIR/$SMP -t $NUM_THREADS
