#!/bin/bash -l
#SBATCH --job-name=mriqc-apptainer
#SBATCH --error=derivatives/mriqc/logs/slurm-%x-%J.err
#SBATCH --output=derivatives/mriqc/logs/slurm-%x-%J.out
#SBATCH --requeue
#SBATCH --time=01:00:00
#SBATCH --mem=50G
##SBATCH --account=free
##SBATCH --partition=standard

conda activate datalad

scontrol show job "$SLURM_JOBID" > derivatives/mriqc/logs/"$SLURM_JOBID"-info.out
export DUCT_OUTPUT_PREFIX="derivatives/mriqc/logs/duct_"
export > derivatives/mriqc/logs/"$SLURM_JOBID"-exports.out

# TODO is input data bind ro?
# TODO assuming containers-run is binding ., workdir is relative
# TODO do we need: stdbuf -i0 -o0 -e0 \

# --no-sub prevents MRIQC default attempt to upload anonymized quality metrics
datalad containers-run \
	-n bids-mriqc \
	--input sourcedata/ds004215 \
	--output derivatives/mriqc \
	'{inputs}' '{outputs}' participant group -w scratch/mriqc --no-sub
