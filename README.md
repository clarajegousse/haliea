# haliea

Study of Halieaceae family

# 00 - Setting the stage

## 001 - Downloading the Halieaceaea genomes

001-download-halieaceae-genomes.sh

## 002 - Downloading the TARA Oceans metagenomes

002-retrieve-tara-info-ncbi.sh
002-download-tara-oceans-mg-ena.sh

## 003 - Defining metagenomic sets, setting sample names, and linking those with the raw data

## 004 - Quality-filtering of raw reads

004-qc-raw-reads.sh
004-qc-raw-reads-gen-pbs.sh

# 01 - Mapping metagenomic reads to Halieaceae genomes

## 011 - Generating an anvi'o CONTIGS database

011-gen-anvio-contig-db.sh

## 012 - Estimating distances between isolate genomes based on full-length 16S ribosomal RNA gene sequences

012-ribosomal-rna-genes.sh

## 013 - Inferring functions with COGs

013-inferring-function-cogs.sh

## 014 - Recruitment of metagenomic reads

014-recruitment-mg-reads-bowtie.sh
014-bowtie-pbs-gen.sh
014-samtools-pbs-gen.sh
014-profile-pbs-gen.sh

## 015 - Profiling the mapping results with anvi'o

015-profiling-mapping.sh

## 016 - Generating a merged anvi'o profile

016-gen-merged-profile.sh


## 017 - Generating a genomic collection

017-gen-genomic-collection.sh
