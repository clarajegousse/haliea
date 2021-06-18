##!/usr/bin/env bash

esearch -db genome -query "txid1132028[Organism:exp]" |\
  efetch -format docsum |\
  xtract -pattern DocumentSummary \
    -element TaxId,Organism_Name,Assembly_Accession,Status

# cat assemblies.txt | cut -f 3 > assemblies_acc.txt
# cat assemblies_acc.txt | while read -r acc ; do esearch -db assembly -query $acc </dev/null \
# | esummary \
# | xtract -pattern DocumentSummary -element FtpPath_GenBank \
# | while read -r url ; do
# fname=$(echo $url | grep -o ’GCA_.*’ | sed ’s/$/_genomic.fna.gz/’) ;
# wget "$url/$fname"
# taxid=$(esearch -db assembly -query $acc </dev/null \
# | esummary \
# | xtract -pattern DocumentSummary -element Taxid)
# echo $taxid
# zcat $fname | sed ’s/>* /|kraken:taxid|’$taxid’ /’ > $acc.fna
# done ; done
# for file in GCA *. fna
# do
# echo $file
# #kraken2-build --add-to-library $file --db $DBNAME
# done
