#!/bin/bash
#
#PBS -N Matlab
#PBS -m be 
#PBS -k oe

subject=${1}
func=${2}

matlab -nodesktop -nosplash -nodisplay <<EOF
[pa,af,~]=fileparts('${func}');
addpath(pa);
disp(['Subject is ${subject}'])
addpath(pwd);
addpath('/home/ccn30/GridCAT')
addpath('/applications/spm/spm12_6906')
addpath('/home/ccn30/Documents/MATLAB/Add-Ons/Collections/Circular Statistics Toolbox (Directional Statistics)/code')
preprocesspathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data';
taskpathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data';
dofunc=sprintf('%s(%s,%s,%s)',af,'''${subject}''','preprocesspathstem','taskpathstem');
disp(['Submitting the following command: ' dofunc])
eval(dofunc)
;exit
EOF
