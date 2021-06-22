#!/usr/bin/env bash

WD=/users/home/cat3/projects/haliea
cd $WD

# get the assembly accession numbers for the cultivated strains according to the DSMZ
cat data/isolates-genomes-taxid.txt | while read -r taxid;
do
  esearch -db genome -query "txid"$taxid"[Organism:exp]" </dev/null |\
    efetch -format docsum |\
    xtract -pattern DocumentSummary \
      -element TaxId,Organism_Name,Assembly_Accession,Status;
  #esearch -db genome -query "txid"$taxid"[Organism:exp]"
done > data/isolates-assemblies-acc.txt

# download the genomes
cat data/isolates-assemblies-acc.txt | cut -f 3 | while read -r acc ; do
  echo $acc
  esearch -db assembly -query $acc </dev/null \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_GenBank \
    | while read -r url ;
      do
      #echo "$url/$fname"
      fname=$(echo $url | grep -o 'GCA_.*' | sed 's/$/_genomic.fna.gz/') ;
      #echo $fname
      wget "$url/$fname"
      spname=$(zcat $fname | grep ">" | head -1 | cut -f 2,3 -d " " | sed 's/\ /-/i')
      #echo $spname
      zcat $fname > data/cultivar-genomes/$spname.fna
      rm -f $fname
    done
done

# clean up
rm -f *.fna.gz; rm -f index.html*

# search for all genome assemblies for the Halieaceae family (taxid 1706372)
esearch -db genome -query "txid1706372[Organism:exp]"  </dev/null  |\
efetch -format docsum |\
xtract -pattern DocumentSummary \
  -element TaxId,Organism_Name,Assembly_Accession,Status  |\
  grep GCA | grep -v Bacteria | cut -f 1 | sort | uniq > data/halieaceae-genomes-taxid.txt

# make sure we keep only taxid that are not cultivated
comm -13 data/isolates-genomes-taxid.txt data/halieaceae-genomes-taxid.txt > data/haliea-genomes-taxid.txt

# get the assembly accession numbers for the cultivated strains according to the DSMZ
cat data/haliea-genomes-taxid.txt | while read -r taxid;
do
  esearch -db genome -query "txid"$taxid"[Organism:exp]" </dev/null |\
    efetch -format docsum |\
    xtract -pattern DocumentSummary \
      -element TaxId,Organism_Name,Assembly_Accession,Status;
  #esearch -db genome -query "txid"$taxid"[Organism:exp]"
done > data/genomes-assemblies-acc.txt

# download the genomes
cat data/genomes-assemblies-acc.txt | cut -f 3 | while read -r acc ; do
  echo $acc
  esearch -db assembly -query $acc </dev/null \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_GenBank \
    | while read -r url ;
      do
      #echo "$url/$fname"
      fname=$(echo $url | grep -o 'GCA_.*' | sed 's/$/_genomic.fna.gz/') ;
      #echo $fname
      wget "$url/$fname"
      spname=$(zcat $fname | grep ">" | head -1 | cut -f 2,3 -d " " | sed 's/\ /-/i')
      #echo $spname
      zcat $fname > data/haliea-genomes/$spname.fna
      rm -f $fname
    done
done

# clean up
rm -f *.fna.gz; rm -f index.html*
