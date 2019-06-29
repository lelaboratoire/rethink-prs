# Get data from simulated-data
# Move 'Class' to first column
# Put these files in reformated-data

library(dplyr)
library(data.table)

mdr_path <- here::here('mb-mdr/')
data_dir <- here::here('simulated-data')
filenames <- list.files(data_dir, pattern = '*.txt')

for (filename in filenames){
  paste(data_dir, filename, sep = '/') %>%
    fread() %>%
    dplyr::select(Class, paste0('X', 0:9)) %>%
    fwrite(paste0(mdr_path, 'reformatted-data/', filename), sep = '\t')
}