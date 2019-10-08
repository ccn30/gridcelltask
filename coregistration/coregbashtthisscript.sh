#!/bin/bash
#! submit coregistration to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
scriptdir=${pathstem}/scripts/coregistration

submit=${scriptdir}/coreg_submit.sh
mysubjs=${pathstem}/mysubjs_deflist.txt

cd slurmoutputs

for subjID in `cat $mysubjs`
do
	echo "Coregistration of:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID}
done
	
