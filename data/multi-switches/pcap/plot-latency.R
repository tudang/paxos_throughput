library('ggplot2')
library('plyr')

args <- commandArgs(TRUE)
data <- read.csv(file=args[1], col.names=c('seq','cid', 'stime', 'atime', 'size'))

data$time <- strptime(data$stime, "%H:%M:%S")
op <- options(digits.secs=6)
data$stime <- strptime(data$stime, "%H:%M:%OS")
data$atime <- strptime(data$atime, "%H:%M:%OS")
data$latency <- as.numeric(data$atime - data$stime) * 1000

s <- ddply(data, c('cid', 'time', 'size'), summarise, count=length(size), 
            mean_lat=mean(latency))

duration <- as.numeric(tail(data$atime,1) - head(data$stime,1))

s$interval <- as.numeric(s$time - head(s$time, 1))
s$throughput = s$count * (s$size * 8) / 10^6

dir.create(file.path(".", "output"), showWarnings = FALSE)
pdf('output/tcpdump.pdf')

p <- ggplot(s, aes(x=interval, y=throughput)) + xlab('Time (s)') + ylab('Throughput (Mbps)')
p + geom_line() + geom_point()
ggplot(s, aes(x=interval, y=mean_lat)) + geom_line() + geom_point() + xlab('Time (s)') + ylab('Latency (ms)')
dev.off()
