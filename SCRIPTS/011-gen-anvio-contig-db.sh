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

mkdir -p $WD/HALIEA-DB

FILES=$WD'/HALIEA-GENOMES/'*.fna
for f in $FILES
do
	echo "Processing $f file..."
	spname=$(echo $f | cut -f 8 -d "/" | cut -f 1 -d ".")
	prefix=$(echo $spname | sed 's/-//')
	anvi-script-reformat-fasta $f \
	-o $WD'/HALIEA-GENOMES/'$spname'.fa' \
	--simplify-names --prefix $prefix

	anvi-gen-contigs-database -f $WD'/HALIEA-GENOMES/'$spname'.fa' \
	-o $WD'/HALIEA-DB/'$prefix'.db' -T 12
done

cat $WD'/HALIEA-GENOMES/'*.fa > $WD/HALIEA-GENOMES/haliea-genomes.fa
anvi-gen-contigs-database -f $$WD/HALIEA-GENOMES/haliea-genomes.fa \
                          -o $WD/HALIEA-CONTIGS.db -T 8 -n 'Haliceaceae genomes'

anvi-export-gene-calls -c $WD/HALIEA-CONTIGS.db \
	--gene-caller 'prodigal' \
	-o $WD/gene_calls_summary.txt
