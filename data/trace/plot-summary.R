
d <- read.csv(file='summary.csv', sep=" ", header=FALSE, 
                    col.names=c('tput', 'invalid', 'unlearn',  'total'))
d$invalid_per <- d$invalid / d$total * 100
d$unlearn_per <- d$unlearn / d$total * 100
print(summary(d))
print(d)

pdf("disagree-and-indecisive.pdf")
op <- par(mar = c(6.5, 7.5, 2.0, 2.0) + 0.1)
plot(NA, xlim=c(0,1000), ylim=c(0,2.5), xlab='', ylab='',
        yaxp=c(0, 2.5, 10),
        cex.lab=2.0, cex.axis= 1.5)
points(d$tput, d$invalid_per, type='b', pch=3, 
        ylab='',
        xlab='',
        xaxt='n',
        yaxt='n')
points(x=d$tput, y=d$unlearn_per, type='b', pch=8, lty=2, 
        ylab='',
        xlab='',
        xaxt='n',
        yaxt='n')

title(xlab="Learner Throughput (Mbps)",
          ylab="Percentage of Disagreements\n or Indecisions", cex.lab = 2.0, line = 3.5)
    legend('topleft', c("Learners Disagree", "Learners are Indecisive"), lty=1, cex=1.5,
            pch=c(3,8))

dev.off()
