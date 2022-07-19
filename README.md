# bioscripts
not quite oneliners but useful and reusable 


##
### extractfasta
```
usage:
 awk -v reg="chr1" -v from=100 -v to=300 -f extractfasta.awk reffastafile.fa
function:
 extract a sequence from a larger fasta file (a reference), 
 provide the region/chromosome start and stop locations required using awk -v parameters.
notes:
 - use for dotplot etc... 
 - outputs a fasta format to stdout.
```
##
### stat_fas.sh
```
usage:
 bash stat_fas.sh
function:
 get statistics from fasta or fastq sequence data which are gz compressed.
notes:
 - output can be plotted as histogram in plot_stat_fas.R

Sample output for SRR19094308 pacbio hifi WGS of HG002 single cell
```
#####
<details><summary>show Output</summary>
<p>

```ruby
file:   SRR19094308_WGS_of_Hg002_cell_subreads.fastq.gz
max read length:        42183
number of base pairs:   1863081397
N50     10772
at read no:     141468
Total n50 BP:   931544786![Screenshot from 2022-07-19 15-37-36](https://user-images.githubusercontent.com/38674063/179677863-578a0216-e72b-4b49-8088-075f6f1c666f.png)

Total Reads:    205565
Total bp:       1863081397
perCent of reads over N50:      31.2
 ============================== 
Histogram, units =      1000
1       512
2       1763
3       7730
4       13962
5       16971
6       17580
7       18927
8       19036
9       16996
10      16149
11      14928
12      12707
13      11513
14      8177
15      6272
16      5307
17      5143
18      3019
19      2257
20      1765
21      1357
22      958
23      642
24      487
25      441
26      269
27      231
28      142
29      114
30      70
31      52
32      31
33      16
34      13
35      13
36      8
37      2
38      3
42      1
43      1
```

</p>
</details>

### plot_stat_fas.R
```
usage:
 run in R studio, set path to output from stat_fas.sh
function:
 plots histogram of stat_fas.sh output 
 will try to put all data sets in the folder into one plot
notes:
 - outputs pdf, change 'tofile' parameter in R code to output to panel 
 - panel output may not display, get margins too large error. 
```
![sample plot](https://github.com/jo-mc/bioscripts/hist.png)



