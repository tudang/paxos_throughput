# load libraries
library("ggplot2")
library("plyr")

# set working directory
pdf("stat.pdf")
args<-commandArgs(TRUE)
data <- data.frame(tmp=numeric(), itf=character(), b_outs=numeric(), b_ins=numeric(), bs=numeric(), pkts=numeric(), role=character(), Mbps=numeric())
for (i in args) {
d = read.csv(i, sep=';', col.names=c('tmp', 'itf', 'b_outs', 'b_ins', 'bs', 'b_in', 'b_out', 'pkt_outs', 'pkt_ins', 'pkts', 'pkt_in', 'pkt_out', 'err_outs', 'err_ins', 'err_in', 'err_out'))
t = subset(d, itf=='enp1s0', select=c(tmp,b_outs,b_ins,bs,pkts))
t$role <- i
t$Mbps <- t$bs*8 / 2^20
st <- t$tmp[1]
t$tmp <- t$tmp - st
data <- rbind(data, t)
}
head(data)
pdf("rplot.pdf")
ggplot(data, aes(x=tmp, y=Mbps, color=role)) + coord_cartesian() +scale_y_continuous()+ geom_line() + expand_limits(y=0) + xlab("Time") + ggtitle("Network Throughput")
ggplot(data, aes(x=tmp, y=pkts, color=role)) + coord_cartesian() +scale_y_continuous()+ geom_line() + xlab("Time") + ggtitle("Number of Packets")
dev.off()
