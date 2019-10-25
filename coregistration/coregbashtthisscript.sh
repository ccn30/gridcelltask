#!/bin/bash
#! submit coregistration to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
scriptdir=${pathstem}/scripts/coregistration

submit=${scriptdir}/coreg_submit.sh
#!submit2=${scriptdir}/coreg_2_submit.sh
mysubjs=${pathstem}/master_subjsdeflist.txt
#!subjID=29336/20190903_U-ID46066
#!mysubjs=${pathstem}/mysubjs_deflist.txt

cd slurmoutputs

for subjID in `cat $mysubjs`
do
	echo "ANTS coregistration of:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID}
	#!sbatch ${submit2} ${scriptdir} ${pathstem} ${subjID}
done	
