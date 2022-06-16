#Bismark Methylation Extraction
15 June 2022

## Background
The bioinformatics core performed deduplication on the RRBS data before extracting methylation calls. Since we expect duplicates in RRBS, we do not want to unncessarily remove these methylation calls. 

Before these notes, I performed the steps found at `reproducing_bismark.md`. In these notes, I outline the process where I perform the deduplication step on one of the RRBS samples using Bismark to confirm that the sample was indeed deduplicated. I did not get identical results to the bioinformatics core at RPCI. I later learned that they used a NuGen techologies pipeline that was generated before the most updated Bismark pipeline. Additionally, in those notes, I perform the methylation extraction using the `bismark_methylation_extractor`  command. Below is are notes on how I ran this step in parallel on data that includes duplicates (non-deduplicated).


## Single-run `bismark_methylation_extractor` 
```
bismark_methylation_extractor --bedGraph /projects/rpci/joyceohm/pnfioric/RRBS_paths/RS-03684228/RS-03684228_1-Sarcoma-RS-03107659-SS_RS-03672201_S1_L001_R1_001_val_1.fq_trimmed_bismark_bt2_pe.sam -o /projects/rpci/joyceohm/pnfioric/RRBS_reproduce/peter_test_RS-03684228_methyl
```
This command will pull context (CpG, CHH, CHG) specific methylation call data for this sample of RRBS data. The current structure of the directories does not easily allow for code to be run in parallel with multiple jobs. Because of this, I generated symbolic links for the files we want to use:

```
for i in `cat /projects/rpci/joyceohm/pnfioric/list_of_RRBS_IDs.txt`; do
        echo $i
        cd /projects/rpci/joyceohm/RQ020887/RQ020887-Ohm_RRBS/output/bismark/${i}
        ln -s /projects/rpci/joyceohm/RQ020887/RQ020887-Ohm_RRBS/output/bismark/${i}/${i}*001_val_1.fq_trimmed_bismark_bt2_pe.sam /projects/rpci/joyceohm/pnfioric/RRBS_samfile_links/${i}_001_
val_1.fq_trimmed_bismark_bt2_pe.sam
done
```
## Running `bismark_methylation_extractor` in parallel
After this, I wrote `.yaml` and `.jinja` files, so the I can generate jobs and run them in parallel:

  * `bismark_extract.jinja`
  * `01_methyl_extract_bismark.yaml`

Now that these files exist, they can be called using [badger](https://github.com/hakyimlab/badger). This is a tool that generates multiple scripts that can be submitted with SLURM. The details can be found in the linked github.

```
python3 /projects/rpci/joyceohm/pnfioric/badger/src/badger.py -yaml_configuration_file 01_methyl_extract_bismark.yaml -parsimony 8
```

This generates scripts at `/projects/rpci/joyceohm/pnfioric/PDX_RRBS_Processing/Code/methyl_extract_jobs/` that get submitted to SLURM.