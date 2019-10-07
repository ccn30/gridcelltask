%% Create physio regressors for grid cell task single run
% Function called from makePhysRegressors which cd's to dir of puls/resp files for each run per subject
% OUTPUT: Physio_regressors dir with Physio struc and .txt file of regressors inside Physio_regressors dir
% For documentation of the parameters, see also tapas_physio_new
% Coco Newton 7.8.19 from PhysIO toolbox

function physio = getPhysRegressors_CMRR(nslices,tr,nvolumes)
fprintf('\n\n You are in the PhysIO toolbox.\n Making regressor files...\n\n\n');
pwd;

ndummies = 0; % always 0 from WBIC

addpath('/home/ccn30/Documents/MATLAB/glob');
addpath('/home/ccn30/Physio_extract/tapas/PhysIO/code');

% get CMRR extracted files
PULSE = glob('*_PULS.log');
RESP = glob('*_RESP.log');
INFO = glob('*_Info.log');
%% Create default parameter structure with all fields
physio = tapas_physio_new();

%% Individual Parameter settings.
physio.save_dir = {'Physio_regressors'};
physio.log_files.vendor = 'Siemens_Tics';
physio.log_files.cardiac = PULSE{1};
physio.log_files.respiration = RESP{1};
physio.log_files.scan_timing = INFO{1};
physio.log_files.relative_start_acquisition = 0;
physio.log_files.align_scan = 'last';
physio.scan_timing.sqpar.Nslices = nslices;
physio.scan_timing.sqpar.TR = tr;
physio.scan_timing.sqpar.Ndummies = ndummies;
physio.scan_timing.sqpar.Nscans = nvolumes;
physio.scan_timing.sqpar.onset_slice = 1;
physio.scan_timing.sync.method = 'scan_timing_log';
physio.preproc.cardiac.modality = 'PPU';
physio.preproc.cardiac.initial_cpulse_select.method = 'auto_matched';
physio.preproc.cardiac.initial_cpulse_select.file = 'initial_cpulse_kRpeakfile.mat';
physio.preproc.cardiac.initial_cpulse_select.min = 0.4;
physio.preproc.cardiac.posthoc_cpulse_select.method = 'off';
physio.preproc.cardiac.posthoc_cpulse_select.percentile = 80;
physio.preproc.cardiac.posthoc_cpulse_select.upper_thresh = 60;
physio.preproc.cardiac.posthoc_cpulse_select.lower_thresh = 60;
physio.model.orthogonalise = 'none';
physio.model.censor_unreliable_recording_intervals = false;
physio.model.output_multiple_regressors = 'multiple_regressors.txt';
physio.model.output_physio = 'physio.mat';
physio.model.retroicor.include = true;
physio.model.retroicor.order.c = 3;
physio.model.retroicor.order.r = 4;
physio.model.retroicor.order.cr = 1;
physio.model.rvt.include = false;
physio.model.rvt.delays = 0;
physio.model.hrv.include = false;
physio.model.hrv.delays = 0;
physio.model.noise_rois.include = false;
physio.model.noise_rois.thresholds = 0.9;
physio.model.noise_rois.n_voxel_crop = 0;
physio.model.noise_rois.n_components = 1;
physio.model.noise_rois.force_coregister = 1;
physio.model.movement.include = false;
physio.model.movement.order = 6;
physio.model.movement.censoring_threshold = 0.5;
physio.model.movement.censoring_method = 'FD';
physio.model.other.include = false;
physio.verbose.level = 2;
physio.verbose.process_log = cell(0, 1);
physio.verbose.fig_handles = zeros(0, 1);
physio.verbose.use_tabs = false;
physio.ons_secs.c_scaling = 1;
physio.ons_secs.r_scaling = 1;

%% Run physiological recording preprocessing and noise modeling
physio = tapas_physio_main_create_regressors(physio);
if exist('Physio_regressors','dir')
    fprintf('\n\n Done!');
else
    error('\n\n Oops, Physio_regressors dir has not been made \n');
end

end
