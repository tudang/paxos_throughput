library("ggplot2")

s = read.csv('single.txt', col.names=c('interface', 'bandwidth', 'lost'))

c = read.csv('multicast.txt', col.names=c('interface', 'bandwidth', 'lost'))

pdf('plot.pdf')

ggplot(s, aes(x=bandwidth, y=lost, colour=interface)) + 
geom_line(aes(group=interface)) + geom_point() + ggtitle("unicast")

ggplot(c, aes(x=bandwidth, y=lost, colour=interface)) + 
geom_line(aes(group=interface)) + geom_point() + ggtitle("multicast")

dev.off()
