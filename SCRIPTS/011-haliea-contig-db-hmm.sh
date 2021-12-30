#!/bin/bash
#SBATCH --job-name=haliea-hmm
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=011-haliea-contig-db-hmm.%j.out
#SBATCH --error=011-haliea-contig-db-hmm.%j.err

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# set the number of threads
NUM_THREADS=$(( $(nproc)-2 ))

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/HALIEA-DB

FILES=$WD'/HALIEA-DB/'*.db
echo -e "name\tcontigs_db_path" > external-genomes.txt

for f in $FILES
do
	echo "Processing $f file..."
	#anvi-run-hmms -c $f -I Ribosomal_RNA_16S -T $NUM_THREADS --just-do-it
	#anvi-run-hmms -c $f -I Ribosomal_RNA_23S -T $NUM_THREADS --just-do-it
	#anvi-run-hmms -c $f -I Ribosomal_RNA_5S -T $NUM_THREADS --just-do-it
	#anvi-run-hmms -c $f -I Bacteria_71 -T $NUM_THREADS --just-do-it
	#anvi-run-ncbi-cogs -c $f -T $NUM_THREADS --search-with diamond
	#anvi-run-pfams -c $f -T $NUM_THREADS

	spname=$(basename $f | cut -f 1 -d "." | sed 's/-/_/')
	echo -e """$spname\t$f""" >> external-genomes.txt
done

anvi-get-sequences-for-hmm-hits --external-genomes external-genomes.txt \
                                -o concatenated-proteins.fa \
                                --hmm-source Bacteria_71 \
                                --return-best-hit \
                                --get-aa-sequences \
                                --concatenate

anvi-gen-phylogenomic-tree -f concatenated-proteins.fa -o phylogenomic-tree.txt


anvi-interactive -p phylogenomic-profile.db \
                 -t phylogenomic-tree.txt \
                 --title "Phylogenomics" \
                 --manual
