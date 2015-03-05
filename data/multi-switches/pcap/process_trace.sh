#!/bin/sh
# ./combine input.pcap client.txt final.txt

filename=$(basename "$1")
extension="${filename##*.}"
filename="${filename%.*}"

client="client.txt"
server="server.txt"

strings $1 | grep -o '[0-9]\{8\},[0-9],[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}.[0-9]\{6\}' >  $client
#tcpdump -r $1 | awk '{$1=$1$filename print $1 "," $8}' > tmp.txt
tcpdump -r $1 |
awk -v column=1 -v value="$filename" '
    BEGIN {
        FS = OFS = " ";
    }
    {
        for ( i = NF + 1; i > column; i-- ) {
            $i = $(i-1);
        }
        $i = value;
        print $1","$2","$9;
    }
' > $server
paste -d ',' $client $server > $2
rm $client $server 
