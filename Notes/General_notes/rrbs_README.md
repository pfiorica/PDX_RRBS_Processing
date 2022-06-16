---
Peter Fiorica
13 June 2022
Notes on Bismark Proces
---
## Introduction
This file provides a brief retrospective overview of the bismark analysis. Since I did not do the analysis, nor have I spoken to Song Liu (the person who performed this analysis) yet, I can not say 100% that this is the order in which these steps were performed (or that they were even performed at all.) My belief that these were performed in this fashion comes fromm review of the [Bismark user guide](https://github.com/FelixKrueger/Bismark/tree/master/Docs#iv-bismark-methylation-extractor).

# (I) Running bismark_genome_preparation
I believe this was done by the bioinformatics team at RPCCC previously and is likely not specific to our results.
The input of this step was like GRCh38 files and the output is located in this folder: `/rpcc/bioinformatics/reference/GRCh38_bismark/`

# (II) Running bismark
### Command:
```
bismark --bowtie2 /rpcc/bioinformatics/reference/GRCh38_bismark/ \
        -1 ../output/trim/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed.fq.gz \
        -2 ../output/trim/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R3_001_val_2.fq_trimmed.fq.gz \
        -o ../output/bismark/RS-03684228 \
        --sam
```
### Input files:

  Referenece Genome:
      `--genome`: `/rpcc/bioinformatics/reference/GRCh38_bismark/`
  RRBS Read Data:
      * This data needs to have be trimmed with TrimGalore for appropriate pre-processing to remove adapter sequences and Mspl regions
      `-1`: `../output/trim/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed.fq.gz`
      `-2`: `../output/trim/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R3_001_val_2.fq_trimmed.fq.gz`
      
### Output files:
   
  Alignment and Methylation Summary: `RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_PE_report.txt`
  Alignments and methylation call strings: `RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam`
    
Other Files:
  Stripped sam file:`RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam_stripped.sam`
    I am not entirely sure what this other file is. It may be a SAM stripped of headers.
    
Note: The user guide states the output of this step is a BAM file. The `-sam` flag was specified, which will output a SAM file, which is a non-binary version of a BAM file.

# (III) Running deduplicate_bismark

# (IV) Running bismark_methylation_extractor
### Input files:

### Output files:
    Methylation output files:
        `CHG_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz`
        `CHG_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz`
        `CHH_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz`
        `CHH_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz`
        `CpG_OB_RS-03684228_nudup.sam.resorted.dedup.txt.gz`
        `CpG_OT_RS-03684228_nudup.sam.resorted.dedup.txt.gz`
    bedGraph and Bismark coverage file:
        `RS-03684228_nudup.sam.resorted.dedup.bedGraph.gz`
        `RS-03684228_nudup.sam.resorted.dedup.bismark.cov.gz`
    M-bias plot data:
        `RS-03684228_nudup.sam.resorted.dedup.M-bias.txt`
    Splitting report file:
        `RS-03684228_nudup.sam.resorted.dedup_splitting_report.txt`
        

# (V) Running bismark2report
### Input files:

### Output files:
  
