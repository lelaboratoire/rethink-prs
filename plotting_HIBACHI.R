setwd("/Users/hoytgong/documents/MooreLab/PRS_GRS/")

library(ggplot2)
library(magrittr)
library(dplyr)
library(tidyr)


scores_df = read.csv("PRS_GRS_scores.csv") 
scores_df %>%
  mutate(category = ifelse(phenotype, 'BC', 'HC')) %>%
  gather('score_type', 'risk_score', 2:3) %>%
  ggplot(aes(x = category, y = risk_score, fill = category)) +
  geom_boxplot() +
  geom_jitter(height = 0, alpha = 0.4) +
  facet_wrap( ~ score_type, scale = 'free_y') +
  theme_bw()

score_plot <- scores_df %>%
  mutate(category = ifelse(phenotype, 'BC', 'HC')) %>%
  gather('score_type', 'risk_score', 2:3)

str(score_plot)

as.factor(scores_df$phenotype)


hcs <- scores_df %>% filter(phenotype == 0)
bcs <- scores_df %>% filter(phenotype == 1)

t.test(hcs$GRS_score, bcs$GRS_score)
t.test(hcs$PRS_score, bcs$PRS_score)




scores_df$category = ifelse(scores_df$phenotype == 0, "HC", "BC")

prs <- ggplot(scores_df, aes(x=category, y=PRS_score)) + 
  geom_boxplot() + labs(title="PRS Plot by Category",x="Subject Category", y = "PRS Score")

grs <- ggplot(scores_df, aes(x=category, y=GRS_score)) + 
  geom_boxplot() + labs(title="GRS Plot by Category",x="Subject Category", y = "GRS Score")




df2 <- data.frame(risk_score = c(scores_df[,"PRS_score"], scores_df[,"GRS_score"]))
df2 = cbind(df2, c(scores_df$category, scores_df$category), c(scores_df$phenotype, scores_df$phenotype), 
            c(scores_df$subject_id, scores_df$subject_id))
temp = rep(c("PRS", "GRS"), times = c(626,626))
df2 = cbind(df2, temp)
names(df2) <- c("risk_score", "category", "phenotype", "subject_id", "score_type")

ggplot(df2, aes(x=score_type, y=risk_score, fill=category)) +
  geom_boxplot() +
  labs(title="Risk Score Plot by Scoring Technique",x="Score Type", y = "Risk Score")



