% List of open inputs
% fMRI model specification: Directory - cfg_files
% fMRI model specification: Units for design - cfg_menu
% fMRI model specification: Interscan interval - cfg_entry
% fMRI model specification: Scans - cfg_files
% fMRI model specification: Onsets - cfg_entry
% fMRI model specification: Durations - cfg_entry
% fMRI model specification: Name - cfg_entry
% fMRI model specification: Value - cfg_entry
% fMRI model specification: Scans - cfg_files
% fMRI model specification: Onsets - cfg_entry
% fMRI model specification: Durations - cfg_entry
% fMRI model specification: Name - cfg_entry
% fMRI model specification: Value - cfg_entry
% fMRI model specification: Scans - cfg_files
% fMRI model specification: Onsets - cfg_entry
% fMRI model specification: Durations - cfg_entry
% fMRI model specification: Name - cfg_entry
% fMRI model specification: Value - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/scripts/SPM_univariate/module_FirstLevel_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(18, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Units for design - cfg_menu
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Interscan interval - cfg_entry
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Scans - cfg_files
    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Onsets - cfg_entry
    inputs{6, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Durations - cfg_entry
    inputs{7, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Name - cfg_entry
    inputs{8, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Value - cfg_entry
    inputs{9, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Scans - cfg_files
    inputs{10, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Onsets - cfg_entry
    inputs{11, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Durations - cfg_entry
    inputs{12, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Name - cfg_entry
    inputs{13, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Value - cfg_entry
    inputs{14, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Scans - cfg_files
    inputs{15, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Onsets - cfg_entry
    inputs{16, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Durations - cfg_entry
    inputs{17, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Name - cfg_entry
    inputs{18, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Value - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
