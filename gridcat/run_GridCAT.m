%% Get grid metrics from fMRI data
% calls GridCAT_mainfunc function wrapper for SPM Matlab batch job

subjectvec = {'27734','28061','28428','29317','29321','29332','29336','29358','29382','29383'};
%dateIDvec = {'20190902_U-ID46027','20190911_U-ID46160','20190903_U-ID46074','20190902_U-ID46030','20190902_U-ID46038','20190903_U-ID46058','20190903_U-ID46066','20190905_U-ID46106','20190911_U-ID46164','20190912_U-ID46168'};

preprocesspathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data';
taskpathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data';

runs = {'BlockA','BlockB','BlockC'};
TR = 2.53;
xfold = 6;
nScans = 238;
maskthresh=0.4;