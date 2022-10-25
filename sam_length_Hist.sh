#!/bin/bash

# Get lengths from SAM/BAM and create a histogram dat file (yourfile.sam.dat) or will use pipe output if "|" present (ie to less)
# run: "bash sam_length_Hist.sh your.sam"   (or your.bam)

# Was a file supplied as variable? (is it a bam/sam - NOT checked)
if [[ $# -ne 1 ]]; then
    echo " : supply a bam / sam file to calculate histogram of lengths. (only primary reads analysed ie -F 4079)" >&2
    exit 2
fi

# Does the supporting awk script exist?
if [ ! -f "../../genericScripts/stratify.awk" ]; then
      echo " stratify.awk not found, required for operation."
fi

# COMMENT: check samtools loaded!
command -v samtools >/dev/null 2>&1 || { echo >&2 "------ Is samtools loaded? error running samtools, exiting."; exit 1; }

# IF piping then do not write to file
if [ -t 1 ] ; then outPut=afile;  fi;  # if output is not piped, if outPut <> afile then do not write to file
# nopipe_out will be set to terminal if the script output is not being sent to a pipe.

samtools view -F 4079 $1  \
    | awk '{ print length($10) }' | sort -n | \
    awk '{ m = (10^(length($1)-1)); a = $1/m; print(int(a)*m) }' | \
if [ "$outPut" == "afile" ]; then
    uniq -c > $1.dat
else
    uniq -c
fi


# TEST awk:
# echo "2435" | awk '{  m = 10^(length($1)-1); print m; a = $1/m; print a; p = int(a)*m; print p }'
