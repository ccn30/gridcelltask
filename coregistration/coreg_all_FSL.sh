#!/bin/bash
#! script to coregister masks in T2 space to EPI space - creates right/left/both EC only masks and right/left MTL masks

#!module unload matlab/matlab2016a    
#!module load matlab/matlab2017b
#!module load freesurfer/6.0.0
#!module load spm/spm12_6906
#!module unload fsl
#!module load fsl/5.0.10
#!export FREESURFER_HOME=/applications/freesurfer/freesurfer_6.0.0
#!source $FREESURFER_HOME/SetUpFreeSurfer.sh
#!export FSF_OUTPUT_FORMAT=nii

	pathstem=${1}
	subjID=${2}
	
	subject="$(cut -d'/' -f1 <<<"$subjID")"
	echo $subj
	
	imagedirpath=${pathstem}/preprocessed_data/images/${subject}
	T1path=${pathstem}/raw_data/images/${subjID}/mp2rage
	N4T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4Series_033_Highresolution_TSE_PAT2_100_c32.nii
	#!N4rT2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii	
	epi=${imagedirpath}/topup_Run_1_split0000.nii
	
	segdirpath=${pathstem}/preprocessed_data/segmentation/${subject}
	coregdir=${segdirpath}/coregistration/FSLtests
	maskregdir=${segdirpath}/epimasks

	#!runs_to_process=(1 2 3)
	#!runs_to_process=1

	#### ---------- COREGISTER T2 TO T1 ---------- ####
	
	# t2 to t1 matrix from ASHS doesn't work
	if [ -f "${coregdir}" ]; then
		echo "${coregdir} exists"
	else
		mkdir ${coregdir}
	fi

	#!echo "EXECUTING t2 to t1 coreg in ${coregdir}" 

	cd ${coregdir}
	pwd

		# initial rigid body coregsitration to initialise BBR later (use skullstripped)
#!		flirt -in ${T2} -ref ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii -dof 6 -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -out ${coregdir}/t22t1_CorRatio_${this_run}.nii -omat ${coregdir}/t22t1_CorRatio_${this_run}.mat
#!		if [ $? -eq 0 ]; then
#!    			echo ">> CORR_RATIO COREG OK: subject ${subj}/run ${this_run}"	
#!		else
#!    			echo ">> CORR_RATIO FAIL: subject ${subj}/run ${this_run}"
#!		fi

		# higher level BBR coregistration (uses SPM wm boundaries - skullstripped ot not may not be important)
#!		flirt -in ${T2} -ref ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii -dof 6 -cost bbr -wmseg ${T1path}/c2n4mag0000_PSIR_skulled_std.nii -schedule /applications/fsl/fsl-5.0.10/etc/flirtsch/bbr.sch -init ${coregdir}/t22t1_CorRatio_${this_run}.mat -omat ${coregdir}/t22t1_bbr_spm_${this_run}.mat -out ${coregdir}/t22t1_bbr_spm_${this_run}.nii
#!		if [ $? -eq 0 ]; then
#!    			echo ">> BBR COREG OK: subject ${subj}/run ${this_run}"
#!		else
#!    			echo ">> BBR COREG FAIL: subject ${subj}/run ${this_run}"
#!		fi

		#### ---------- COREGISTER EPIS TO T1 AND INVERT ---------- ####

		#echo "EXECUTING matrix calcs for run ${this_run} series ${series_to_process[$this_run]}"
		echo "EXECUTING epi_reg for subject ${subject}"

		epi_reg --epi=${epi} --t1=${T1path}/denoiseRn4mag0000_PSIR_skulled_std.nii --t1brain=${T1path}/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii --out=${coregdir}/EPItoT1_denoise
		
		if [ $? -eq 0 ]; then
    			echo ">> EPI_REG OK: subject ${subj}/run ${this_run}"
		else
    			echo ">> EPI_REG FAIL: subject ${subj}/run ${this_run}"
		fi
		
#!		convert_xfm -omat ${coregdir}/t12epi_${this_run}.mat -inverse ${coregdir}/epi2t1_${this_run}.mat
	
#!		if [ $? -eq 0 ]; then
#!   			echo ">> MATRIX INVERSION OK: subject ${subj}/run ${this_run}"	
#!		else
#!    			echo ">> MATRIX INVERSION FAIL: subject ${subj}/run ${this_run}"
#!		fi	

#!		convert_xfm -omat ${coregdir}/t22epi_${this_run}.mat -concat ${coregdir}/t12epi_${this_run}.mat ${coregdir}/t22t1_bbr_spm_${this_run}.mat

#!		if [ $? -eq 0 ]; then
#!	    		echo ">> MATRIX CONCATENATION OK: subject ${subj}/run ${this_run}"	
#!		else
#!	    		echo ">> MATRIX CONCATENATION FAIL: subject ${subj}/run ${this_run}"
#!		fi	 
		#done


		#### ---------- COREGISTER ASHS OUTPUT TO EPIS AND MAKE EC MASKS --------- ####



		# for left MTL
#!		flirt -in final/${subj}_left_lfseg_corr_nogray.nii.gz -ref ${imagedirpath}/meantopup_Run_${this_run}.nii -applyxfm -init ${coregdir}/t22epi_${this_run}.mat -o ${maskregdir}/leftMTLmask_${this_run}.nii -interp nearestneighbour

		# for right MTL
#!		flirt -in final/${subj}_right_lfseg_corr_nogray.nii.gz -ref ${imagedirpath}/meantopup_Run_${this_run}.nii -applyxfm -init ${coregdir}/t22epi_${this_run}.mat -o ${maskregdir}/rightMTLmask_${this_run}.nii -interp nearestneighbour

# same as coreg_all current




