#!/bin/bash
#SBATCH --job-name=download-sra-tara
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

#salloc -N 1
#ssh $SLURM_NODELIST
echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD/00-infos

WD=/users/home/cat3/projects/haliea
cd $WD/00-tara-metagenomes

# ENA sra structure
# ftp://ftp.sra.ebi.ac.uk/vol1/fastq/<accession-prefix>/<full-accession>/

cat $WD/00-infos/sra-accessions.txt | while read -r acc
do
	#echo 'Downloading '$acc 'from SRA ...'
	echo 'wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/'${acc:0:6}'/000/'$acc'/'$acc'_1.fastq.gz'
	echo 'wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/'${acc:0:6}'/000/'$acc'/'$acc'_2.fastq.gz'
done

# from NCBI SRA does not work :(
# cat $WD/00-infos/sra-accession.txt | while read -r acc
# do
# 	echo 'Downloading '$acc 'from SRA ...'
# 	fastq-dump $acc --gzip --split-files  --outdir $WD/00-tara-metagenomes
# done
