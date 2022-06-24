## Overview of Files in Directory
Here is a brief overview of the code used to initially analyze the RRBS data for 22 samples of parent tumor and PDX tissue. These notes can be used for the Ohm Lab after my lab rotation.

`00_link_sam_files.sh`: quick bash script to generate symbolic links for `.sam` files. This organizes a directory, so that I can call a new command with `01_methyl_extract_bismark.yaml` 

`01_methyl_extract_bismark.yaml`: This is a `.yaml` script that is used with the tool [badger](). It generates multiple jobs to be submitted. I covered the details of this [here](https://github.com/pfiorica/PDX_RRBS_Processing/blob/main/Notes/Pipeline_notes/01_bismark_methylation_extractor.md)

`02_call_split_file.sh`: This is a script calls `02_split_M_file.py`. It is used the M-bias files from the methylation extraction into their specific cytosine contexts (CpG-Original Top Strand, CpG-Original Bottom Strand, CHH-Original Top Strand, etc.)

`03_Compare_deduplicated_to_reproduced_analysis.R`: Compares the results of the de-duplicated (RPCCC Bioinformatics Core-generated) data and my bismark analysis data. It generates M-plots to look at the percent methylation across different cytosine contexts for the de-duplicated analysis and my analysis.

`04_distribution_plots_for_samples.R`: Is called by `04_call_distribution_plots.sh`. The script generates histograms of the methylation percentage and the total read depth for all the cytosines in each sample. It also generates a plot of the distribution of methylation percentage for all 22 samples.

`05_Compare_Methylation_Density.R`: Generates density plots of the distribution of percent methylation change between a PDX and the parent tumor from which it was derived. The script is called by `05_call_compare_methylation_density.sh`.

`06_Compare_Methylation_Change.R`: Generates a Manhatton plot-esque figure of the change in methylation percent of each locus between parent tumor and its PDX. It is called by `06_call_compare_methylation_change.sh`.

`07_Generate_Full_Samples_Coverage_File.R`: Generates 2 files for PDX samples and Parent tumor samples, respectively. In these files. Rows are different methylation loci and columns are samples. The first column is the locus (Chr:pos). The second column is the call rate for the cytosine at that locus. This means that if the cytosine is mapped in 9 of the 10 PDX samples, it will have a call rate of 90% or .9. The third column and those that follow are the methylation percent for a locus in a given sample. Samples are labeled corresponding to their source ID. A PDX and parent tumor should all map back to a specific source ID. The key for these IDs is available at: `/projects/rpci/joyceohm/pnfioric/sample_info/sample_key.txt`.
