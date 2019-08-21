
- [`1-reformat-data.R`](mb-mdr/1-reformat-data.R) is the R script that preps datasets in [`simulated-data`](simulated-data) for MB-MDR runs.
It writes the reformated train/test datasets in [`reformatted-data/`](mb-mdr/reformatted-data/).

- [`2-run-mb-mdr.sh`](mb-mdr/2-run-mb-mdr.sh) executes [`mbmdr-4.4.1-mac-64bits.out`](mb-mdr/mbmdr-4.4.1-mac-64bits.out) --- the MBMDR-4.4.1 software that can be downloaded [here](http://bio3.giga.ulg.ac.be/index.php/software/mb-mdr/) --- and writes results to [`mb-mdr/results/`](mb-mdr/results/).
There are two result files per dataset: `output` that contains the SNP combinations and their corresponding statistics and `model` that contains the HLO matrices of all SNP combinations.

- The `3*.Rmd` files parse the MB-MDR results in [`mb-mdr/results/`](mb-mdr/results/), compute the multilocus risk scores (MRS) and write them to [`mb-mdr/risks/`](mb-mdr/risks/).
`kd` indicates k-way interactions within the SNP combinations.

- [`mb-mdr/documentation/`](mb-mdr/documentation/) contains documentation and papers related to the MB-MDR software.
