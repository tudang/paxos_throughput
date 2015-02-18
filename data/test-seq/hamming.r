# run: Rscript hamming.txt all.txt cut.txt

library("ggplot2")

pdf("simple_test.pdf")

args<-commandArgs(TRUE)

df = read.csv(args[1], col.names=c('packetsize','hamming', 'client', 'server', 'lost'))

srv = read.csv(args[2], col.names=c('packetsize','hamming', 'client', 'server', 'lost'))

ggplot(data=srv, aes(x=server)) + geom_line(aes(y=hamming)) + geom_point(aes(y=hamming)) + ylab("hamming distance") + xlab("server throughput (Mbps)") + ggtitle("Stress test with 2 clients and 2 servers")

c <- ggplot(data=df, aes(x=client)) 

c  + geom_line(aes(y=hamming)) + geom_point(aes(y=hamming)) + ylab("hamming distance") + xlab("client throughput (Mbps)") + ggtitle("Stress test with 2 clients and 2 servers")

c + geom_line(aes(y=lost)) + geom_point(aes(y=lost)) + ylab("packet lost %") + xlab("client throughput (Mbps)") + ggtitle("Stress test with 2 clients and 2 servers")

dev.off()
