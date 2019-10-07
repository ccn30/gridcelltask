#!/bin/bash
# script to calculate tSNR images of preprocessed EPIS and then create tSNR maps using EC masks

pathstem="/lustre/scratch/wbic-beta/ccn30/ENCRYPT"
maskdir="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/Segmentation/29273/epimasks"

subjects_to_process=(0 1 2 3 4 5 6 7 8 9 10 11)
series_to_process=("null" "Run_2iso30_nopads" "Run_1.5iso30_nopads" "Run_1.5x1_nopads" "Run_1isoSB_nopads" "Run_1isoMB_nopads" "Run_1.5iso0_nopads" "Run_1.5iso90_nopads" "null" "null" "Run_1.5iso30_PADS" "Run_1.5iso0_PADS")

#**************************************
# calculate tSNR maps for whole EPIs (after topup and reslice)
#for this_subj in ${subjects_to_process[@]}
#do
	#echo 'NEXT tSNR for series '${subjects_to_process[$this_subj]}
	#cd ${pathstem}"/preprocessed_images_29273_"$( printf '%01d' ${subjects_to_process[$this_subj]})
	#pwd
	
	#echo 'Calculating MEAN of' ${series_to_process[$this_subj]} 'in folder preprocessed_images_29273_'$( printf '%01d' ${subjects_to_process[$this_subj]})
	#fslmaths rtopup_${series_to_process[$this_subj]}.nii -Tmean MEANrtopup_${series_to_process[$this_subj]}.nii
	#MEAN=${pathstem}"/preprocessed_images_29273_"$( printf '%01d' ${subjects_to_process[$this_subj]})"/MEANrtopup_"${series_to_process[$this_subj]}".nii"	
		#if [ -f $MEAN ]; then
			#echo $MEAN
		#else
			#echo FAILURE
		#fi
	#echo 'Calculating STD of' ${series_to_process[$this_subj]}
	#fslmaths rtopup_${series_to_process[$this_subj]}.nii -Tstd STDrtopup_${series_to_process[$this_subj]}.nii
	#echo 'Calculating tSNR of' ${series_to_process[$this_subj]}
	#fslmaths MEANrtopup_${series_to_process[$this_subj]}.nii -div STDrtopup_${series_to_process[$this_subj]}.nii tSNRrtopup_${series_to_process[$this_subj]}.nii
#done

#****************************************
# apply EC masks to tSNR maps
cd ${pathstem}"/preprocessed_images_29273_"$( printf '%01d' ${subjects_to_process[$this_subj]})
for this_subj in ${subjects_to_process[@]}
do
	echo 'NEXT making EC tSNR maps for series '${subjects_to_process[$this_subj]}
	cd ${pathstem}"/preprocessed_images_29273_"$( printf '%01d' ${subjects_to_process[$this_subj]})
	pwd
	fslmaths tSNRrtopup_${series_to_process[$this_subj]}.nii -mas ${maskdir}/leftECmask_${series_to_process[$this_subj]}.nii leftEC_tSNR_${series_to_process[$this_subj]}.nii
	if [ $? -eq 0 ]; then
    		echo >> leftEC tSNR image COMPLETE	
	else
    		echo >> leftEC tSNR image FAIL
	fi
	fslmaths tSNRrtopup_${series_to_process[$this_subj]}.nii -mas ${maskdir}/rightECmask_${series_to_process[$this_subj]}.nii rightEC_tSNR_${series_to_process[$this_subj]}.nii
	if [ $? -eq 0 ]; then
    		echo >> rightEC tSNR image COMPLETE	
	else
    		echo >> rightEC tSNR image FAIL
	fi
done
