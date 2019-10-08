#!/bin/bash
# script to coregister masks in T2 space to EPI space - creates right/left/both EC only masks and right/left MTL masks

declare -a mysubjs=("27734/20190902_U-ID46027
28061/20190911_U-ID46160
28428/20190903_U-ID46074
29317/20190902_U-ID46030
29321/20190902_U-ID46038
29332/20190903_U-ID46058
29336/20190903_U-ID46066
29358/20190905_U-ID46106
29382/20190911_U-ID46164
29383/20190912_U-ID46168"
);

pathstem="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data"

for subjID in ${mysubjs[@]}
do

subj="$(cut -d'/' -f1 <<<"$subjID")"

imagedirpath=${pathstem}/images/${subj}
T1path="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/images/${subjID}/mp2rage"
T2="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/Series_033_Highresolution_TSE_PAT2_100_c32.nii"
segdirpath=${pathstem}/segmentation/${subj}
coregdir=${segdirpath}/coregistration
maskregdir=${segdirpath}/epimasks

#runs_to_process=(1 2 3)
#series_to_process=("Run_2iso30_nopads" "Run_1isoSB_nopads" "Run_1isoMB_nopads")
runs_to_process=1

cd ${segdirpath}
pwd

#### ---------- COREGISTER T2 TO T1 ---------- ####
# t2 to t1 matrix from ASHS doesn't work

if [ -f "${coregdir}" ]; then
	echo "${coregdir} exists"
else
	mkdir ${coregdir}
fi

echo "EXECUTING t2 to t1 coreg in ${coregdir}" 

for this_run in ${runs_to_process[@]}
do

# initial rigid body coregsitration to initialise BBR later (use skullstripped)
flirt -in ${T2} -ref ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii -dof 6 -out ${coregdir}/t22t1_nSSCorRatio_${this_run}.nii -omat ${coregdir}/t22t1_nSSCorRatio_${this_run}.mat
	if [ $? -eq 0 ]; then
    		echo ">> CORR_RATIO COREG OK: subject ${subj}/run ${this_run}"	
	else
    		echo ">> CORR_RATIO FAIL: subject ${subj}/run ${this_run}"
	fi
end
end
	
