#!/bin/bash
# script to coregister masks in T2 space to EPI space - creates right/left/both EC only masks and right/left MTL masks

#!declare -a mysubjs=("27734/20190902_U-ID46027
#!28061/20190911_U-ID46160
#!28428/20190903_U-ID46074
#!29317/20190902_U-ID46030
#!29321/20190902_U-ID46038
#!29332/20190903_U-ID46058
#!29336/20190903_U-ID46066
#!29358/20190905_U-ID46106
#!29382/20190911_U-ID46164
#!29383/20190912_U-ID46168"
#!);

#!module unload matlab/matlab2016a    
#!module load matlab/matlab2017b
#!module load freesurfer/6.0.0
#!module load spm/spm12_6906
module unload fsl
module load fsl/5.0.11
#!export FREESURFER_HOME=/home/tec31/freesurfer
#!source $FREESURFER_HOME/SetUpFreeSurfer.sh
#!export FSF_OUTPUT_FORMAT=nii

mysubjs="28428/20190903_U-ID46074"

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
flirt -in ${T2} -ref ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii -dof 6 -out ${coregdir}/t22t1_CorRatio_${this_run}.nii -omat ${coregdir}/t22t1_CorRatio_${this_run}.mat
	if [ $? -eq 0 ]; then
    		echo ">> CORR_RATIO COREG OK: subject ${subj}/run ${this_run}"	
	else
    		echo ">> CORR_RATIO FAIL: subject ${subj}/run ${this_run}"
	fi

# white matter segmentation for BBR if spm mp2rage C2 does not suffice - use brain extracted and set to two tissue types (wm=pve2)
#fast -t 1 -n 2 -o FAST_ ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii

# WITH SPM WM SEG
# higher level BBR coregistration (uses wm boundaries - skullstripped ot not may not be important)
flirt -in ${T2} -ref ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii -dof 6 -cost bbr -wmseg ${T1path}/c2n4mag0000_PSIR_skulled_std.nii -schedule /applications/fsl/fsl-5.0.10/etc/flirtsch/bbr.sch -init ${coregdir}/t22t1_CorRatio_${this_run}.mat -omat ${coregdir}/t22t1_bbr_spm_${this_run}.mat -out ${coregdir}/t22t1_bbr_spm_${this_run}.nii
	if [ $? -eq 0 ]; then
    		echo ">> BBR COREG OK: subject ${subj}/run ${this_run}"
	else
    		echo ">> BBR COREG FAIL: subject ${subj}/run ${this_run}"
	fi

#done


#### ---------- COREGISTER EPIS TO T1 AND INVERT ---------- ####



#for this_run in ${runs_to_process[@]}
#do

#echo "EXECUTING matrix calcs for run ${this_run} series ${series_to_process[$this_run]}"
echo "EXECUTING matrix calcs for subject ${subj} run $this_run}"

epi_reg --epi=${imagedirpath}/meantopup_Run_${this_run}.nii --t1=${T1path}/n4mag0000_PSIR_skulled_std.nii --t1brain=${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii --wmseg=${T1path}/c2n4mag0000_PSIR_skulled_std.nii --out=${coregdir}/epi2t1_${this_run}
	if [ $? -eq 0 ]; then
    		echo ">> EPI_REG OK: subject ${subj}/run ${this_run}"
	else
    		echo ">> EPI_REG FAIL: subject ${subj}/run ${this_run}"
	fi
convert_xfm -omat ${coregdir}/t12epi_${this_run}.mat -inverse ${coregdir}/epi2t1_${this_run}.mat
	if [ $? -eq 0 ]; then
    		echo ">> MATRIX INVERSION OK: subject ${subj}/run ${this_run}"	
	else
    		echo ">> MATRIX INVERSION FAIL: subject ${subj}/run ${this_run}"
	fi	
convert_xfm -omat ${coregdir}/t22epi_${this_run}.mat -concat ${coregdir}/t12epi_${this_run}.mat ${coregdir}/t22t1_CorRatio_${this_run}.mat
	if [ $? -eq 0 ]; then
    		echo ">> MATRIX CONCATENATION OK: subject ${subj}/run ${this_run}"	
	else
    		echo ">> MATRIX CONCATENATION FAIL: subject ${subj}/run ${this_run}"
	fi	 
#done


#### ---------- COREGISTER ASHS OUTPUT TO EPIS AND MAKE EC MASKS --------- ####


if [ -f "${maskregdir}" ]; then
	echo "${maskregdir} exists"
else
	mkdir ${maskregdir}
fi

#for this_run in ${runs_to_process[@]}
#do
echo "EXECUTING mask to epi coreg for subject ${subj} run ${this_run}"

# for left MTL
flirt -in final/${subj}_left_lfseg_corr_nogray.nii.gz -ref ${imagedirpath}/meantopup_Run_${this_run}.nii -applyxfm -init ${coregdir}/t22epi_${this_run}.mat -o ${maskregdir}/leftMTLmask_${this_run}.nii -interp nearestneighbour

# for right MTL
flirt -in final/${subj}_right_lfseg_corr_nogray.nii.gz -ref ${imagedirpath}/meantopup_Run_${this_run}.nii -applyxfm -init ${coregdir}/t22epi_${this_run}.mat -o ${maskregdir}/rightMTLmask_${this_run}.nii -interp nearestneighbour

# create EC only masks
fslmaths ${maskregdir}/leftMTLmask_${this_run}.nii -thr 8.5 -uthr 9.5 -bin ${maskregdir}/leftECmask_${this_run}.nii -odt char
fslmaths ${maskregdir}/rightMTLmask_${this_run}.nii -thr 8.5 -uthr 9.5 -bin ${maskregdir}/rightECmask_${this_run}.nii -odt char
cd ${maskregdir}
	if [ -f "leftECmask_${this_run}.nii" ] && [ -f "rightECmask_${this_run}.nii" ]; then
		echo ">> EC MASKS SUCCESSFULLY TRANSFORMED TO EPI SPACE: subject ${subj}/run ${this_run}"
	else
		echo ">> EC MASKS FAILED TRANSFORMATION: subject ${subj}/run ${this_run}"
	fi
cd ${pathstem}

done
done


