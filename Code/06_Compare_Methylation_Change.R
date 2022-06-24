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
outpath<-"/projects/rpci/joyceohm/pnfioric/general_plots/comparison_plots/"

parent_key<-fread(parent_key_path, header = T)
PDX_key<-fread(PDX_key_path, header = T)
total_key<-left_join(parent_key, PDX_key, by ="Source_ID") %>%
  rename(Parent_ID=Sample_ID.x, PDX_ID=Sample_ID.y)
chr_list<-c(1:22,"X","M", "Y")
#plot_list
for (i in 1:nrow(total_key)){
  parent_ID<-total_key$Parent_ID[i]
  PDX_ID<-total_key$PDX_ID[i]
  source_ID<-total_key$Source_ID[i]
  parent_coverage_file<-fread("/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_"%&% parent_ID %&% "/" %&% parent_ID %&% "_001_val_1.fq_trimmed_bismark_bt2_pe.bismark.cov.gz", header = F)%>%
    mutate(total_reads=(V5+V6)) %>%
    filter(total_reads>1) %>%
    mutate(position=paste(V1,V2, sep = ":"))
  PDX_coverage_file<- fread("/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_"%&% PDX_ID %&% "/" %&% PDX_ID %&% "_001_val_1.fq_trimmed_bismark_bt2_pe.bismark.cov.gz", header = F) %>%
    mutate(total_reads=(V5+V6))%>%
    filter(total_reads>1) %>%
    mutate(position=paste(V1,V2, sep = ":"))
  coverage_file<-left_join(parent_coverage_file,PDX_coverage_file, by = "position")
  coverage_file1<- coverage_file %>% mutate(methylation_change=(V4.x-V4.y)) %>%
    rename(CHR=V1.x, BP=V3.x) %>%
    mutate(CHR = gsub("chr","", CHR)) %>%
    filter(CHR %in% chr_list) %>%
    filter(is.na(methylation_change)==FALSE) 
  coverage_file1$BP<-as.numeric(coverage_file1$BP)
  coverage_file1<- coverage_file1 %>% 
    mutate(CHR = if_else(CHR=="X","23",
                         if_else(CHR=="Y","24",
                                               if_else(CHR=="M","25", coverage_file1$CHR)))) %>%
    mutate(CHR=as.integer(CHR))
    
  don <- coverage_file1 %>%
    # Compute chromosome size
    group_by(CHR) %>% 
    summarise(chr_len=max(BP)) %>%
    # Calculate cumulative position of each chromosome
    mutate(tot=cumsum(chr_len)-chr_len) %>%
    select(-chr_len) %>%
    # Add this info to the initial dataset
    left_join(coverage_file1, ., by=c("CHR"="CHR")) %>%
    arrange(CHR, BP) %>%
    mutate(BPcum=BP+tot)
  axisdf = don %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
  
  plotA<-ggplot(don, aes(x=BPcum, y=methylation_change)) +
    # Show all points
    geom_point(aes(color=as.factor(CHR)), na.rm = T) +
    geom_hline(yintercept = sd(coverage_file1$methylation_change), color = "red")+
    geom_hline(yintercept = sd(coverage_file1$methylation_change) *-1, color = "red") +
    geom_hline(yintercept = sd(coverage_file1$methylation_change) * 3, color = "red", linetype = "dashed") +
    geom_hline(yintercept = sd(coverage_file1$methylation_change) * -3, color = "red", linetype = "dashed") +
    scale_color_manual(values = rep(c("springgreen3", "darkorchid4", "skyblue4"), 25 ))
    # Custom the theme:
    theme_classic(18) + ylab("Change in % Methylation") +xlab("Chromosome") +
    guides(colour="none") +theme_bw()
    #theme(axis.title.x=element_blank(),
    #      axis.text.x=element_blank(),
    #      axis.title=element_text(size=20),
    #      plot.title = element_text(vjust=4.12),
    #      panel.grid.major.x = element_blank(),
    #      panel.grid.minor.x = element_blank(),
    #      panel.grid.major.y = element_blank(),
    #      panel.grid.minor.y = element_blank(),
    #      plot.margin=unit(c(1,1,0.1,1), units ="cm")
    #)+
  #plot_list<-c(plot_list,plotA)
  png(outpath %&% source_ID %&%"_comparison_of_global_methylation_change.png", height = 750, width = 650, units = "px")
  print(plotA)
  dev.off()
}

