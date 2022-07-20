#! /bin/awk -f

BEGIN {
    gap = 5;  # distance from index to count (allows 1-10000 before no gap)
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
    for (j in v) printf("|%s",v[j][i]);   # for condensed size use  "printf(".%s.",v[j][i])"
    print;
}
}