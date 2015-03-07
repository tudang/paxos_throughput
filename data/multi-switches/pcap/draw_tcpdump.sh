#!/bin/sh
# ./combine input.pcap client.txt final.txt

for var in "$@"
do
    filename=$(basename "$var")
    extension="${filename##*.}"
    filename="${filename%.*}"
    #sh process_trace.sh $var 
    sh check-loss-clients.sh $var 1
done

#Rscript plot-latency.R *.csv
rm *.csv
#open output/tcpdump.pdf
