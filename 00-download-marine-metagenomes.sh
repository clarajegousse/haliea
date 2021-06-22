#!/usr/bin/env bash

cd data/metagenomes
for url in `cat ../ftp-links-for-raw-data-files.txt`
do
    wget $url
done
