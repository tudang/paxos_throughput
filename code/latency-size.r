# run command
# Rscript latency-size.r [input1] [input2] ...
# This code uses to plot the latency of a client running the experiments
# while varying the packet-size
# load libraries
library("ggplot2")
library("plyr")

# set working directory
setwd("/Users/hdang/paxos_throughput")

pdf("fig-latency-size.pdf")

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

ggplot(data=df, aes(x=time, y=mean_lat, group=pktsize, colour=factor(pktsize))) + 
geom_line() + 
geom_point() + 
ylab("msec")

dev.off()
