
library(data.table)
library(dplyr)
library(ggplot2)
library(stringr)
#library(berryFunctions)
"%&%"=function(a,b) paste(a,b,sep="")
require(lattice)

input_path <- "/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/"
outfile <- "/projects/rpci/joyceohm/pnfioric/general_plots/"
samples <- fread("/projects/rpci/joyceohm/pnfioric/list_of_RRBS_IDs.txt", header = F)$V1

sample<-"RS-03684228"

a<-data.table()
for(sample in samples){
  coverage_file<-fread("/panasas/scratch/grp-joyceohm/rrbs_methyl_extract/methyl_extract_"%&% sample %&% "/" %&% sample %&% "_001_val_1.fq_trimmed_bismark_bt2_pe.bismark.cov.gz", header = F)
  coverage_file<- coverage_file %>%
    mutate(total_reads=(V5+V6))
  filterd_cov_file <- coverage_file %>%
    filter(total_reads > 1) %>%
    mutate(sample_id = sample)
  print("For sample: " %&% sample %&% ", " %&% (nrow(coverage_file)-nrow(filterd_cov_file)) %&% " loci were removed because they contained than one read at the locus.")
  a<-bind_rows(a,filterd_cov_file)
  pdf(outfile %&% sample %&%"_locus_meth_distribution.pdf", height = 7.50, width = 9.00)
  print( ggplot(filterd_cov_file, aes(x=V4))+ geom_histogram()+ xlab("% Methylation")+    ggtitle(paste0(sample, " Distribution of % Methylation by Locus")) +theme_bw())
  dev.off()
  pdf(outfile %&% sample %&%"_reads_per_locus_distribution.pdf", height = 7.50, width = 9.00)
  print( ggplot(filterd_cov_file, aes(x=total_reads))+ geom_histogram()+ xlab("Total Reads at Given Locus")+    ggtitle(paste0(sample, " Distribution of Reads at Locus")) +theme_bw())
  dev.off()
}
 
pdf(outfile %&% "all_sample_distribution.pdf", height = 7.50, width = 9.00) 
ggplot(a, aes(x=V4, colour=sample_id))+geom_density(alpha=0.05) + xlab("% Methylation")+ theme_bw()
dev.off()

#pdf(outfile %&% sample %&%"_call_versus_meth_rate.pdf", height = 7.50, width = 9.00)
#ggplot(filterd_cov_file, aes(y=V4, x = total_reads))+
#  geom_density_2d()+ xlab("% Methylation") +theme_bw()
#dev.off()