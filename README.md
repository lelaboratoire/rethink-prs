# Multilocus Risk Scores

This repository contains detailed simulation and analysis code needed to reproduce the results in this study:

**Expanding polygenic risk scores to include automatic genotype encodings and gene-gene interactions**.
Trang T. Le, Hoyt Gong, Patryk Orzechowski, Elisabetta Manduchi, Jason H. Moore.
In preparation.

## Simulated data
Simulated datasets are in [`simulated-data`](simulated-data).

The primary objective of this data simulation process was to provide a comprehensive set of reproducible and diverse datasets for the current study.
Containing 1000 individuals and 10 SNPs, each dataset was generated in the following manner.
For an individual, each genotype was randomly assigned with 1/2 probability of being heterozygous (*Aa*, coded as `1`), 1/4 probability of being homozygous major (*AA*, coded as `0`) and 1/4 probability of being homozygous minor (*aa*, coded as `2`).
The binary endpoint for the data was determined using a recently proposed evolutionary-based method for dataset generation called Heuristic Identification of Biological Architectures for simulating Complex Hierarchical Interactions (HIBACHI) [@doi:10.1142/9789813235533_0024].
This method uses Genetic Programming (GP) to build different mathematical and logical models resulting in a binary endpoint, such that the objective function called fitness is maximized. 
The unique feature of HIBACHI is explainability, as each generated model represents a formula for generating the endpoint. 
In this study, to arrive at a diverse collection of datasets, we aim to maximize the difference in predictive performance of all pairs of ten pre-selected classifiers from the extensive library of scikit-learn [@url:https://hal.archives-ouvertes.fr/hal-00650905/] (Table 1).
Therefore, we define the fitness function of HIBACHI as the difference in accuracy between two classifiers. In other words, the first classifier was supposed to perform as well as possible on the data while the second as bad as possible.

Table 1. Selected machine learning methods and their parameters.

| Algorithm      |                             Parameters                                         |
|:--------------:|:------------------------------------------------------------------------------:|
| GaussianNB     |'priors': {None,2}, 'var_smoothing': {1e-9, 1e-7, 1e-5, 1e-3, 1e-1, 1e+1}       |
| BernoulliNB    |'alpha': {1e-3, 1e-2, 1e-1, 1., 10., 100.},'fit_prior': {True, False}           |
| DecisionTree   |'criterion': {"gini", "entropy"}, 'max_depth': [1, 11], 'min_samples_split': [2, 21], 'min_samples_leaf': [1, 21]|
|ExtraTrees      |'n_estimators': {50,100}, 'criterion': {"gini", "entropy"},'max_features': [0.1, 1], 'min_samples_split': range(2, 21,2),'min_samples_leaf': range(1, 21,2), 'bootstrap': {True, False}|
|RandomForest    |'n_estimators': {50,100}, 'criterion': {"gini", "entropy"},'max_features': [0.1, 1], 'min_samples_split': range(2, 21,4), 'min_samples_leaf':  range(1, 21,5), 'bootstrap': {True, False}                 |
|GradientBoosting|  'n_estimators': {50,100},'learning_rate': {1e-3, 1e-2, 1e-1, 0.5, 1}, 'max_depth': {2,4,8}, 'min_samples_split': [2, 21], 'min_samples_leaf': [1, 21], 'subsample': [0.1, 1], 'max_features': [0.1, 1]|
|KNeighbors      |'n_neighbors': [1, 100], 'weights': {"uniform", "distance"} , 'p': {1, 2}   |
|LogisticRegression| 'C': {1e-3, 1e-2, 1e-1, 1., 10.}, 'solver' : {'newton-cg', 'lbfgs', 'liblinear', 'sag'}|
|XGBoost     | 'n_estimators'=100, 'max_depth': [2, 10], 'learning_rate': {1e-3, 1e-2, 1e-1, 0.5, 1.}, 'subsample': [0.05, 1], 'min_child_weight': [1, 20],
|MLPClassifier |: 'hidden_layer_sizes': {(10),(11),(12),(13),(14),(15),(10,5)},  'activation': {'logistic','tanh','relu'}, 'solver': ['lbfgs'], 'learning_rate': {'constant','invscaling'}, 'max_iter'=1000, 'alpha':np.logspace(-4,1,4)|

HIBACHI was run for 50 iterations with population of 500 individuals representing pairs of classifiers.
At each iteration, five randomly chosen settings for each of the classifiers (Table 1) were chosen among all potential options and served as hyperparameters for that method.
Each of the settings was analyzed using 5-fold cross-validation and the best set of hyperparameters for each classifier was considered for comparison. 
The best settings out of 5 for each classifiers were compared and the settings that maximized the difference in the fitness were promoted.
Each experiment in which one machine learning method was expected to outperform the other was repeated five times.
The results of each pair of classifiers were later averaged.