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
	#!antsRegistrationSyNQuick.sh -d 3 -f ${N4rT2} -m ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -o t12t1_ANTS_

	## Run ANTS quick reg EPI to T1 - nearly worked, try skulstripped t1
	#!antsRegistrationSyNQuick.sh -d 3 -f ${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii -m ${imagedirpath}/meantopup_Run_1.nii -o epi2T1_ANTS_ss_
	
	## Run ANTS quick reg T1 to EPI
	antsRegistrationSyNQuick.sh -d 3 -f ${imagedirpath}/meantopup_Run_1.nii -m ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -o T12epi_ANTS_whole

