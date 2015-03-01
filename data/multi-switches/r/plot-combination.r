library('ggplot2')

args<-commandArgs(TRUE)

pdf('output/plot.pdf')
s = read.csv(args[1], col.names=c('node', 'interface', 'throughput', 'lost'))
ggplot(s, aes(x=throughput, y=lost, shape=node)) + 
geom_point(aes(color=interface)) 
#qplot(throughput, lost, data=s, shape=node, color=interface)
dev.off()

