#!/bin/bash
#SBATCH --job-name=mriqc-apptainer
#SBATCH --error=slurm-%x-%J.err
#SBATCH --output=slurm-%x-%J.out
#SBATCH --requeue
#SBATCH --time=01:00:00
#SBATCH --mem=50G
##SBATCH --account=free
##SBATCH --partition=standard

conda activate datalad

scontrol show job "$SLURM_JOBID" > "$SLURM_JOBID"-info.out
export > "$SLURM_JOBID"/export.out

stdbuf -i0 -o0 -e0 \
	apptainer run --contain \
        --bind "$PWD"/sourcedata/ds004215:/data:ro \
        --bind "$PWD"/derivatives/mriqc/:/out \
        --bind "$PWD"/scratch/mriqc/:/workdir \
	docker://nipreps/mriqc:24.0.2 /data /out \
		participant -w /workdir --no-sub
