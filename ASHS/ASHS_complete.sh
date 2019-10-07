#!/bin/bash
# submit ASHS to slurm

#module unload matlab/matlab2016a    
#module load matlab/matlab2017b
#module load freesurfer/6.0.0
#module load spm/spm12_6906
#module load ASHS_1.0.0
#module load ANTS/2.2.0

declare -a mysubjs=("27734/20190902_U-ID46027
28061/20190911_U-ID46160
29317/20190902_U-ID46030
29321/20190902_U-ID46038
29332/20190903_U-ID46058
29336/20190903_U-ID46066
29358/20190905_U-ID46106
29382/20190911_U-ID46164
29383/20190912_U-ID46168"
);

#mysubjs="27734/20190902_U-ID46027"
#mysubjs="28428/20190903_U-ID46074"

export rawpathstem="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/images"
export preprocesspathstem="/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/segmentation"
export ashsdir="/home/ccn30/privatemodules/ASHS"

for subj in $mysubjs
do	
	subject="$(cut -d'/' -f1 <<<"$subj")"
	slurmworkdir=${preprocesspathstem}/${subject}/slurmoutput
	cd ${slurmworkdir}
	# set inputs for ASHS
	export subj
	echo "ASHS processing via SLURM:	$subj"
	sbatch /lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/scripts/ASHS/ASHS_sba.sh ${i}
done



# bias field correction for T2
#N4BiasFieldCorrection -d 3 -i ${T2} -o ${n4T2}  -r 1 -c [50x50x30x20,1e-6] -b [200]; 











