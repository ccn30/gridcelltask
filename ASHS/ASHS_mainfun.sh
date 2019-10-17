#!/bin/bash

# arguments from ASHS_sba.sh
pathstem=${1}
subjID=${2}

# initialise software roots
antsroot=/applications/ANTS/2.2.0/bin
ashsroot=/home/ccn30/privatemodules/ASHS/ashs-fastashs_beta
atlasdir=/home/ccn30/ENCRYPT/atlases/magdeburgatlas

# initialise subject-wise paths
subject="$(cut -d'/' -f1 <<<"$subjID")"
rawpathstem=${pathstem}/raw_data/images/${subjID}
preprocesspathstem=${pathstem}/preprocessed_data/segmentation/${subject}
outputdir=${preprocesspathstem}/ASHS_2

#------------------------------------------------------------------------#
# Make N4 bias corrected T2s = ${N4T2}					 #
#------------------------------------------------------------------------#

T2path=${rawpathstem}/Series_033_Highresolution_TSE_PAT2_100
T2=${T2path}/reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii
echo "Running N4BiasFieldCorrection on: " ${T2}

cd ${T2path}
$antsroot/N4BiasFieldCorrection -d 3 -i ${T2} -o N4reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii
N4T2=${T2path}/N4reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii
if [ -f "${N4T2}" ]; then
		echo ">> N4BiasFieldCorrection SUCCESS"
	else
		echo ">> N4BiasFieldCorrection FAIL"
fi 

#------------------------------------------------------------------------#
# Denoise the MP2RAGES = ${denoiseT1}					 #
#------------------------------------------------------------------------#

T1path=${rawpathstem}/mp2rage
wholeT1=${T1path}/reorientn4mag0000_PSIR_skulled_std.nii
brainT1=${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii
echo "Running DenoiseImage in: " ${T1path}

cd ${T1path}
$antsroot/DenoiseImage -d 3 -i $brainT1 -o ${rawpathstem}/${subjID}/mp2rage/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii
$antsroot/DenoiseImage -d 3 -i $wholeT1 -o ${rawpathstem}/${subjID}/mp2rage/denoiseRn4mag0000_PSIR_skulled_std.nii
denoiseT1brain=${T1path}/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii
denoiseT1whole=${T1path}/denoiseRn4mag0000_PSIR_skulled_std.nii
if [ -f "${denoiseT1brain}" && "${denoiseT1whole}" ]; then
		echo ">> DenoiseImage SUCCESS"
	else
		echo ">> DenoiseImage FAIL"
fi

#------------------------------------------------------------------------#
# Run ASHS					 			 #
#------------------------------------------------------------------------#

if [ -f "${outputdir}" ]; then
		echo "${outputdir} exists"
	else
		mkdir ${outputdir}
fi

echo "Beginning ASHS for: " $subject
echo "OUTPUT:" $outputdir
echo "INPUT:" $denoiseT1brain $N4T2

cd $outputdir

# second ASHS run (corrected inputs, skullstripped T1}
$ashsroot/bin/ashs_main.sh -I $subject'_2' -a $atlasdir -g ${denoiseT1brain} -f ${N4T2} -w ${outputdir}

echo ">> DONE: " ${subject}
 
# first ASHS run (non corrected inputs, skullstripped T1}
#!$ashspath/bin/ashs_main.sh -I ${subject} -a $atlasdir -g ${brainT1} -f ${T2} -w $OUTPUT

