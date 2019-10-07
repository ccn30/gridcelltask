#!/bin/bash
# script to merge all resliced topup corrected EPIs

pathstem="/lustre/scratch/wbic-beta/ccn30/ENCRYPT"
subjects_to_process=(0 1 2 3 4 5 6 7 8 9 10 11)
series_to_process=("NA" "Run_2iso30_nopads" "Run_1.5iso30_nopads" "Run_1.5x1_nopads" "Run_1isoSB_nopads" "Run_1isoMB_nopads" "Run_1.5iso0_nopads" "Run_1.5iso90_nopads" "X" "Y" "Run_1.5iso30_PADS" "Run_1.5iso0_PADS")

for this_subj in ${subjects_to_process[@]}
do
	#echo 'NEXT processing '${subjects_to_process[$this_subj]}
	cd ${pathstem}"/preprocessed_images_29273_"$( printf '%01d' ${subjects_to_process[$this_subj]})
	pwd
	#echo 'Converting' ${series_to_process[$this_subj]} 'in folder preprocessed_images_29273_'$( printf '%01d' ${subjects_to_process[$this_subj]})
	#fslmerge -t rtopup_${series_to_process[$this_subj]}.nii rtopup_${series_to_process[$this_subj]}_split*.nii
	FILE=${pathstem}'/preprocessed_images_29273_'$( printf '%01d' ${subjects_to_process[$this_subj]})'/rtopup_'${series_to_process[$this_subj]}'.nii'
	echo "$FILE"
	v=`dirname ${FILE}`	
	if [ -f "$FILE" ]; then
		echo "${V}"
	fi
done
