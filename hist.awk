#! /bin/awk -f

#
#  Create a text histogram in the terminal from stat_fas.sh output.
#
#  also for any 2 columns of numeric data ? may be edge cases not working? (ignoring header lines begining with non numeric) 
#

#/ Copyright ©2022 J McConnell  . All rights reserved.
#// Use of this source code is governed by a BSD-style
#// license that can be found in the LICENSE.txt file.

# usage:
#  awk -f hist.awk hist.txt 
#  OR: awk -v s=1 -f hist.awk hist.txt  (produce slanted output)
#  OR: awk -v s=2 -f hist.awk hist.txt  (produce "|" delimited output)
#  option: -v x=1 will plot histogram with 2nd highest value as 100% (where highest is much larger tham rest allows histogram resolution of remaining data, highest value will be indicated with "#")

BEGIN {
    gap = 5;  # distance from index to count (allows 1-10000 before no gap)
    if (s==1) {slant=1} else {slant=0}
    if (x) {skipmax=1} else {skipmax=0}
    if (s==2) {sline=1} else {sline=0}
    xindex = 0;
print sline;
print slant;
}

{
if (($1 ~ /^#/) || !($1 ~ /^[0-9]/)) {startl = startl + 1; header = (header $0) "\n";  next;}
# use $1 will trim whitespace in case $0 " 1   100" 
aref[NR] = $1
count = $2
if (count > cmax) cmax = count; else if (count >c2max) c2max=count;  # get second highest count.
acount[NR] = count
elements = elements + 1
# print $0
}

END {
printf("%s\n",header);
#slant = 1
la = length(aref[NR])
spc = " ";
# print "length : ", la
for (j=1;j<=la;j++) {
        for (i=1;i<=elements;i++ ) {
                n = substr(aref[i+startl],j,1)
                if (n) printf("%s",n); else printf(" ");
                if (slant) printf("\\");
                if (sline) printf("|");
        }
	printf("\n");
        if (slant) {for (k1=1;k1<=j;k1++) {printf(" ")}; }
}

# printf("\n")
###########################	 gap indicator:
#if (slant) { for (k1=1;k1<=j;k1++) {printf(" ")};}
printf(" ");
if (slant) printf("\\");
if (sline) printf("|");
for (i=2;i<=elements;i++ ) {
     if (aref[i+startl] <= (aref[i+startl-1] + 1)  ) {printf(".")} else {printf("~")}
     if (slant) printf("\\");
     if (sline) printf("|");
}
if (slant) k1= k1 +1;
printf("\n")
###########################

lc = length(cmax)
if (slant) { for (k1=1;k1<=j;k1++) {printf(" ")};}
for (j=1;j<=lc;j++) {
        for (i=1;i<=elements;i++  ) {
                n = substr(acount[i+startl],j,1)
                if (n) printf("%s",n); else printf(" ");
                if (slant) printf("\\");
                if (sline) printf("|");
        }
	printf("\n");
        if (slant) {for (k2=1;k2<=j+k1-1;k2++) {printf(" ")}; }
}

#for (i=1;i<=elements;i++  ) {
#     percent = int(10*acount[i+startl]/cmax);
#     printf(" val: %s, percent %s, int %s\n",acount[i+start],100*acount[i+start]/cmax,percent);
#}

printf("\n");
if (slant) {for (k2=1;k2<=j+k1-1;k2++) {printf(" ")};}

for (j=1;j<=10;j++){
  for (i=1;i<=elements;i++  ) {
        if (skipmax) {percent = int(10*acount[i+startl]/c2max);} else {percent = int(10*acount[i+startl]/cmax);}
        if (percent > 10) printf("#"); else
        if (percent >= j) printf("*"); else printf(" ");
        if (slant) printf("\\");
                if (sline) printf("|");
  }
  printf("\n");
  if (slant) {for (k3=1;k3<=j+k2-1;k3++) {printf(" ")};}
}

 print "index max ", $1, " count max ", cmax, " count c2max (2nd highest) : ", c2max,  " elements: ", elements
 if (skipmax) {print " plotted relative to 2nd highest count. (max count (#) truncated)" }
}

