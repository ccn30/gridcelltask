function jobfile = create_GLM1_SPM_job(TR,subject,outpath,minvols,filestoanalyse,TranslationAligned,TranslationMisaligned,Rotation,rpfile)
%-----------------------------------------------------------------------
% Job saved on 30-Sep-2019 12:01:11 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

% create file to write to
jobfile = ['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/scripts/SPM_univariate/SPM_jobfiles/SPM_GLM1_' num2str(subject) '_job.m'];
fileID = fopen(jobfile,'w');

%-----file contents start-----%

%% MODEL SPECIFICATION
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.dir = {''' outpath '''};\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.timing.units = ''secs'';\n');
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.timing.RT = ' num2str(TR) ';\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;\n');

%  REMOVE RUNS, INDEX OUT 0'S FROM CONDITION INFO VARIABLES VIA
%  VARIABLE(ANY(VARIABLE,2))
for run = 1:3
    
    % define scan locations
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').scans = {\n']);
    for i = 1:minvols
        fprintf(fileID,['''' filestoanalyse{run}{i} '''\n']); % NEED TO ADD ALL SESSIONS HERE 
    end
    fprintf(fileID,'};\n');
    
    % Condition info 
    % rotations
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(1).name = ''Rotation'';\n']);
    times = sprintf('%f; ', Rotation{run}{:,1}); % print as a character vector separated by ;
    times = times(1:end-2); % remove last ; and ''
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(1).onset = [' times '];\n']);
    lengths = sprintf('%f; ',Rotation{run}{:,2});
    lengths = lengths(1:end-2);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(1).duration = [' lengths '];\n']);
    % translation aligned
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(2).name = ''TranslationAligned'';\n']);
    times = sprintf('%f; ',TranslationAligned{run}{:,1}); % print as a character vector separated by ;
    times = times(1:end-2); % remove last ; 
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(2).onset = [' times '];\n']);
    lengths = sprintf('%f; ',TranslationAligned{run}{:,2});
    lengths = lengths(1:end-2);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(2).duration = [' lengths '];\n']);
    % translation misaligned
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(3).name = ''TranslationMisaligned'';\n']);
    times = sprintf('%f; ',TranslationMisaligned{run}{:,1}); % print as a character vector separated by ;
    times = times(1:end-2); % remove last ; 
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(3).onset = [' times '];\n']);
    lengths = sprintf('%f; ',TranslationMisaligned{run}{:,2});
    lengths = lengths(1:end-2);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond(3).duration = [' lengths '];\n']);
    
    % standard settings
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.tmod = 0;\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.pmod = struct(''name'', {}, ''param'', {}, ''poly'', {});\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.orth = 1;\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').multi = {''''};\n']);
    
    % Regressors: block effect to model 3 sessions (last one modeled by mean column of design matrix) and multi regressor rp file
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').regress(1).name = ''Session 1'';\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').regress(1).val = kron([1 0 0]'',ones(minvols,1));\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').regress(2).name = ''Session 2'';\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').regress(2).val = kron([0 1 0]'',ones(minvols,1));\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').multi_reg = {''' rpfiles{run} '''};\n']); % need to concatenate
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').hpf = 128;\n']);

end

%% futher model specification
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.fact = struct(''name'', {}, ''levels'', {});\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.volt = 1;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.global = ''None'';\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.4;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.mask = {''''};\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.cvi = ''AR(1)'';\n');

%% MODEL ESTIMATION
%fprintf(fileID,['matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = ''/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/regressors/' num2str(subj) '/Run' num2str(runN) '/fcontrast/SPM.mat'';\nmatlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;\nmatlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;\n']);
fprintf(fileID,'matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep(''fMRI model specification: SPM.mat File'', substruct(''.'',''val'', ''{}'',{1}, ''.'',''val'', ''{}'',{1}, ''.'',''val'', ''{}'',{1}), substruct(''.'',''spmmat''));\nmatlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;\nmatlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;\n');

%-----end of file contents-----%

fclose(fileID);

end % of function

