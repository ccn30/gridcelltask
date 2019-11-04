% extract information from gridcat output
% Matthias Stangl adapted by Coco Newton 11/19

function standalone_collateGridCAToutput()

clear all
clc

% -----------------------------------------------------------------
% SETTINGS

%allSubjGridcatData_dir = '/Volumes/DataHD2/GCAP/ANALYSIS/GridCAT_Analysis/GridCAT_output';
allSubjGridcatData_dir = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results';
%GLM2findStr = 'GLM2_6fold*r_pmod_oriAvg0_BILATERAL';
GLM2findStr = 'gridCAT_out*';

get_magnitude = 1;
magnitude_showOnlyAllRunsAvg = 0;
get_sStability = 1;
get_tStability = 1;

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
        if  contains(GLM2dirName, '01')
            ROI_GLM2meanGridOriCalc = 'both';
            dataFile = [subjDir filesep GLM2dirName filesep 'GridCATmetrics.txt'];
        elseif contains(GLM2dirName, '02')
            ROI_GLM2meanGridOriCalc = 'both';
            dataFile = [subjDir filesep GLM2dirName filesep 'GridCATmetrics_' subjNameList{subjIdx} '_xfold7.txt'];
        elseif contains(GLM2dirName, '03')
            ROI_GLM2meanGridOriCalc = 'Left';
            dataFile = [subjDir filesep GLM2dirName filesep 'GridCATmetrics_' subjNameList{subjIdx} '_xfold_6_left.txt'];
        elseif contains(GLM2dirName, '04')
            ROI_GLM2meanGridOriCalc = 'Righ';
            dataFile = [subjDir filesep GLM2dirName filesep 'GridCATmetrics_' subjNameList{subjIdx} '_xfold_6_right.txt'];
        elseif contains(GLM2dirName, '05')
            ROI_GLM2meanGridOriCalc = 'both';
            dataFile = [subjDir filesep GLM2dirName filesep 'GridCATmetrics_' subjNameList{subjIdx} '_xfold_4_both.txt'];
        elseif contains(GLM2dirName, '07')
            ROI_GLM2meanGridOriCalc = 'both';
            dataFile = [subjDir filesep GLM2dirName filesep 'GridCATmetrics_' subjNameList{subjIdx} '_xfold_6_both_control.txt'];
        else
        end

        fid = fopen(dataFile);
        
        if fid>0
            
            fprintf('.');

            tline = fgetl(fid);
            while ischar(tline)

                lineData = strsplit(tline, ';');

                if strcmp(lineData{1}, 'Magnitude of grid code response within ROI') && get_magnitude

                    cellData = strsplit(lineData{3}, '_');
                    ROI_gridMetricMask = cellData{1};

                    if strncmp(ROI_gridMetricMask, ROI_GLM2meanGridOriCalc, 4)

                        cellData = strsplit(lineData{5}, {'-','_'});
                        run_str = cellData{1};

                        if ~magnitude_showOnlyAllRunsAvg || (magnitude_showOnlyAllRunsAvg && ~contains(run_str, 'allRuns'))

                            GCmagnitude = lineData{6};                    
                            metricName = ['GCmagnitude_' run_str '_' ROI_gridMetricMask(1:4) '_' GLM2dirName];                    
                            [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList);
                            output_cArray{subjIdx, metricIdx} = GCmagnitude;

                        end
                    end

                elseif strcmp(lineData{1}, 'Between-voxel grid orientation coherence within ROI') && get_sStability

                    cellData = strsplit(lineData{3},'-');
                    ROI_gridMetricMask = cellData{1};

                    if strncmp(ROI_gridMetricMask,ROI_GLM2meanGridOriCalc,4)

                        cellData = strsplit(lineData{4}, '-');
                        run_str = cellData{3};

                        zRayleigh = lineData{5};
                        metricName = ['sStability_zRay_' run_str '_' ROI_gridMetricMask(1:4) '_' GLM2dirName];                    
                        [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList);
                        output_cArray{subjIdx, metricIdx} = zRayleigh;

                        pRayleigh = lineData{6};
                        metricName = ['sStability_pRay_' run_str '_' ROI_gridMetricMask(1:4) '_' GLM2dirName];                    
                        [metricIdx, metricNameList] = getMetricIdx(metricName, metricNameList);
                        output_cArray{subjIdx, metricIdx} = pRayleigh;
                    end


                elseif strcmp(lineData{1}, 'Within-voxel grid orientation coherence within ROI') && get_tStability

                    cellData = strsplit(lineData{3},'_');
                    ROI_gridMetricMask = cellData{1};

                    if strncmp(ROI_gridMetricMask,ROI_GLM2meanGridOriCalc,4)

                        cellData = strsplit(lineData{4}, '_');
                        runA_str = cellData{3};

                        cellData = strsplit(lineData{5}, '_');
                        runB_str = cellData{3};

                        pcntStableVox = lineData{6};
                        metricName = ['tStability_pcntStableVox_' runA_str 'VS' runB_str '_' ROI_gridMetricMask(1:4) '_' GLM2dirName];                    
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

filename = [GLM2findStr '_totalresults'];
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


