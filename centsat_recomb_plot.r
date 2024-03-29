library(ggplot2)
library(dplyr)
library(readxl)

# data from here: https://www.ncbi.nlm.nih.gov/assembly/GCA_009914755.4#/st 
chm13 <- read.csv('/home/a1779913/Documents/training/t2t/chm13_chr_size.tsv', sep = "\t", header = FALSE, comment.char = "#")

# from https://www.sciencedirect.com/science/article/pii/S0002929722000659    Familial long-read sequencing increases yield of de novo mutations
haplotype <- read_excel("/home/a1779913/Documents/training/t2t/1-s2.0-S0002929722000659-mmc2.xlsx")


## >>>>>>>>>>>>>>>>>>>>>>>>>>> add centromere indicator line <<<<<<<<<<<<<<<<<<<<<<<<<<<<

aCent <- "grch38"
if (aCent == "chm13") {
centsat <- read.csv("/home/a1779913/Documents/training/t2t/chm13v2.0CenSat-NO_Y.csv", header = TRUE, comment.char = "#")
# data from here: http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=1512978831_3p2DNY0HOJHeRIw4C3RWn2m44yfe&clade=mammal&org=Human&db=hs1&hgta_group=map&hgta_track=hub_3671779_censat&hgta_table=0&hgta_regionType=genome&position=chr9%3A145%2C458%2C455-145%2C495%2C201&hgta_outputType=primaryTable&hgta_outFileName=

# just get start and end not type of repeat within centr omere  chrY edited from csv!
chrGroup <- centsat %>% group_by(chrom) %>%              # dplyr
  summarise(min = min(chromStart[1:which.max(chromStart)]),
            max = max(chromEnd),
            diff = 1 + max(chromEnd) - min(chromStart[1:which.max(chromStart)]))
# build centromere lines
xchm <- c(substr(chrGroup$chrom,4,5))
xchm <- replace(xchm, xchm=="X", 23)
# removed from csv xchmC <- xchmC[xchmC != "Y"]  # http://www.simonqueenborough.info/R/basic/lessons/Subsetting_Vectors.html
xchm <- as.integer(xchm)
xchm <-rep(xchm,times=c(rep(2,length(xchm))))
r <- paste(xchm,"cent",sep="")
hap <- rep("cent",length(xchm))
aAll <- c(rbind(chrGroup$min,chrGroup$max))
mfp <- data.frame(xchm,aAll,r,hap)
centText = "CHM13v2.0"
} else {
# >>>>> GrcH38 
centsat <- read.csv("/home/a1779913/Documents/training/t2t/grch38v2013CenSat_edit_noY.csv", header = TRUE, comment.char = "#")

chrGroup <- centsat %>% group_by(chrom) %>%              # dplyr
  summarise(min = min(chromStart[1:which.max(chromStart)]),
            max = max(chromEnd),
            diff = 1 + max(chromEnd) - min(chromStart[1:which.max(chromStart)]))
# build centromere lines
xchm <- c(substr(chrGroup$chrom,4,5))
xchm <- replace(xchm, xchm=="X", 23)
# removed from csv xchmC <- xchmC[xchmC != "Y"]  # http://www.simonqueenborough.info/R/basic/lessons/Subsetting_Vectors.html
xchm <- as.integer(xchm)
xchm <-rep(xchm,times=c(rep(2,length(xchm))))
r <- paste(xchm,"cent",sep="")
hap <- rep("cent",length(xchm))
aAll <- c(rbind(chrGroup$min,chrGroup$max))
mfp <- data.frame(xchm,aAll,r,hap)
centText = "GRCh38"
}
## >>>>>>>>>>>>>>>>>>>>>>>>>>> add centromere indicator line <<<<<<<<<<<<<<<<<<<<<<<<<<<<


# create per chromosome:
fun <- function (p) {   #https://r-coder.com/lapply-r/#lapply_vs_for_loop
  mf <- p %% 4
  if ((mf == 0)  | (mf == 3)) { 
     p <-"H1" } else {
      p<- "H2"
     }
  # round((p  )/2 +0.1)   #%% 4  + 0.5
}
fun2 <- function (p) {   #https://r-coder.com/lapply-r/#lapply_vs_for_loop
#  mf <- p %% 4
 round((p  )/2 +0.1)   #%% 4  + 0.5
}

chmCount <- nrow(chm13) - 1    # Subject is female no chr Y !!, only use 1-23 of chm13
for (i in 1:chmCount) { 
  aStart <- rbind(subset(haplotype, inherited.homolog=="14455.mo" & resolution=="1000bin" & sample.id=="proband" & seqnames==chm13[i,1], select=c(seqnames,start)))
  aEnd <- rbind(subset(haplotype, inherited.homolog=="14455.mo" & resolution=="1000bin" & sample.id=="proband" & seqnames==chm13[i,1], select=c(seqnames,end)))
  aAll <- c(1,rbind(aStart$start,aEnd$end),chm13[i,2])
  xchm <- rep(i-0.2,length(aAll))
  aIndex <- c(1:length(aAll))
  r <- sapply(aIndex,fun2)
  r <- paste(i,r,sep="")
  hap <- sapply(aIndex,fun)
  hap <- paste("mo.",hap,sep="")
  #xchm <- xchm + r
 # r <- sapply(aIndex,fun)
 mfm <- data.frame(xchm,aAll,r,hap)

# ggplot(mf, aes(x=xchm, y=aAll, group=r)) +
#   geom_line(aes(group = r,size=2, color=hap))
  
 aStart <- subset(haplotype, inherited.homolog=="14455.fa" & resolution=="1000bin" & sample.id=="proband" & seqnames==chm13[i,1], select=c(seqnames,start))
 aEnd <- subset(haplotype, inherited.homolog=="14455.fa" & resolution=="1000bin" & sample.id=="proband" & seqnames==chm13[i,1], select=c(seqnames,end))
 aAll <- c(1,rbind(aStart$start,aEnd$end),chm13[i,2])
 xchm <- rep((i+0.2),length(aAll))
 aIndex <- c(1:length(aAll))
 r <- sapply(aIndex,fun2)
 r <- paste(i,"p",r,sep="")
 hap <- sapply(aIndex,fun)  
 hap <- paste("fa.",hap,sep="")
 mff <- data.frame(xchm,aAll,r,hap)
# if (i == 1) { mfp <- rbind(mfm,mff) } else {    # now cent inits mfm
    mfp <- rbind(mfp,mfm,mff) 
# }
  
}


v <- append(append(1:22,"X"),"Y")
atitle <- paste("chromosome, centromere -",centText,"- and recombination locations",sep="")

ggplot(mfp, aes(x=xchm, y=aAll, group=r)) +
  geom_line(aes(group = r, color=hap),size=2) +
  scale_y_continuous(labels = scales::comma)  + 
  scale_x_continuous(breaks = c(1:24),labels = v) +
  labs(x = "Chromosome") + 
  labs(y = "chromosome position")  +  # centered on centromere")
  labs(title = atitle) + 
  labs(caption = "ref: Familial long-read sequencing increases yield of de novo mutations") +
  scale_colour_manual(values = c("mo.H1" = "sienna1", "mo.H2" = "violetred3", "fa.H1" = "skyblue1", "fa.H2" = "royalblue4", "cent" = "green4"))




#  scale_colour_manual https://stulp.gmw.rug.nl/ggplotworkshop/colours.html
