#!/bin/bash

# arguments from denoise_submit.sh
pathstem=${1}
subjID=${2}

# initialise software roots
export antsroot=/applications/ANTS/2.2.0/bin

# initialise subject-wise paths
subject="$(cut -d'/' -f1 <<<"$subjID")"
rawpathstem=${pathstem}/raw_data/images/${subjID}
#!preprocesspathstem=${pathstem}/preprocessed_data/segmentation/${subject}
#!T1path=${pathstem}/preprocessed_data/images/${subject}

#------------------------------------------------------------------------#
# Denoise the MP2RAGES = ${denoiseT1}					 #
#------------------------------------------------------------------------#

T2path=${rawpathstem}/Series_033_Highresolution_TSE_PAT2_100
#!wholeT1=${T1path}/reorientn4mag0000_PSIR_skulled_std.nii
#!brainT1=${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii

#!wholeT1=${T1path}/structural.nii
#!brainT1=${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii
T2=${T2path}/N4Series_033_Highresolution_TSE_PAT2_100_c32.nii

echo "Running DenoiseImage in: " ${T2path}

#!denoiseT1brain=${T1path}/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii
#!denoiseT1whole=${T1path}/denoiseRn4mag0000_PSIR_skulled_std.nii
#!denoiseT1brain=${T1path}/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii
#!denoiseT1whole=${T1path}/denoise_structural.nii
denoiseT2=${T2path}/denoiseT2.nii

cd ${T2path}

#!if [ -f "${denoiseT1brain}" ]; then
#!		echo $subject "already denoised brain"
#!	else
#!		$antsroot/DenoiseImage -d 3 -i $brainT1 -o $denoiseT1brain -v 1
#!fi

if [ -f "${denoiseT1whole}" ]; then
		echo $subject "already denoised whole"
	else
		$antsroot/DenoiseImage -d 3 -i $T2 -o $denoiseT2 -v 1
fi

#!if [ -f "${denoiseT1brain}" && "${denoiseT1whole}" ]; then
#!		echo ">> DenoiseImage SUCCESS"
#!	else
#!		echo ">> DenoiseImage FAIL"
#!fi
