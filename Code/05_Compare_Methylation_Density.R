#Compare_Methylation_Change_between_samples
library(data.table)
library(dplyr)
library(ggplot2)
library(stringr)
#library(berryFunctions)
"%&%"=function(a,b) paste(a,b,sep="")
require(lattice)
parent_key_path<-"/projects/rpci/joyceohm/pnfioric/sample_info/parent_sample_key.txt"
PDX_key_path<-"/projects/rpci/joyceohm/pnfioric/sample_info/PDX_sample_key.txt"
outpath<-"/projects/rpci/joyceohm/pnfioric/general_plots/comparison_plots/"

parent_key<-fread(parent_key_path, header = T)
PDX_key<-fread(PDX_key_path, header = T)
total_key<-left_join(parent_key, PDX_key, by ="Source_ID") %>%
  rename(Parent_ID=Sample_ID.x, PDX_ID=Sample_ID.y)
#plot_list
for (i in 1:nrow(total_key)){
  parent_ID<-total_key$Parent_ID[i]
  PDX_ID<-total_key$PDX_ID[i]
  source_ID<-total_key$Source_ID[i]
  parent_coverage_file<-fread("/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_"%&% parent_ID %&% "/" %&% parent_ID %&% "_001_val_1.fq_trimmed_bismark_bt2_pe.bismark.cov.gz", header = F)%>%
    mutate(total_reads=(V5+V6)) %>%
    filter(total_reads>1) %>%
    mutate(source="parent")
  PDX_coverage_file<- fread("/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_"%&% PDX_ID %&% "/" %&% PDX_ID %&% "_001_val_1.fq_trimmed_bismark_bt2_pe.bismark.cov.gz", header = F) %>%
    mutate(total_reads=(V5+V6))%>%
    filter(total_reads>1) %>%
    mutate(source="PDX")
  coverage_file<-bind_rows(parent_coverage_file,PDX_coverage_file)
  plotA<-ggplot(coverage_file, aes(x = V4, colour = source)) +geom_density(alpha=0.05) + xlab("% Methylation")+ ggtitle(paste(source_ID, " % Methylation_Comparison")) +theme_bw()
  #plot_list<-c(plot_list,plotA)
  pdf(outpath %&% source_ID %&%"_comparison_of_global_methylation_density.pdf", height = 9, width = 9)
  print(plotA)
  dev.off()
}