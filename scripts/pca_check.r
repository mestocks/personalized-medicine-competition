pca.pcb <- function(mytrain, mycvs, mytest, a, b) {
    
    mypch <- 20
    mytrain.col <- "grey40"
    mycvs.col <- "tomato3"
    mytest.col <- "steelblue"    

    PCa <- paste("PC", a, sep = "")
    PCb <- paste("PC", b, sep = "")

    xmin <- min(mytrain[, a], mycvs[, a], mytest[, a])
    xmax <- max(mytrain[, a], mycvs[, a], mytest[, a])

    ymin <- min(mytrain[, b], mycvs[, b], mytest[, b])
    ymax <- max(mytrain[, b], mycvs[, b], mytest[, b])

    xlimit <- c(xmin, xmax)
    ylimit <- c(ymin, ymax)
    
    plot(0, 0, type = 'n', bty = 'n', xaxt = 'n', yaxt = 'n', main = "",
         xlim = xlimit, ylim = ylimit, xlab = PCa, ylab = PCb)
    
    points(mytrain[, a], mytrain[, b], pch = mypch, col = mytrain.col)
    points(mycvs[, a], mycvs[, b], pch = mypch, col = mycvs.col)
    points(mytest[, a], mytest[, b], pch = mypch, col = mytest.col)

    axis(1)
    axis(2, las = 2)
}

mytrain <- read.table("data/feat/mytrain.xw", header = FALSE)
mycvs <- read.table("data/feat/mycvs.xw", header = FALSE)
mytest <- read.table("data/feat/mytest.xw", header = FALSE)



png("pca_check.png")

par(mfrow = c(2, 2))

for (i in seq(1, 7, 2)) {
    pca.pcb(mytrain, mycvs, mytest, i, i + 1)
}


dev.off()
