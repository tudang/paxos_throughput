# run command
# Rscript plot_client_data.r [input1] [input2] ...
# This code plots the latency figure, value/sec using output from libpaxos
# client. Input file name convention "<replica-number>-*.csv
# load libraries
library("ggplot2")
library("plyr")

# set working directory

args<-commandArgs(TRUE)

df <- data.frame(outstanding=numeric(), pktsize=numeric(), time=numeric(), 
                  latency=numeric(),count=numeric(), mean_lat=numeric(), 
                  replicas=numeric(), Mbps=numeric())

for (i in args) {
  c1 = read.csv(i, col.names=c('outstanding','pktsize','time', 'latency'))
  c1stat <- ddply(c1, c("outstanding", "pktsize", "time"), 
            summarise, count=length(latency), mean_lat=mean(latency)/10^3)
  title <- strsplit(i, "-")
  number <- as.numeric(title[[1]][1])
  c1stat$replicas <- number
  c1stat$Mbps <- c1stat$pktsize * 8 * c1stat$count / 10^6
  df <- rbind(df, c1stat)
}

pdf("fig-latency-client.pdf")
ggplot(data=df, aes(x=factor(replicas), y=mean_lat)) + 
geom_boxplot() + 
xlab("replicas") +
ylab("latency (ms)") +
ggtitle("latency distribution")

ggplot(data=df, aes(x=factor(replicas), y=count)) + 
geom_boxplot() + 
xlab("replicas") +
ylab("value/sec") +
ggtitle("Number of values a client submitting per second")

dev.off()
