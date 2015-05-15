latency_plot <- function() {
    # Define input
    data <- read.csv("exp.dat", header=T)
    net <- data[,c(1,2)]
    net <- na.omit(net)
    
    basic <- data[,c(1,3)]
    basic <- na.omit(basic)
    
    colors <-c('darkslateblue', 'forestgreen')
    
    pdf("figures/tput-vs-latency.pdf")
    par(mar=c(6.5, 7.5, 2.0, 2.0))
    
    yrange <- range(basic$BasicPaxos, net$NetPaxos)
    xrange <- range(net$PPS)
    
    plot(x=basic$PPS, y=basic$BasicPaxos, type="b", 
        lty=1, pch=4,
        xlab="", ylab="", 
        col=colors[1],
        yaxp = c(0,5000,10),
        ylim=yrange, xlim=xrange, 
        cex.axis=1.5, lwd=3)
    title(xlab="Messages / Second", ylab="Latency (us)", cex.lab=2.0, line=4)
    par(new=T)
    
    plot(x=net$PPS, y=net$NetPaxos,  type="b", xlab="", ylab="",
        col=colors[2],
         ylim=yrange, axes=F, lty=2, pch=2, lwd=3)
    par(new=F)
    
    legend('topright', c('BasicPaxos', 'NetPaxos'),
        cex=1.5,
        lty=c(1,2),
        col=colors,
        pch=c(4,2),
        lwd=3,
    )
    
    dev.off()
}

loss_plot <- function() {
    # Define input
    data <- read.csv("loss.dat", header=T)
    
    colors <-c('royalblue', 'red')
    ptype <- c(3,0)
    pdf("figures/tput-vs-loss.pdf")
    par(mar=c(6.5, 9.5, 2.0, 2.0))
    
    yrange <- range(data$indecisive, data$disagree)
    xrange <- range(data$pps)
    
    plot(x=data$pps, y=data$indecisive, type="b", 
        lty=1, pch=ptype[1],
        xlab="", ylab="", 
        yaxp = c(0, 0.5, 5),
        col=colors[1],
        ylim=yrange, xlim=xrange, 
        cex.axis=1.5, lwd=3)
    title(xlab="Messages / Second", ylab="Percentage of Packet\nLost or Reordered", cex.lab=2.0, line=4)
    par(new=T)
    
    plot(x=data$pps, y=data$disagree,  type="b", xlab="", ylab="",
        col=colors[2],
         ylim=yrange, axes=F, lty=2, pch=ptype[2], lwd=3)
    par(new=F)
    
    legend('topleft', c('Indecisive', 'Disagree'),
        cex=1.5,
        lty=c(1,2),
        pch=ptype,
        lwd=3,
        col=colors
    )
    
    dev.off()
}

latency_plot()
loss_plot()
