library('ggplot2')

args<-commandArgs(TRUE)

pdf('plot.pdf')
s = read.csv(args[1], col.names=c('interface', 'throughput', 'lost'))
ggplot(s, aes(x=throughput, y=lost, colour=interface)) + geom_point(aes(group=interface), size=3) 
dev.off()

