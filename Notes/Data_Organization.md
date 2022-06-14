#Data Organization
---
Peter Fiorica
10 June 2022
---

#Introduction
This document serves as notes to help explain to organization of RRBS files on CCR.

#Working Directory:
`pwd`
```
/projects/rpci/joyceohm/RQ020887/RQ020887-Ohm_RRBS/output/bismark
```

Within this directory, there are 22 folders that I imagine represent corresponding samples.

If I open one of these folders the directory list is as follows:
```
total 55G
-rw-rw-r-- 1 lsmatott grp-songliu 485M Oct 21  2021 CHG_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz
-rw-rw-r-- 1 lsmatott grp-songliu 484M Oct 21  2021 CHG_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz
-rw-rw-r-- 1 lsmatott grp-songliu 858M Oct 21  2021 CHH_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz
-rw-rw-r-- 1 lsmatott grp-songliu 858M Oct 21  2021 CHH_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz
-rw-rw-r-- 1 lsmatott grp-songliu 351M Oct 21  2021 CpG_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz
-rw-rw-r-- 1 lsmatott grp-songliu 350M Oct 21  2021 CpG_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz
-rw-rw-r-- 1 lsmatott grp-songliu 2.1K Oct 21  2021 RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_PE_report.txt
-rw-rw-r-- 1 lsmatott grp-songliu  23G Oct 21  2021 RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam
-rw-rw-r-- 1 lsmatott grp-songliu  22G Oct 21  2021 RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam_stripped.sam
-rw-rw-r-- 1 lsmatott grp-songliu  142 Oct 21  2021 RS-03684228_nudup.sam_dup_log.txt
-rw-rw-r-- 1 lsmatott grp-songliu 4.3G Oct 21  2021 RS-03684228_nudup.sam.resorted.dedup.bam
-rw-rw-r-- 1 lsmatott grp-songliu  57M Oct 21  2021 RS-03684228_nudup.sam.resorted.dedup.bedGraph.gz
-rw-rw-r-- 1 lsmatott grp-songliu  56M Oct 21  2021 RS-03684228_nudup.sam.resorted.dedup.bismark.cov.gz
-rw-rw-r-- 1 lsmatott grp-songliu  17K Oct 21  2021 RS-03684228_nudup.sam.resorted.dedup.M-bias.txt
-rw-rw-r-- 1 lsmatott grp-songliu  863 Oct 21  2021 RS-03684228_nudup.sam.resorted.dedup_splitting_report.txt
-rw-rw-r-- 1 lsmatott grp-songliu 1.9G Oct 21  2021 RS-03684228_nudup.sam.sorted.dedup.bam
-rw-rw-r-- 1 lsmatott grp-songliu 2.1G Oct 21  2021 RS-03684228_nudup.sam.sorted.markdup.bam
```

For someone who is unfamiliar with linux command line, I showed this output using a simple: `ll -h` command.  Additionally, `-rw-rw-r--` shows the read/write privileges for these documents. `lsmatott` is the user who wrote these files. `grp-songliu` is the group CCR account with which they work. `485M` Is the file size. `Oct 21  2021` is when the file was written. `CHG_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz` is the file name. I will start from the top of the list and work my way down for navigating what these files are. 


## Methylation Extraction Results:
Key: https://github.com/FelixKrueger/Bismark/tree/master/Docs#iv-bismark-methylation-extractor

Files:
```
CHG_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz
CHG_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz
CHH_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz
CHH_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz
CpG_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz
CpG_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz
```

These are files generated from `bismark_methylation_extractor`. The inside of the files all look like:
```
Bismark methylation extractor version v0.22.3
A00453:238:HHNCTDRXY:1:1101:1000:1157   -       chr21   42567058        x
A00453:238:HHNCTDRXY:1:1101:1000:1157   -       chr21   42567015        x
A00453:238:HHNCTDRXY:1:1101:1000:1157   -       chr21   42567010        x
A00453:238:HHNCTDRXY:1:1101:1000:1157   -       chr21   42567003        x
```
Where the column headers are not labeled, but each column is:
```
seq-ID          methylation state           chromosome  `start position`    `methylation call`
```

