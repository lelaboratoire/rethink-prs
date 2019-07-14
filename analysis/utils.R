## Define some utility functions

sub_name <- function(filetype, my_file){
  gsub('.txt', glue::glue('_{filetype}.txt'), my_file)
}

read_risks <- function(filetype, my_file){
  fread(here('mb-mdr', 'risks', sub_name(filetype, filename)))
}

my_t_test <- function(var){
  t.test(x = cases[, var], y = ctrls[, var], 'greater', paired = TRUE) %>%
    broom::tidy() %>%
    select(statistic, p.value)
}

risktype_recode <- function(prefix = 'prs', x){
  fct_recode(x, 
             PRS = paste0(prefix, '_ori'),
             `MRS1` = paste0(prefix, '_1d'), 
             `MRS2` = paste0(prefix, '_2d'), 
             `MRS3` = paste0(prefix, '_3d'),
             `MRS` = paste0(prefix, '_12d'))
}

roc_func <- function(risk_type){
  PRROC::roc.curve(scores.class0 = all_risks[, risk_type],
                   weights.class0 = all_risks$Class,
                   curve = T)
}

pr_func <- function(risk_type){
  tryCatch(
    PRROC::pr.curve(scores.class0 = all_risks[, risk_type],
                    weights.class0 = all_risks$Class,
                    curve = T),
    error = function(c) NA)
}

get_auroc <- function(x, risktype){
  tryCatch(x[[risktype]]$auc,
           error = function(c) NA)
}

get_auprc <- function(x, risktype){
  tryCatch(x[[risktype]]$auc.integral,
           error = function(c) NA)
}

get_roc_curve <- function(var, varname){
  df <- as.data.frame(roci[[var]]$curve)
  df$type <- varname
  df
}

get_pr_curve <- function(var, varname){
  df <- as.data.frame(pri[[var]]$curve)
  df$type <- varname
  df
}

read_info <- function(filename, col_val = 'value'){
  # read in information gain files
  read_csv(
    here('results', filename), 
    col_names = c('filenames', col_val)) %>%
    left_join(rownames_to_column(tibble(filenames), 'dataset'), by = 'filenames') 
}

