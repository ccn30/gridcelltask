#!/bin/bash
# script to coregister masks in T2 space to EPI space - creates right/left/both EC only masks and right/left MTL masks
# repeat for no pads ASHS when complete

module unload matlab/matlab2016a    
module load matlab/matlab2017b
module load freesurfer/6.0.0
module load spm/spm12_6906
module load ASHS_FASTB
module load ANTS/2.2.0

#declare -a mysubjs=("28061/20190911_U-ID46160
#28428/20190903_U-ID46074");
#29317/20190902_U-ID46030
#29321/20190902_U-ID46038
#29332/20190903_U-ID46058
#29336/20190903_U-ID46066
#29358/20190905_U-ID46106
#29382/20190911_U-ID46164
#29383/20190912_U-ID46168"
#);

mysubjs="27734/20190902_U-ID46027"

rawpathstem="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/images"
preprocesspathstem="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/segmentation"

for subj in $mysubjs
do
# set inputs for ASHS
subject="$(cut -d'/' -f1 <<<"$subj")"
wholeT1=${rawpathstem}/"$subj"/mp2rage/n4mag0000_PSIR_skulled_std.nii
brainT1=${rawpathstem}/"$subj"/mp2rage/n4mag0000_PSIR_skulled_std_struc_brain.nii
T2=${rawpathstem}/"$subj"/Series_033_Highresolution_TSE_PAT2_100/Series_033_Highresolution_TSE_PAT2_100_c32.nii
n4T2=${rawpathstem}/"$subj"/Series_033_Highresolution_TSE_PAT2_100/n4Series_033_Highresolution_TSE_PAT2_100_c32.nii
outpath=${preprocesspathstem}/$subject

# bias field correction for T2
N4BiasFieldCorrection -d 2 -i ${T2} -o ${n4T2}; 

# %%%%%%%%%%%%%%%%%%%%%%
# run ASHS
nohup $ASHS_ROOT/bin/ashs_main.sh -P -I $subject -a ~/privatemodules/ASHS/atlases/magdeburgatlas -g $brainT1 -f $T2 -w $outpath/ASHSoutput &
done








