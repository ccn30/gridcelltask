#!/bin/bash
module unload fsl
module load fsl/5.0.10

	pathstem=${1}
	subjID=${2}
	
	subj="$(cut -d'/' -f1 <<<"$subjID")"
	echo $subj
	echo $pathstem
	
	imagedirpath=${pathstem}/preprocessed_data/images/${subj}
	T1path=${pathstem}/raw_data/images/${subjID}/mp2rage
	T2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii

	segdirpath=${pathstem}/preprocessed_data/segmentation/${subj}
	coregdir=${segdirpath}/coregistration
	maskregdir=${segdirpath}/epimasks

	#runs_to_process=(1 2 3)
	runs_to_process=1

	cd $coregdir
	pwd
	
	## run N4BiasFieldCorrection

	#!N4BiasFieldCorrection -i ${T2} -o ${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4rSeries_033_Highresolution_TSE_PAT2_100_c32.nii
	N4rT2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4rSeries_033_Highresolution_TSE_PAT2_100_c32.nii
	#!echo "Ran N4BiasFieldCorrection"
	
	## INSERT BEST ANTS FOR STRUCTURAL
	#!antsRegistrationSyNQuick.sh -d 3 -f ${N4rT2} -m ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -o ${coreg}/t12t1_ANTS_

	## Run ANTS quick reg EPI to T1 - nearly worked, try skulstripped t1 - no
	#!antsRegistrationSyNQuick.sh -d 3 -f ${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii -m ${imagedirpath}/meantopup_Run_1.nii -o ${coreg}/epi2T1_ANTS_ss_
	
	## Run ANTS quick reg T1 to EPI - works
	#!antsRegistrationSyNQuick.sh -d 3 -f ${imagedirpath}/meantopup_Run_1.nii -m ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -o ${coreg}/T12epi_ANTS_whole

	## Run ANTS syn full with parameters from Nick Tustison on SourceForge help thread 7d71cb7d64
	antsRegistration \
		--dimensionality 3 \
		--float 0 \
		--output [T12EPI_fullANTS_,T12EPI_fullANTS_Warped.nii.gz,T12EPI_fullANTS_InverseWarped.nii.gz] \
		--interpolation Linear --winsorize-image-intensities [0.005,0.995] \
		--use-histogram-matching 0 \
		--initial-moving-transform [${imagedirpath}/meantopup_Run_1.nii,${T1path}/reorientn4mag0000_PSIR_skulled_std.nii,1] \
		--transform Rigid[0.1] \
		--metric MI[${imagedirpath}/meantopup_Run_1.nii,${T1path}/reorientn4mag0000_PSIR_skulled_std.nii,1,32,Regular,0.20] \
		--convergence [1000x500x100x0,1e-6,10] \
		--shrink-factors 8x4x2x1 \
		--smoothing-sigmas 3x2x1x0vox \
		--transform SyN[0.1,3,0] \
		--restrict-deformation 1x1x0 \
		--metric CC[${imagedirpath}/meantopup_Run_1.nii,${T1path}/reorientn4mag0000_PSIR_skulled_std.nii,1,4] \
		--convergence [10,1e-6,10] \
		--shrink-factors 1 \
		--smoothing-sigmas 0vox  \
		--verbose


	## concatenate matrices and warp t2 masks to EPI space - t12t1 should be t12t2. WORKS with NN - now try multilabel (but these were wrong epi <> T1 matrix - correct should be T12epi)- now try correct matrix with syn deformations with multilabel - WORKS BEST
#!	antsApplyTransforms -d 3 \
#!				-i ${segdirpath}/final/${subj}_left_lfseg_corr_nogray.nii.gz \
#!				-r ${imagedirpath}/meantopup_Run_1.nii \
#!				-o t12epimasks_syn_multilabel.nii.gz \
#!				-n MultiLabel \
#!				-t T12epi_ANTS_whole1Warp.nii.gz \
#!				-t T12epi_ANTS_whole0GenericAffine.mat \
#!				-t t12t1_ANTS_1InverseWarp.nii.gz \
#!				-t [t12t1_ANTS_0GenericAffine.mat,1] \
#!				-v
	## now try correct matrix with syn deformations with nearest neighbour	- WORKS BUT FEWER VOXELS IN EC MASK
#!	antsApplyTransforms -d 3 \
#!				-i ${segdirpath}/final/${subj}_left_lfseg_corr_nogray.nii.gz \
#!				-r ${imagedirpath}/meantopup_Run_1.nii \
#!				-o t12epimasks_syn_NN.nii.gz  \
#!				-n NearestNeighbor \
#!				-t T12epi_ANTS_whole1Warp.nii.gz \
#!				-t T12epi_ANTS_whole0GenericAffine.mat \
#!				-t t12t1_ANTS_1InverseWarp.nii.gz \
#!				-t [t12t1_ANTS_0GenericAffine.mat,1] \
#!				-v

	## now try correct matrix without syn deformations with multilabel - overlays on area of dropout...oriiginal EC or is EC distorted up which SyN picks up on?
#!	antsApplyTransforms -d 3 \
#!				-i ${segdirpath}/final/${subj}_left_lfseg_corr_nogray.nii.gz \
#!				-r ${imagedirpath}/meantopup_Run_1.nii \
#!				-o t12epimasks_affine_multilabel.nii.gz  \
#!				-n MultiLabel \
#!				-t T12epi_ANTS_whole0GenericAffine.mat \
#!				-t [t12t1_ANTS_0GenericAffine.mat,1] \
#!				-v


