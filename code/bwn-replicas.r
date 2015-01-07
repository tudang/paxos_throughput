# This code plots the throughput and number of packets
# of a client running the experiments with variable 
# number of learners.

# load libraries
library("ggplot2")
library("plyr")
#library("Hmisc")

args<-commandArgs(TRUE)

data <- data.frame(tmp=numeric(), itf=character(), b_outs=numeric(), b_ins=numeric(), 
		bs=numeric(), pkts=numeric(), replicas=numeric(), role=character(), Mbps=numeric())

for (i in args) {
	d = read.csv(i, sep=';', col.names=c('tmp', 'itf', 
	'b_outs', 'b_ins', 'bs', 'b_in', 'b_out', 
	'pkt_outs', 'pkt_ins', 'pkts', 'pkt_in', 'pkt_out', 
	'err_outs', 'err_ins', 'err_in', 'err_out'))

	t = subset(d, itf=='eth0', select=c(tmp,b_outs,b_ins,bs,pkt_ins, pkt_outs, pkts))
#        mean_t = ddply(d, .(itf), summarise, mean_b_outs = mean(b_outs), mean_b_ins = mean(b_ins),
#                        mean_bs = mean(bs), mean_pkt_ins = mean (pkt_ins), 
#                        mean_pkt_outs = mean(pkt_outs), mean_pkts = mean(pkts))

	title <- strsplit(i, "-")
	number <- as.numeric(title[[1]][1])
	name <- title[[1]][2]
        t$replicas <- number
	t$role <- name
	t$Mbps <- t$bs*8 / 2^20
	t$b_outs <- t$b_outs*8 / 2^20
	t$b_ins <- t$b_ins*8 / 2^20
	st <- t$tmp[1]
	t$tmp <- t$tmp - st
	data <- rbind(data, t)
	}

pdf("ggplot.pdf")
p <- ggplot(data, aes(x=factor(replicas), y=Mbps)) + xlab("replica") + ylab("throughput (Mbps)")


p + aes(colour = role) + stat_summary(fun.data = "mean_cl_boot") + ggtitle("average throughput")

p + geom_point(aes(shape=role, colour=role)) + ggtitle("throughput range")

p + geom_boxplot(aes(fill = role))  + ggtitle("throughput distribution")

q <- ggplot(data, aes(x=factor(replicas))) + xlab("replica") + ylab("count") 

q + geom_point(aes(y=pkt_ins, colour=role)) + ggtitle("Number of packet receiving")
q + geom_point(aes(y=pkt_outs, colour=role)) + ggtitle("Number of packet sending")


dev.off()


.f = function() { 
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

}
