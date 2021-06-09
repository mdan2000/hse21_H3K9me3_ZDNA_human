
library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)


DATA_DIR <- 'data/'
OUT_DIR <- 'results/'

#NAME <- 'DeepZ'
#NAME <- 'H3K9me3_K562.ENCFF567HEH.hg19'
#NAME <- 'H3K9me3_K562.ENCFF567HEH.hg38'
#NAME <- 'H3K9me3_K562.ENCFF963GZJ.hg19'
#NAME <- 'H3K9me3_K562.ENCFF963GZJ.hg38'
NAME <- 'DeepZ'

###

bed_df <- read.delim(paste0(DATA_DIR, NAME, '.bed'), as.is = TRUE, header = FALSE)
#colnames(bed_df) <- c('chrom', 'start', 'end', 'name', 'score')
colnames(bed_df) <- c('chrom', 'start', 'end')
bed_df$len <- bed_df$end - bed_df$start

ggplot(bed_df) +
  aes(x = len) +
  geom_histogram() +
  ggtitle(NAME, subtitle = sprintf('Number of peaks = %s', nrow(bed_df))) +
  theme_bw()
ggsave(paste0('len_hist.', NAME, '.pdf'), path = OUT_DIR)
