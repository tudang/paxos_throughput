library('ggplot2')
library('plyr')

args <- commandArgs(TRUE)
df <- data.frame(seq=numeric(), cid=numeric(), size=numeric(), interface=character(), count=numeric(),
                        latency=numeric(), interval=numeric(), throughput=numeric())

for (i in args) {

    data <- read.csv(file=i, col.names=c('seq','cid', 'send_time', 'interface', 'receive_time', 'size'))
    
    data$time <- strptime(data$send_time, "%H:%M:%S")
    op <- options(digits.secs=6)
    data$send_time <- strptime(data$send_time, "%H:%M:%OS")
    data$receive_time <- strptime(data$receive_time, "%H:%M:%OS")
    data$latency <- as.numeric(data$receive_time - data$send_time) * 1000
    
    s <- ddply(data, c('cid', 'time', 'size', 'interface'), summarise, count=length(size), 
                latency=mean(latency))
    
    duration <- as.numeric(tail(data$receive_time,1) - head(data$send_time,1))
    
    s$interval <- as.numeric(s$time - head(s$time, 1))
    s$throughput = s$count * (s$size * 8) / 10^6
    
    df <- rbind(df, s)
}
dir.create(file.path(".", "output"), showWarnings = FALSE)
pdf('output/tcpdump.pdf')

ggplot(df, aes(x=interval, y=throughput, color=interface)) + xlab('Time (s)') + ylab('Throughput (Mbps)') +  geom_line() + geom_point()
ggplot(df, aes(x=interval, y=latency, color=interface)) + geom_line() + geom_point() + xlab('Time (s)') + ylab('Latency (ms)')

dev.off()
