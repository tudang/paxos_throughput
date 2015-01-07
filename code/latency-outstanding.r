# run command
# Rscript latency-oustanding.r [input1] [input2]
# This code uses to plot the figure of a client run the experiment with
# variable of number of outstanding. 
# load libraries
library("ggplot2")
library("plyr")

# set working directory
setwd("/Users/hdang/paxos_throughput")

pdf("fig-latency-outstanding.pdf")

args<-commandArgs(TRUE)

df <- data.frame(outstanding=numeric(), pktsize=numeric(), time=numeric(), 
                    latency=numeric(),count=numeric(), mean_lat=numeric(), 
                    client=numeric(), Mbps=numeric())

for (i in args) {
  c1 = read.csv(i, col.names=c('outstanding','pktsize','time', 'latency'))
  c1stat <- ddply(c1, c("outstanding", "pktsize", "time"), 
                summarise, count=length(latency), mean_lat=mean(latency)/10^3)
  c1stat$Mbps <- c1stat$pktsize * 8 * c1stat$count / 10^6
  df <- rbind(df, c1stat)
}

p <- ggplot(data=df, aes(x=time, group=outstanding, colour=factor(outstanding))) 
p + geom_line(aes(y=mean_lat)) + ylab("latency (ms)") + ggtitle("5 learners, pkt-size 8KB")
p + geom_line(aes(y=count)) + ylab("value/sec") + ggtitle("5 learners, pkt-size 8KB")

dev.off()
