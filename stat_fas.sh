#!/bin/bash

# NOTE assumes *.gz files in folder are fastq.gz or fasta.gz
# process all files in folder with*.gz, change to *.fasta  or *.fastq as required. OR add a command line parameter to specify
#
# run script iff fodler with sequence files to process $ bash stat_fas.sh
#  creates a temporary file genstat.dat to hold intermediate data
#  ouputs the fasta or fastq.gz statistics file with .gz.dat extension
#

#/ Copyright ©2022 J McConnell  . All rights reserved.
#// Use of this source code is governed by a BSD-style
#// license that can be found in the LICENSE.txt file.

for file in *gz   
  do
    echo $file
    gunzip -c $file | \
    awk '  {if (seq==1) {print length($0); seq=0 } \
           else {ftype = substr($0,1,1); \
           if ((ftype== ">" ) || (ftype== "@")) {seq = 1} } }' \
    | sort -n > genstat.dat; \
    # count how many base pairs and max read length, put into bash variable numBP_gs
    read numBP_gs <<< $(awk '{a=a+$0; if ($0 > m) { m = $0 } } END {print a "," m}' genstat.dat) ; \
    # calculate stats,
    awk -v nbpMaxr="$numBP_gs" -v sFile="$file" \
   'BEGIN { printf("file:\t%s\n",sFile); \
            PROCINFO["sorted_in"] = "@ind_num_asc"; \
            # above to auto sort awk arrays.
            nbp = substr(nbpMaxr,1,index(nbpMaxr,",")-1); \
            maxRead = 1*substr(nbpMaxr,index(nbpMaxr,",")+1); \
            n50= nbp/2;  \
            if (maxRead > 1000000) {adiv = 20000; } else { adiv = 1000; } \
            printf("max read length:\t%s\n",maxRead); \
            printf("number of base pairs:\t%s\n",nbp); } \
            \
          { a = a + $0; \
            if ((a > n50) && (n50found ==0)) \
                { n50found = 1; n50Val=$0; n50Read=NR; n50Cnt = a; } \
                {arr[int(1 + $0/adiv)] = arr[int(1 + $0/adiv)] + 1}; \
            } \
          \
          END { printf("N50\t%s\nat read no:\t%s\nTotal n50 BP:\t%s\n",n50Val,n50Read,n50Cnt); \
          printf("Total Reads:\t%s\nTotal bp:\t%s\nperCent of reads over N50:\t%3.1f\n",NR,a,100*(NR-n50Read)/NR); \
          printf(" ==============================\t\nHistogram, units =\t%s\n",adiv); \
      for (v in arr) printf("%s\t%s\n",v,arr[v]); \
}' genstat.dat  > $file.stat.dat
done

