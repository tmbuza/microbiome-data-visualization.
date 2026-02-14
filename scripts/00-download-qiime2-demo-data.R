suppressPackageStartupMessages({
  library(fs)
})

dir_create("data/qiime2")

download.file(
  "https://docs.qiime2.org/2024.2/data/tutorials/moving-pictures/table.qza",
  "data/qiime2/feature-table.qza",
  mode = "wb"
)

download.file(
  "https://data.qiime2.org/2024.2/tutorials/moving-pictures/sample_metadata.tsv",
  "data/qiime2/sample-metadata.tsv",
  mode = "wb"
)

download.file(
  "https://docs.qiime2.org/2024.2/data/tutorials/moving-pictures/taxonomy.qza",
  "data/qiime2/taxonomy.qza",
  mode = "wb"
)