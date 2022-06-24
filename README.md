# PDX_RRBS_Processing

## Introduction
This directory includes the notes and code used to pull methylation calls from reduced representation bisulfite sequencing (RRBS) data sampled from patient derived xenographs. Analysis was performed during June 2022 during Peter Fiorica's PhD lab rotation in the Ohm Lab at RPCCC.

## Background
Initially, the bioinformatics core at RPCCC performed analysis of the raw RRBS data of parent tumor and PDXs generated from the tumor. They performed the following analysis:

  * Quality control with [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
  * Adaptor and Mspl-cut site trimming with [TrimGalore](https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/) ([github](https://github.com/FelixKrueger/TrimGalore))
  * Alignment to Hg38 genome build with [Bismark](https://www.bioinformatics.babraham.ac.uk/projects/bismark/) ([github](https://github.com/FelixKrueger/Bismark/tree/master/Docs))
  
I detail the above steps [here](https://github.com/pfiorica/PDX_RRBS_Processing/blob/main/Notes/General_notes/Walkthrough_of_RRBS_Pipeline.md).
  
In the the analysis of the RRBS data with Bismark, the bioinformatics core used a [NuGEN Technologies pipeline](https://github.com/nugentechnologies/NuMetRRBS). This pipeline includes [steps to remove duplicates](https://github.com/nugentechnologies/NuMetRRBS#duplicate-determination-with-nudup-optional). We determined this step was performed by the core because there are removed values from the `.sam` files for the RRBS data. Details on the process I used to determine this are found [here](https://github.com/pfiorica/PDX_RRBS_Processing/blob/main/Notes/General_notes/reproducing_bismark.md). Additionally, files are labeled with `dedup`. It is [well-documented](https://github.com/FelixKrueger/Bismark/tree/master/Docs#iii-bismark-deduplication-step) that removing duplicates from RRBS data is not recommended because we expected non-random PCR amplification of the Mspl cut sites. Because deduplication was performed by the core against the recommendation of the authors of Bismark, I decided to return to the data immediately after it was aligned a reference genome and re-perform the methylation extraction step and the steps that followed.

## General Bismark Pipeline Overview
### (I) Bismark Genome Preparation
This step organizes a folder containing information relating to a reference genome. It is performed to prepare reference genome data for alignment. This was performed by the RPCCC core using a reference genome in build Hg38.

### (II) Bismark Alignment Step
This step aligns the raw `.fastq` files to the reference genome. This was performed by the RPCCC core. The output of this step is where I picked up my analysis.
  
### (III) Bismark Deduplication Step
Performed by the RPCCC Core but not recommended for analysis of RRBS data.

### (IV) Bismark methylation extractor
I performed this step to extract methylation call for different cytosines across the genome. The details of how I performed this step are [here](https://github.com/pfiorica/PDX_RRBS_Processing/blob/main/Notes/Pipeline_notes/01_bismark_methylation_extractor.md).

### (V) The Bismark HTML Processing Report
I did not perform this step or any of the steps that follow because I spent most of my time confirming the output of the methylation extraction. It is a step used to compile a more user-friendly `html` document of reports from previous steps.

### (VI) The Bismark Summary Report
I did not perform this step.

### (VII) Bismark Nucleotide Coverage report 
I did not perform this step.

### (VIII) Filtering out non-bisulfite converted reads
I did not perform this step.

## Contact
Peter Fiorica
pnfioric@buffalo.edu
