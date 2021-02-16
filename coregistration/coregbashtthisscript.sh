#!/bin/bash
#! submit coregistration to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/fMRI/gridcellpilot
scriptdir=${pathstem}/scripts/coregistration

submit=${scriptdir}/coreg_submit.sh
func=${scriptdir}/coreg_MasksxEPI.sh
mysubjs=${pathstem}/master_subjsdeflist.txt

cd slurmoutputs

for subjID in `cat $mysubjs`
do
	echo "Mask warping for:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID} ${func}
	#!sbatch ${submit2} ${scriptdir} ${pathstem} ${subjID}
done	
