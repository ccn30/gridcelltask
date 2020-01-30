#!/bin/bash
# script to calculate tSNR images of preprocessed EPIS and then create tSNR maps using EC masks

fsldir=/applications/fsl/fsl-5.0.10/bin
pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
mysubjs=${pathstem}/master_subjsdeflist.txt

for subject in `cat $mysubjs`
do	
	subj="$(cut -d'/' -f1 <<<"$subject")"
	tsnrdir=${pathstem}/preprocessed_data/images/old_data/${subj}/tSNR
	bilateralmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/pmEC_bothWarped_ITKaffine.nii
	leftpmECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/pmEC_leftWarped_ITKaffine.nii
	rightpmECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/pmEC_rightWarped_ITKaffine.nii
	leftalECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/alEC_leftWarped_ITKaffine.nii
	rightalECmask=${pathstem}/preprocessed_data/segmentation/${subj}/epimasks/alEC_rightWarped_ITKaffine.nii
	tsnrepi=${pathstem}/preprocessed_data/images/old_data/${subj}/tSNR/tSNR_epi_${subj}.nii	
#!	tSNRepi1=${tsnrdir}/tSNR_epi_run1.nii
#!	tSNRepi2=${tsnrdir}/tSNR_epi_run2.nii	
#!	tSNRepi3=${tsnrdir}/tSNR_epi_run3.nii
	cd ${tsnrdir}	

#!	echo 'Left stats for: '$subj
#!	echo 'PM: '$subj
#!	${fsldir}/fslstats $tsnrepi -k $leftpmECmask -V -M -S -R
#!	echo 'AL: '$subj
#!	${fsldir}/fslstats $tsnrepi -k $leftalECmask -V -M -S -R
#!	echo 'Done.'
#!	echo 'Right stats for: '$subj
#!	echo 'PM: '$subj
#!	${fsldir}/fslstats $tsnrepi -k $rightpmECmask -V -M -S -R
#	echo 'AL: '$subj
#!	${fsldir}/fslstats $tsnrepi -k $rightalECmask -V -M -S -R
#!	echo 'Done.'
#!	echo 'Bilateral pmEC stats for: '$subj
	${fsldir}/fslstats $tsnrepi -k $bilateralmask -V -M -S -R
done
