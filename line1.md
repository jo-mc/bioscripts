
folder: /home/a1779913/Documents/repbase_human
file: humrep.refPerLine.txt

format:
 ```bash   {https://www.rubycoloredglasses.com/2013/04/languages-supported-by-github-flavored-markdown/}
 >MER34B
tgtgggagaccagaatatgccaccccaaaatatgcctctttggcataa...........
>UCON63
aattgaaaaaacgcttttactgcacgcagtaattgacattaagtgctg........
>LTR30
tgagaggaggtkccagctgggcttcctgggtcgagtaggggctcagaa.........
>MER117
cagggatggcaaataggtttcatctcatgtgycaactctgatcgattg........
>MER34D
tgaaggagtkaaggatatgccaccccaaaatatgccagattggtatat.........
>PRIMAX_I
aaaaggctgcyraakcttctyctccyycagaagcttmtccttswcctk.........
```

awk '{if(NR%2==0) printf("%s : ",$0); else printf("%s : %s\n",length($0),($0)) }' humrep.refPerLine.txt | sort | less -S
refine:
awk 'BEGIN {aseq=0}  {if (aseq ==1) printf("%s : %s\n",length($0),($0));  if (index($0,">L1") > 0) {printf("%s : ",$0); aseq=1;} else {aseq= 0};  }' humrep.refPerLine.txt | sort -n -r  -k 3 | less -S

```bash
>L1PREC2 : 8145 : ggctggccaagatggccgactagaagcagcta
>L1P_MA2 : 7678 : gaaggcggaacaagatggccgaatagaagmct
>L1PB2c : 6582 : ggggatcatggcggacgggaggcaggactagat
>L1PREC1 : 6460 : ggggcggggccaagatggccaactagaaacag
>L1HS : 6064 : gggaggaggagccaagatggccgaataggaacagc
>L1 : 5403 : gggggaggagccaagatggccgaataggaacagctcc
>L1M4B : 5024 : aaggagtttcacttctggaatggcagcatgagga
>L1M2_5 : 4191 : aggaggggcttcaagatggctgactagaggcat
>L1PA16_5 : 4083 : tttttttcccaagatggcggattagaggctt
>L1M2C_5 : 4038 : ggagagtgatgtcagcaagatggctgactaga
>L1M1_5 : 3834 : aagtggtgattagagggaggcggagcaagatgg
```

GET L1HS:
awk 'BEGIN {aseq=0}  {if (aseq ==1) printf("length:%s source:%s\n%s\n",length($0),FILENAME,($0));  if (index($0,">L1HS") > 0) {printf("%s ",$0); aseq=1;} else {aseq= 0};  }' humrep.refPerLine.txt   > L1HS.fasta
L1HS.fasta:
```bash
>L1HS length:6064 source:humrep.refPerLine.txt
gggaggaggagccaagatggccgaataggaacagctccggtctacagctcc.............
```
GET all L1's in a fasta file separated by 40 "N's":
```bash
  awk 'BEGIN {aseq=0; printf">L1 from repbase\n"}  \
       {if (aseq ==1) printf("%sNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN",($0)); \
       if (index($0,">L1") > 0) { aseq=1;} else {aseq= 0};  }' humrep.refPerLine.txt | sort -n -r  -k 3 > allL1.fasta
```  
refine (to keep size order)
```bash
 awk 'BEGIN {aseq=0; }  {if (aseq ==1) printf("%s %sNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN\n",length($0),($0)); \
 if (index($0,">L1") > 0) {printf("%s ",$0); aseq=1;} else {aseq= 0};  }' humrep.refPerLine.txt | sort -n -r -k 2 | \
 awk '{ header = header $1 ":" $2 " "; fasta = fasta $3; } END {printf(">%s\n%s",header,fasta)}' > allL1.fasta
```

and refine again.  gepard dotplot did not like all info in description line, so outputting order and size to separate file.
also modified seperator form NN to the first 142 base paris of L1HS to show tick marks across boundaries (revers of this did not show)
```bash
awk 'BEGIN {aseq=0; asep="gggaggaggagccaagatggccgaataggaacagctccggtctacagctcccagcgtgagcgacgcagaagacgggtgatttctgcatttccatctgaggtaccgggttcatctcactagggagtgccagacagtgggcgca"; }  \
{if (aseq ==1) printf("%s %s%s\n",length($0),($0),asep);  \
if (index($0,">L1") > 0) {printf("%s ",$0); aseq=1;} else {aseq= 0};  }' humrep.refPerLine.txt | \
sort -n -r -k 2 | \
awk '{ header = header (substr($1,2)) "," $2 " "; fasta = fasta $3; } \
END {printf(">ALL-L1 large to small\n%s\n",fasta); printf("%s",header) > "headerallL1.txt" }' > allL1.fasta
```
