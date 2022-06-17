import pandas
import numpy as np
import pathlib
import argparse

parser = argparse.ArgumentParser("Change M-file_from1_file_to_6")
parser.add_argument("--input_duplicated")
parser.add_argument("--input_deduplicated")
parser.add_argument("--output")
parser.add_argument("--sample")
args = parser.parse_args()

dup_path = args.input_duplicated
dedup_path = args.input_deduplicated
outpath = args.output
sample = args.sample

#dedup_path = "/projects/rpci/joyceohm/pnfioric/RRBS_paths/RS-03684249/RS-03684249_nudup.sam.resorted.dedup.M-bias.txt"
#dup_path = "/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_RS-03684249/RS-03684249_001_val_1.fq_trimmed_bismark_bt2_pe.M-bias.txt"
#outpath = "/projects/rpci/joyceohm/pnfioric/"

dedup=open(dedup_path)
dedup_txt=dedup.read()
list_tables=dedup_txt.split("\n\n")
#sample= dedup_path[44:55]
context=("CpG_R1", "CHG_R1", "CHH_R1","CpG_R2", "CHG_R2", "CHH_R2")

dup=open(dup_path)
dup_txt=dup.read()
list_tables2=dup_txt.split("\n\n")

for i in range(6):
    file = open(outpath + context[i] +"_"+ sample+"_deduplicated.txt", "w")
    file.write("%s \n" % list_tables[i])
    file.close()
    
for i in range(6):
    file2 = open(outpath + context[i] +"_"+ sample+"_duplicated.txt", "w")
    file2.write("%s \n" % list_tables2[i])
    file2.close()
