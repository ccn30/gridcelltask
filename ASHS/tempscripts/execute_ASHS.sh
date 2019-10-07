#!/bin/bash

# Everything should run from the this script but it depends on the contents of a txt file of scanIDs
# My data was organised craply in one directory with scanID_T1 scanID_T2 in directory ASHS_data. I wouldn't advise this - organise your data better than I did.
# But the output is organised nicely into participant directories.
# This code should be easy enough to adapt to your format (in the -g -f options in ASHS_sba.sh)


# I've changed some of this for readability and to be slightly more flexible. I apologise if there are syntax errors. Definitely worth testing on one ppts scan first.

# Change me 
export workDir=/lustre/scratch/wbic-beta/dh525/ashs-fastash_beta

#prerequisite: create a list of file names without specifying scan name e.g. scanID. Child scripts call scanID_T1.nii.gz etc so should be basename ONLY.

fileList=${workDir}/ASHS_File_list.txt

for ppt in `cat $fileList`; do 
	export ppt 
	echo "ASHS processing via SLURM:	$ppt"

	sbatch /home/dh525/Desktop/scratch/ASHS_sba.sh ${i}
done
