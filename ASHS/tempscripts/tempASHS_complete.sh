#segdirpath=${preprocesspathstem}/segmentation/$
#coregdir=${segdirpath}/coreg_PADS
#maskregdir=${segdirpath}/epimasks

#runs_to_process=(1 8 9)
#series_to_process=("Run_2iso30_nopads" "Run_1.5iso30_nopads" "Run_1.5x1_nopads" "Run_1isoSB_nopads" "Run_1isoMB_nopads" "Run_1.5iso0_nopads" "Run_1.5iso90_nopads" "null" "null" "Run_1.5iso30_PADS" "Run_1.5iso0_PADS")

#cd ${segdirpath}
#pwd

# %%%%%%%%%%%%%%%%%%%%%% 
# coregister T2 to T1 (PADS condition)
if [ -f "$coregdir" ]; then
	echo "$coregdir exists"
else
	mkdir ${coregdir}
fi
echo "EXECUTING t2 to t1 coreg in ${coregdir}" 
flirt -in inputs/t2_PADS.nii -ref inputs/t1whole.nii -dof 6 -out ${coregdir}/t22t1_CorRatio.nii -omat ${coregdir}/t22t1_CorRatio.mat
	if [ $? -eq 0 ]; then
    		echo >> CORR_RATIO COREG OK	
	else
    		echo >> CORR_RATIO FAIL
	fi
flirt -in inputs/t2_PADS.nii -ref t1whole.nii -dof 6 -cost bbr -wmseg inputs/t1wmseg.nii -schedule /applications/fsl/fsl-5.0.10/etc/flirtsch/bbr.sch -init ${coregdir}/t22t1_CorRatio.mat -omat ${coregdir}/t22t1_bbr.mat -out ${coregdir}/t22t1_bbr.nii
	if [ $? -eq 0 ]; then
    		echo >> BBR COREG OK
	else
    		echo >> BBR COREG FAIL
	fi

# %%%%%%%%%%%%%%%%%
# coregister EPIs to T1, invert and concatenate to t22t1
for this_run in ${runs_to_process[@]}
do
echo "EXECUTING matrix calcs for run ${runs_to_process[$this_run]} series ${series_to_process[$this_run]}"
epi_reg --epi=${pathstem}/preprocessed_images_${subj}_${runs_to_process[$this_run]}/rtopup_${series_to_process[$this_run]}.nii --t1=inputs/t1whole.nii --t1brain=inputs/t1brain.nii --wmseg=inputs/t1wmseg.nii --out=${coregdir}/epi2t1_${series_to_process[$this_run]}
	if [ $? -eq 0 ]; then
    		#echo ">> EPI_REG OK for epi2t1_"${series_to_process[$this_run]}	
	else
    		#echo ">> EPI_REG FAIL for epi2t1_"${series_to_process[$this_run]}
	fi
convert_xfm -omat ${coregdir}/t12epi_${series_to_process[$this_run]}.mat -inverse ${coregdir}/epi2t1_${series_to_process[$this_run]}.mat
	if [ $? -eq 0 ]; then
    		echo >> MATRIX INVERSION OK	
	else
    		echo >> MATRIX INVERSION FAIL
	fi	
convert_xfm -omat ${coregdir}/t22epi_${series_to_process[$this_run]}.mat -concat ${coregdir}/t12epi_${series_to_process[$this_run]}.mat ${coregdir}/t22t1_bbr.mat
	if [ $? -eq 0 ]; then
    		echo >> MATRIX CONCATENATION OK	
	else
    		echo >> MATRIX CONCATENATION FAIL
	fi	 
done

# %%%%%%%%%%%%%%%%%%%
# coregister ASHS masks to each EPI series
if [ -f "$maskregdir" ]; then
	echo "$maskregdir exists"
else
	mkdir ${maskregdir}
fi

for this_run in ${runs_to_process[@]}
do
echo "EXECUTING mask to epi coreg for run ${runs_to_process[$this_run]} series ${series_to_process[$this_run]}"
# for left MTL
flirt -in ASHS_output_PADS/final/${subj}_left_lfseg_corr_nogray.nii.gz -ref ${pathstem}/preprocessed_images_${subj}_${runs_to_process[$this_run]}/rtopup_${series_to_process[$this_run]}.nii -applyxfm -init ${coregdir}/t22epi_${series_to_process[$this_run]}.mat -o ${maskregdir}/leftMTLmask_${series_to_process[$this_run]}.nii -interp nearestneighbour
# for right MTL
flirt -in ASHS_output_PADS/final/${subj}_right_lfseg_corr_nogray.nii.gz -ref ${pathstem}/preprocessed_images_${subj}_${runs_to_process[$this_run]}/rtopup_${series_to_process[$this_run]}.nii -applyxfm -init ${coregdir}/t22epi_${series_to_process[$this_run]}.mat -o ${maskregdir}/rightMTLmask_${series_to_process[$this_run]}.nii -interp nearestneighbour
# create EC only masks
fslmaths ${maskregdir}/leftMTLmask_${series_to_process[$this_run]}.nii -thr 8.5 -uthr 9.5 -bin ${maskregdir}/leftECmask_${series_to_process[$this_run]}.nii -odt char
fslmaths ${maskregdir}/rightMTLmask_${series_to_process[$this_run]}.nii -thr 8.5 -uthr 9.5 -bin ${maskregdir}/rightECmask_${series_to_process[$this_run]}.nii -odt char
	if [ -f "leftECmask_"${series_to_process[$this_run]}".nii" ] && [ -f "rightECmask_"${series_to_process[$this_run]}".nii" ]; then
		echo >> EC MASKS SUCCESSFULLY TRANSFORMED TO EPI SPACE
	else
		echo >> EC MASKS FAILED TRANSFORMATION
	fi
done
