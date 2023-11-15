
### Kraken-Braken installation
# creating tykky container for Kraken and braken
TYKKY_DIR="" # folder path for the installation of the containers

module purge
module load tykky
mkdir Kraken_Braken
conda-containerize new --prefix Kraken_Braken kraken_braken.yml

## HumGut database download
# direct download from https://arken.nmbu.no/~larssn/humgut/

### Bowtie2 and trim-galore installation
# creating tykky container for QC tools

module purge
module load tykky
mkdir QC_tools
conda-containerize new --prefix QC_tools QC_env.yml

## Human genome download
# Download the bowtie2 database for the human genome from https://genome-idx.s3.amazonaws.com/bt/GRCh38_noalt_as.zip

### Humann3 installation
# Humann3 and Metaphlan are available on Puhti modules
# https://docs.csc.fi/apps/metaphlan/
# https://docs.csc.fi/apps/humann/

## Database download
DB_DIR="../../databases"
mkdir -p $DB_DIR/Humann3
module load humann
humann_databases --download chocophlan full $DB_DIR/Humann3 
humann_databases --download uniref uniref90_diamond $DB_DIR/Humann3

module load metaphlan
mkdir Metaphlan
metaphlan --install --bowtie2db $DB_DIR/Metaphlan

