%% GridCAT function for batch script
% input images, event table and regressors to generate grid cell metrics
% CCNewton adapted from GridCAT demo script 22/08/19

% Add GridCAT to the Matlab path:
%GridCAT_path = '/home/ccn30/GridCAT'; % specify the path to the GridCAT directory
%addpath(genpath(GridCAT_path));

% % Add SPM12 to the Matlab path:
%SPM12_path = '/applications/spm/spm12_6906'; % specify the path to the SPM12 directory
%addpath(genpath(SPM12_path));

% Add CircStat2012a to the Matlab path:
%CircStat_path = '/home/ccn30/Documents/MATLAB/Add-Ons/Collections/Circular Statistics Toolbox (Directional Statistics)/code'; % specify the path to the CircStat2012a directory
%addpath(genpath(CircStat_path));

function GridCAT_mainfunc
%(preprocesspathstem,outpathstem,subjectvec,dateIDvec,nrun,TR,xfold)

subjectvec = {'27734','28061','28428','29317','29321','29332','29336','29358','29382','29383'};
%dateIDvec = {'20190902_U-ID46027','20190911_U-ID46160','20190903_U-ID46074','20190902_U-ID46030','20190902_U-ID46038','20190903_U-ID46058','20190903_U-ID46066','20190905_U-ID46106','20190911_U-ID46164','20190912_U-ID46168'};

preprocesspathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data';
taskpathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data';
outpathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/gridCAT_output';

runs = {'BlockA','BlockB','BlockC'};
TR = 2.53;
xfold = 6;
nScans = 238;
maskthresh=0.4;

%% FLAGS
% what type of mask to use - affine or SyN
warp_flag = 'affine';
% calculate mean grid orientation within each run separately (0) or across all runs (1)
orientationcalc_flag = 0;
% use physiology regressors (phys) or use movement parameters (move)
regressor_flag='phys';

