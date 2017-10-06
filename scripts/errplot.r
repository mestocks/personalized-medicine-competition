data.load <- function(err.fname) {
    err.data <- read.table(err.fname, header = FALSE)
    err.data
}

errs <- c(
    "data/wts/mytrain_1085x50x50x50x9-1-1-1-100.err",
    "data/wts/mytrain_1085x100x50x50x9-1-1-1-100.err",
    "data/wts/mytrain_1085x100x50x30x9-1-1-1-100.err",
    "data/wts/mytrain_1085x100x100x9-1-1-1-100.err",
    "data/wts/mytrain_1085x300x50x30x9-1-1-1-100.err",
    "data/wts/mytrain_1085x300x300x9-1-1-1-100.err"
    )

pt.col <- c("steelblue", "goldenrod", "green", "tomato3", "purple", "grey50")

xmax = 2400
ymax = 0.5

xlimit = c(0, xmax)
ylimit = c(0, ymax)

pdf("archerr.pdf")

plot(0, 0, type = 'n', xaxt = 'n', yaxt = 'n', bty = 'n',
     xlim = xlimit, ylim = ylimit,
     xlab = "Epoch number",
     ylab = "Mean squared error")

abline(h = 0.15, lty = 2, col = "grey70", lwd = 1.5)
abline(h = 0.1, lty = 2, col = "grey70", lwd = 1.5)
abline(h = 0.05, lty = 2, col = "grey70", lwd = 1.5)

for (i in 1:length(errs)) {

    err.fname <- errs[i]
    err.data <- data.load(err.fname)
    points(err.data$V1, err.data$V2, col = pt.col[i], cex = 1)
}

axis(1, at = seq(0, xmax, 600))
axis(2, las = 2, at = seq(0, ymax, 0.05))

arch <- c("100,100",
          "300,300",
          "50,50,50",
          "100,50,30",
          "100,50,50",
          "300,50,30")

arch.col <- c("tomato3", "grey50", "steelblue", "green", "goldenrod", "purple")

legend(1700, 0.5, arch, col = arch.col, bty = 'n', pch = 19)

dev.off()
