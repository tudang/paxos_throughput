#!/bin/sh
# ./combine input.pcap client.txt final.txt
tcpdump -r $1 | awk '{print $1 "," $8}' > tmp.txt
paste -d ',' $2 tmp.txt > latency.txt
rm tmp.txt 
Rscript plot-latency.R latency.txt
open output/latency.pdf
