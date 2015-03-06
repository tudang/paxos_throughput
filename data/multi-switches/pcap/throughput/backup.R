library('ggplot2')
library('plyr')
library('scales')

args <- commandArgs(TRUE)


data <- read.csv(file=args[1], col.names=c('host','throughput', 'lost'))

pdf('tput-vs-loss.pdf')
ggplot(data, aes(x=factor(throughput),y=lost)) +  
geom_boxplot() + stat_summary(fun.y=mean, colour="darkred", geom="point", 
                                shape=18, size=3,show_guide = FALSE) +
scale_y_continuous(labels = percent) +
theme(axis.line = element_line(colour = "black")) + 
xlab("Receiver's Throughput (Mbps)") + ylab("Message Lost")

dev.off()
