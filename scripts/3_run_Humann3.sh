#!/bin/bash
#SBATCH --job-name=humann
#SBATCH --account=
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=4000

# load job configuration
cd $SLURM_SUBMIT_DIR
source config/config.sh

# echo for log
echo "job started"; hostname; date

# Get sample ID
FASTQC="/scratch/project_2004512/temp/Ching_FMT/qc_host"
HUM_OUT="$OUT_DIR/Humann3"

if [[ ! -d "$HUM_OUT" ]]; then
        mkdir -p $HUM_OUT
fi

HUM_MET_OUT="$OUT_DIR/Humann3/Metaphlan"

if [[ ! -d "$HUM_MET_OUT" ]]; then
        mkdir -p $HUM_MET_OUT
fi

export SAMPLE_ID=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`

PAIR1="${SAMPLE_ID}_host_removed_R1_val_1.fq.gz"
PAIR2="${SAMPLE_ID}_host_removed_R2_val_2.fq.gz"

# run metaphlan first because this thing is stupid
#metaphlan $FASTQC/$PAIR1 --input_type fastq -o $HUM_MET_OUT/${SAMPLE_ID}_profile.txt -x mpa_vOct22_CHOCOPhlAnSGB_202212 --bowtie2db $MET_DB

#run humann
module load humann
module load metaphlan
humann --input $FASTQC/${PAIR1} --output $HUM_OUT --nucleotide-database $HU3_DB/chocophlan --protein-database $HU3_DB/uniref
#rm -r "${SMPLE%%.fq.gz}_humann_temp"

echo "Finished `date`"
