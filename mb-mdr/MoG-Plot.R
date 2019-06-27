# This code takes as argument two files:
# 1) a file containing a list of SNPs and the p-values representing their main effects on a particular disease
# 2) a file containing a list of pair of SNPs and the p-values corresponding to their interaction effects on the same disease
# The code produces a graphic that is a mixture of a manhattan plot (except that it is presented on a circle) and a grail plot.
# This allows to study visually the relation between the main effects and the interactions.

# Libraries (go to the bioconductor website to download the packages needed)
# BiocManager::install("biomaRt")
# BiocManager::install("GenomicFeatures")
# BiocManager::install("GenomicRanges")
# BiocManager::install("SNPlocs.Hsapiens.dbSNP.20120608")

library("SNPlocs.Hsapiens.dbSNP.20120608"); #to get position of the given SNP
library(biomaRt)#for conversion refGene to gene symbol
library("GenomicFeatures") #to construct dabase of the transcripts
library("GenomicRanges") #to use the select command

# Constructing a database of the transcripts/genes based on the human genome version 19
dbTransc_hg19 = makeTxDbFromUCSC(genome="hg19", tablename="knownGene", url="http://genome-mirror.moma.ki.au.dk/")
tx <- transcriptsBy(dbTransc_hg19, "gene") #extract all genes from the database
seqtx <- as.data.frame(seqinfo(tx)) #create a dataframe linking chrom numbers with number of positions
pairsinchromx <- seqtx$seqlength[1:22]
workvect1 <- c(0,pairsinchromx[1:21])

# read the input files of MoG-plot, i.e. the MB-MDR output files of a 1D and 2D analysis
result1D <- "file1.txt"
result2D <- "file2.txt"
result1DTable <- read.table(result1D, skip=3, col.names=c("snp", "t", "p"),stringsAsFactors=FALSE)
result2DTable <- read.table(result2D, skip=3, col.names=c("snp1", "snp2", "t", "p"),stringsAsFactors=FALSE)

# create new colomns containing the positions of the SNPs on their chrom and the chromosome number
fullLoc1D <- rsid2loc(result1DTable$snp)
fullLoc2D1 <- rsid2loc(as.character(result2DTable$snp1))
fullLoc2D2 <- rsid2loc(as.character(result2DTable$snp2))
result1DTable$pos <- fullLoc1D
result2DTable$pos1 <- fullLoc2D1
result2DTable$pos2 <- fullLoc2D2
result1DTable$chrom <- names(fullLoc1D)
result2DTable$chrom1 <- names(fullLoc2D1)
result2DTable$chrom2 <- names(fullLoc2D2)

# create a colomn containing the chrom number as a numeric
result1DTable$chrnum <- as.numeric(gsub("\\D", "", result1DTable$chrom))
result2DTable$chrnum1 <- as.numeric(gsub("\\D", "", result2DTable$chrom1))
result2DTable$chrnum2 <- as.numeric(gsub("\\D", "", result2DTable$chrom2))

# change p-value to -log(10) scale
result1DTable$neglogp <- -1*log10(result1DTable$p)

# create a vector containting the total length from the start of chrom 1 to the start of chrom x
pairsuntilchromx <- vector()
for (i in 1:22){
  pairsuntilchromx[i] <- sum(as.numeric(workvect1[1:i]))
}

# create the PNG file
Sys.setlocale("LC_CTYPE", "C")
png(file="myMogPlot.png",width=800, height=700)
layout(matrix(c(1,2,3,3), 2, 2, byrow = TRUE),widths=c(3,1),heights=c(6,1))
par(mar=c(0,3,2,2)+0.1)

# Calculate the total length equivalent to 360° in the plot
cirLength <- sum(as.numeric(pairsinchromx))

# main circle and axis
cirSize <- 3
scale=3
theta0 <- seq(0,2*pi,length=10000)
x=cirSize*scale*cos(theta0)
y=cirSize*scale*sin(theta0)
plot((cirSize+3)*scale*cos(theta0),(cirSize+3)*scale*sin(theta0),type='n',xlab="",ylab="",axes=FALSE)
axis(1, at=c(cirSize*scale,scale*(cirSize-log10(0.1)),scale*(cirSize-log10(0.01)),scale*(cirSize-log10(0.001))), labels=c("",expression(10^{-1}),expression(10^{-2}),expression(10^{-3})),pos=c(0,0),xlab="p-value")
lines(x,y,lwd=1)
lines((cirSize+1)*scale*cos(theta0),(cirSize+1)*scale*sin(theta0),col="grey",lwd=0.8)
lines((cirSize+2)*scale*cos(theta0),(cirSize+2)*scale*sin(theta0),col="grey",lwd=0.8)
lines((cirSize+3)*scale*cos(theta0),(cirSize+3)*scale*sin(theta0),col="grey",lwd=0.8)
lines((cirSize-log10(0.05))*scale*cos(theta0),(cirSize-log10(0.05))*scale*sin(theta0),col="red")

