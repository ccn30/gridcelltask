#!/bin/bash
# corgeister templates masks to pilot subject EPIs or T2s
# steps: coregister T1 to template, warp masks to T1, warp masks to T2 and EPI using pre=existing coreg matrices

pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/fMRI/gridcellpilot
studyTemplateDir=~/ENCRYPT/atlases/templates/ECtemplatemasks2015

# when called in Slurm:
#subjID=${1}

# when used as standalone script: (NB DONE AT END)
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
epi=${imagedirpath}/meantopup_Run_1.nii

rawpathstem=${pathstem}/raw_data/images/$subjID
cd $rawpathstem

T2dir=$(ls -d Series_???_Highresolution_TSE_PAT2_100)
T2path=${rawpathstem}/${T2dir}
N4T2=${T2path}/N4Series_033_Highresolution_TSE_PAT2_100_c32.nii

cd ${workdir}

studyTemplate=${studyTemplateDir}/Study_template_wholeBrain.nii

## Perform T1 x study template registration (study template 0.6iso)

#antsRegistrationSyNQuick.sh -f ${studyTemplate} -m ${denoiseT1} -o ${coregdir}/T1xStudyTemplate_

# ** INTERMEDIATE STEP CHECK COREG T1 TO TEMPLATE *
#vglrun itksnap -g $studyTemplate -o $coregdir/T1xStudyTemplate_Warped.nii.gz

#done

## set paths to coregistrations

T1xTempAffine=$coregdir/T1xStudyTemplate_0GenericAffine.mat
T1xTempInvWarp=$coregdir/T1xStudyTemplate_1InverseWarp.nii.gz
T2xT1=$coregdir/T1toT2_ANTS_0GenericAffine.mat
EPIxT1=$coregdir/EPItoT1_ITK_affine_crosscorr.txt

## set paths to masks

alEC_left=${studyTemplateDir}/alEC_PRCpref_left.nii
alEC_right=${studyTemplateDir}/alEC_PRCpref_right.nii
pmEC_left=${studyTemplateDir}/pmEC_PHCpref_left.nii
pmEC_right=${studyTemplateDir}/pmEC_PHCpref_right.nii

alECLxEPI=$coregdir/alEC_leftMaassMaskxEPI.nii
pmECLxEPI=$coregdir/pmEC_leftMaassMaskxEPI.nii
alECRxEPI=$coregdir/alEC_rightMaassMaskxEPI.nii
pmECRxEPI=$coregdir/pmEC_rightMaassMaskxEPI.nii

combinedEC_right=${studyTemplateDir}/rightEC_combined.nii.gz
combinedEC_left=${studyTemplateDir}/leftEC_combined.nii.gz

comb_rightEC_T2out=$coregdir/MaassMasks_rightECxT2.nii.gz
com_leftEC_T2out=$coregdir/MaassMasks_leftECxT2.nii.gz

# probs don't need to make these for pilot, border from Naz looks pretty similar
#MaassMask_T2xEPI_alECL=$coregdir/MaassMasks_T2xEPI_alEC_left.nii.gz
#MaassMask_T2xEPI_alECR=$coregdir/MaassMasks_T2xEPI_alEC_right.nii.gz
#MaassMask_T2xEPI_pmECL=$coregdir/MaassMasks_T2xEPI_pmEC_left.nii.gz
#MaassMask_T2xEPI_pmECR=$coregdir/MaassMasks_T2xEPI_pmEC_right.nii.gz


## Perform mask x T2 transformation

# combined right
		antsApplyTransforms -d 3 \
				-i ${combinedEC_right} \
				-r ${N4T2} \
				-o ${comb_rightEC_T2out} \
				-n GenericLabel \
				-t [${T2xT1},1] \
				-t [${T1xTempAffine},1] \
				-t ${T1xTempInvWarp} \
				-v 1 

# combined left
		antsApplyTransforms -d 3 \
				-i ${combinedEC_left} \
				-r ${N4T2} \
				-o ${comb_leftEC_T2out} \
				-n GenericLabel \
				-t [${T2xT1},1] \
				-t [${T1xTempAffine},1] \
				-t ${T1xTempInvWarp} \
				-v 1 

# alEC left
		antsApplyTransforms -d 3 \
				-i ${alEC_left} \
				-r ${epi} \
				-o ${alECLxEPI} \
				-n GenericLabel \
				-t [${EPIxT1},1] \
				-t [${T1xTempAffine},1] \
				-t ${T1xTempInvWarp} \
				-v 1 

# alEC right
		antsApplyTransforms -d 3 \
				-i ${alEC_right} \
				-r ${epi} \
				-o ${alECRxEPI} \
				-n GenericLabel \
				-t [${EPIxT1},1] \
  			    -t [${T1xTempAffine},1] \
				-t ${T1xTempInvWarp} \
				-v 1 

# pmEC right
		antsApplyTransforms -d 3 \
				-i ${pmEC_right} \
				-r ${epi} \
				-o ${pmECRxEPI} \
				-n GenericLabel \
				-t [${EPIxT1},1] \
				-t [${T1xTempAffine},1] \
				-t ${T1xTempInvWarp} \
				-v 1 

# pmEC left
		antsApplyTransforms -d 3 \
				-i ${pmEC_left} \
				-r ${epi} \
				-o ${pmECLxEPI} \
				-n GenericLabel \
				-t [${EPIxT1},1] \
			    -t [${T1xTempAffine},1] \
				-t ${T1xTempInvWarp} \
				-v 1 

done

## combine alEC and pmEC masks


