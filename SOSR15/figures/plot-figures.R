library("bear")
library("Hmisc")

plot_broadcast <- function() {
    dfc = read.csv('csv/input.csv', header=F, col.names=c('proto', 'tput', 'latency'))
    tputs <- dfc$tput
    latencies <- dfc$latency 
    names(tputs) <- dfc$proto 
    names(latencies) <- dfc$proto
    pdf("figures/broadcast-tput.pdf")
    op <- par(mar = c(4, 8, 4, 2) + 0.1)
    barplot(tputs, ylim=c(0,470), cex.lab=2.5, cex.axis=2.0, cex.names=2.0)
    title(ylab = "Throughput (Mbps)", cex.lab = 2.5, line = 4.5)
    box()
    dev.off()
    pdf("figures/broadcast-latency.pdf")
    op <- par(mar = c(4, 8, 4, 2) + 0.1)
    barplot(latencies, ylim=c(0, 2.1), cex.lab=2.5, cex.axis=2.0, cex.names=2.0)
    title(ylab = "Latency (ms)", cex.lab = 2.5, line = 4.5)
    box()
    dev.off()
}

plot_max_tput <- function() {
    net = c(887,888,890)
    plain = c(128.3, 135.86)
    data = c(mean(net), mean(plain))
    names(data) <- c('NetPaxos', 'Basic Paxos')
    pdf('figures/netpaxos-tput.pdf')
    op <- par(mar = c(4, 8, 4, 2) + 0.1)
    barplot(data, ylim=c(0,910), cex.lab=2.5, cex.axis=2.0, cex.names=2.0)
    title(ylab = "Throughput (Mbps)", cex.lab = 2.5, line = 4.5)
    box()
    dev.off()
}

plot_netpaxos_tput <- function() {
    net = read.csv("csv/netpaxos-latency.csv", header=F, col.names=c('latency'))
    reg = read.csv("csv/basicpaxos-latency.csv", header=F, col.names=c('latency'))
    a = mean(net$latency) / 10^3  #convert ms -> us
    b = mean(reg$latency)
    latency <- c(a,b)
    names(latency) <- c('NetPaxos', 'Basic Paxos')
    
    pdf("figures/netpaxos-latency.pdf")
    op <- par(mar = c(4, 8, 4, 2) + 0.1)
    barplot(latency, ylim=c(0,2.1), cex.lab=2.5, cex.axis=2.0, cex.names=2.0)
    title(ylab = "Latency (ms)", cex.lab = 2.5, line = 4.5)
    box()
dev.off()
}

plot_netpaxos_latency <- function() {
    df <- read.csv(file="csv/netpaxos-tput-latency.csv", col.names=c('host','interface', 
                        'size', 'count', 'latency', 'duration', 'throughput', 'lost'))
    #Round throughput to mulplier of hunderds.
    #df$throughput = round(df$throughput / 100) * 100
    df$latency = df$latency / 10^3
    dfc <- summarySE(df, measurevar="latency", groupvars=c("throughput"))
    d = data.frame(
        x=dfc$throughput,
        y=dfc$latency,
        sd=dfc$sd
    )
    pdf('figures/tput-vs-latency.pdf')
    op <- par(mar = c(7, 7, 3.5, 1.5) + 0.1)
    plot(d$x, d$y, type="l", cex.axis = 2.0,
         ylim=c(0,2.2),
         ylab="",
         xlab="" )
    with (
        data = d,
        expr = errbar(x, y, y+sd, y-sd, add=T, pch=0.1, cap=.01)
    )
    title(xlab="Learner Throughput (Mbps)",
          ylab="Latency (ms)", cex.lab = 2.5, line = 4)
    dev.off()
    
    
    dfc <- summarySE(df, measurevar="lost", groupvars=c("throughput"))
    d = data.frame(
        x=dfc$throughput,
        y=dfc$lost,
        sd=dfc$sd
    )
    pdf('figures/tput-vs-loss.pdf')
    op <- par(mar = c(7, 9, 3.5, 1.5) + 0.1)
    plot(d$x, d$y, type="l", cex.axis = 2.0,
         ylab="",
         xlab="" )
    with (
        data = d,
        expr = errbar(x, y, y+sd, y-sd, add=T, pch=0.1, cap=.01)
    )
    title(xlab="Learner Throughput (Mbps)",
          ylab="Percentage of Packet\nLost or Re-ordered",
          cex.lab = 2.5, line = 4)
    dev.off()

}

dir.create(file.path(".", "figures"), showWarnings = FALSE)
plot_broadcast()
plot_max_tput()
plot_netpaxos_tput()
plot_netpaxos_latency()