## `RS-03684228_nudup.sam.resorted.dedup_splitting_report.txt`
```
RS-03684228_nudup.sam.resorted.dedup.bam
Parameters used to extract methylation information:
Bismark Extractor Version: v0.22.3
Bismark result file: paired-end (SAM format)
Output specified: strand-specific (default)
No overlapping methylation calls specified
Processed 24271287 lines in total
Total number of methylation call strings processed: 48542574
Final Cytosine Methylation Report
=================================
Total number of C's analysed:   775160522
Total methylated C's in CpG context:    50811678
Total methylated C's in CHG context:    1211324
Total methylated C's in CHH context:    1849793
Total C to T conversions in CpG context:        71447176
Total C to T conversions in CHG context:        204978329
Total C to T conversions in CHH context:        444862222
C methylated in CpG context:    41.6%
C methylated in CHG context:    0.6%
C methylated in CHH context:    0.4%
```

## `RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_PE_report.txt`
This file is the log file for the bismark alignment run.

The file starts with:
```
Bismark report for: ../output/trim/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed.fq.gz and ../output/trim/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R3_001_val_2.fq_t
rimmed.fq.gz (version: v0.22.3)
Bismark was run with Bowtie 2 against the bisulfite genome of /rpcc/bioinformatics/reference/GRCh38_bismark/ with the specified options: -q --score-min L,0,-0.2 --ignore-quals --no-mixed --no-discordant --dovetail --maxins 500
Option '--directional' specified (default mode): alignments to complementary strands (CTOT, CTOB) were ignored (i.e. not performed)
```
## `RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam`
This file is the bismark alignment file. As we can see, it is very large. more details on these files can be found at `rrbs_README.md` and the [bismark user guide](https://github.com/FelixKrueger/Bismark/tree/master/Docs).

The above bismark files (`RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_PE_report.txt` and `RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam`)help us learn the following:

* We are working with what looks like paired-end reads:
    * `RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed.fq.gz`
    * `RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R3_001_val_2.fq_trimmed.fq.gz`
    
* Reference genome folder for alignment: `/rpcc/bioinformatics/reference/GRCh38_bismark/`

* Flags:
  `-q`: Input files are fastQ files
  `--score-min L,0,-0.2`:
  `--ignore-quals`: always consider the quality value at the mismatched position to be the highest possible
  `--no-mixed`:  disables Bowtie 2's behavior to try to find alignments for the individual mates if it cannot find a concordant or discordant alignment for a pair
  `--no-discordant`: disables Bowtie 2's search of discordant alignments if it cannot find any concordant alignments
  `--dovetail`
  `--maxins 500`: specifies the maximum insert size for valid paired-end alignments (Default)
  `--directional`: we have directional read information

## `RS-03684228_nudup.sam_dup_log.txt`
This file contains general information about the number of positions that are duplicated:
```
aligned_count   unaligned_count position_dup_count      frac_position_dup       moltag_dup_count        frac_molt
ag_dup
29142225        0       27204123        0.9335  4890793 0.1678
```
93% of the positions being duplicated seems rather high, but this is normal for RRBS libraries because of motif selection. 

## `RS-03684228_nudup.sam.resorted.dedup.bam`
This file is one of the input files for the `deduplicate bismark` step. The [details](https://github.com/FelixKrueger/Bismark/tree/master/Docs#iii-bismark-deduplication-step) of this step require the BAM file to be resorted as Read 1 then Read 2 rather than by position. This is why this file is titled as `resorted`

## `RS-03684228_nudup.sam.resorted.dedup.bedGraph.gz`
File containing methylation information with the following columns:
```
<chromosome> <start position> <end position> <methylation percentage>
```

## `RS-03684228_nudup.sam.resorted.dedup.bismark.cov.gz`
Bismark coverage file with the headings being:
```
<chromosome> <start position> <end position> <methylation percentage> <count methylated> <count unmethylated>
```
## `RS-03684228_nudup.sam.resorted.dedup.M-bias.txt`

```
<read position> <count methylated> <count unmethylated> <% methylation> <total coverage>
```
## `RS-03684228_nudup.sam.resorted.dedup_splitting_report.txt`
This file is generated with the `bismark_methylation_extractor`. This provides a summary of methylation information at different cytosines, split by their different context.

## `RS-03684228_nudup.sam.sorted.dedup.bam`
## `RS-03684228_nudup.sam.sorted.markdup.bam`
