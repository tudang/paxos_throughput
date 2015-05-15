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
    barplot(tputs, ylim=c(0,900), cex.lab=2.5, cex.axis=2.0, cex.names=2.0)
    title(ylab = "Throughput (Mbps)", cex.lab = 2.5, line = 4.5)
    box()
    dev.off()
    pdf("figures/broadcast-latency.pdf")
    op <- par(mar = c(4, 8, 4, 2) + 0.1)
    barplot(latencies, ylim=c(0, 2.9), cex.lab=2.5, cex.axis=2.0, cex.names=2.0)
    title(ylab = "Latency (ms)", cex.lab = 2.5, line = 4.5)
    box()
    dev.off()
}

plot_max_tput <- function() {
    df <- read.csv(file="csv/summary.csv", col.names=c('host', 'size', 'count', 'latency', 
                    'duration', 'throughput', 'lost'))
    df <- subset(df, lost == 0)
    net <- max(df$throughput)
    #net = c(887,888,890)
    plain = c(285.3, 285.1, 273.8225)
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
    df <- read.csv(file="csv/summary.csv", col.names=c('host', 'size', 'count', 'latency', 
                    'duration', 'throughput', 'lost'))
    #net = read.csv("csv/netpaxos-latency.csv", header=F, col.names=c('latency'))
    net = df
    reg = read.csv("csv/basic-latency.csv", header=F, col.names=c('latency'))
    a = mean(net$latency) / 10^3  #convert ms -> us
    b = mean(reg$latency)
    latency <- c(a,b)
    names(latency) <- c('NetPaxos', 'Basic Paxos')
    
    pdf("figures/netpaxos-latency.pdf")
    op <- par(mar = c(4, 8, 4, 2) + 0.1)
    barplot(latency, ylim=c(0,1.1), cex.lab=2.5, cex.axis=2.0, cex.names=2.0) 
    title(ylab = "Latency (ms)", cex.lab = 2.5, line = 4.5)
    box()
dev.off()
}

plot_netpaxos_loss <- function() {
    df <- read.csv(file="csv/summary.csv", col.names=c('host', 'size', 'count', 'latency', 
                    'duration', 'throughput', 'lost'))
    #Round throughput to nearest 50
    df$throughput = 25.0 * floor((df$throughput/25.0)+0.5) 
    df$host <- sub("eth[0-3].[1-4]", "server1", df$host)
    df$host <- sub("eth[0-3].[5-8]", "server2", df$host)
    #Convert latency from us to ms
    df$latency = df$latency / 10^3
    dfc <- summarySE(df, measurevar="latency", groupvars=c("throughput"))
    d = data.frame(
        x=dfc$throughput,
        y=dfc$latency,
        sd=dfc$sd
    )
    #pdf('figures/tput-vs-latency.pdf')
    #op <- par(mar = c(7, 7, 3.5, 1.5) + 0.1)
    #plot(d$x, d$y, type="l", cex.axis = 2.0,
    #     ylim=c(0,3.1),
    #     ylab="",
    #     xlab="" )
    #with (
    #    data = d,
    #    expr = errbar(x, y, y+sd, y-sd, add=T, pch=0.1, cap=.01)
    #)
    #title(xlab="Learner Throughput (Mbps)",
    #      ylab="Latency (ms)", cex.lab = 2.5, line = 4)
    #dev.off()
    
    
    dfc <- summarySE(df, measurevar="lost", groupvars=c("throughput"))
    d = data.frame(
        x=dfc$throughput,
        y=dfc$lost,
        sd=dfc$sd
    )
    pdf('figures/tput-vs-loss.pdf')
    op <- par(mar = c(7, 9, 3.5, 1.5) + 0.1)
    plot(d$x, d$y, type="l", cex.axis = 2.0,
         ylim=c(0,4.1),
         ylab="",
         col='blue',
         lwd=2,
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

plot_basic_netpaxos_latency <- function() {
    df <- data.frame(proto=character(), size=numeric(), throughput=numeric(), latency=numeric() )
    for (i in c("csv/netPaxos.csv", "csv/basicPaxos.csv")) {
    x <- read.csv(file=i, col.names=c('proto', 'size', 'throughput', 'latency'))
    #Convert latency from us to ms
    x$latency = x$latency / 10^3
    df <- rbind(df, x)
    }
    d = subset(df, proto == "NetPaxos" )
    #Round throughput to nearest 50
    d$throughput = 25.0 * floor((d$throughput/25.0)+0.5) 
    pdf('figures/tput-vs-latency.pdf')
    dfc <- summarySE(d, measurevar="latency", groupvars=c("throughput"))
    d = data.frame(
        x=dfc$throughput,
        y=dfc$latency,
        sd=dfc$sd
    )
    op <- par(mar = c(6.5, 7.5, 2.0, 2.0) + 0.1)
    plot(d$x, d$y, type="l", cex.axis = 1.5, cex.lab=2,
         ylim=c(0,3.1),
         xlim=c(0,1000),
         ylab="",
         lty=1,
         lwd=2,
         col='blue',
         xlab="" )
    with (
        data = d,
        expr = errbar(x, y, y+sd, y-sd, add=T, pch=0.1, cap=.01)
    )

    d <- subset(df, proto == "Basic Paxos" )
    #Round throughput to nearest 50
    d$throughput = 15.0 * floor((d$throughput/15.0)+0.5) 
    dfc <- summarySE(d, measurevar="latency", groupvars=c("throughput"))
    d = data.frame(
        x=dfc$throughput,
        y=dfc$latency,
        sd=dfc$sd
    )
    par(new = TRUE)
    plot(d$x, d$y, type="l", cex.axis = 1.5,
         ylim=c(0,3.1),
         xlim=c(0,1000),
         ylab="",
         lty=2,
         lwd=2,
         col='red',
         xaxt='n',
         yaxt='n',
         xlab="" )
    with (
        data = d,
        expr = errbar(x, y, y+sd, y-sd, add=T, pch=0.1, cap=.01)
    )
    

    title(xlab="Learner Throughput (Mbps)",
          ylab="Latency (ms)", cex.lab = 2.0, line = 4)
    legend('topright',
    c("NetPaxos", "Basic Paxos"),
    cex = 1.5,
    lty=c(1,2),
    lwd=2,
    #bty='n', 
    col=c('blue', 'red')
    )
    dev.off()
}
dir.create(file.path(".", "figures"), showWarnings = FALSE)
plot_broadcast()
plot_max_tput()
plot_netpaxos_tput()
plot_netpaxos_loss()
plot_basic_netpaxos_latency()
