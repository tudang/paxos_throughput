# load libraries
library("ggplot2")
library("plyr")

# set working directory
setwd("/Users/hdang/paxos_throughput")
pdf("stat.pdf")
args<-commandArgs(TRUE)
c1 = read.csv(args[1], col.names=c('outstanding','pktsize','time', 'latency'))
summary(c1)
c1stat <- ddply(c1, c("outstanding", "pktsize", "time"), summarise, N=length(latency), lnc_mean = mean(latency))
c1stat$Mbps <- c1stat$pktsize * 8 * c1stat$N / 10^6
ggplot(data=c1stat, aes(x=time, y=Mbps)) + geom_line() 
dev.off()
