%% extract grid metrics

function extractGridMetrics 

subjectvec = {'27734','28061','28428','29317','29321','29332','29336','29358','29382','29383'};

for i = 1:length(subjectvec)
    subject = subjectvec{i}
    
    % grid code results
    GCresult = fopen(['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/' subject '/gridCAT_out01/GridCAT_grid_metrics.txt']);
    tline = fgetl(GCresult);
    
    % init
    prev = 'dummy';
    
    while ischar(tline)
            
            lineInfo = strsplit(tline, ';');
            
            if ~isempty(lineInfo{1})
                
                % if prev is dummy and lineInfo{1} = GRID METRIC, move to
                % next line and prev is GRID METRIC
                
                % if prev is GRID METIRC and lineInfo{1} is Magnitude....
                % extract
                
                % if prev is Magnitude
                
                if strcmp(lineInfo{1},'Magnitude of grid code response within ROI') && strcmp(curr
                    nVoxelsROI = lineInfo{};
                    nVoxelsNAN = lineInfo{};
                    gridmag_R1 = lineInfo{6}
                elseif strcmp(lineInfo{1},'Between-voxel grid orientation coherence within ROI')
                elseif strcmp(lineInfo{1},'Within-voxel grid orientation coherence within ROI')
                
                
    
    
    % grid task results
    taskresultsfile{1} = fopen(['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data/' subject '/BlockA/testResultsData.csv']);
    taskresultsfile{2} = fopen(['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data/' subject '/BlockB/testResultsData.csv']);
    taskresultsfile{3} = fopen(['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data/' subject '/BlockC/testResultsData.csv']);
    
    % extract grid magnitudes per run
    gridmag_R1 = GCresult
    gridmag_R2 = GCresult
    grid
    
end % of for loop

end % of function