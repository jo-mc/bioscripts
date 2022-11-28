#!/bin/awk -f

# bin distance   for read-ref across bins of 1000bp from similarity script output
# also bin read length after clip vs read length

BEGIN {
cpos = 0;

  mind =2; maxd = 0; avd = 0;
  minp = 0; maxp = 0; avp = 0;
  minRL = 0; maxRL = 0; avRL =0;
  binIndex = 0;
  dist_sum = 0; readp_sum = 0; readl_sum = 0; SIM_sum = 0;

binSize = 10000;  # default 100,000 for whole chromosomes, or pick smaller if looking at sub region
}

{
if (cpos == 0) { cpos = int($4 /binSize) + 1; minp = 1; minRL = $8}

cbin = int($4 /binSize) + 1

if (cbin > cpos) {
	avd = dist_sum/binIndex;
	avp = readp_sum/binIndex;
        avl = readl_sum/binIndex;
        avSIM = SIM_sum/binIndex;
#	print "pos ", cpos, "binCount: ", binIndex, " distance (av,min,max) ", avd, mind, maxd, " percent unclipped (av,min,max) ", avp, minp, maxp, \
#              " read length av, min, max", avl, minRL,  maxRL 
        printf("pos %s, binCount %s, Distance %.4f min/max  %.3f / %.3f Unclipped  %.4f min/max %.3f / %.3f, Similarity %.4f min/max %.3f / %.3f ReadLen %.0f min/max %.1f / %.1f\n", \
                cpos,binIndex,avd,mind,maxd,avp,minp,maxp,avSIM,minSIM,maxSIM,avl,minRL,maxRL);
	mind =$13; maxd = 0; avd = 0;
	minp = 1; maxp = 0; avp = 0;
        minSIM = $11; maxSIM = 0; avSIM =0;
	minRL = $8; maxRL = 0; avRL =0;
	binIndex = 0;
        dist_sum = 0; readp_sum = 0; readl_sum = 0; SIM_sum = 0;
        cpos = cbin;

# print "minRL init: ", minRL
}

declipLen =  $6
readLen = $8
dist = $13
aSim = $11
lenp = declipLen/readLen

# if (cpos == 2) {printf("dist %s dist_sum %s", dist, dist_sum)}

# if (cpos == 2) {printf("dist %s mind %s\n", dist, mind)}


if (dist != "-") {  # dist = "-" means unmapped read
 binIndex ++;

#  if (cpos == 2) {printf(" index %s \n", binIndex)};

# distance
 if (mind > dist) {mind = dist}
 if (maxd < dist) {maxd = dist}
 dist_sum = dist_sum + dist

# read percentage
 if (minp > lenp) {minp = lenp}
 if (maxp < lenp) {maxp = lenp}
 readp_sum = readp_sum + lenp

# readlength
 if (minRL > readLen) {minRL = readLen}
 if (maxRL < readLen) {maxRL = readLen}
 readl_sum = readl_sum + readLen

# similarity
 if (minSIM > aSim) {minSIM = aSim}
 if (maxSIM < aSim) {maxSIM = aSim}
 SIM_sum = SIM_sum + aSim


#  if (cpos == 2) {printf(" index %s  %s\n", binIndex,dist_sum)};
# if (cpos == 2) {printf(" minRL %s, maxRl %s, sum  %s\n", minRL,maxRL,readl_sum)};
}
}
