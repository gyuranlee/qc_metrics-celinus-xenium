
# find /ess/discovery/celinus/Analysis/2024*visium -name "metrics_summary.csv"  >> ~/Visium_file_2024_metrics.csv
# find /ess/discovery/celinus/Analysis/2024*chromium -name "metrics_summary.csv"  >> ~/Chromium_file_2024_metrics.csv
# find /ess/xenium_data/analyser/XETG00079/2024*/output* -name "metrics_summary.csv"  >> ~/xenium_file_2024_metrics.csv
visium_metrics <- read.csv('~/Visium_file_2024_metrics.csv', header = F)
visium_metrics$path <- paste0('/ess/discovery/celinus/Analysis/', visium_metrics$V1)
visium_metrics$sample_id <- visium_metrics$sample_id <- sapply(stringr::str_split(visium_metrics$V1, "/"), function(x) {
  element <- x[grep("^CR", x)][1]
  if (length(element) > 0) element else NA
})
visium_metrics$sample_id <- gsub("_old", "", visium_metrics$sample_id)

visium_qc <- lapply(1:nrow(visium_metrics), function(i) {
  csv <- read.csv(visium_metrics[i, "path"])
  csv$cs_id <- visium_metrics[i, "sample_id"]
  csv$path <- visium_metrics[i, "path"]
  return(csv)
})
visium_qc_df <- dplyr::bind_rows(visium_qc)
write.csv(visium_qc_df, "~/Visium_2024_metrics_summary.csv")

# chromium
chromium_metrics <- read.csv('~/Chromium_file_2024_metrics.csv', header = F)
chromium_metrics$sample_id <- chromium_metrics$sample_id <- sapply(stringr::str_split(chromium_metrics$V1, "/"), function(x) {
  element <- x[grep("^CR", x)][1]
  if (length(element) > 0) element else NA
})


chromium_metrics<- chromium_metrics[file.exists(chromium_metrics$V1),]
chromium_qc <- lapply(1:nrow(chromium_metrics), function(i) {
  csv <- read.csv(chromium_metrics[i, "V1"])
  csv$cs_id <- chromium_metrics[i, "sample_id"]
  csv$path <- chromium_metrics[i, "V1"]
  return(csv)
})
chromium_qc <- lapply(chromium_qc, function(df) {
  df[] <- lapply(df, as.character)
  return(df)
})
chromium_qc_df <- dplyr::bind_rows(chromium_qc)
write.csv(chromium_qc_df, "~/Chromium_2024_metrics_summary.csv")

#Xenium
# find $PWD -name "metrics_summary.csv" >> ~/Xenium_2024_file-metrics_summary.csv
xenium_metrics <- read.csv('~/Xenium_2024_file-metrics_summary.csv', header = F)
xenium_metrics$path <- paste0(xenium_metrics$V1, "/metrics_summary.csv")
xenium_metrics$cs_id <- stringr::str_split_fixed(xenium_metrics$V1, "/", n=Inf)[,7]
xenium_metrics<- xenium_metrics[file.exists(xenium_metrics$path),]
xenium_qc <- lapply(1:nrow(xenium_metrics), function(i) {
  csv <- read.csv(xenium_metrics[i, "path"])
  csv$cs_id <- xenium_metrics[i, "cs_id"]
  csv$path <- xenium_metrics[i, "path"]
  return(csv)
})

xenium_qc <- lapply(xenium_qc, function(df) {
  df[] <- lapply(df, as.character)
  return(df)
})
xenium_qc_df <- dplyr::bind_rows(xenium_qc)
write.csv(xenium_qc_df, "~/Xenium_2024_metrics_summary.csv")
