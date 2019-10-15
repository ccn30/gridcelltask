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
	
	# run N4BiasFieldCorrection
	#!N4BiasFieldCorrection -i ${T2} -o ${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4rSeries_033_Highresolution_TSE_PAT2_100_c32.nii
	N4rT2=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/N4rSeries_033_Highresolution_TSE_PAT2_100_c32.nii
	#!echo "Ran N4BiasFieldCorrection -- ${N4rT2}"

	#### ---------- COREGISTER T2 TO T1 ---------- ####
	#! t2 to t1 matrix from ASHS doesn't work
	#!if [ -f "${coregdir}" ]; then
	#!	echo "${coregdir} exists"
	#!else
	#!	mkdir ${coregdir}
	#!fi

	echo "EXECUTING t2 to t1 coreg in ${coregdir}" 

	
		# try ANTSyN using ITK snap manual brain mask and rigid transformation matrix (could also use MP2RAGE mask or MTL mask form ITKSNAP?)	
		#!antsRegistrationSyN.sh -d 3.....

		# try ANTS simple default with T2 as fixed image and mask on T1 to exclude brain, using whole brain T1 - WORKED BUT MASK DIDNT
		antsRegistrationSyNQuick.sh -d 3 -f ${N4rT2} -m ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -o t12t1_ANTS_

		# try ANTS simple default (have added module load to SLURM submit script) - WORKED BETTER (need to skullstrip)
		#!antsRegistrationSyNQuick.sh -d 3 -f ${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii -m ${N4rT2} -o t22t1_ANTS

	
	
		#--------------------------FSL------------------------------#
	
		## try FLIRT BBR using itksnap.mat manual MI rigid registration to initialise - skullstripped no, whole brain no
		
		#!flirt -in ${N4rT2} -ref ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -dof 6 -cost bbr -wmseg ${T1path}/reorientc2n4mag0000_PSIR_skulled_std.nii -schedule /applications/fsl/fsl-5.0.10/etc/flirtsch/bbr.sch -init ${coregdir}/t22t1itksnap.mat -omat ${coregdir}/t22t1_bbr_itksnap.mat -out ${coregdir}/t22t1_bbr_itksnap.nii
		#if [ $? -eq 0 ]; then
    	#		echo ">> BBR COREG OK: subject ${subj}/run ${this_run}"
		#else
    	#		echo ">> BBR COREG FAIL: subject ${subj}/run ${this_run}"
		#fi
	
		## FLIRT BBR with ANTS affine.mat to initialise (whole brain, T2 ref) - doens't work with ANTS MAT
		flirt -in ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -ref ${N4rT2} -dof 6 -cost bbr -wmseg ${T1path}/reorientc2n4mag0000_PSIR_skulled_std.nii -schedule /applications/fsl/fsl-5.0.10/etc/flirtsch/bbr.sch -init ${coregdir}/t12t2_ANTS_0GenericAffine.mat -omat ${coregdir}/t12t2_bbr_ANTSaffine.mat -out ${coregdir}/t12t2_bbr_ANTSaffine.nii
		if [ $? -eq 0 ]; then
    			echo ">> BBR COREG OK: subject ${subj}/run ${this_run}"
		else
    			echo ">> BBR COREG FAIL: subject ${subj}/run ${this_run}"
		fi
		
		## FLIRT BBR with ANTS affine.mat to initialise (whole brain, T1 REF - invert matrix) - doens't work with ANTS MAT
		convert_xfm -omat ${coregdir}/t12t2_ANTS_0GenericAffine_inverse.mat -inverse ${coregdir}/t12t2_ANTS_0GenericAffine.mat
		
		flirt -in ${N4rT2} -ref ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -dof 6 -cost bbr -wmseg ${T1path}/reorientc2n4mag0000_PSIR_skulled_std.nii -schedule /applications/fsl/fsl-5.0.10/etc/flirtsch/bbr.sch -init ${coregdir}/t12t2_ANTS_0GenericAffine_inverse.mat -omat ${coregdir}/t22t1_bbr_ANTSaffine.mat -out ${coregdir}/t22t1_bbr_ANTSaffine.nii
		if [ $? -eq 0 ]; then
    			echo ">> BBR COREG OK: subject ${subj}/run ${this_run}"
		else
    			echo ">> BBR COREG FAIL: subject ${subj}/run ${this_run}"
		fi
		
		
		## try MI instead of corr ratio for whole brain images - NO

		#!flirt -in ${N4rT2} -ref ${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii -dof 6 -cost mutualinfo -out ${coregdir}/t22t1_MI_reorientN4_${this_run}.nii -omat ${coregdir}/t22t1_MI_reorientN4_${this_run}.mat		

		## use T2 as ref image instead of T1 - NO
		
		#!flirt -in ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii -ref ${T2} -dof 6 -out ${coregdir}/t12t2_CorRatio_T2REF_${this_run}.nii -omat ${coregdir}/t12t2_CorRatio_${this_run}.mat
		#if [ $? -eq 0 ]; then
    	#		echo ">> CORR_RATIO COREG T2REF OK: subject ${subj}/run ${this_run}"	
		#else
    	#		echo ">> CORR_RATIO T2REF FAIL: subject ${subj}/run ${this_run}"
		#fi

		## use BET T2 as well as BET T1, with T1 as ref	- NO
		
		#!bet ${T2} ${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/BET_T2.nii
		#T2BET=${pathstem}/raw_data/images/${subjID}/Series_033_Highresolution_TSE_PAT2_100/BET_T2.nii
		#!flirt -in ${T2BET} -ref ${T1path}/n4mag0000_PSIR_skulled_std_struc_brain.nii -dof 6 -out ${coregdir}/t22t1_CorRatio_BETT2_${this_run}.nii -omat ${coregdir}/t22t1_CorRatio_${this_run}.mat
		#if [ $? -eq 0 ]; then
    	#		echo ">> CORR_RATIO BET COREG OK: subject ${subj}/run ${this_run}"	
		#else
    	#		echo ">> CORR_RATIO BET FAIL: subject ${subj}/run ${this_run}"
		#fi
		
		## use fslreorient2std images and N4BiasFieldCorrection T2 and 3DOF - NO,NO,NO
		
		#!flirt -in ${N4rT2} -ref ${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii -dof 3 -out ${coregdir}/t22t1_CorRatio_reorientN43DOF_${this_run}.nii -omat ${coregdir}/t22t1_CorRatio_reorientN43DOF_${this_run}.mat
		#if [ $? -eq 0 ]; then
    	#		echo ">> CORR_RATIO COREG T2REF OK: subject ${subj}/run ${this_run}"	
		#else
    	#		echo ">> CORR_RATIO T2REF FAIL: subject ${subj}/run ${this_run}"
		#fi
		
		## try simple schedule -NO
		
		#!flirt -in ${N4rT2} -ref ${T1path}/reorientn4mag0000_PSIR_skulled_std_struc_brain.nii -schedule /applications/fsl/fsl-5.0.10/etc/flirtsch/simple3D.sch -dof 6 -out ${coregdir}/t22t1_CorRatio_reorientN4sch_${this_run}.nii -omat ${coregdir}/t22t1_CorRatio_reorientN4sch_${this_run}.mat
		#if [ $? -eq 0 ]; then
    	#		echo ">> CORR_RATIO COREG T2REF OK: subject ${subj}/run ${this_run}"	
		#else
    	#		echo ">> CORR_RATIO T2REF FAIL: subject ${subj}/run ${this_run}"
		#fi
		
		## try whole brain T1 - NO
		
		#!flirt -in ${N4rT2} -ref ${T1path}/reorientn4mag0000_PSIR_skulled_std.nii -dof 6 -out ${coregdir}/t22t1_CorRatio_reorientN4whole_${this_run}.nii -omat ${coregdir}/t22t1_CorRatio_reorientN4whole_${this_run}.mat
		#if [ $? -eq 0 ]; then
    	#		echo ">> CORR_RATIO COREG T2REF OK: subject ${subj}/run ${this_run}"	
		#else
    	#		echo ">> CORR_RATIO T2REF FAIL: subject ${subj}/run ${this_run}"
		#fi
		
