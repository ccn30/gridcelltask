#!/bin/bash
# script to calculate tSNR images of preprocessed EPIS and then create tSNR maps using EC masks

fsldir=/applications/fsl/fsl-5.0.10/bin
pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/fMRI/gridcellpilot
mysubjs=${pathstem}/mysubjs_deflist.txt

for subject in `cat $mysubjs`
do	
	subj="$(cut -d'/' -f1 <<<"$subject")"	
	bilateralmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/pmEC_bothWarped_ITKaffine.nii
	leftpmECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/pmEC_leftWarped_ITKaffine.nii
	rightpmECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/pmEC_rightWarped_ITKaffine.nii
	leftalECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/alEC_leftWarped_ITKaffine.nii
	rightalECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/alEC_rightWarped_ITKaffine.nii
	epirun1=${pathstem}/preprocessed_data/images/old_data/${subj}/rtopup_Run_1.nii
	epirun2=${pathstem}/preprocessed_data/images/old_data/${subj}/rtopup_Run_2.nii
	epirun3=${pathstem}/preprocessed_data/images/old_data/${subj}/rtopup_Run_3.nii	
	tsnr=${pathstem}/preprocessed_data/images/old_data/${subj}/tSNR
	
	mkdir $tsnr
	
	# make tSNR images
	echo 'NEXT mean for '$subj
	meanepi1=${tsnr}/meanepi_run1.nii
	meanepi2=${tsnr}/meanepi_run2.nii
	meanepi3=${tsnr}/meanepi_run3.nii
#!	${fsldir}/fslmaths $epirun1 -Tmean $meanepi1
#!	${fsldir}/fslmaths $epirun2 -Tmean $meanepi2
#!	${fsldir}/fslmaths $epirun3 -Tmean $meanepi3
	echo 'NEXT sd for '$subj
	sdepi1=${tsnr}/sdepi_run1.nii
	sdepi2=${tsnr}/sdepi_run2.nii
	sdepi3=${tsnr}/sdepi_run3.nii
#!	${fsldir}/fslmaths $epirun1 -Tstd $sdepi1
#!	${fsldir}/fslmaths $epirun2 -Tstd $sdepi2
#!	${fsldir}/fslmaths $epirun3 -Tstd $sdepi3
	echo 'NEXT tSNR for '$subj
	tSNRepi1=${tsnr}/tSNR_epi_run1.nii
	tSNRepi2=${tsnr}/tSNR_epi_run2.nii	
	tSNRepi3=${tsnr}/tSNR_epi_run3.nii		
#!	${fsldir}/fslmaths $meanepi1 -div $sdepi1 $tSNRepi1
#!	${fsldir}/fslmaths $meanepi2 -div $sdepi2 $tSNRepi2
#!	${fsldir}/fslmaths $meanepi3 -div $sdepi3 $tSNRepi3

	echo 'NEXT left EC extraction for '$subj
	${fsldir}/fslmaths $tSNRepi1 -mas $leftECmask $tsnr/Left_tSNR_run1.nii
	${fsldir}/fslmaths $tSNRepi2 -mas $leftECmask $tsnr/Left_tSNR_run2.nii
	${fsldir}/fslmaths $tSNRepi3 -mas $leftECmask $tsnr/Left_tSNR_run3.nii

	if [ $? -eq 0 ]; then
    		echo >> leftEC tSNR image COMPLETE	
	else
    		echo >> left EC tSNR image FAIL
	fi
	
	echo 'NEXT right EC extraction for '$subj
	${fsldir}/fslmaths $tSNRepi1 -mas $rightECmask $tsnr/Right_tSNR_run1.nii
	${fsldir}/fslmaths $tSNRepi2 -mas $rightECmask $tsnr/Right_tSNR_run2.nii
	${fsldir}/fslmaths $tSNRepi3 -mas $rightECmask $tsnr/Right_tSNR_run3.nii

	if [ $? -eq 0 ]; then
    		echo >> rightEC tSNR image COMPLETE	
	else
    		echo >> right EC tSNR image FAIL
	fi

done
