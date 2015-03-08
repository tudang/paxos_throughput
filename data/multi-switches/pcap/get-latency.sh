#!/bin/sh
# ./combine input.pcap client.txt final.txt
for var in "$@"
do
DIR=$(dirname "${var}")
filename=$(basename "$var")
extension="${filename##*.}"
filename="${filename%.*}"

client="client.csv"
server="server.csv"

strings $var | grep -o '[0-9]\{8\},[0-9],[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}.[0-9]\{6\}' >  $client
grep ",1," $client > s1.csv
grep ",2," $client > s2.csv
LOST1=$(diff -u s1.csv ${DIR}/client1.csv | grep "[+-][0-9]" | wc -l)
LOST2=$(diff -u s2.csv ${DIR}/client2.csv | grep "[+-][0-9]" | wc -l)
TOTAL_LOST=$[$LOST1 + $LOST2]
tcpdump -r $var |
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
#paste -d ',' $client $server | awk -F, '{print $3","$5","$6}' > "${filename}.csv" 
paste -d ',' $client $server | awk 'length > 50' >  "${filename}.csv"
#Rscript plot-latency.R ${filename}.csv $TOTAL_LOST
Rscript compute-lost-latency.R ${filename}.csv $TOTAL_LOST

rm $client $server s1.csv s2.csv 
mv ${filename}.csv $DIR/${filename}.csv
done
