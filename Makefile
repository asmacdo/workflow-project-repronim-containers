submit-mriqc:
	datalad get -r .
	./code/mriqc-slurm.sh
