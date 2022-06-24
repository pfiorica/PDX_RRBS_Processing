#Compare_Methylation_Between_Samples_inR
library(data.table)
library(dplyr)
library(ggplot2)
library(stringr)
#library(berryFunctions)
"%&%"=function(a,b) paste(a,b,sep="")
require(lattice)
parent_key_path<-"/projects/rpci/joyceohm/pnfioric/sample_info/parent_sample_key.txt"
PDX_key_path<-"/projects/rpci/joyceohm/pnfioric/sample_info/PDX_sample_key.txt"
outfile<-"/projects/rpci/joyceohm/pnfioric/"

parent_key<-fread(parent_key_path, header = T)
PDX_key<-fread(PDX_key_path, header = T)
total_key<-left_join(parent_key, PDX_key, by ="Source_ID") %>%
  rename(Parent_ID=Sample_ID.x, PDX_ID=Sample_ID.y)
chr_list<-c(1:22,"X","M", "Y")

#parent_file <- data.table()
#PDX_file <- data.table()
for (i in 1:nrow(total_key)){
  parent_ID<-total_key$Parent_ID[i]
  PDX_ID<-total_key$PDX_ID[i]
  source_ID<-total_key$Source_ID[i]
  print("Reading in Files that pair for the source "%&% source_ID)
  parent_coverage_file<-fread("/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_"%&% parent_ID %&% "/" %&% parent_ID %&% "_001_val_1.fq_trimmed_bismark_bt2_pe.bismark.cov.gz", header = F) %>%
      mutate(total_reads = V6 + V5) %>%
      filter(total_reads>1) %>%
      mutate(position=paste(V1,V2, sep = ":"))
  parent_file_for_join <- parent_coverage_file %>% select(position, V4)
  colnames(parent_file_for_join)<-c("Position", paste(parent_ID, "Meth_Perc", sep = "_"))
  if(exists("parent_file")){
    parent_file<-full_join(parent_file, parent_file_for_join, by = "Position")
  }else{
    parent_file <- parent_file_for_join
  }
  PDX_coverage_file<- fread("/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_"%&% PDX_ID %&% "/" %&% PDX_ID %&% "_001_val_1.fq_trimmed_bismark_bt2_pe.bismark.cov.gz", header = F) %>%
     mutate(total_reads=(V5+V6))%>%
     filter(total_reads>1) %>%
     mutate(position=paste(V1,V2, sep = ":"))
 PDX_file_for_join <- PDX_coverage_file %>% select(position, V4)
 colnames(PDX_file_for_join)<-c("Position", paste(PDX_ID, "Meth_Perc", sep = "_"))
 if(exists("PDX_file")){
   PDX_file<-full_join(PDX_file, PDX_file_for_join, by = "Position")
 }else{
   PDX_file <- PDX_file_for_join
 }
 print("Done reading and merging files pair for the source "%&% source_ID %&% ". " )
}

PDX_file2<- PDX_file %>% 
  mutate(Call_Rate=(10-(rowSums(is.na(PDX_file))))/(ncol(PDX_file)-1)) %>%
  select(Position, Call_Rate, `RS-03684229_Meth_Perc`, `RS-03684231_Meth_Perc`, `RS-03684233_Meth_Perc`,`RS-03684235_Meth_Perc`, `RS-03684237_Meth_Perc` ,`RS-03684239_Meth_Perc`,`RS-03684243_Meth_Perc`,`RS-03684241_Meth_Perc`, `RS-03684245_Meth_Perc`, `RS-03684247_Meth_Perc`)
Parent_file2<- parent_file %>% 
  mutate(Call_Rate=(10-(rowSums(is.na(parent_file))))/(ncol(parent_file)-1))  %>%
  select(Position, Call_Rate, `RS-03684228_Meth_Perc`, `RS-03684230_Meth_Perc`,`RS-03684232_Meth_Perc`,`RS-03684234_Meth_Perc`,`RS-03684236_Meth_Perc`,`RS-03684238_Meth_Perc`,`RS-03684242_Meth_Perc`,`RS-03684240_Meth_Perc`,`RS-03684244_Meth_Perc`,`RS-03684246_Meth_Perc`)

fwrite(PDX_file2, outfile %&%"PDX_methylation_rate.txt.gz", col.names = T, row.names = F, sep = "\t", quote = F)
fwrite(Parent_file2, outfile %&%"Parent_tumor_methylation_rate.txt.gz", col.names = T, row.names = F, sep = "\t", quote = F)