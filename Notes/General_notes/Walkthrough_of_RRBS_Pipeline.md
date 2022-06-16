# Walkthrough of RRBS Pipeline  
---
Peter Fiorica
9 June 2022
---

## Introduction
This document is a set of notes that accompany a walkthrough of the [Epigenesys protocol](https://www.epigenesys.eu/images/stories/protocols/pdf/20120720103700_p57.pdf) for QC, trimming and alignment of RRBS data.

# (1) Quality control of high-throughput sequencing files

`fastqc illumina_100K.fastq.gz`

`mv illumina_100K_fastqc.zip "/mnt/c/Users/Peter Fiorica/Documents/JSOMBS/MD-PhD Related/Rotation Material/Ohm Lab/RRBS_Intro"`

When I look at the output `.html` file that comes from the zipped folder that FastQC outputs, it looks like this data has already gone through QC.

### Per base sequence content
Bisulfite sequencing experiments should have a cytosine content between 1-2%  throughout entire sequencing length. A suddent increase in cytosine towards the end of the sequence suggests that adapter contamination may be in play.

### GC-content plot
The peak of GC-content for BS-Seq libraries should be between 20-30% of the mean per-base GC-content. Adapter contamination will skew this curve to the right.

###Duplication and over-represented sequences
For RRBS libraries, de-duplication of alignments is not recommended since it will remove a lot of the aligned data. In RNA-seq or other sequencing efforts, we would not want a lot of duplication. For RRBS, a lot of duplication is normal because fragments are expected to line up perfectly at the same genetic locus multiple times.

# (2) Quality and adapter trimming

`trim_galore sequence_file.fastq`

This command:
- removes base calls with a Phred score of 20 or lower (assuming Sanger encoding)
- removes any signs of the Illumina adapter sequence from the 3' end (AGATCGGAAGAGC)
- removes sequences that got shorter than 20 bp

For paired-end reads, call Trim_galore is called as:
`trim_galore --paired --trim1 file_1_1.fastq file_1_2.fastq`


# (3) Alignment and methylation calling of bisulfite treated reads
Bismark is a tool used for RRBS alignments. It will perform the alignment and calculate methylation calls, so the data can be analyzed immediately.

### Genome indexing
Before starting alignments, we have to bisulfite convert and index a reference genome in-silico. This is done with Bowtie2:

`bismark_genome_preparation --bowtie2 /path/to/genome/`

Directions for downloading and indexing a reference genome can be found at https://daehwankimlab.github.io/hisat2/howto/.

Since the genome and bisulfite-converted genome take up a lot of space, this step should only be converted once. Symbolic links can be generated to re-use this BS-genome.

### Read alignments

#### Single-end alignments
`bismark -n 1 /path/to/bisulfite-genome/ file.fq`

The value for the `-n` parameter determines that amount of acceptable mismatch in an an alignment. The larger number will lead to the alignment time taking a longer amount of time. It is recommended that we start with 0 or 1 for this parameter and then work up to higher numbers if needed.

There is also a default `-e` parameter that is not listed in the command. This value represents the upper limit of the product of `total number of mismatches` X `quality score of that mismatch`. If the default ceiling mismatch parameter is 70, that means that 2 mismatches with a score of 30 ( 2*30=60) or 3 mismatches with a score of 20 would be allowed before the limit is exceeded.

#### Note about bowtie2
```
Use of Bowtie 2 for alignments
Using Bowtie 2 for bisulfite alignments offers the unique feature of aligning reads over 
indels. Even though Bowtie 2 is supposed to be quicker for very long reads compared to
Bowtie, we often see that running Bismark is considerably slower when run with 
Bowtie 2. So unless you would benefit from indel mapping we would suggest running
Bismark in the default, i.e. Bowtie, mode
```

#### Paired-end alignments
`bismark -n 1 /path/to/bisulfite-genome/ -1 file_1.fq -2 file_2.fq`

Note on low mapping efficiency: a common issue with paired-end alignments is low mapping efficiency. This can happen when a read is so long that both reads completely contain each other. An alignment in this fashion will be considered invalid by bowtie. This can be addressed in advance by using appropriate QC with the `--trim1` flag in Trim Galore.

## Methylation extractor
Extracting methylation information from a single-end file:
`methylation_extractor -s file.fq_bismark.sam`

Extracting methylation information from a paired-end file:
`methylation_extractor -p --no_overlap file_1.fq_bismark_pe.sam`

# (4) Filtering reads after alignments

#### Filtering out reads with non-CG methylation
Some people will remove reads that contain too many methylated cytosines in non-GC context because non-CG methylation is virtually non-existent.

#### De-duplication
Since mammalian genomes are very large, it is unlikely to that there will be several independent fragments that align at the same genomic position. If this does happen, it is likely because of PCR amplification. Bismark has a de-duplication tool that removes reads with the same orientation and start-stop site.

*Note: This is not recommended for RRBS data since duplication is non-random. Mspl is the restriction enzyme that will cleave at certain spots. This will lead to non-random duplication of regions.*

