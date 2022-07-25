#! /bin/awk -f

BEGIN {
    gap = 5;  # distance from index to count (allows 1-10000 before no gap)
    if (s) {slant=1} else {slant=0}    
    xindex = 0;
}

{
if (($0 ~ /^#/) || !($0 ~ /^[0-9]/)) {startl = startl + 1; header = (header $0) "\n";  next;}
aref[NR] = $1
count = $2
if (count > cmax) cmax = count;
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
        }
        printf("\n");
        if (slant) {for (k1=1;k1<=j;k1++) {printf(" ")}; }
}

# printf("\n")
###########################      gap indicator:
#if (slant) { for (k1=1;k1<=j;k1++) {printf(" ")};}
printf(" ");
if (slant) printf("\\");
for (i=2;i<=elements;i++ ) {
     if (aref[i+startl] <= (aref[i+startl-1] + 1)  ) {printf(".")} else {printf("~")} 
     if (slant) printf("\\");
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
        percent = int(10*acount[i+startl]/cmax);
        if (percent >= j) printf("*"); else printf(" ");
        if (slant) printf("\\");
  }
  printf("\n");
  if (slant) {for (k3=1;k3<=j+k2-1;k3++) {printf(" ")};}
}

# print "index max ", $1, " count max ", cmax, " elements: ", elements
}
