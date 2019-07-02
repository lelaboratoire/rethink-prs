# Get data from simulated-data
# Move 'Class' to first column
# Put these files in reformated-data

library(dplyr)
library(data.table)

set.seed(1618)

mdr_path <- here::here('mb-mdr/')
data_dir <- here::here('simulated-data')
filenames <- list.files(data_dir, pattern = '*.txt')

for (filename in filenames){
  mydat <- paste(data_dir, filename, sep = '/') %>%
    fread() %>%
    dplyr::select(Class, paste0('X', 0:9)) 
  nsamp <- nrow(mydat)
  
  train_idx <- sample(seq(nsamp), floor(nsamp/2), replace = F)
  train_dat <- mydat[train_idx, ]
  test_dat <- mydat[-train_idx, ]
  
  # fwrite(mydat, paste0(mdr_path, 'reformatted-data/', filename), sep = '\t')
  fwrite(train_dat, paste0(mdr_path, 'reformatted-data/train/', filename), sep = '\t')
  fwrite(test_dat, paste0(mdr_path, 'reformatted-data/test/', filename), sep = '\t')
}