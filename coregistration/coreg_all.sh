#!/bin/bash
# script to coregister masks in T2 space to EPI space - creates right/left/both EC only masks and right/left MTL masks
	
	export antsroot=/applications/ANTS/2.2.0/bin

	pathstem=${1}
	subjID=${2}
	
	subject="$(cut -d'/' -f1 <<<"$subjID")"
	echo $subject
	
	# set subject-wise paths
#!	imagedirpath=${pathstem}/preprocessed_data/images/old_data/${subject}
#!	T1path=${pathstem}/raw_data/images/${subjID}/mp2rage
#!	T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/Series_033_Highresolution_TSE_PAT2_100_c32.nii
#!	N4T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii	
	
	# for new pTx pilot	
	imagedirpath=${pathstem}/preprocessed_data/images/${subject}
	segdirpath=${pathstem}/preprocessed_data/segmentation/${subject}
	coregdir=${segdirpath}/coregistration
	maskregdir=${segdirpath}/epimasks

	T1=${pathstem}/preprocessed_data/images/${subject}/structural.nii
	T2=${pathstem}/raw_data/images/${subjID}/Series_039_Highresolution_TSE_PAT2_100_PatSpec/Series_039_Highresolution_TSE_PAT2_100_PatSpec.nii
	N4T2=${pathstem}/raw_data/images/${subjID}/Series_039_Highresolution_TSE_PAT2_100_PatSpec/N4Series_039_Highresolution_TSE_PAT2_100_PatSpec.nii
	epi=${imagedirpath}/topup_Run_1_split0000.nii
	
	#!pm_al_maskdir=/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/segmentation/pm-alEC_masks
		
	cd ${segdirpath}
	pwd

#################################################################
# 		COREGISTER T2 to T1 (ANTS)			#	
#################################################################
	
	if [ -f "${coregdir}" ]; then
		echo "Coregistration directory exists"
	else
		mkdir ${coregdir}
		echo "Making coregistration directory..."
	fi
	
	cd ${coregdir}
	pwd
	
	echo "EXECUTING t2 to t1 coreg: " $subject	
	# N4 T2 and whole brain denoised reorientated T1 (if using new MP2RAGE, don't denoise)
#!	$antsroot/antsRegistrationSyNQuick.sh -d 3 -f ${N4T2} -m ${T1} -o ${coregdir}/T1toT2_ANTS_

	# to check affine only transformation

#!	antsApplyTransforms -d 3 \
#!			-i ${N4T2} \
#!			-r ${T1} \
#!			-o T2toT1Warped_affine.nii.gz \
#!			-n Linear \
#!			-t [T1toT2_ANTS_0GenericAffine.mat,1] \
#!			-v

#################################################################
# 		COREGISTER EPIS to T1 (ANTS)			#	
#################################################################
# NB currently using ITK affine cross corr in GUI
	
		
		# run second time with skullstripped T1 instead of whole brain
#!		echo "EXECUTING epi to T1 coregistration for subject ${subject} using:"
#!		echo "EPI: " $epi
#!		echo "T1: " $T1
#!		antsRegistration \
#!			--dimensionality 3 \
#!			--float 0 \
#!			--output [T1toEPI_ssANTS_,T1toEPI_ssANTS_Warped.nii.gz,T1toEPI_ssANTS_InverseWarped.nii.gz] \
#!			--interpolation Linear --winsorize-image-intensities [0.005,0.995] \
#!			--use-histogram-matching 0 \
#!			--initial-moving-transform [${epi},${T1},1] \
#!			--transform Rigid[0.1] \
#!			--metric MI[${epi},${T1},1,32,Regular,0.20] \
#!			--convergence [1000x500x100x0,1e-6,10] \
#!			--shrink-factors 8x4x2x1 \
#!			--smoothing-sigmas 3x2x1x0vox \
#!			--transform SyN[0.1,3,0] \
#!			--restrict-deformation 1x1x0 \
#!			--metric CC[${epi},${T1},1,4] \
#!			--convergence [10,1e-6,10] \
#!			--shrink-factors 1 \
#!			--smoothing-sigmas 0vox  \
#!			--verbose
		
#!		if [ $? -eq 0 ]; then
#!    			echo ">> EPI_REG OK: subject ${subject}/run ${this_run}"
#!		else
#!    			echo ">> EPI_REG FAIL: subject ${subject}/run ${this_run}"
#!		fi
		
#################################################################
# 	COREGISTER ASHS OUTPUT TO EPIS AND MAKE EC MASKS 	#	
#################################################################
		
		if [ -f "${maskregdir}" ]; then
			echo "Epi Mask directory exists"
		else
			mkdir ${maskregdir}
			echo "Making EPI Mask directory"
		fi
		echo "EXECUTING T2 mask to EPI space transformation for subject ${subject}"
		
		# use same EPI as for T1 to EPI coregistration
		
		#----- DIFFEOMORPHIC SYN -----#
		
		#left MTL
#!		antsApplyTransforms -d 3 \
#!				-i ${segdirpath}/ASHS_corinputs/final/${subject}_3_left_lfseg_corr_nogray.nii.gz \
#!				-r ${epi} \
#!				-o ${maskregdir}/LeftMTLmaskWarped_SyN.nii.gz \
#!				-n MultiLabel \
#!				-t T1toEPI_ANTS_1Warp.nii.gz \
#!				-t T1toEPI_ANTS_0GenericAffine.mat \
#!				-t T1toT2_ANTS_1InverseWarp.nii.gz \
#!				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
#!				-v

		#right MTL
