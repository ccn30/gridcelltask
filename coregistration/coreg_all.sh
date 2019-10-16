#!/bin/bash
#! script to coregister masks in T2 space to EPI space - creates right/left/both EC only masks and right/left MTL masks

#!module unload matlab/matlab2016a    
#!module load matlab/matlab2017b
#!module load freesurfer/6.0.0
#!module load spm/spm12_6906
module unload fsl
module load fsl/5.0.10
#!export FREESURFER_HOME=/applications/freesurfer/freesurfer_6.0.0
#!source $FREESURFER_HOME/SetUpFreeSurfer.sh
#!export FSF_OUTPUT_FORMAT=nii

	pathstem=${1}
	subjID=${2}
	
	subj="$(cut -d'/' -f1 <<<"$subjID")"
	echo $subj
	
	imagedirpath=${pathstem}/preprocessed_data/images/${subj}
	T1path=${pathstem}/raw_data/images/${subjID}/mp2rage
	T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/Series_033_Highresolution_TSE_PAT2_100_c32.nii

	segdirpath=${pathstem}/preprocessed_data/segmentation/${subj}
	coregdir=${segdirpath}/coregistration
	maskregdir=${segdirpath}/epimasks

	#runs_to_process=(1 2 3)
	runs_to_process=1

	cd ${segdirpath}
	pwd

	####-----N4BiasFieldCorrection for T2-----####

	

	#### ---------- COREGISTER T2 TO T1 ---------- ####
	
	# t2 to t1 matrix from ASHS doesn't work
	if [ -f "${coregdir}" ]; then
		echo "${coregdir} exists"
	else
		mkdir ${coregdir}
	fi

	echo "EXECUTING t2 to t1 coreg in ${coregdir}" 
>>>
	cd ${coregdir}
	

	#### ---------- COREGISTER EPIS TO T1 --------- ####

	for this_run in ${runs_to_process[@]}
	do

		echo "EXECUTING epi to T1 coregistration for subject ${subj} run $this_run}"

>>
		
		if [ $? -eq 0 ]; then
    			echo ">> EPI_REG OK: subject ${subj}/run ${this_run}"
		else
    			echo ">> EPI_REG FAIL: subject ${subj}/run ${this_run}"
		fi
		

	#### ---------- COREGISTER ASHS OUTPUT TO EPIS AND MAKE EC MASKS --------- ####
		

		if [ -f "${maskregdir}" ]; then
			echo "${maskregdir} exists"
		else
			mkdir ${maskregdir}
		fi

		echo "EXECUTING T2 mask to epi coreg for subject ${subj} run ${this_run}"

		# for left MTL


		# for right MTL


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