# circular manhattan plot
chrcolvec <- c("coral","springgreen","firebrick4","turquoise1","orange","purple","yellow3","grey72","peru","green2","magenta","forestgreen","slateblue3","limegreen","palevioletred","yellowgreen","palevioletred4","tan4","skyblue2","grey37","orangered","grey0")
points((result1DTable$neglogp+cirSize)*scale*sin(2*pi*(result1DTable$pos+pairsuntilchromx[result1DTable$chrnum])/cirLength),(result1DTable$neglogp+cirSize)*scale*cos(2*pi*(result1DTable$pos+pairsuntilchromx[result1DTable$chrnum])/cirLength),col=chrcolvec[result1DTable$chrnum],pch=19)

# delimiting the chromosomes
limLine <- seq(cirSize*scale,(cirSize+3)*scale,length=1000)
for (i in 1:22){
  limX = limLine*sin(2*pi*pairsuntilchromx[i]/cirLength)
  limY = limLine*cos(2*pi*pairsuntilchromx[i]/cirLength)
  lines(limX,limY,col="grey",lwd=0.8)
}

# drawing the hyperbolic lines
for (i in 1:length(result2DTable$pos1)) {
  x1=cirSize*scale*sin(2*pi*(result2DTable$pos1[i]+pairsuntilchromx[result2DTable$chrnum1[i]])/cirLength)
  y1=cirSize*scale*cos(2*pi*(result2DTable$pos1[i]+pairsuntilchromx[result2DTable$chrnum1[i]])/cirLength)
  x2=cirSize*scale*sin(2*pi*(result2DTable$pos2[i]+pairsuntilchromx[result2DTable$chrnum2[i]])/cirLength)
  y2=cirSize*scale*cos(2*pi*(result2DTable$pos2[i]+pairsuntilchromx[result2DTable$chrnum2[i]])/cirLength)
  y.prime = (cirSize*scale)^2*(x2/x1 - 1)/(y1*x2/x1 - y2)
  x.prime = ((cirSize*scale)^2-y.prime*y2)/x2
  r.prime = sqrt((x.prime-x1)^2 + (y.prime - y1)^2)
  theta2 = atan2((y2-y.prime)/r.prime,(x2-x.prime)/r.prime)
  theta1 = atan2((y1-y.prime)/r.prime,(x1-x.prime)/r.prime)
  if (theta1<0 && (x1>0 || x2>0)) {theta1=theta1+2*pi}
  if (theta2<0 && (x1>0 || x2>0)) {theta2=theta2+2*pi}
  if (theta1 < theta2) {theta <- seq(theta1,theta2,length=1000)} else {theta <- seq(theta2,theta1,length=1000)}
  x.hypline = x.prime+r.prime*cos(theta)
  y.hypline=y.prime+r.prime*sin(theta)
  if(result2DTable$p[i]<=0.5) { 
    if(result2DTable$p[i]>=0.05) {
      lines(x.hypline,y.hypline,col='red',lwd=round(1-log10(result2DTable$p[i])),lty=2)
    } else {
      lines(x.hypline,y.hypline,col='red',lwd=round(1-log10(result2DTable$p[i])),lty=1)
    }
  }
}

# adding a legend
chrvec <- c("ch1","ch2","ch3","ch4","ch5","ch6","ch7","ch8","ch9","ch10","ch11","ch12","ch13","ch14","ch15","ch16","ch17","ch18","ch19","ch20","ch21","ch22")
plot(18,7,type='n',xlab="",ylab="",axes=FALSE)
for (i in 1:22){
  legend(10,9.5-i/5,col = chrcolvec[i],pch=19,chrvec[i],bty='n',cex=1.5)
}

# add legend underneath the plot of hyperbolic lines, indicating the strength of an epi interaction
critP <- c(0.5,0.1,0.05,0.01,0.005,0.001)
critPtxt <- c("0.5","0.1","0.05","0.01","0.005","0.001")
par(mar=c(0,0,0,0)+0.1)
plot(c(1:100),c(1:100),type='n',xlab="",ylab="",axes=FALSE)
text(20,90,"Interaction",cex=1.5,font=2)
text(21,70,"P-Value",cex=1.5,font=2)

for (i in 1:6) {
  if (critP[i]>=0.05) {
    legend(20+i*8,101,lty=2,lwd=round(1-log10(critP[i])),bty='n',col="red",legend="")
  } else {
    legend(20+i*8,101,lty=1,lwd=round(1-log10(critP[i])),bty='n',col="red",legend="")
  }
  text(22+i*8,70,critPtxt[i],cex=1.5)
}

# saving the file
dev.off()