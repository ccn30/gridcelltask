#!/bin/bash
#! using affine.mat outputs of ANTS from coreg_all.sh to do T2-T1 and T1-EPI affine transformations
	
	export antsroot=/applications/ANTS/2.2.0/bin
	
	## import variables from SLURM submission script
	pathstem=${1}
	subjID=${2}
	#!pathstem=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot
	#!subjID=28428/20190903_U-ID46074
	subject="$(cut -d'/' -f1 <<<"$subjID")"
	echo $subject
	
	## set subject-wise paths
	imagedirpath=${pathstem}/preprocessed_data/images/${subject}
	T1path=${pathstem}/raw_data/images/${subjID}/mp2rage
	N4T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4Series_033_Highresolution_TSE_PAT2_100_c32.nii
	#!N4rT2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii	
	epi=${imagedirpath}/topup_Run_1_split0000.nii
	segdirpath=${pathstem}/preprocessed_data/segmentation/${subject}
	coregdir=${segdirpath}/coregistration
	maskregdir=${segdirpath}/epimasks

cd ${coregdir}
pwd

##----TRANSFORM T2 to T1 SPACE----##
## to check affine only transformation

antsApplyTransforms -d 3 \
			-i ${N4T2} \
			-r ${T1path}/denoiseRn4mag0000_PSIR_skulled_std.nii \
			-o T2toT1Warped_affine.nii.gz \
			-n Linear \
			-t [T1toT2_ANTS_0GenericAffine.mat,1] \
			-v

##----TRANSFORM T1 to EPI SPACE----##

# whole brain didn't work, now trying skullstripped (overwriting output)
#!antsApplyTransforms -d 3 \
#!			-i ${T1path}/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii \
#!			-r ${epi} \
#!			-o T1toEPIWarped_affine.nii.gz \
#!			-n Linear \
#!			-t T1toEPI_ssANTS_0GenericAffine.mat \
#!			-v

##---TRY MANUAL ITKSNAP RIGID---#
#!antsApplyTransforms -d 3 \
#!			-i ${T1path}/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii \
#!			-r ${epi} \
#!			-o T1toEPI_Warped_ITKmanual.nii.gz \
#!			-n Linear \
#!			-t [EPItoT1_ITK_manual.txt,1] \
#!			-v
