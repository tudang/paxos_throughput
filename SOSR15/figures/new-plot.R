latency_plot <- function() {
    # Define input
    data <- read.csv("exp.dat", header=T)
    net <- data[,c(1,2)]
    net <- na.omit(net)
    
    basic <- data[,c(1,3)]
    basic <- na.omit(basic)
    
    colors <-c('royalblue', 'red')
    
    pdf("figures/tput-vs-latency.pdf")
    par(mar=c(6.5, 7.5, 2.0, 2.0))
    
    yrange <- range(basic$BasicPaxos, net$NetPaxos)
    xrange <- range(net$PPS)
    
    plot(x=basic$PPS, y=basic$BasicPaxos, type="b", 
        lty=1, pch=4,
        xlab="", ylab="", 
        yaxp = c(0,5000,10),
        ylim=yrange, xlim=xrange, 
        cex.axis=1.5, lwd=2)
    title(xlab="Message / Second", ylab="Latency (us)", cex.lab=2.0, line=4)
    par(new=T)
    
    plot(x=net$PPS, y=net$NetPaxos,  type="b", xlab="", ylab="",
         ylim=yrange, axes=F, lty=2, pch=2, lwd=2)
    par(new=F)
    
    legend('topright', c('BasicPaxos', 'NetPaxos'),
        cex=1.5,
        lty=c(1,2),
        pch=c(4,2),
        lwd=2,
    )
    
    dev.off()
}

loss_plot <- function() {
    # Define input
    data <- read.csv("loss.dat", header=T)
    
    colors <-c('royalblue', 'red')
    
    pdf("figures/tput-vs-loss.pdf")
    par(mar=c(6.5, 9.5, 2.0, 2.0))
    
    yrange <- range(data$indecisive, data$disagree)
    xrange <- range(data$pps)
    
    plot(x=data$pps, y=data$indecisive, type="b", 
        lty=1, pch=4,
        xlab="", ylab="", 
        yaxp = c(0, 0.5, 5),
        ylim=yrange, xlim=xrange, 
        cex.axis=1.5, lwd=2)
    title(xlab="Message / Second", ylab="Percentage of Packet\nLost or Reordered", cex.lab=2.0, line=4)
    par(new=T)
    
    plot(x=data$pps, y=data$disagree,  type="b", xlab="", ylab="",
         ylim=yrange, axes=F, lty=2, pch=2, lwd=2)
    par(new=F)
    
    legend('topleft', c('Indecisive', 'Disagree'),
        cex=1.5,
        lty=c(1,2),
        pch=c(4,2),
        lwd=2,
    )
    
    dev.off()
}

latency_plot()
loss_plot()
