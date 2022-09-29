options(timeout = 1000)
args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]

download.file("https://figshare.com/ndownloader/articles/10298696?private_link=139f64b495dea9d88c70", destfile=file.path(work_dir, "dataset.zip"))