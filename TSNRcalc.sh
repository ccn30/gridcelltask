#!/bin/bash
# script to calculate tSNR images of preprocessed EPIS and then create tSNR maps using EC masks

fsldir=/applications/fsl/fsl-5.0.10/bin
pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
mysubjs=${pathstem}/master_subjsdeflist.txt

for subject in `cat $mysubjs`
do	
	subj="$(cut -d'/' -f1 <<<"$subject")"	
	bilateralmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/bothECmaskWarped_ITKaffine.nii
	leftECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/LeftECmaskWarped_ITKaffine.nii
	rightECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/RightECmaskWarped_ITKaffine.nii
	epi=${pathstem}/preprocessed_data/images/old_data/${subj}/rtopup_Run_1.nii
	tsnr=${pathstem}/preprocessed_data/images/old_data/${subj}/tSNR
	
	mkdir $tsnr

	echo 'NEXT mean for '$subj
	meanepi=${tsnr}/meanepi.nii
	${fsldir}/fslmaths $epi -Tmean $meanepi
	echo 'NEXT sd for '$subj
	sdepi=${tsnr}/sdepi.nii
	${fsldir}/fslmaths $epi -Tstd $sdepi
	echo 'NEXT tSNR for '$subj
	tSNRepi=${tsnr}/tSNR_epi_${subj}.nii	
	${fsldir}/fslmaths $meanepi -div $sdepi $tSNRepi

	# apply EC masks to tSNR maps
	echo 'NEXT bilateral EC extraction for '$subj
	${fsldir}/fslmaths $tSNRepi -mas $bilateralmask $tsnr/Bilateral_tSNR_${subj}.nii
	if [ $? -eq 0 ]; then
    		echo >> bilateralEC tSNR image COMPLETE	
	else
    		echo >> bilateral EC tSNR image FAIL
	fi
	
	echo 'NEXT left EC extraction for '$subj
	${fsldir}/fslmaths $tSNRepi -mas $leftECmask $tsnr/Left_tSNR_${subj}.nii
	if [ $? -eq 0 ]; then
    		echo >> leftEC tSNR image COMPLETE	
	else
    		echo >> left EC tSNR image FAIL
	fi
	
	echo 'NEXT right EC extraction for '$subj
	${fsldir}/fslmaths $tSNRepi -mas $rightECmask $tsnr/Right_tSNR_${subj}.nii
	if [ $? -eq 0 ]; then
    		echo >> rightEC tSNR image COMPLETE	
	else
    		echo >> right EC tSNR image FAIL
	fi

done
