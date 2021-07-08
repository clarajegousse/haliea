#!/bin/bash
#SBATCH --job-name=genomes-db
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

mkdir -p $WD/01-halieaceae-dbs

FILES=$WD/00-halieaceae-genomes/*.fna
for f in $FILES
do
	echo "Processing $f file..."
	spname=$(echo $f | cut -f 8 -d "/" | cut -f 1 -d ".")
	prefix=$(echo $spname | sed 's/-/_/')
	anvi-script-reformat-fasta $f \
	-o $WD'/00-halieaceae-genomes/'$spname'.fa' \
	--simplify-names --prefix $prefix

	anvi-gen-contigs-database -f $WD'/00-halieaceae-genomes/'$spname'.fa' \
	-o $WD'/01-halieaceae-dbs/'$spname'.db' -T 8
done

cat $WD/00-halieaceae-genomes/*.fa > $WD/01-halieaceae-dbs/haliea-genomes.fa
anvi-gen-contigs-database -f $WD/01-halieaceae-dbs/haliea-genomes.fa \
                          -o $WD/01-halieaceae-dbs/HALIEA-CONTIGS.db -T 8 -n 'Haliceaceae genomes'
