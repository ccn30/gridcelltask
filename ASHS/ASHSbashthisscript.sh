#!/bin/bash
# submit ASHS to slurm

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
scriptdir=${pathstem}/scripts/ASHS
submit=${scriptdir}/ASHS_sba.sh

# separate txt file with subject and date IDs are listed
#!mysubjs=${pathstem}/master_subjsdeflist.txt
mysubjs=${pathstem}/mysubjs_deflist.txt
# this script must be called from ASHS script dir where a slurmoutputs folder must be
cd slurmoutputs

for subjID in `cat $mysubjs`
do
	echo "Submitting ASHS segmentation of:	$subjID"
	sbatch ${submit} ${scriptdir} ${pathstem} ${subjID}
done

#-----old directives below for future ref-----#

#!module unload matlab/matlab2016a    
#!module load matlab/matlab2017b
#!module load freesurfer/6.0.0
#!module load spm/spm12_6906
#!module load ASHS_1.0.0
#!module load ANTS/2.2.0

#!	declare -a mysubjs=("27734/20190902_U-ID46027
#!	28061/20190911_U-ID46160
#!	29317/20190902_U-ID46030
#!	29321/20190902_U-ID46038
#!	29332/20190903_U-ID46058
#!	29336/20190903_U-ID46066
#!	29358/20190905_U-ID46106
#!	29382/20190911_U-ID46164
#!	29383/20190912_U-ID46168"
#!	);
