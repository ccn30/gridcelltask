%% Run GLM on regressors
% to check multiple_regressors.txt file from CMRR extraction and PhysIO processing is plausible
addpath('/applications/spm/spm12_6906');
addpath('/home/ccn30/Physio_extract/tapas/PhysIO/code/assess/');

% initialise
subj = 27734;
TR = 2.53;
nScans = 238;
runN = 2;

% specify and estimate model
nrun = 1; % enter the number of runs here
jobfile = checkPhysRegress_job(subj,TR,nScans,runN);
jobs = repmat(jobfile, 1, nrun);
spm('defaults', 'FMRI');
spm_jobman('initcfg')
spm_jobman('run', jobs);

% f-contrast
outdir = ['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/regressors/' num2str(subj) '/Run' num2str(runN) '/fcontrast'];
spmmat = ['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/regressors/' num2str(subj) '/Run' num2str(runN) '/fcontrast/SPM.mat'];
physio = ['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/regressors/' num2str(subj) '/Run' num2str(runN) '/Physio_regressors/physio.mat'];
overlayim = ['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/' num2str(subj) '/rtopup_Run_' num2str(runN) '.nii'];

args = tapas_physio_report_contrasts(...
      'fileReport', outdir, ...
      'fileSpm', spmmat, ...
      'filePhysIO', physio, ...
      'fileStructural', overlayim, ...
      'reportContrastThreshold', '0.001', ...
      'reportContrastCorrection', 'FWE');
  
