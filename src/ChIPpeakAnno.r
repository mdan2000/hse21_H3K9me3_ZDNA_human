library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)


DATA_DIR <- 'data/'
OUT_DIR <- 'results/'




###

# https://bioconductor.org/packages/release/bioc/vignettes/ChIPpeakAnno/inst/doc/quickStart.html
# BiocManager::install("ChIPpeakAnno")
# BiocManager::install("org.Hs.eg.db")
# BiocManager::install("org.Mm.eg.db")

library(ChIPpeakAnno)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(org.Hs.eg.db)
#library(TxDb.Mmusculus.UCSC.mm10.knownGene)
#library(org.Mm.eg.db)

###


peaks <- toGRanges(paste0(DATA_DIR, 'H3K9me3_K562.intersect_with_DeepZ.bed'), format="BED")
peaks[1:2]

annoData <- toGRanges(TxDb.Hsapiens.UCSC.hg19.knownGene)
annoData[1:2]


anno <- annotatePeakInBatch(peaks, AnnotationData=annoData, 
                            output="overlapping", 
                            FeatureLocForDistance="TSS",
                            bindingRegion=c(-2000, 300))
data.frame(anno) %>% head()

anno$symbol <- xget(anno$feature, org.Hs.egSYMBOL)
data.frame(anno) %>% head()

anno_df <- data.frame(anno)
write.table(anno_df, file=paste0(DATA_DIR, 'H3K4me3_A549.intersect_with_DeepZ.genes.txt'),
            col.names = TRUE, row.names = FALSE, sep = '\t', quote = FALSE)

uniq_genes_df <- unique(anno_df['symbol'])
write.table(uniq_genes_df, file=paste0(DATA_DIR, 'H3K4me3_A549.intersect_with_DeepZ.genes_uniq.txt'),
            col.names = FALSE, row.names = FALSE, sep = '\t', quote = FALSE)
