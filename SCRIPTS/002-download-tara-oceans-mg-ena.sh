#!/bin/bash
#SBATCH --job-name=download-sra-tara
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=002-download-tara-oceans-mg-ena.%j.out
#SBATCH --error=002-download-tara-oceans-mg-ena.%j.err

#salloc -N 1
#ssh $SLURM_NODELIST
echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD/RAW-READS

# ENA sra structure
# ftp://ftp.sra.ebi.ac.uk/vol1/fastq/<accession-prefix>/<full-accession>/
# ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR358/000/ERR3589559/ERR3589559_1.fastq.gz
# ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR599/ERR599077/ERR599077_1.fastq.gz

# ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR358/006/ERR3589556/ERR3589556_1.fastq.gz

cat $WD/INFOS/sra-accessions.txt | while read -r acc
do
	echo $acc
	l=$(expr length $acc)

	if [[ "$l" == 10 ]]; then
		wget 'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/'${acc:0:6}'/00'${acc:9:10}'/'$acc'/'$acc'_1.fastq.gz'
		wget 'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/'${acc:0:6}'/00'${acc:9:10}'/'$acc'/'$acc'_2.fastq.gz'
	else
		wget 'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/'${acc:0:6}'/'$acc'/'$acc'_1.fastq.gz'
		wget 'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/'${acc:0:6}'/'$acc'/'$acc'_2.fastq.gz'
	fi
done

# from NCBI SRA does not work :(
# cat $WD/00-infos/sra-accession.txt | while read -r acc
# do
# 	echo 'Downloading '$acc 'from SRA ...'
# 	fastq-dump $acc --gzip --split-files  --outdir $WD/00-tara-metagenomes
# done
