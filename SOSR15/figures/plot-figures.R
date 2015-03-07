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
    title(ylab = "Latency (us)", cex.lab = 2.5, line = 4.5)
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
    title(ylab = "Latency (us)", cex.lab = 2.5, line = 4.5)
    box()
dev.off()
}

dir.create(file.path(".", "figures"), showWarnings = FALSE)
plot_broadcast()
plot_max_tput()
plot_netpaxos_tput()
