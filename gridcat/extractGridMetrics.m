%% extract grid metrics

function extractGridMetrics 

subjectvec = {'27734','28061','28428','29317','29321','29332','29336','29358','29382','29383'};
runvec = {'BlockA','BlockB','BlockC'};

% prepare output files
outfileall = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/group_pilot_results_leftEC6fold.txt';
resultsall = fopen(outfileall, 'w+');
outfilematrix = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/group_pilot_results_leftEC6fold_data.csv';
resultsmatrix = fopen(outfilematrix,'w+');

% header
fprintf(resultsall, '%-20s','Subject','Voxels_NAN','Voxels_ROI','Magnitude_all','MeanOrientation','RayleighZ_all','RayleighP_all', ...
        'WithinVoxStability_R1','WithinVoxStability_R2','WithinVoxStability_R3');
fprintf(resultsall, '\n');

% preallocate group_level variables for further analysis
subjects = NaN(10,1);
Magnitude_R1 = NaN(10,1);
Magnitude_R2 = NaN(10,1);
Magnitude_R3 = NaN(10,1);
Magnitude_all = NaN(10,1);
Voxels_ROI = NaN(10,1);
Voxels_NAN = NaN(10,1);
RayleighZ_all = NaN(10,1);
RayleighP_all = NaN(10,1);
RayleighZ_R1 = NaN(10,1);
RayleighP_R1 = NaN(10,1);
RayleighZ_R2 = NaN(10,1);
RayleighP_R2 = NaN(10,1);
RayleighZ_R3 = NaN(10,1);
RayleighP_R3 = NaN(10,1);
WithinVoxStability_R1 = NaN(10,1);
WithinVoxStability_R2 = NaN(10,1);
WithinVoxStability_R3 = NaN(10,1);
MeanOrientation_R1 = NaN(10,1);
MeanOrientation_R2 = NaN(10,1);
MeanOrientation_R3 = NaN(10,1);
MeanOrientation_all = NaN(10,1);
Responseone = NaN(10,1);
Responsetwo = NaN(10,1);
Responsethree = NaN(10,1);
MeanRTone = NaN(10,1);
MeanRTtwo = NaN(10,1);
MeanRTthree = NaN(10,1);

