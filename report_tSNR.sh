#!/bin/bash
# script to calculate tSNR images of preprocessed EPIS and then create tSNR maps using EC masks

fsldir=/applications/fsl/fsl-5.0.10/bin
pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
mysubjs=${pathstem}/master_subjsdeflist.txt

#subj='27734'
for subject in `cat $mysubjs`
do	
	subj="$(cut -d'/' -f1 <<<"$subject")"
	tsnrdir=${pathstem}/preprocessed_data/images/old_data/${subj}/tSNR
	#lefttSNR=$tsnr/Left_tSNR_${subj}.nii
	#righttSNR=$tsnr/Right_tSNR_${subj}.nii
	#bilateraltSNR=$tsnr/Bilateral_tSNR_${subj}.nii	
	leftECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/LeftECmaskWarped_ITKaffine.nii
	rightECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/RightECmaskWarped_ITKaffine.nii
	tSNRepi=${tsnrdir}/tSNR_epi_${subj}.nii
	echo 'Left stats for: '$subj
	${fsldir}/fslstats $tSNRepi -k $leftECmask -v -V -m -s -M -S -r -R
	echo 'Done.'
	echo 'Right stats for: '$subj
	${fsldir}/fslstats $tSNRepi -k $rightECmask -v -V -m -s -M -S -r -R
	echo 'Done.'
done
