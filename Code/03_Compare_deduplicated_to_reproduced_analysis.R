#14 June 2022
#Peter Fiorica
#Compare_M_Plots

library(data.table)
library(dplyr)
library(ggplot2)
library(stringr)
library(berryFunctions)
"%&%"=function(a,b) paste(a,b,sep="")
require(lattice)

input_path <- "/projects/rpci/joyceohm/pnfioric/split_M_files/"
samples <- fread("/projects/rpci/joyceohm/pnfioric/list_of_RRBS_IDs.txt", header = F)$V1

dir.create(input_path %&% "M_plots/")
output_path <- paste(input_path, "M_plots/", sep = "")
  
context<-c("CpG_R1", "CHG_R1", "CHH_R1","CpG_R2", "CHG_R2", "CHH_R2")


for (sample in samples){
  duplicated<-data.table()
  deduplicated<-data.table()
  for (i in 1:6){
    a<-fread(input_path %&% context[i] %&% "_" %&% sample %&% "_" %&% "duplicated.txt", skip = 2)
    a$context<-context[i]
    duplicated<-bind_rows(duplicated, a)
    duplicated$version<-"duplicated"
    b<-fread(input_path %&% context[i] %&% "_" %&% sample %&% "_" %&% "deduplicated.txt", skip = 2)
    b$context <- context[i]
    deduplicated<-bind_rows(deduplicated,b)
    deduplicated$version<-"deduplicated"
  }
  pdf(file = output_path %&% sample %&%"_deduplicated.pdf", height = 6, width = 6)
  print(ggplot(data = deduplicated, aes(x=position, y= `% methylation`, color = context)) +geom_line() + ggtitle(paste0(sample,"Deduplicated RRBS M-Plot")))
  dev.off()
  pdf(file = output_path %&% sample %&% "_duplicated.pdf", height = 6, width = 6)
  print(ggplot(data = duplicated, aes(x=position, y= `% methylation`, color = context)) + geom_line() + ggtitle(paste0(sample," RRBS M-Plot")))
  dev.off()
  combined<-bind_rows(duplicated,deduplicated) %>%
    filter(context == "CpG_R1")
  pdf(file = output_path %&% sample %&% "_comparison_between_duplication.pdf", height = 7, width = 7)
  print(ggplot(data = combined, aes(x=position, y= `% methylation`, color = version)) + geom_line() + ggtitle(paste0(sample," RRBS M-Plot Comparison (Dup v. De-Dup) of CpG_R1")))
  dev.off()
}

