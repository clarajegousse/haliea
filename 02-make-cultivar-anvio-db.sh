# ----- CREATE ANVIO DB -----
conda activate anvio-master

CULTIVAR="data/cultivar-genomes/*.fna"
for f in $CULTIVAR
do
  echo "Processing $f file..."
  spname=$(echo $f | cut -f 3 -d "/" | cut -f 1 -d ".")
  anvi-script-reformat-fasta $f \
    -o data/cultivar-genomes/$spname.fa \
    --simplify-names

  anvi-gen-contigs-database -f data/cultivar-genomes/$spname.fa \
  -o data/cultivar-genomes/$spname.db
  # take action on each file. $f store current file name
  #cat "$f"
done
