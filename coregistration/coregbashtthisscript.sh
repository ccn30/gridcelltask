#!/bin/bash
#! submit coregistration to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
scriptdir=${pathstem}/scripts/coregistration

submit=${scriptdir}/coreg_submit.sh
#!mysubjs=${pathstem}/mysubjs_deflist.txt
subjID=27734/20190902_U-ID46027

cd slurmoutputs

#!for subjID in `cat $mysubjs`
#!do
	echo "Coregistration of:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID}
#!done
	