for subj = 1 %1:length(subjectvec)
    %% FUNCTIONAL SCANS, EVENT-TABLES, ADDITIONAL REGRESSORS
    for run = 1:3 %1:length(runs)
        
        % specify functional scans
        for scan = 1:nScans
            cfg.rawData.run(run).functionalScans(scan,1) = {[preprocesspathstem '/images/' subjectvec{subj} '/rtopup_Run_' num2str(run) '.nii,' num2str(scan)]};
        end
        
        % specify event-table
        cfg.rawData.run(run).eventTable_file = [taskpathstem '/' subjectvec{subj} '/' runs{run} '/eventTable_movemenEventData.txt'] ;
        
        % specify additional regressors file - need to combine rp.txt with phys regressors
        if strcmp(regressor_flag,'phys') == 1
            cfg.rawData.run(run).additionalRegressors_file = {[preprocesspathstem '/regressors/' subjectvec{subj} '/Run' num2str(run) '/Physio_regressors/multiple_regressors.txt']};
        elseif strcmp(regressor_flag,'move') == 1
            cfg.rawData.run(run).additionalRegressors_file = {[preprocesspathstem '/images/' subjectvec{subj} '/rp_topup_Run_' num2str(run) '.txt']};
        end
        
    end
    %% MODEL SETTINGS
    
    % TR (inter-scan-interval) in seconds
    cfg.GLM.TR = TR;
    
    % x-fold symmetry value that the model is testing for
    cfg.GLM.xFoldSymmetry = xfold;
    
    % Masking threshold
    cfg.GLM.maskingThreshold = maskthresh;
    
    % Microtime onset & resolution
    cfg.GLM.microtimeOnset = 8;
    cfg.GLM.microtimeResolution = 16;
    
    % HPF per run
    cfg.GLM.HPF_perRun = [128, 128];
    
    % Model derivatives
    %   [0 0] ... do not model derivatives
    %   [1 0] ... time derivatives
    %   [1 1] ... model time and dispersion derivatives
    cfg.GLM.derivatives = [0 0];
    
    % Optional: Do you want to display the design matrix after it has been created?
    % The design matrix will not be displayed, if this settings is not defined
    % use 0 or 1
    cfg.GLM.dispDesignMatrix = 1;
    
    
    %% GLM1
    
    % Specify GLM number
    %   1 ... estimate grid orientations voxelwise
    %   2 ... test grid orientations
    cfg.GLMnr = 1;
    
    % Specify data directory for this GLM
    % The directory will be created if it does not exist
    cfg.GLM.dataDir = [outpathstem '/GLM1'];
    
    % Which grid events should be used for this GLM?
    %	2 ... use the first half of grid events per run
    %	3 ... use the second half of grid events per run
    %	4 ... use odd grid events within each run
    %	5 ... use even grid events within each run
    %	6 ... use all grid events of odd runs
    %	7 ... use all grid events of even runs
    %	8 ... use all grid events of all runs
    %	9 ... use specification from event-table
    cfg.GLM.eventUsageSpecifier = 2;
    
    % Include unused grid events in the model?
    %	0 ... grid events that are not used for this GLM will not be included in the model
    %	1 ... grid events that are not used for this GLM will not be included in the model
    cfg.GLM.keepUnusedGridEvents = 1;
    
    % Specify GLM1 using the current configuration (cfg)
    specifyGLM(cfg);
    
    % Estimate GLM1 using the current configuration (cfg)
    estimateGLM(cfg);
    
    
    %% GLM2
    
    % Specify GLM number
    %   1 ... estimate grid orientations voxelwise
    %   2 ... test grid orientations
    cfg.GLMnr = 2;
    
    % Specify data directory for this GLM
    % The directory will be created if it does not exist
    cfg.GLM.dataDir = [outpathstem '/GLM2'];
    
    % Which grid events should be used for this GLM?
    %	2 ... use the first half of grid events per run
    %	3 ... use the second half of grid events per run
    %	4 ... use odd grid events within each run
    %	5 ... use even grid events within each run
    %	6 ... use all grid events of odd runs
    %	7 ... use all grid events of even runs
    %	8 ... use all grid events of all runs
    %	9 ... use specification from event-table
    cfg.GLM.eventUsageSpecifier = 3;
    
    % Include unused grid events in the model?
    %	0 ... grid events that are not used for this GLM will not be included in the model
    %	1 ... grid events that are not used for this GLM will not be included in the model
    cfg.GLM.keepUnusedGridEvents = 1;
    
    % GLM2 tests the estimated grid orientations that were estimated in GLM1.
    % Specify here, where the GLM1 output is stored (i.e., the GLM1 data directory)
    cfg.GLM.GLM1_resultsDir = [outpathstem '/GLM1'];
    
    % Specify binary ROI mask
    % Nonzero voxels within this mask are used to calculate the mean grid orientation.
    % Use either affine or SyN mask
    if strcmp(warp_flag,'affine') == 1
        cfg.GLM.GLM2_roiMask_calcMeanGridOri = {
                                            [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/LeftECmaskWarped_affine.nii']
                                            [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/RightECmaskWarped_affine.nii']
                                            };
    elseif strcmp(warp_flag,'SyN') == 1
        cfg.GLM.GLM2_roiMask_calcMeanGridOri = {
                                            [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/LeftECmaskWarped_SyN.nii']
                                            [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/RightECmaskWarped_SyN.nii']
                                            };
    end
    
    % Use different weighting for individual voxels within the ROI, when estimating the mean grid orientation?
    %   0 ... all voxels within the ROI will get the same weighting
    %   1 ... voxels will be weighted differently, according to their estimated firing amplitude in GLM1
    cfg.GLM.GLM2_useWeightingForVoxels = 1;
    
    % Calculate the mean grid orientation within an ROI across all runs or separately for each run?
    %   0 ... the mean grid orientation is calculated for each run separately
    %   1 ... the mean grid orientation is averaged across all runs
    cfg.GLM.GLM2_averageMeanGridOriAcrossRuns = orientationcalc_flag;
    
    % Which type of regressor should be included for grid events?
    %   'pmod' ... one regressor with a parametric modulation
    %   'aligned_misaligned' ... one regressor for events that are aligned with the mean grid orientation
    %                            and one regressor for misaligned events
    %   'aligned_misaligned_multiple' ... one regressor for each orientation, for which either a positive peak (for aligned events)
    %                                     or a negative peak (for misaligned events) in the BOLD signal is expected
    cfg.GLM.GLM2_gridRegressorMethod = 'aligned_misaligned';
    
    % Specify GLM2 using the current configuration (cfg)
    specifyGLM(cfg);
    
    % Estimate GLM2 using the current configuration (cfg)
    estimateGLM(cfg);
    
    
    %% EXPORT GRID METRICS
    
    % Specify ROI masks, for which the grid metrics are calculated and exported
    if strcmp(warp_flag,'affine') == 1
        ROI_masks = {
                     [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/LeftECmaskWarped_affine.nii']
                     [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/RightECmaskWarped_affine.nii']
                     };
    elseif strcmp(warp_flag,'SyN') == 1
        ROI_masks = {
                     [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/LeftECmaskWarped_SyN.nii']
                     [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/RightECmaskWarped_SyN.nii']
                     };
    end
    
    % Specify where the GLM1 and GLM2 output is stored
    GLM1dir = [outpathstem '/GLM1'];
    GLM2dir = [outpathstem '/GLM2'];
    
    % Specify where the grid metric output should be saved
    output_file = {[outpathstem '/GridCAT_grid_metrics.txt']};
    
    % Calculate and export grid metrics
    gridMetric_export(ROI_masks, GLM1dir, GLM2dir, output_file);
    
end
end












