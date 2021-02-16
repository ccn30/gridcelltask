#!/bin/bash
# script to visualise results in itksnap simultaenously for all subjects in different windows
# needs to be called from graphics window sith source command run

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/fMRI/gridcellpilot
#mysubjs=${pathstem}/testsubjcode.txt
mysubjs=${pathstem}/master_subjsdeflist.txt

for subjID in `cat $mysubjs`
do
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
denoiseT1=${pathstem}/raw_data/images/$subjID/mp2rage/denoiseRn4mag0000_PSIR_skulled_std.nii
N4T2=${pathstem}/raw_data/images/${subjID}/Series_039_Highresolution_TSE_PAT2_100_PatSpec/N4Series_039_Highresolution_TSE_PAT2_100_PatSpec.nii
epi=${imagedirpath}/meantopup_Run_1.nii

studyTemplate=${studyTemplateDir}/Study_template_wholeBrain.nii
T1xTemplateWarped=$coregdir/

## run itksnap

# check T1 warp to mask template
vglrun itksnap -g ${template} -o ${T1xTemplateWarped} &

done
