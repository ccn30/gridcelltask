#!/bin/bash
# coregister EPI runs to first volume of run 2

export antsroot=/applications/ANTS/2.2.0/bin

#!pathstem=${1}
#!subjID=${2}
pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
	
#!subject="$(cut -d'/' -f1 <<<"$subjID")"
subject=27734
echo $subject
	
# set subject-wise paths
EPIpath=${pathstem}/preprocessed_data/images/${subject}
ref=${EPIpath}/topup_Run_2_split0000.nii
run1=${EPIpath}/topup_Run_1.nii
run2=${EPIpath}/topup_Run_2.nii
run3=${EPIpath}/topup_Run_3.nii

Rrun1=${EPIpath}/ANTSRtopup_Run_1
Rrun2=${EPIpath}/ANTSRtopup_Run_2
Rrun3=${EPIpath}/ANTSRtopuup_Run_3

#Run 1
antsMotionCorr -d 3 \
-o [ ${Rrun1}, ${Rrun1}.nii.gz,${Rrun1}_avg.nii.gz] \
-m MI[${ref}, ${run1}, 1 , 32 , Regular, 0.2 ] \
-t Affine[ 0.1 ] -u 1 -e 1 -s 1x0 -f 2x1 \
-i 15x3 -n 3 -w 1

#Run 2
antsMotionCorr -d 3 \
-o [ ${Rrun2}, ${Rrun2}.nii.gz,${Rrun2}_avg.nii.gz] \
-m MI[${ref}, ${run2}, 1 , 32 , Regular, 0.2 ] \
-t Affine[ 0.1 ] -u 1 -e 1 -s 1x0 -f 2x1 \
-i 15x3 -n 3 -w 1

#Run 2
antsMotionCorr -d 3 \
-o [ ${Rrun3}, ${Rrun3}.nii.gz,${Rrun3}_avg.nii.gz] \
-m MI[${ref}, ${run3}, 1 , 32 , Regular, 0.2 ] \
-t Affine[ 0.1 ] -u 1 -e 1 -s 1x0 -f 2x1 \
-i 15x3 -n 3 -w 1
