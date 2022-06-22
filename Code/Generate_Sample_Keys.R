#Peter Fiorica
#22 June 2022

# Introduction
##This script is what I used to generate a sample key for the RRBS reads.
## James Ellegate showed me two files that could have been used as sample keys,
## but neither of these files contained all of the information I needed to appropriately analyze the rrbs data

#Load Packages
library(dplyr)
library(tidyr)
library(data.table)
library(stringr)
"%&%"=function(a,b) paste(a,b,sep="")

#Defined Paths
sample_path<-"/projects/rpci/joyceohm/pnfioric/sample_info/"
sample_list<-fread("/projects/rpci/joyceohm/pnfioric/list_of_RRBS_IDs.txt", header = F)$V1

#Read in files
seq_info<-fread(sample_path %&% "sequencing-sample-info.csv", header = T)
sarcoma_info<-fread(sample_path %&% "Sarcoma PDX Update.csv", header =T)
GSR_info <- fread(sample_path %&% "HHNCTDRXY-RRBS.csv", skip =20)

#Check if GSR_info contains all samples
table(sample_list %in% GSR_info$Sample_ID)

GSR_info <- GSR_info %>%
  select(-Sample_Plate, -Sample_Well, -Index_Plate_Well) %>%
  separate(Sample_Name, "_", into=c("V1","V2", "V3")) 

GSR_info2 <- GSR_info %>%
  separate(V2, "-", into=c("sample_number", "Tumor_Type","RS", "Source_ID", "Lineage")) %>%
  mutate(Source_ID=paste(RS,Source_ID, sep = "-")) %>% select(-Lane,-RS, -Description, -Sample_Project,-index,-I7_Index_ID) %>%
  arrange(Source_ID)

parent_sample<-GSR_info2 %>% filter(Lineage=="SS")
PDX_sample<-GSR_info2 %>% filter(Lineage == "P3" | Lineage =="P1")

fwrite(parent_sample, sample_path %&% "parent_sample_key.txt", row.names= F, sep = "\t", quote = F, col.names = T)
fwrite(PDX_sample, sample_path %&% "PDX_sample_key.txt", row.names= F, sep = "\t", quote = F, col.names = T )
fwrite(GSR_info2, sample_path %&%  "sample_key.txt", row.names= F, sep = "\t", quote = F, col.names = T)
