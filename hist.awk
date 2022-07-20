#! /bin/awk -f

BEGIN {
    gap = 5;  # distance from index to count (allows 1-10000 before no gap)
    if (s) {slant=1} else {slant=0}    
}

{
gsub(/[ ]+/," ",$0);
n=split($0,arr,""); 
j=0; 
for (i = 1; i <= n; i++) { 
    if (arr[i] =="\t" || arr[i] ==" ") { 
        for(k=i;k<=j+gap-i;k++) {
            v[NR][k]=" ";
        } 
        j=j+gap-i; 
    } 
    else { 
        j=j+1; 
        v[NR][j] = arr[i];
    }
} 
} 
END {
for (i = 1; i < NR; i++) {
    sz[i] = length(v[i]); 
    if (length(v[i])>vmax) vmax=length(v[i]) 
}; 

for (i in v) { 
    if (length(v[i]) < vmax) { 
        for(k=length(v[i])+1;k<=vmax;k++) {
            v[i][k]=" ";
        }
    } 
} 
for (i=1;i<= vmax;i++)  {

    for (j in v) {
	if (slant) {seP="\\"} else {seP = "|"}
	 if ((j > 1) && (i < gap)) {
		if ( (v[j][i] == v[j-1][i])  || (v[j][i]  == (v[j-1][i])+1) )
		 {if (slant) {seP="\\"} else {seP = "|"}}
		else
		 seP="~"
	  }
	  printf("%s%s",seP,v[j][i]);   # for condensed size use  "printf(".%s.",v[j][i])"
    }
    print;
    if (slant) { for (k=0; k<=(i-1); k++) printf(" ") }
}
}