for i = 1:length(subjectvec)
    disp('EXTRACTING GRID CODE RESULTS: ');
    Subject = subjectvec{i}
    subjects(i,1) = Subject;
    
    %% GRID CODE RESULTS
    GCresult = fopen(['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/' Subject '/gridCAT_out02/GridCAT_metrics_' Subject '_xfold7.txt']);
    tline = fgetl(GCresult);
    
    % iterate through file line by line until end reached
    while ~feof(GCresult)
            
            lineInfo = strsplit(tline, ';');
            
            if ~isempty(lineInfo{1}) && ~strcmp(lineInfo{1},'GRID METRIC')
                
                % MAGNITUDE - 9 cells
                    if strncmp(lineInfo{1},'Mag', 3) 
                        
                        if strncmp(lineInfo{5},'Run1', 4)
                            % this is first line of file
                            Voxels_ROI(i,1) = lineInfo{7};
                            Voxels_NAN(i,1) = lineInfo{8};
                            Magnitude_R1(i,1) = lineInfo{6};

                        elseif strncmp(lineInfo{5},'Run2', 4)
                            Magnitude_R2(i,1) = lineInfo{6};

                        elseif strncmp(lineInfo{5},'Run3', 4)
                            Magnitude_R3(i,1) = lineInfo{6};                  
                    
                        elseif strncmp(lineInfo{5},'all', 3)
                            Magnitude_all(i,1) = lineInfo{6};
                            
                        end                    
                    end
                
                % BETWEEN VOXEL ORI COHERENCE - 10 cells
                    if strncmp(lineInfo{1},'Bet', 3) 
                        
                        if endsWith(lineInfo{4}, "allRunsAvg-deg.nii")
                            RayleighZ_all(i,1) = lineInfo{5};
                            RayleighP_all(i,1) = lineInfo{6};
                        
                        elseif endsWith(lineInfo{4}, "run1-deg.nii")
                            RayleighZ_R1(i,1) = lineInfo{5};
                            RayleighP_R1(i,1) = lineInfo{6};
                        
                        elseif endsWith(lineInfo{4}, "run2-deg.nii")
                            RayleighZ_R2(i,1) = lineInfo{5};
                            RayleighP_R2(i,1) = lineInfo{6};
                        
                        elseif endsWith(lineInfo{4}, "run3-deg.nii")
                            RayleighZ_R3(i,1) = lineInfo{5};
                            RayleighP_R3(i,1) = lineInfo{6};
                        end                       
                    end
                        
                % WITHIN VOXEL ORI COHERENCE - 11 cells       
                    if strncmp(lineInfo{1},'Wit', 3)
                       
                        if endsWith(lineInfo{4}, "allRunsAvg_deg.nii") && endsWith(lineInfo{5}, "run1_deg.nii")
                            WithinVoxStability_R1(i,1) = lineInfo{6};
                       
                        elseif endsWith(lineInfo{4}, "allRunsAvg_deg.nii") && endsWith(lineInfo{5}, "run2_deg.nii")
                            WithinVoxStability_R2(i,1) = lineInfo{6};
                        
                        elseif endsWith(lineInfo{4}, "allRunsAvg_deg.nii") && endsWith(lineInfo{5}, "run3_deg.nii")
                            WithinVoxStability_R3(i,1) = lineInfo{6} ;
                            
                        end
                    end
                    
                % MEAN GRID ORI IN ROI - 8 cells
                    if strncmp(lineInfo{1},'Mea', 3)
                        
                        if strcmp(lineInfo{5},'1')
                            MeanOrientation_R1(i,1) = lineInfo{6};
                            
                        elseif strcmp(lineInfo{5},'2')
                            MeanOrientation_R2(i,1) = lineInfo{6};
                            
                        elseif strcmp(lineInfo{5},'3')
                            MeanOrientation_R3(i,1) = lineInfo{6};
                             
                        end
                    end
                                      
                % go to next line of file if line extraction is complete
                tline = fgetl(GCresult);    
           
            else
                
                % skip to next line of file if line is empty or has 'GRID METRIC'
                tline = fgetl(GCresult);
                
            end % of if loop
                            
    end % of while loop
    
    % get last line
    lineInfo = strsplit(tline, ';');
    if strncmp(lineInfo{5},'av',2)
        MeanOrientation_all(i,1) = lineInfo{6}; 
    end
    
    fclose(GCresult);
    disp('GRID CODE RESULT EXTRACTION COMPLETE');
    
    %% GRID TASK RESULTS
    
    for j = 1:length(runvec)
        
        disp(' ');
        disp('EXTRACTING GRID TASK RESULTS: ');
        Run = runvec{j}
        
        % init
        answers = cell(length(runvec),3);
        answers{1,j} = NaN(7,1); % answers per question
        answers{2,j} = NaN(7,1); % reaction time per question
        nQs = 7;
        
        if j == 3 && strcmp(Subject,'28061') % missing data for third run
            continue
        end
        
        GTresult = fopen(['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/task_data/' Subject '/' Run '/testResultsData.csv']);
        tline = fgetl(GTresult);    
    
        while ~feof(GTresult)
            
            lineInfo = strsplit(tline, ';');
            
            if strncmp(lineInfo{2}, 'Answer', 6)
                
                % iterate through 7 questions
                for q = 1:nQs
                    
                    % get subject response and correct answer
                    r = strsplit(lineInfo{2},':');
                    response = str2double(r{2});
                    c = strsplit(lineInfo{3}, ':');
                    correct = str2double(c{2});
                
                    if response == correct
                        answers{1,j}(q) = 1;
                    else 
                        answers{1,j}(q) = 0;
                    end                 
                    
                    % get reaction time
                    rt = strsplit(lineInfo{4}, ':');
                    answers{2,j}(q) = str2double(rt{2});
                    
                end
                
                % continue to next line
                tline = fgetl(GTresult); 
                
            else
                % skip to next line
                tline = fgetl(GTresult);
                
            end % of if loop
            
        end % of while loop
        
        % compute averages 1 = mean correct, 2 = mean RT
        if j == 1
            Responseone(i,1) = mean(answers{1,j}(:));
            MeanRTone(i,1) =  mean(answers{2,j}(:));
        elseif j == 2
            Responsetwo(i,1) = mean(answers{1,j}(:));
            MeanRTtwo(i,1) =  mean(answers{2,j}(:));
        elseif j == 3
            Responsethree(i,1) = mean(answers{1,j}(:));
            MeanRTthree(i,1) =  mean(answers{2,j}(:));
        end
    
    end % of for loop
    
    fclose(GTresult);                   
    
    disp('GRID TASK RESULTS EXTRACTION COMPLETE');
    
    %% WRITE TO FILE
    fprintf(resultsall, '%-20s',Subject,Voxels_NAN(i,1),Voxels_ROI(i,1),Magnitude_all(i,1),MeanOrientation_all(i,1),RayleighZ_all(i,1),RayleighP_all(i,1), ...
        WithinVoxStability_R1(i,1),WithinVoxStability_R2(i,1),WithinVoxStability_R3(i,1));
    fprintf(resultsall, '\n');
    
    totalmatrix = [subjects,Magnitude_R1,Magnitude_R2,Magnitude_R3,Magnitude_all,Voxels_ROI,Voxels_NAN,RayleighZ_all,RayleighP_all, ...
        RayleighZ_R1 = NaN(10,1);RayleighP_R1 = NaN(10,1);RayleighZ_R2 = NaN(10,1);RayleighP_R2 = NaN(10,1);RayleighZ_R3 = NaN(10,1);RayleighP_R3 = NaN(10,1); ...
        WithinVoxStability_R1 = NaN(10,1);WithinVoxStability_R2 = NaN(10,1);WithinVoxStability_R3 = NaN(10,1); ...
        MeanOrientation_R1 = NaN(10,1);MeanOrientation_R2 = NaN(10,1);MeanOrientation_R3 = NaN(10,1);MeanOrientation_all = NaN(10,1); ...
        Responseone,ResponsetwoResponsethree = NaN(10,1); ...
        MeanRTone,MeanRTtwo,MeanRTthree]

                
  
end % of for loop

fclose(resultsall);

end % of function