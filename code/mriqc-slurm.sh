#!/bin/bash
#SBATCH --job-name=mriqc-apptainer
#SBATCH --error=slurm-%x-%J.err
#SBATCH --output=slurm-%x-%J.out
#SBATCH --requeue
#SBATCH --time=01:00:00
#SBATCH --mem=50G
##SBATCH --account=free
##SBATCH --partition=standard

# Always execute from the root of the repo
cd $(dirname "$0")/..

conda activate datalad

scontrol show job "$SLURM_JOBID" > "$SLURM_JOBID"-info.out
export > "$SLURM_JOBID"/export.out

# TODO is input data bind ro?
# TODO assuming containers-run is binding ., workdir is relative
# TODO do we need: stdbuf -i0 -o0 -e0 \

# --no-sub prevents MRIQC default attempt to upload anonymized quality metrics
datalad containers-run \
	-n bids-mriqc \
	--input sourcedata/ds004215 \
	--output derivatives/mriqc \
	'{inputs}' '{outputs}' participant group -w scratch/mriqc --no-sub
