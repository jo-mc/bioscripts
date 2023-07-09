#!/bin/awk -f

# like sim but more infor and compact output form.

# generate similarity/distance scores for bam files (with MD tag)
# Jukes-Cantor Distance
# gap = 1 + 0.2*(gap-1)   ie gap of 1 = 1 gap of 2 = 1.2,  gap can be insert or delete.
# similarity:  S = matches / (positions_scored + gaps * gap_penalty)

#  positions scored = length of aligned read LESS any soft or hard clips  (no penalty for clips has been added)
#  matches = mismatchs between aligned part of read (ie cigar M ) and reference. (or X and = if in cigar)

BEGIN {
printf("ID flag chr pos MQ len readlen nm similarity distance AS\n")
}
{
# print $0;
printf("%s %s %s %s %s ",$1,$2,$3,$4,$5)

cigA = $6;

if ((cigA == "*") || ($10 == "*")) { skipAlign = 1 } else { skipAlign = 0 }    # $10 = "*"  secondary alignmetn no dna data - in primary 

if (skipAlign == 0)   {   

regex =  "[[:upper:]=]+";
n=split(cigA, arr, regex);   # arr will be array of numbers from CIGAR [72,12,1,37,1...]   # hmm need to check this? samtools should do some checking of sam file integrity? 
regex =  "[[:digit:]]+";
m=split(cigA, brr, regex);   # brr will be array of letters form CIGAR ["",S,M,D,M...]  will have empty letter in first position, from split function.

m=0; mC=0; ins=0; del=0; insC=0; delC=0; s=0; sC = 0; h=0; hC=0; eq=0; eqC = 0;  xx=0; xxC=0;
affine_penalty = 0.2;  delpr = 0; inspr = 0; AS = 0;

for ( i=1; i<n; i++ ) {
      # works:   print "--------------- " arr[i] ":" brr[i+1]
        len = arr[i]
        switch( brr[i+1] ) {
        case "M" : m = m + 1; mC = mC +  len; break;
        case "=" : eq++; eqC=eqC+len; break;
        case "X" : xx++; xxC=xxC + len; break;
        case "D" : del++; delC = delC + len; if (len > 1) {delpr = delpr + affine_penalty *(len-1)}  break;  # affine gap  1 + 0.2 * everay additial del in cur del
        case "I" : ins++; insC = insC + len;  if (len > 1) {inspr = inspr + affine_penalty *(len-1)}  break;
        case "N" : 	break;
        case "P" : 	break;
        case "S" : s++; sC = sC + len; break;
        case "H" : h++; hC = hC + len; break;

        default:
                break;
        }
}
#print "_______________________"
#print "s: " s "  h: " h " length $10 " length($10) " nm: " substr($12,6);

len = length($10) - sC;  ( was -sC-hC)
nm = substr($12,6);
AS =  substr($14,6);
matches = len - (nm - delC);
gaps = delC + insC;
gap_penalty = 1;
# old calc:  similarity = matches / (len + gaps * gap_penalty);
similarity = matches / (len + del + ins + delpr + inspr);
distance =  -0.75* log(1-(1-similarity)/0.75);    # jukes-cantor distance NO? similarity has to be >  0.25 else err (shoulud be o k for alingment but prob better to check

# REDO CALCS
alignLength = length($10) - sC;
reflen = mC + delC + xxC + eqC;  # Depending on cigar coding either mC will be 0 or xxC and eqC will be zero
mismatch = nm - insC - delC;
matches = alignLength - insC - mismatch; # or will also equal eqC if cigar string uses X and =. But this will cover both cigar versions.

similarity = matches / ( alignLength + del + ins + delpr + inspr);
if (similarity > 0.25) {
	distance =  -0.75* log(1-(1-similarity)/0.75);   # similarity has to be >  0.25 else err (should be o k for alingment but prob better to check)
} else {
	distance = 1
}

# printf("\nMcount: %s EQ count %s Xcount %s delCount %s insCount %s softCount %s hardCount %s \n ",m,eq,xx,del,ins,s,h);

# print "len: " len

# print  "matches: " matches
# print  "distance: " distance

# affineP = sprintf(" gaps (d/i): %s/%s affine penalties (d/i): %s/%s  total gap penalty:%s linear penalty(gap-penalty=1):%s ",del,ins,delpr,inspr,(del + ins + delpr + inspr),(gaps * gap_penalty));
# printf("len:%s readlen:%s nm:%s similarity:%s distance:%s cig:%s %s affine:%s\n",alignLength,length($10),nm,similarity,distance,$6,$13,affineP)

# printf("len: %s readlen: %s nm: %s similarity: %s distance: %s AS: %s \n",alignLength,length($10),nm,similarity,distance,AS)
printf("%s %s %s %s %s %s\n",alignLength,length($10),nm,similarity,distance,AS)
}
else
{
printf("len: %s readlen: %s nm:- similarity:- distance: -   AS: %s\n",alignLength,length($10),AS)
}

}
