function jobfile = create_GLM1_SPM_job(TR,subject,outpath,minvols,filestoanalyse,onsets,durations,rpfiles)
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

for run = 1:3
    
    % define scan locations
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').scans = {\n']);
    for i = 1:minvols
        fprintf(fileID,['''' filestoanalyse{run}{i} '''\n']);
    end
    fprintf(fileID,'};\n');
    
    % condition info
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.name = ''translation'';\n']);
    times = sprintf('%f; ',onsets{run}'); % print as a character vector separated by ;
    times = times(1:end-2); % remove last ; 
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.onset = [' times '];\n']);
    lengths = sprintf('%f; ',durations{run}');
    lengths = lengths(1:end-2);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.duration = [' lengths '];\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.tmod = 0;\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.pmod = struct(''name'', {}, ''param'', {}, ''poly'', {});\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').cond.orth = 1;\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').multi = {''''};\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').regress = struct(''name'', {}, ''val'', {});\n']);
    fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess(' num2str(run) ').multi_reg = {''' rpfiles{run} '''};\n']);
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

