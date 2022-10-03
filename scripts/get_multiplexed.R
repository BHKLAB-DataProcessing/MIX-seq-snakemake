library(SummarizedExperiment)
args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]
filename <- args[2]

data_dir <- paste0(work_dir, 'data')
dir.create(data_dir)
unzip(paste0(work_dir, "download/dataset.zip"), exdir=data_dir)

file.remove(file.path(data_dir, c('README.txt', 'Supplementary Tables.xlsx')))

features <- readRDS(file.path(data_dir, "all_CL_features.rds"))
drugs <- names(features)
drugs <- c(drugs,"DMSO_6hr_expt1","DMSO_6hr_expt3","DMSO_24hr_expt1","DMSO_24hr_expt3","sgGPX4_1_expt2","sgGPX4_2_expt2","sgLACZ_expt2","sgOR2J2_expt2")
# for (i in drugs) {
#   unzip(file.path(data_dir, paste(i,".zip", sep = "")), exdir=data_dir)
# }
# file.remove(file.path(data_dir, list.files(data_dir, pattern = "*.zip")))

drugs <- drugs[2:29]
drugs <- drugs[-(20)]
drugs <- drugs[!is.na(drugs)]
drug <- drugs[1]
unzip(file.path(data_dir, paste0(drug,".zip")), exdir=data_dir)
drug_dir <- file.path(data_dir, drug)
matrix <- Matrix::readMM(file.path(drug_dir, "matrix.mtx"))
genes <- read.csv(file.path(drug_dir, "genes.tsv"), sep="\t",header = FALSE,col.names = c("Ensembl","genesymbol"))
barcodes <-read.csv(file.path(drug_dir, "barcodes.tsv"), sep="\t",header = FALSE,col.names = c("cells"))
class <- read.csv(file.path(drug_dir, "classifications.csv"), row.names = 1)
experiment <- SummarizedExperiment(assays = matrix,rowData = genes,colData = barcodes,metadata = list(class))
experiment_list <- list(experiment)
file.remove(file.path(data_dir, paste0(drug,".zip")))
unlink(drug_dir, recursive=TRUE)

for (i in 2:length(drugs)) {
  drug <- drugs[i]
  print(drug)
  unzip(file.path(data_dir, paste0(drug,".zip")), exdir=data_dir)
  drug_dir <- file.path(data_dir, drug)
  matrix <- Matrix::readMM(file.path(drug_dir, "matrix.mtx"))
  genes <- read.csv(file.path(drug_dir, "genes.tsv"), sep="\t",header = FALSE,col.names = c("Ensembl","genesymbol"))
  barcodes <-read.csv(file.path(drug_dir, "barcodes.tsv"),sep="\t",header = FALSE,col.names = c("cells"))
  class <- read.csv(file.path(drug_dir, "classifications.csv"),row.names = 1)
  experiment <- SummarizedExperiment(assays = matrix,rowData = genes,colData = barcodes,metadata = list(class))
  experiment_list <- append(experiment_list,experiment)
  file.remove(file.path(data_dir, paste0(drug,".zip")))
  unlink(drug_dir, recursive=TRUE)
}

names(experiment_list) <- drugs

unlink(data_dir, recursive=TRUE)

saveRDS(experiment_list, file.path(work_dir, filename))