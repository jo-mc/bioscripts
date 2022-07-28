#! /bin/awk -f

# awk -v reg="chr1" -v from=100 -v to=300 -f extractfasta.awk reffastafile.fa
#
# extract a sequence from a larger fasta file (a reference), provide the region/chromosome start and stop locations required.
#
# use for dotplot etc... outputs a fasta format to stdout.

BEGIN {
nR=1; 
c=0; 
s=from; 
e=to; 
chr=reg;
ans="";
if (s== 0 || e == 0 || chr == 0) {
 print " enter variables to run: awk -v reg=""chr1"" -v from=100 -v to=300 -f extractfasta.awk fastafile.fa"
}
}  

{
  #  print "----" $0
if (substr($0,1,1) == ">") { 
    if (substr($0,1,(length(chr)+1)) == ">" chr) { 
        inReg =1; 
        next;
        #print $0 
    } else { 
        inReg = 0 
    }
}
if (inReg ==1) {
    l = length($0); 
    st=1;
    en = l;
    a=c+1; 
    b=c+l; 
    if (nR==1) # looking for start
    {
        if((s>=a) && (s<=b)) {
            nR=2; 
            st=s-a+1;
            en=l-st+1;  # could be updated in nR=2
        }
    }
    if (nR==2) {
            if(e<=b) {
                en=e-a+2-st;
                ans=ans substr($0,st,en); 
                exit
            } 
            else {
                ans=ans substr($0,st,en)}  
            } 
  #  print a,b,l,(b-a),$0; 
    c = l+c; 
} 
}

END {
print "> " reg ":" s "-" e " " FILENAME
print ans
}
