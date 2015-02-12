# run command
# Rscript convert.R [input-file] [output-file]

args<-commandArgs(TRUE)

c1 = read.csv(args[1], col.names=c('outstanding','pktsize','time','latency'))
c1$time <- floor(c1$time / 10^6)
write.table(c1, file=args[2], sep=',', quote=FALSE, row.names=FALSE, col.names=FALSE)
