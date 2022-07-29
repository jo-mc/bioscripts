
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
headerallL1.txt:  (view header info line by line:   awk '{ for (i=1;i<=NF;i++) print $i }' headerallL1.txt | less )
```
L1PREC2,8145 L1P_MA2,7678 L1PB2c,6582 L1PREC1,6460 L1HS,6064 L1,5403 L1M4B,5024 L1M2_5,4191 L1PA16_5,4083 L1M2C_5,4038 L1M1_5,3834 L1MDA_5,3320 L1ME_ORF2,3285 L1M2B_5,3252 L1PBA_5,3104 L1PA12_5,3072 L1MC4,2761 L1M3A_5,2728 L1MCA_5,2647 L1P4a_5end,2596 L1MC4_5end,2555 L1MEC_5,2527 L1M6_5end,2515 L1MB3_5,2500 L1MC3,2487 L1PA13_5,2278 L1M7_5end,2237 L1M2A_5,2233 L1MEf_5end,2217 L1MC5,2174 L1M3DE_5,2137 L1MA9_5,2113 L1MEg_5end,210
```
allL1.fasta
```
>ALL-L1 large to small
ggctggccaagatggccgactagaagcagct..................
```
gepard:
```bash
java -cp /home/a1779913/tools/gepard/Gepard-1.40.jar org.gepard.client.cmdline.CommandLine -seq1 /home/a1779913/Documents/repbase_human/allL1.fasta -seq2 /home/a1779913/Documents/repbase_human/L1HS.fasta -matrix /home/a1779913/tools/gepard/edna.mat -maxwidth 2500  -outfile 1kv1k.png
```
output:
![1kv1k](https://user-images.githubusercontent.com/38674063/181656133-777a3b7e-34d7-49c6-ae76-281f3fee6592.png)

================================================================
now for DFAM L1

get L1 data into per line format:
```bash
awk -v name="L1" -f dfam.awk Dfam.embl | awk '{ if (index($0,"L1") > 0 ) {if (NR>1) {print ""} printf(">%s\n",$0)} else printf("%s",$0);  }' | less -S
```
gets:
```bash
awk -v name="L1" -f dfam.awk Dfam.embl | awk '{ if (index($0,"L1") > 0 ) {if (NR>1) {print ""} printf(">%s\n",$0)} else printf("%s",$0);  }' | awk 'BEGIN {aseq=0; asep="gggaggaggagccaagatggccgaataggaacagctccggtctacagctcccagcgtgagcgacgcagaagacgggtgatttctgcatttccatctgaggtaccgggttcatctcactagggagtgccagacagtgggcgca"; }  \
> {if (aseq ==1) printf("%s %s%s\n",length($0),($0),asep);  \
> if (index($0,">L1") > 0) {printf("%s ",$0); aseq=1;} else {aseq= 0};  }'  | \
> sort -n -r -k 2 | \
> awk '{ header = header (substr($1,2)) "," $2 " "; fasta = fasta $3; } \
> END {printf(">ALL-L1 large to small\n%s\n",fasta); printf("%s",header) > "headerallL1DFAM.txt" }' > allL1DFAM.fasta
```


view header (L1 list)
```bash
 awk '{ for (i=1;i<=NF;i++) print $i }' headerallL1DFAM.txt | less

```
dotpolt dfam vs repbase - bit of a mess...

Now for alu: (not quite right? first line is printed?) 

~/Documents/repbase_human$ awk '{ if (index($0,"Alu") > 0 ) { {if (NR>1) {print ""};} printf("%s\n",$0); } else printf("%s",$0);}'  humsub.ref.txt | less -S
