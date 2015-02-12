# This code plots the throughput, number of packets
# over the time line.
# load libraries
library("ggplot2")
library("plyr")

args<-commandArgs(TRUE)

data <- data.frame(proto=character(), tmp=numeric(), itf=character(), b_outs=numeric(), b_ins=numeric(), 
		bs=numeric(), pkts=numeric(), role=character(), Mbps=numeric())

for (i in args) {
	d = read.csv(i, sep=';', col.names=c('tmp', 'itf', 
	'b_outs', 'b_ins', 'bs', 'b_in', 'b_out', 
	'pkt_outs', 'pkt_ins', 'pkts', 'pkt_in', 'pkt_out', 
	'err_outs', 'err_ins', 'err_in', 'err_out'))
	
	t = subset(d, itf=='eth0', select=c(tmp,b_outs,b_ins,bs,pkt_ins, pkt_outs, pkts))

	fname <- strsplit(i, "[.]")
	name <- fname[[1]][1]
	proto <- fname[[1]][2]
        t$proto <- proto
	t$role <- name
	t$Mbps <- t$bs*8 / 2^20
	t$b_outs <- t$b_outs*8 / 2^20
	t$b_ins <- t$b_ins*8 / 2^20
	st <- t$tmp[1]
	t$tmp <- t$tmp - st
	data <- rbind(data, t)
	}


pdf("rplot.pdf")

p <- ggplot(data) + coord_cartesian() + scale_y_continuous() + facet_grid(. ~ proto)  + expand_limits(y=0) + xlab("Time")

p + geom_line(aes(x=tmp, y=b_outs, color=role)) + 
ylab("Mbps") + ggtitle("Sending Rate")

p + geom_line(aes(x=tmp, y=b_ins, color=role)) + 
ylab("Mbps") + ggtitle("Receiving Rate")


p + geom_line(aes(x=tmp, y=Mbps, color=role)) + 
ylab("Mbps") + ggtitle("Aggregate Throughput")

p + geom_line(aes(x=tmp, y=pkt_ins, color=role)) + 
ylab("packets") + ggtitle("Packet Receiving Rate")

p + geom_line(aes(x=tmp, y=pkt_outs, color=role)) + 
ylab("packets") + ggtitle("Packet Sending Rate")

p + geom_line(aes(x=tmp, y=pkts, color=role)) + 
ylab("packets") + ggtitle("Aggregate Packet Rate")

dev.off()
