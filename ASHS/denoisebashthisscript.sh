#!/bin/bash
# submit ASHS to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
scriptdir=${pathstem}/scripts/ASHS
submit=${scriptdir}/denoise_submit.sh

# separate txt file with subject and date IDs are listed
mysubjs=${pathstem}/mysubjs_deflist.txt

# this script must be called from ASHS script dir where a slurmoutputs folder must be
cd slurmoutputs

for subjID in `cat $mysubjs`
do
	echo "Submitting whole T1 denoising of:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID}
done
