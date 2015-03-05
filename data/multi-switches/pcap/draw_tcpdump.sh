#!/bin/sh
# ./combine input.pcap client.txt final.txt

for var in "$@"
do
    filename=$(basename "$var")
    extension="${filename##*.}"
    filename="${filename%.*}"
    outfile="$filename.csv"
    sh process_trace.sh $var $outfile
    echo "Output to $outfile"
done

Rscript plot-latency.R *.csv
open output/tcpdump.pdf
