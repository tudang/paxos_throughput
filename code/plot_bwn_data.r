# This code plots the throughput, number of packets
# over the time line.
# load libraries
library("ggplot2")
library("plyr")

args<-commandArgs(TRUE)

data <- data.frame(tmp=numeric(), itf=character(), b_outs=numeric(), b_ins=numeric(), 
		bs=numeric(), pkts=numeric(), role=character(), Mbps=numeric())

for (i in args) {
	d = read.csv(i, sep=';', col.names=c('tmp', 'itf', 
	'b_outs', 'b_ins', 'bs', 'b_in', 'b_out', 
	'pkt_outs', 'pkt_ins', 'pkts', 'pkt_in', 'pkt_out', 
	'err_outs', 'err_ins', 'err_in', 'err_out'))
	
	t = subset(d, itf=='eth0', select=c(tmp,b_outs,b_ins,bs,pkt_ins, pkt_outs, pkts))

	name <- strsplit(i, "[.]")
	name <- name[[1]][1]
	t$role <- name
	t$Mbps <- t$bs*8 / 2^20
	t$b_outs <- t$b_outs*8 / 2^20
	t$b_ins <- t$b_ins*8 / 2^20
	st <- t$tmp[1]
	t$tmp <- t$tmp - st
	data <- rbind(data, t)
	}


pdf("rplot.pdf")

ggplot(data, aes(x=tmp, y=b_outs, color=role)) + 
coord_cartesian() +
scale_y_continuous() + 
geom_line() + 
expand_limits(y=0) + 
xlab("Time") + ylab("Mbps") + ggtitle("Sending Rate")

ggplot(data, aes(x=tmp, y=b_ins, color=role)) + 
coord_cartesian() +
scale_y_continuous() + 
geom_line() + 
expand_limits(y=0) + 
xlab("Time") + ylab("Mbps") + ggtitle("Receiving Rate")


ggplot(data, aes(x=tmp, y=Mbps, color=role)) + 
coord_cartesian() +
scale_y_continuous() + 
geom_line() + 
expand_limits(y=0) + 
xlab("Time") + ggtitle("Aggregate Throughput")

ggplot(data, aes(x=tmp, y=pkt_ins, color=role)) + 
coord_cartesian() +
scale_y_continuous() + 
geom_line() + xlab("Time") + 
ggtitle("Packet Receiving Rate")

ggplot(data, aes(x=tmp, y=pkt_outs, color=role)) + 
coord_cartesian() +
scale_y_continuous() + 
geom_line() + xlab("Time") + 
ggtitle("Packet Sending Rate")

ggplot(data, aes(x=tmp, y=pkts, color=role)) + 
coord_cartesian() +
scale_y_continuous() + 
geom_line() + xlab("Time") + 
ggtitle("Aggregate Packet Rate")

dev.off()
