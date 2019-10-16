#!/bin/bash

pathstem=${1}
subjID=${2}

subject="$(cut -d'/' -f1 <<<"$subjID")"
rawpathstem=${pathstem}/raw_data/images/${subjID}
preprocesspathstem=${pathstem}/preprocessed_data/segmentation/${subject}
ashspath=/home/ccn30/privatemodules/ASHS/ashs-fastashs_beta
atlasdir=/home/ccn30/ENCRYPT/atlases/magdeburgatlas
output=${preprocesspathstem}/ASHS_2

mkdir ${output}

#! Work directory (i.e. where the job will run):
workdir="$output"

wholeT1=${rawpathstem}/mp2rage/reorientn4mag0000_PSIR_skulled_std.nii
brainT1=${rawpathstem}/mp2rage/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii
T2=${rawpathstem}/reorientSeries_033_Highresolution_TSE_PAT2_100/Series_033_Highresolution_TSE_PAT2_100_c32.nii

echo "OUTPUT:" $output
echo "INPUT:" $wholeT1 $T2

# Denoise the MP2RAGE
cd ${rawpathstem}/${subjID}/mp2rage
pwd
echo

DenoiseImage -d 3 -i $brainT1 -o ${rawpathstem}/${subjID}/mp2rage/denoisen4mag0000_PSIR_skulled_std_struc_brain.nii
DenoiseImage -d 3 -i $brainT1 -o ${rawpathstem}/${subjID}/mp2rage/denoisen4mag0000_PSIR_skulled_std_struc_brain.nii

cd $OUTPUT

$ashspath/bin/ashs_main.sh -I ${subject} -a $atlasdir -g ${brainT1} -f ${T2} -w $OUTPUT

end=(`date +%T`)
printf "\n\n ASHS completed $subj at $end, it took $(($SECONDS/86400)) days $(($SECONDS/3600)) hours $(($SECONDS%3600/60)) minutes and $(($SECONDS%60)) seconds to complete \n\n"

