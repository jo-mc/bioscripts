
# process all fas_stat.sh output from *.gz.dat.  ASSIGN path to setpath for dat files before running.
# setpath <- "./data"   
 setpath <- "./hg002_sra_sc_wgs"

# writing to pdf file then tofile <- TRUE,  to display in plot pane then tofile <- FALSE
# plotting to plot pane may get margins to large error.. and legend may not display correctly.
# should be ok to pfd as scaled to 7x7 inches. (again some may not fit right) 
tofile <- TRUE

if (tofile) {
  pdf(file="master.pdf",width=(4.5+1+7),height=(4.5+7.5+7))
}
# inset of legend seems to be related to height of plot (default 7, with no margin?) 
# p*0.07 seems to work as each plot scales within 7 inches ?????

par(mar=c(4.5,4.5,7.5,1), xpd = TRUE) # set margins c(bottom, left, top, right)
 

flist <- list.files(path=setpath, pattern = ".dat", full.names = TRUE)
p <- length(flist)
par(mfrow=c(p,1))
for (x in 1:p) {
  header <- read.table(flist[x],sep="\n", nrows=10)
  dataseq <- read.delim(flist[x], sep="\t", skip = 10, header = FALSE, comment.char = "#") 
  plot(dataseq$V1,dataseq$V2,type="b",main="",xlab="read length (Kbp)",ylab="count")
  legend('topleft', inset=c(0,-(.07*p)),  bg="transparent", cex=0.75, legend=as.list(header[1:5,]))
  a <- header[6:9,]
  a <- append(a,header[11,],length(a))
  legend('topright', inset=c(0,-(0.07*p)), bg="transparent", cex=0.75, legend=as.list(a))
  #legend('topleft', bg="transparent", cex=1, legend=c("1","2",'3','4'))
  #header[1,1],header[2,1],header[3,1]))
}

# reset margins to default
par(mar=c(5.1,4.1,4.1,2.1))

if (tofile) {
  dev.off()
}
