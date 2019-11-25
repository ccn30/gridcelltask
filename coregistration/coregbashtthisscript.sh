#!/bin/bash
#! submit coregistration to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
scriptdir=${pathstem}/scripts/coregistration

submit=${scriptdir}/coreg_submit.sh
#!submit2=${scriptdir}/coreg_2_submit.sh
mysubjs=${pathstem}/master_subjsdeflist.txt
#!subjID=29382/20190911_U-ID46164
#!mysubjs=${pathstem}/mysubjs_deflist.txt

cd slurmoutputs

for subjID in `cat $mysubjs`
do
	echo "ANTS coregistration of:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID}
	#!sbatch ${submit2} ${scriptdir} ${pathstem} ${subjID}
done	
