#!/bin/bash
# script to calculate tSNR images of preprocessed EPIS and then create tSNR maps using EC masks

fsldir=/applications/fsl/fsl-5.0.10/bin
pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
mysubjs=${pathstem}/mysubjs_deflist.txt

for subject in `cat $mysubjs`
do	
	subj="$(cut -d'/' -f1 <<<"$subject")"
	tsnrdir=${pathstem}/preprocessed_data/images/${subj}/tSNR
	leftECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/LeftECmaskWarped_ITKaffine.nii
	rightECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/ManualEC_right.nii.gz
	tSNRepi1=${tsnrdir}/tSNR_epi_run1.nii
	tSNRepi2=${tsnrdir}/tSNR_epi_run2.nii	
	tSNRepi3=${tsnrdir}/tSNR_epi_run3.nii
	cd ${tsnrdir}	

	echo 'Left stats for: '$subj
	${fsldir}/fslstats $tSNRepi1 -k $leftECmask -v -V -m -s -M -S -r -R -h 20
	echo 'run 2'
	${fsldir}/fslstats $tSNRepi2 -k $leftECmask -v -V -m -s -M -S -r -R -h 20
	echo 'run 3'
	${fsldir}/fslstats $tSNRepi3 -k $leftECmask -v -V -m -s -M -S -r -R -h 20
	echo 'Done.'
	echo 'Right stats for: '$subj
	${fsldir}/fslstats $tSNRepi1 -k $rightECmask -v -V -m -s -M -S -r -R -h 20
	echo 'run 2'
	${fsldir}/fslstats $tSNRepi2 -k $rightECmask -v -V -m -s -M -S -r -R -h 20
	echo 'run 3'
	${fsldir}/fslstats $tSNRepi3 -k $rightECmask -v -V -m -s -M -S -r -R -h 20
	echo 'Done.'
done
