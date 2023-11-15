#!/bin/bash -l
#SBATCH --job-name=qc_humanfilt
#SBATCH --account=
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=10:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config/config.sh

# load environment
export PATH="$TYKKY_QC:$PATH"

# echo for log
echo "job started"; hostname; date

# go to folder
cd $IN_DIR 

QC_OUT_DIR=$OUT_DIR/qc_host

if [[ ! -d "$QC_OUT_DIR" ]]; then
        mkdir -p $QC_OUT_DIR
fi

# read sample to process
export SAMPLE_ID=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`

PAIR1="${SAMPLE_ID}_R1_001.fastq.gz"
PAIR2="${SAMPLE_ID}_R2_001.fastq.gz"

# run Bowtie2 for human read removal
BOWTIE_NAME="$QC_OUT_DIR/${SAMPLE_ID}_host_removed_R%.fastq.gz"
SAM_NAME="$QC_OUT_DIR/${SAMPLE_ID}_host.sam"
MET_NAME="$QC_OUT_DIR/${SAMPLE_ID}_hostmap.log"

echo "bowtie2 -p 8 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME"
bowtie2 -p 8 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME

rm $SAM_NAME

## Paired-end Illumina
trim_galore --paired -o $QC_OUT_DIR --fastqc $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz

rm $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz
rm $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz

# echo for log
echo "job done"; date
