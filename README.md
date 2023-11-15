# Taxonomy_Functional_HPCpipeline
Parrallel pipeline for HPC (Slurm scheduler) for the QC, taxonomic annotation and functional profiling of WGS metagenomes

## Requirements
This pipeline uses the following tools:
- bowtie2 version 2.5.1
- trim_galore version 0.6.10
- Kraken2 version 2.1.3
- Bracken version 2.8
- Humann3 version 3.0.1

## Installation and database download
Use the script in config/installation to install the required tools and download the necessary databases.

## Run the script
Edit the config.sh file with the following parameters:

- TYKKY_QC="/path/to/bin:$PATH"
- TYKKY_KRAKEN="/path/to/bin:$PATH"
- IN_LIST="/path/to/list.txt"
- IN_DIR="/path/to/input/directory"
- OUT_DIR="/path/to/output/directory"
- HUM_DB="/path/to/humangenome/GRCh38_noalt_as"
- DBNAME="/path/to/database/k2_Humgut"
- HU3_DB="/path/to/database/Humann3"
- MET_DB="/path/to/database/Metaphlan"

Provide the list of samples to process in the IN_LIST parameter.

Run the submission scripts: 

```
./1_run_QC.sh # submit QC and human filtering jobs as an array
./2_Run_Kraken.sh # submit Kraken2 and Bracken profiling jobs as an array
./3_Run_Humann3.sh # submit Humann3 profiling jobs as an array
```
