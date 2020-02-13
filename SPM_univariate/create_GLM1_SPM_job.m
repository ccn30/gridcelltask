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

% define scan locations
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {\n');
for run = 1:3
    for i = 1:minvols
        fprintf(fileID,['''' filestoanalyse{run}{i} '''\n']); % NEED ALL SESSIONS HERE
    end
end
fprintf(fileID,'};\n');

% Condition info
% rotations
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = ''Rotation'';\n');
times = sprintf('%f; ', Rotation.onsets(:,1)); % print as a character vector separated by ;
times = times(1:end-2); % remove last ; and ''
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = [' times '];\n']);
lengths = sprintf('%f; ',Rotation.durations(:,1));
lengths = lengths(1:end-2);
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = [' lengths '];\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct(''name'', {}, ''param'', {}, ''poly'', {});\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;\n');
% translation aligned
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = ''TranslationAligned'';\n');
times = sprintf('%f; ',TranslationAligned.onsets(:,1)); % print as a character vector separated by ;
times = times(1:end-2); % remove last ;
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = [' times '];\n']);
lengths = sprintf('%f; ',TranslationAligned.durations(:,1));
lengths = lengths(1:end-2);
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = [' lengths '];\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct(''name'', {}, ''param'', {}, ''poly'', {});\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;\n');
% translation misaligned
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = ''TranslationMisaligned'';\n');
times = sprintf('%f; ',TranslationMisaligned.onsets(:,1)); % print as a character vector separated by ;
times = times(1:end-2); % remove last ;
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = [' times '];\n']);
lengths = sprintf('%f; ',TranslationMisaligned.durations(:,1));
lengths = lengths(1:end-2);
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = [' lengths '];\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct(''name'', {}, ''param'', {}, ''poly'', {});\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;\n');

fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''''};\n');

% Regressors: block effect to model 3 sessions (last one modeled by mean column of design matrix) and multi regressor rp file
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = ''Session 1'';\n');
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = kron([1 0 0]'',ones(' num2str(minvols) ',1));\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = ''Session 2'';\n');
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = kron([0 1 0]'',ones(' num2str(minvols) ',1));\n']);
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''' rpfile '''};\n']); % concatenated
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;\n');

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

