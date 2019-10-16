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

	## now try correct matrix without syndeformations with multilabel
	antsApplyTransforms -d 3 \
				-i ${segdirpath}/final/${subj}_left_lfseg_corr_nogray.nii.gz \
				-r ${imagedirpath}/meantopup_Run_1.nii \
				-o t12epimasks_affine_multilabel.nii.gz  \
				-n MultiLabel \
				-t T12epi_ANTS_whole0GenericAffine.mat \
				-t [t12t1_ANTS_0GenericAffine.mat,1] \
				-v

