#!/bin/bash -l
#SBATCH --job-name=kraken
#SBATCH --account=
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=14:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=4000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config/config.sh

# load tykky environment
export PATH="$TYKKY_KRAKEN:$PATH"

# echo for log
echo "job started"; hostname; date

# run kraken2
FASTQC="$OUT_DIR/qc_host"
KRA_OUT="$OUT_DIR/Kraken"

if [[ ! -d "$KRA_OUT" ]]; then
        mkdir -p $KRA_OUT
fi

export SAMPLE_ID=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`

PAIR1="${SAMPLE_ID}_host_removed_R1_val_1.fq.gz"
PAIR2="${SAMPLE_ID}_host_removed_R2_val_2.fq.gz"

SAMPLE="${SAMPLE_ID}_profiles.txt"
OUTPUT="${SAMPLE_ID}_output.txt"

if [[ -f "$OUT_DIR/$SAMPLE" ]]; then
	echo "$OUT_DIR/$SAMPLE already done."
else 
	kraken2 --paired --db $DBNAME --report $KRA_OUT/$SAMPLE $FASTQC/$PAIR1 $FASTQC/$PAIR2
fi

# run Braken
OUT_BRA="$OUT_DIR/braken"
if [[ ! -d "$OUT_BRA" ]]; then
        mkdir -p $OUT_BRA
fi

if [[ -f "$OUT_BRA/$SAMPLE" ]]; then
      echo "$OUT_BRA/$SAMPLE already done."
else
	bracken -d $DBNAME -i $KRA_OUT/$SAMPLE -o $OUT_BRA/$SAMPLE -r 150 -l S 
fi

# echo for log
echo "job finished;"; date


