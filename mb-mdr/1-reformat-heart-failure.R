library(dplyr)

set.seed(0)

my_dat <- paste('data/heartFailure.txt', sep = '/') %>%
  data.table::fread(sep = '\t',  quote = '') %>% 
  dplyr::select(- eid, - array) %>%
  dplyr::rename(PHENOTYPE = class) %>%
  mutate_at(vars(matches("rs")), round)

n_train <- floor(0.8*nrow(my_dat))
train_idx <- sample.int(nrow(my_dat), size = n_train, replace = F)

data.table::fwrite(my_dat[train_idx, ], 'data/reformat_heart_failure_train.txt', sep = '\t')
data.table::fwrite(my_dat[- train_idx, ], 'data/reformat_heart_failure_test.txt', sep = '\t')