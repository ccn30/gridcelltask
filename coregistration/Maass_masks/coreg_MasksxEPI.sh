#!/bin/bash
# corgeister templates masks to pilot subject EPIs or T2s
# steps: coregister T1 to template, warp masks to T1, warp masks to T2 and EPI using pre=existing coreg matrices

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/fMRI/gridcellpilot
studyTemplateDir=~/ENCRYPT/atlases/templates/ECtemplatemasks2015

subjID=${1}

subject="$(cut -d'/' -f1 <<<"$subjID")"
echo "******** starting $subject ********"

## set subject specific paths

regDir=${pathstem}/registrations/${subject}
imagedirpath=${pathstem}/preprocessed_data/images/old_data/${subject}
segdirpath=${pathstem}/preprocessed_data/segmentation/${subject}
coregdir=${segdirpath}/coregistration
maskregdir=${segdirpath}/epimasks

## set images

T1=${pathstem}/preprocessed_data/images/${subject}/structural.nii
denoiseT1=${pathstem}/raw_data/images?$subjID/mp2rage/denoiseRn4mag0000_PSIR_skulled_std.nii
N4T2=${pathstem}/raw_data/images/${subjID}/Series_039_Highresolution_TSE_PAT2_100_PatSpec/N4Series_039_Highresolution_TSE_PAT2_100_PatSpec.nii
epi=${imagedirpath}/meantopup_Run_1.nii

studyTemplate=${studyTemplateDir}/Study_template_wholeBrain.nii

## Perform T1 x study template registration (study template 0.6iso)

antsRegistrationSyN.sh -f ${studyTemplate} -m ${denoiseT1} -o ${coregDir}/T1xStudyTemplate_ -t s

# ** INTERMEDIATE STEP CHECK COREG T1 TO TEMPLATE *

## set paths to existing coregistrations

T2xT1=coregdir/T1toT2_ANTS_0GenericAffine.mat
EPIxT1=$coregdir/EPItoT1_ITK_affine_crosscorr.txt

## set paths to masks

alEC_left=${studyTemplateDir}/alEC_PRCpref_left.nii
alEC_right=${studyTemplateDir}/alEC_PRCpref_right.nii
pmEC_left=${studyTemplateDir}/pmEC_PHCpref_left.nii
pmEC_right=${studyTemplateDir}/pmEC_PHCpref_right.nii

alECLxEPI=$maskregdir/alEC_leftMaskxEPI.nii
pmECLxEPI=$maskregdir/pmEC_leftMaskxEPI.nii
alECRxEPI=$maskregdir/alEC_rightMaskxEPI.nii
pmECRxEPI=$maskregdir/pmEC_rightMaskxEPI.nii


## Perform mask x EPI transformation

## Perform mask x T2 transformation

## combine alEC and pmEC masks


