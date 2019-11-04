function standalone_collateGridCAToutput()

clear all
clc

% -----------------------------------------------------------------
% SETTINGS

allSubjGridcatData_dir = '/Volumes/DataHD2/GCAP/ANALYSIS/GridCAT_Analysis/GridCAT_output';

GLM2findStr = 'GLM2_6fold*r_pmod_oriAvg0_BILATERAL';


get_magnitude = 1;
magnitude_showOnlyAllRunsAvg = 1;
get_sStability = 0;
get_tStability = 0;

% -----------------------------------------------------------------

metricNameList = {};
subjNameList = {};
output_cArray = {};
subjDirList = dir(allSubjGridcatData_dir);

% delete all list entries that precede with . or $ (except ..), or non dir
subjDirList(~[subjDirList(:).isdir]) = [];
letters = cellfun(@(x) x(1:1),{subjDirList(:).name},'un',0);
badIds = find(strcmp(letters, '.') | strcmp(letters, '$'));
subjDirList(badIds) = [];

for subjIdx = 1:length(subjDirList)
    
    subjDir = [allSubjGridcatData_dir filesep subjDirList(subjIdx).name];
    
    fprintf('\n%s',subjDirList(subjIdx).name);

    GLM2dirList = dir([subjDir filesep GLM2findStr]);

    for GLM2dirIdx = 1:length(GLM2dirList)
        
        subjNameList{subjIdx} = subjDirList(subjIdx).name;

        GLM2dirName = GLM2dirList(GLM2dirIdx).name;

        % for which ROI was the mean grid ori computed at GLM2?
        if strfind(GLM2dirName, '_RH')
            ROI_GLM2meanGridOriCalc = 'RH';
        elseif strfind(GLM2dirName, '_LH')
            ROI_GLM2meanGridOriCalc = 'LH';
        elseif strfind(GLM2dirName, '_BILATERAL')
            ROI_GLM2meanGridOriCalc = 'BILATERAL';
        end

        dataFile = [subjDir filesep GLM2dirName filesep 'GridCAT_grid_metrics.txt'];

        fid = fopen(dataFile);
        
        if fid>0
            
            fprintf('.');

            tline = fgetl(fid);
            while ischar(tline)

                lineData = strsplit(tline, ';');

                if strcmp(lineData{1}, 'Magnitude of grid code response within ROI') && get_magnitude

                    cellData = strsplit(lineData{3}, {'_', '.'});
                    ROI_gridMetricMask = cellData{4};

                    if strcmp(ROI_gridMetricMask, ROI_GLM2meanGridOriCalc)

                        cellData = strsplit(lineData{5}, '-');
                        run_str = cellData{1};

                        if ~magnitude_showOnlyAllRunsAvg || (magnitude_showOnlyAllRunsAvg && ~isempty(strfind(run_str, 'allRuns')))

                            GCmagnitude = lineData{6};                    
                            metricName = ['GCmagnitude_' run_str '_visRoi' ROI_gridMetricMask '_' GLM2dirName];                    
                            [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList);
                            output_cArray{subjIdx, metricIdx} = GCmagnitude;

                        end
                    end

                elseif strcmp(lineData{1}, 'Between-voxel grid orientation coherence within ROI') && get_sStability

                    cellData = strsplit(lineData{3}, {'-', '.'});
                    ROI_gridMetricMask = cellData{4};

                    if strcmp(ROI_gridMetricMask, ROI_GLM2meanGridOriCalc)

                        cellData = strsplit(lineData{4}, '-');
                        run_str = [cellData{2} '_' cellData{3}];

                        zRayleigh = lineData{5};
                        metricName = ['sStability_zRay_' run_str '_visRoi' ROI_gridMetricMask '_' GLM2dirName];                    
                        [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList);
                        output_cArray{subjIdx, metricIdx} = zRayleigh;

                        pRayleigh = lineData{6};
                        metricName = ['sStability_pRay_' run_str '_visRoi' ROI_gridMetricMask '_' GLM2dirName];                    
                        [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList);
                        output_cArray{subjIdx, metricIdx} = pRayleigh;
                    end


                elseif strcmp(lineData{1}, 'Within-voxel grid orientation coherence within ROI') && get_tStability

                    cellData = strsplit(lineData{3}, {'_', '.'});
                    ROI_gridMetricMask = cellData{4};

                    if strcmp(ROI_gridMetricMask, ROI_GLM2meanGridOriCalc)

                        cellData = strsplit(lineData{4}, '_');
                        runA_str = [cellData{2} '-' cellData{3}];

                        cellData = strsplit(lineData{5}, '_');
                        runB_str = [cellData{2} '-' cellData{3}];

                        pcntStableVox = lineData{6};
                        metricName = ['tStability_pcntStableVox_' runA_str '_VS_' runB_str '_visRoi' ROI_gridMetricMask '_' GLM2dirName];                    
                        [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList);
                        output_cArray{subjIdx, metricIdx} = pcntStableVox;

                    end
                end
                
                tline = fgetl(fid);
                
            end
            
            fclose(fid);
            
        end

    end
end

disp(' ');
output_cArray = [['Subject' subjNameList]' [metricNameList; output_cArray]];

filename = GLM2findStr;
filename(filename=='*')='X';

cell2csv([allSubjGridcatData_dir filesep filename '.csv'], output_cArray);
save(    [allSubjGridcatData_dir filesep filename '.mat'], 'output_cArray');

disp(' ');
disp(['data saved to: ' allSubjGridcatData_dir filesep filename '.mat']);

%%
function [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList)

if ~isempty(find(strcmp(metricNameList, metricName), 1))
    metricIdx = find(strcmp(metricNameList, metricName));
else
    metricIdx = length(metricNameList)+1;
    metricNameList{metricIdx} = metricName;
end



