library(dplyr)
library(data.table)

mdr_path <- here::here('mb-mdr/')

sim1 <- fread(
  'simulated-data/hibachi-res_BernoulliNB_DecisionTreeClassifier-s690_0.098.txt'
  ) %>%
  select(Class, paste0('X', 0:9)) %>%
  fwrite(paste0(mdr_path, 'sim1.txt'), sep = '\t')
