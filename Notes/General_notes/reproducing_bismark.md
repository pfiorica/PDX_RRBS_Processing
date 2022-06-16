# Replicating Bismark Analysis

## Introduction
Since I have questions about the Bismark analysis, I figured I would just attempt to replicate it to see if I can get identical results.

## Deduplicate 
```
deduplicate_bismark --bam /projects/rpci/joyceohm/pnfioric/RRBS_paths/RS-03684228/RS-03684228_nudup.sam.resorted.dedup.bam --outfile /projects/rpci/joyceohm/pnfioric/RRBS_reproduce/peter_test_RS-03684228
```

## Methylation Extraction
```
bismark_methylation_extractor /projects/rpci/joyceohm/pnfioric/RRBS_paths/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam -o /projects/rpci/joyceohm/pnfioric/RRBS_reproduce/peter_test_RS-03684228_methyl
```
The above job did not generate bedGraph files, so I edited it to include the `--bedGraph` flag.