#!		antsApplyTransforms -d 3 \
#!				-i ${segdirpath}/ASHS_corinputs/final/${subject}_3_right_lfseg_corr_nogray.nii.gz \
#!				-r ${epi} \				-o ${maskregdir}/RightMTLmaskWarped_SyN.nii.gz \
#!				-n MultiLabel \
#!				-t T1toEPI_ANTS_1Warp.nii.gz \
#!				-t T1toEPI_ANTS_0GenericAffine.mat \
#!				-t T1toT2_ANTS_1InverseWarp.nii.gz \
#!				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
#!				-v
	
		#----- AFFINE ITK and ANTS -----#
		
		#right MTL mask transformation 
		antsApplyTransforms -d 3 \
				-i ${segdirpath}/ASHS/final/${subject}_right_lfseg_corr_nogray.nii.gz \
				-r ${epi} \
				-o ${maskregdir}/RightMTLmaskWarped_ITKaffine.nii.gz \
				-n MultiLabel \
				-t [EPItoT1_ITKaffine_Run_1.txt,1] \
				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
				-v
		#left MTL mask transformation
		antsApplyTransforms -d 3 \
				-i ${segdirpath}/ASHS/final/${subject}_left_lfseg_corr_nogray.nii.gz \
				-r ${epi} \
				-o ${maskregdir}/LeftMTLmaskWarped_ITKaffine.nii.gz \
				-n MultiLabel \
				-t [EPItoT1_ITKaffine_Run_1.txt,1] \
				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
				-v

		#left MTL for pmEC mask
#!		antsApplyTransforms -d 3 \
#!				-i ${pm_al_maskdir}/leftMTL_${subject}.nii.gz \
#!				-r ${epi} \
#!				-o ${pm_al_maskdir}/leftMTLWarped_${subject}.nii.gz \
#!				-n MultiLabel \
#!				-t [EPItoT1_ITK_affine_crosscorr.txt,1] \
#!				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
#!				-v
		#right MTL for pmEC mask
#!		antsApplyTransforms -d 3 \
#!				-i ${pm_al_maskdir}/rightMTL_${subject}.nii.gz \
#!				-r ${epi} \
#!				-o ${pm_al_maskdir}/rightMTLWarped_${subject}.nii.gz \
#!				-n MultiLabel \
#!				-t [EPItoT1_ITK_affine_crosscorr.txt,1] \
#!				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
#!				-v

		#right MTL original mask transformation code
#!		antsApplyTransforms -d 3 \
#!				-i ${segdirpath}/ASHS_corinputs/final/${subject}_3_right_lfseg_corr_nogray.nii.gz \
#!				-r ${epi} \
#!				-o ${maskregdir}/RightMTLmaskWarped_ITKaffine.nii.gz \
#!				-n MultiLabel \
#!				-t [EPItoT1_ITK_affine_crosscorr.txt,1] \
#!				-t [T1toT2_ANTS_0GenericAffine.mat,1] \
#!				-v
#!		
		#----- CREATE EC ONLY MASKS -----#
		
		# diffeomorphic
#!		fslmaths ${maskregdir}/LeftMTLmaskWarped_SyN.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/LeftECmaskWarped_SyN.nii.gz -odt char
#!		fslmaths ${maskregdir}/RightMTLmaskWarped_SyN.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/RightECmaskWarped_SyN.nii.gz -odt char
		
		# affine
		fslmaths ${maskregdir}/LeftMTLmaskWarped_ITKaffine.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/LeftECmaskWarped_ITKaffine.nii -odt char
		fslmaths ${maskregdir}/RightMTLmaskWarped_ITKaffine.nii.gz -thr 8.5 -uthr 9.5 -bin ${maskregdir}/RightECmaskWarped_ITKaffine.nii -odt char
		
		# pmEC mask extractrion 14.5,15.5, alEC extraction 13.5,14.5
#!		fslmaths ${pm_al_maskdir}/leftMTLWarped_${subject}.nii.gz -thr 13.5 -uthr 14.5 -bin ${maskregdir}/alEC_leftWarped_ITKaffine.nii -odt char
#!		fslmaths ${pm_al_maskdir}/rightMTLWarped_${subject}.nii.gz -thr 13.5 -uthr 14.5 -bin ${maskregdir}/alEC_rightWarped_ITKaffine.nii -odt char
		
		# make control masks of posterior hippocampus
#!		fslmaths ${maskregdir}/LeftMTLmaskWarped_ITKaffine.nii.gz -thr 4.5 -uthr 5.5 -bin ${maskregdir}/LeftPostHCmaskWarped_ITKaffine.nii -odt char
#!		fslmaths ${maskregdir}/RightMTLmaskWarped_ITKaffine.nii.gz -thr 4.5 -uthr 5.5 -bin ${maskregdir}/RightPostHCmaskWarped_ITKaffine.nii -odt char
	


		cd ${maskregdir}
		
		if [ -f "LeftECmaskWarped_ITKaffine.nii" ] && [ -f "RightECmaskWarped_ITKaffine.nii" ]; then
			echo ">> EC MASKS SUCCESSFULLY TRANSFORMED TO EPI SPACE: subject ${subject}"
		else
			echo ">> EC MASKS FAILED TRANSFORMATION: subject ${subject}"
		fi
		
		cd ${pathstem}
