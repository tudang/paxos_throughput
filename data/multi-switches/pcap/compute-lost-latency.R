library('ggplot2')
library('plyr')

args <- commandArgs(TRUE)
df <- data.frame(seq=numeric(), cid=numeric(), size=numeric(), 
                    interface=character(), count=numeric(),
                    latency=numeric(), interval=numeric(), throughput=numeric())

data <- read.csv(file=args[1], sep=",", col.names=c('seq','cid', 'send_time', 
                    'interface', 'receive_time', 'size'))
#data$time <- strptime(data$receive_time, "%H:%M:%S")
op <- options(digits.secs=6)
data$send_time <- strptime(data$send_time, "%H:%M:%OS")
data$send_time <- as.POSIXct(data$send_time)
data$receive_time <- strptime(data$receive_time, "%H:%M:%OS")
data$receive_time <- as.POSIXct(data$receive_time)
data$latency <- as.numeric(data$receive_time - data$send_time) * 10^6
duration <- as.numeric(tail(data$receive_time,1) - head(data$send_time,1))

s <- ddply(data, c('interface', 'size'), summarise, count=length(size), 
            latency=mean(latency))

s$latency <- round(s$latency)
s$duration = round(duration,2)
s$throughput = round(s$count * (s$size * 8) / 10^6 / duration)
#df <- rbind(df, s)
s <- subset(s, count > 1)
s$lost = as.numeric(args[2]) * 100 / s$count
print(head(s))
write.table(s, append=T, file="output/summary.csv", sep="," , col.names=F,
       row.names=F, quote=F)


#dir.create(file.path(".", "output"), showWarnings = FALSE)
#pdf('output/latency-tput.pdf')

#ggplot(df, aes(x=interval, y=throughput)) + xlab('Time (s)') + 
#ylab('Throughput (Mbps)') +  geom_line() + geom_point()
#ggplot(df, aes(x=interval, y=latency)) + geom_line() + geom_point() + 
#xlab('Time (s)') + ylab('Latency (ms)')

#dev.off()
