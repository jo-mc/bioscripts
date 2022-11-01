#!/bin/bash

# interleave two fastq files 
# need to edit script for filenames and fields

# use paste to create one line per four lines of fastq ie one set of read data. For each pair file.
paste  - - - - < fastp1.QAd.fastq > f1.fastq
paste  - - - - < fastp2.QAd.fastq > f2.fastq

# test with subset:
# head -n 40 fastp1.QAd.fastq | paste  - - - - > f1.fastq
# head -n	40 fastp2.QAd.fastq | paste  - - - - > f2.fastq

# interleave files
# use sed to read alternate lines from each output of paste into a single file, interleaving reads.
sed 'R f1.fastq' f2.fastq  > r1r2QAinterleaveTEMP.fastq

# split each read in interleaved file into four lines.

# not format of fastq ID may alter which fields to use! 
awk '{ print substr($1,1,length($1)-2); print $4; print "+"; print $8 }' r1r2QAinterleaveTEMP.fastq > r1r2QAinterleave.fastq
