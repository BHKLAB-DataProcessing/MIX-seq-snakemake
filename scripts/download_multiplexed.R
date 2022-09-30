options(timeout = 1000)
args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]

download_dir <- file.path(work_dir, 'download')
dir.create(download_dir)
download.file("https://figshare.com/ndownloader/articles/10298696?private_link=139f64b495dea9d88c70", destfile=file.path(download_dir, "dataset.zip"))