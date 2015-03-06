library('ggplot2')
library('bear')
library('scales')

args <- commandArgs(TRUE)


df <- read.csv(file=args[1], col.names=c('host','throughput', 'lost'))
dfc <- summarySE(df, measurevar="lost", groupvars=c("throughput"))
print(dfc)
pdf('tput-vs-loss.pdf')
ggplot(dfc, aes(x=throughput,y=lost)) +
    geom_errorbar(aes(ymin=lost-se, ymax=lost+se), width=.1) + 
    geom_line() +
    geom_point() +
    scale_y_continuous(label = percent) + 
    xlab("Receivers' throughput (Mbps)") + 
    ylab("Percentage of message lost and reorder") 
dev.off()
