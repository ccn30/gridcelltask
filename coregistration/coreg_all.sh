#!/bin/bash
#! script to coregister masks in T2 space to EPI space - creates right/left/both EC only masks and right/left MTL masks
	
	export antsroot=/applications/ANTS/2.2.0/bin

	pathstem=${1}
	subjID=${2}
	
	subject="$(cut -d'/' -f1 <<<"$subjID")"
	echo $subject
	
	# set subject-wise paths
	imagedirpath=${pathstem}/preprocessed_data/images/${subject}
	T1path=${pathstem}/raw_data/images/${subjID}/mp2rage
	#!N4T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4Series_033_Highresolution_TSE_PAT2_100_c32.nii
	N4T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii	
	segdirpath=${pathstem}/preprocessed_data/segmentation/${subject}
	coregdir=${segdirpath}/coregistration
	maskregdir=${segdirpath}/epimasks

	#!runs_to_process=(1 2 3) - combine means after coregistering EPIs together?
	#!runs_to_process=1

	cd ${segdirpath}
	pwd

	#### ---------- COREGISTER T2 TO T1 ---------- ####
	
	if [ -f "${coregdir}" ]; then
		echo "Coregistration directory exists"
	else
		mkdir ${coregdir}
		echo "Making coregistration directory..."
	fi
	
	cd ${coregdir}
	pwd
	
	#!echo "EXECUTING t2 to t1 coreg: " $subject	
	#!$antsroot/antsRegistrationSyNQuick.sh -d 3 -f ${N4T2} -m ${T1path}/denoiseRn4mag0000_PSIR_skulled_std.nii -o ${coregdir}/T1toT2_ANTS_

	#### ---------- COREGISTER EPIS TO T1 --------- ####
	
	# will need to remove for loop if making average EPI across all runs and coregistering 4D time series to it
	#!for this_run in ${runs_to_process[@]}
	#!do
		
		# run second time with skullstripped T1 instead of whole brain
		echo "EXECUTING epi to T1 coregistration for subject ${subject} using:"
		epi=${imagedirpath}/topup_Run_1_split0000.nii
		T1=${T1path}/denoiseRn4mag0000_PSIR_skulled_std_struc_brain.nii
		echo "EPI: " $epi
		echo "T1: " $T1
		antsRegistration \
			--dimensionality 3 \
			--float 0 \
			--output [T1toEPI_ssANTS_,T1toEPI_ssANTS_Warped.nii.gz,T1toEPI_ssANTS_InverseWarped.nii.gz] \
			--interpolation Linear --winsorize-image-intensities [0.005,0.995] \
			--use-histogram-matching 0 \
			--initial-moving-transform [${epi},${T1},1] \
			--transform Rigid[0.1] \
			--metric MI[${epi},${T1},1,32,Regular,0.20] \
			--convergence [1000x500x100x0,1e-6,10] \
			--shrink-factors 8x4x2x1 \
			--smoothing-sigmas 3x2x1x0vox \
			--transform SyN[0.1,3,0] \
			--restrict-deformation 1x1x0 \
			--metric CC[${epi},${T1},1,4] \
			--convergence [10,1e-6,10] \
			--shrink-factors 1 \
			--smoothing-sigmas 0vox  \
			--verbose
		
		if [ $? -eq 0 ]; then
    			echo ">> EPI_REG OK: subject ${subject}/run ${this_run}"
		else
    			echo ">> EPI_REG FAIL: subject ${subject}/run ${this_run}"
		fi
		

	#### ---------- COREGISTER ASHS OUTPUT TO EPIS AND MAKE EC MASKS --------- ####
	# do affine mask transformation as well as diffeomorphic
		
		if [ -f "${maskregdir}" ]; then
			echo "Epi Mask directory exists"
		else
			mkdir ${maskregdir}
			echo "Making EPI Mask directory"
		fi
		#!echo "EXECUTING T2 mask to EPI space transformation for subject ${subject}"
		
		# use same EPI as for T1 to EPI coregistration
		
		#----- DIFFEOMORPHIC SYN -----#
		#left MTL
		#!antsApplyTransforms -d 3 \
				-i ${segdirpath}/ASHS_corinputs/final/${subject}_3_left_lfseg_corr_nogray.nii.gz \
				-r ${epi} \
				-o ${maskregdir}/LeftMTLmaskWarped_SyN.nii.gz \
				-n MultiLabel \
				-t T1toEPI_ANTS_1Warp.nii.gz \
				-t T1toEPI_ANTS_0GenericAffine.mat \
				-t T1toT2_ANTS_1InverseWarp.nii.gz \
				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
				-v

		#right MTL
		#!antsApplyTransforms -d 3 \
				-i ${segdirpath}/ASHS_corinputs/final/${subject}_3_right_lfseg_corr_nogray.nii.gz \
				-r ${epi} \
				-o ${maskregdir}/RightMTLmaskWarped_SyN.nii.gz \
				-n MultiLabel \
				-t T1toEPI_ANTS_1Warp.nii.gz \
				-t T1toEPI_ANTS_0GenericAffine.mat \
				-t T1toT2_ANTS_1InverseWarp.nii.gz \
				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
				-v
	
		#----- AFFINE -----#
		#left MTL
		#!antsApplyTransforms -d 3 \
				-i ${segdirpath}/ASHS_corinputs/final/${subject}_3_left_lfseg_corr_nogray.nii.gz \
				-r ${epi} \
				-o ${maskregdir}/LeftMTLmaskWarped_affine.nii.gz \
				-n MultiLabel \
				-t T1toEPI_ANTS_0GenericAffine.mat \
				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
				-v

		#right MTL
		#!antsApplyTransforms -d 3 \
				-i ${segdirpath}/ASHS_corinputs/final/${subject}_3_right_lfseg_corr_nogray.nii.gz \
				-r ${epi} \
				-o ${maskregdir}/RightMTLmaskWarped_affine.nii.gz \
				-n MultiLabel \
				-t T1toEPI_ANTS_0GenericAffine.mat \
				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
				-v
		
		# create EC only masks
		# diffeomorphic
		#!fslmaths ${maskregdir}/LeftMTLmaskWarped_SyN.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/LeftECmaskWarped_SyN.nii.gz -odt char
		#!fslmaths ${maskregdir}/RightMTLmaskWarped_SyN.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/RightECmaskWarped_SyN.nii.gz -odt char
		# affine
		#!fslmaths ${maskregdir}/LeftMTLmaskWarped_affine.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/LeftECmaskWarped_affine.nii.gz -odt char
		#!fslmaths ${maskregdir}/RightMTLmaskWarped_affine.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/RightECmaskWarped_affine.nii.gz -odt char
		
		cd ${maskregdir}
		
		#!if [ -f "LeftECmaskWarped_affine.nii" ] && [ -f "RightECmaskWarped_SyN.nii" ]; then
			#!echo ">> EC MASKS SUCCESSFULLY TRANSFORMED TO EPI SPACE: subject ${subject}"
		#!else
			#!echo ">> EC MASKS FAILED TRANSFORMATION: subject ${subject}"
		#!fi
		
		cd ${pathstem}

	#!done


