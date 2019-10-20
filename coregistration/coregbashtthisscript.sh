#!/bin/bash
#! submit coregistration to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
scriptdir=${pathstem}/scripts/coregistration

submit=${scriptdir}/coreg_submit.sh
mysubjs=${pathstem}/master_subjsdeflist.txt
#!subjID=27734/20190902_U-ID46027

cd slurmoutputs

for subjID in `cat $mysubjs`
do
	echo "ANTS coregistration of:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID}
done
	
