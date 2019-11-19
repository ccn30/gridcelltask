#!/bin/bash
#
#PBS -N Matlab
#PBS -m be 
#PBS -k oe

subject=${1}
func=${2}

matlab -nodesktop -nosplash <<EOF
[pa,af,~]=fileparts('${func}');
addpath(pa);
disp(['Subject is ${subject}'])
addpath(pwd);
addpath('/home/ccn30/GridCAT')
addpath('/applications/spm/spm12_6906')
addpath('/home/ccn30/Documents/MATLAB/Add-Ons/Collections/Circular Statistics Toolbox (Directional Statistics)/code')

% what type of mask to use - affine or SyN or control?
warp_flag = 'affine'

% use original [left,right,both] EC ROI or [pmLeft,pmRight] new posteromedial EC ROI mask?
ROI_flag = 'pmLeft'

% 4,5,6,7 or 8 fold symmetry?
xFold = '6'

% SPM mask threshold for GLM
mask_thresh = '0.4'

% Which type of regressor should be included for grid events?
    %   'pmod' ... one regressor with a parametric modulation
    %   'aligned_misaligned' ... one regressor for events that are aligned with the mean grid orientation
    %                            and one regressor for misaligned events
    %   'aligned_misaligned_multiple' ... one regressor for each orientation, for which either a positive peak (for aligned events)
    %                                     or a negative peak (for misaligned events) in the BOLD signal is expected
regressor_flag = 'aligned_misaligned'

% Name of output directory
outdirname = 'gridCAT_pmEC02'

preprocesspathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data';
taskpathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data';

dofunc=sprintf('%s(%s,%s,%s,%s,%s,%s,%s,%s,%s)',af,'''${subject}''','preprocesspathstem','taskpathstem','outdirname','ROI_flag','warp_flag','xFold','mask_thresh','regressor_flag');
disp(['Submitting the following command: ' dofunc])
eval(dofunc)
;exit
EOF
