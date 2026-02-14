suppressPackageStartupMessages({
  library(qiime2R)
  library(phyloseq)
  library(tidyverse)
})

# ----------------------------
# 1) Load QIIME2 artifacts
# ----------------------------
metadata <- qiime2R::read_q2metadata("data/qiime2/sample-metadata.tsv")
ASVs <- qiime2R::read_qza("data/qiime2/feature-table.qza")$data

# ----------------------------
# 2) Ensure sample IDs match
# ----------------------------

# ASV table sample IDs
colnames(ASVs) <- trimws(colnames(ASVs))

# Metadata: move SampleID column into rownames if needed
metadata_df <- as.data.frame(metadata)

if ("SampleID" %in% colnames(metadata_df)) {
  rownames(metadata_df) <- trimws(metadata_df$SampleID)
  metadata_df$SampleID <- NULL
} else {
  stop("Metadata does not contain a 'SampleID' column. Cannot align samples.")
}

keep_ids <- intersect(colnames(ASVs), rownames(metadata_df))

if (length(keep_ids) == 0) {
  stop("No overlapping sample IDs after aligning metadata. Check SampleID values.")
}

ASVs2 <- ASVs[, keep_ids, drop = FALSE]
metadata2 <- metadata_df[keep_ids, , drop = FALSE]

# ----------------------------
# 3) Build phyloseq object
# ----------------------------
ps <- phyloseq::phyloseq(
  phyloseq::otu_table(ASVs2, taxa_are_rows = TRUE),
  phyloseq::tax_table(as.matrix(taxonomy)),
  phyloseq::sample_data(metadata2)
)

# ----------------------------
# 4) Save canonical object
# ----------------------------
dir.create("data", showWarnings = FALSE)
saveRDS(ps, "data/moving-pictures-ps.rds")

# Optional quick checks (prints to console)
cat("Saved: data/moving-pictures-ps.rds\n")
cat("Samples:", phyloseq::nsamples(ps), "\n")
cat("Taxa:", phyloseq::ntaxa(ps), "\n")