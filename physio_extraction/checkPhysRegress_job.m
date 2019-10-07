function jobfile = checkPhysRegress_job(subj,TR,nScans,runN)
%-----------------------------------------------------------------------
% Job saved on 30-Sep-2019 12:01:11 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

% create file to write to
jobfile = ['/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/scripts/physio_extraction/SPM_jobfiles/SPM_' num2str(subj) '_run' num2str(runN) '_job.m'];
fileID = fopen(jobfile,'w');

%-----file contents start-----%

%% MODEL SPECIFICATION
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.dir = {''/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/regressors/' num2str(subj) '/Run' num2str(runN) '/fcontrast''};\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.timing.units = ''secs'';\n');
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.timing.RT = ' num2str(TR) ';\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;\n');
%% define scan locations
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {\n');
for i = 1:nScans
    fprintf(fileID,['''/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/' num2str(subj) '/rtopup_Run_' num2str(runN) '.nii,' num2str(i) '''\n']);
end
fprintf(fileID,'};\n');
%% further variables
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct(''name'', {}, ''onset'', {}, ''duration'', {}, ''tmod'', {}, ''pmod'', {}, ''orth'', {});\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''''};\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct(''name'', {}, ''val'', {});\n');
fprintf(fileID,['matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/regressors/' num2str(subj) '/Run' num2str(runN) '/Physio_regressors/multiple_regressors.txt''};\n']);
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.fact = struct(''name'', {}, ''levels'', {});\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.volt = 1;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.global = ''None'';\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.mask = {''''};\n');
fprintf(fileID,'matlabbatch{1}.spm.stats.fmri_spec.cvi = ''AR(1)'';\n');
%% MODEL ESTIMATION
%fprintf(fileID,['matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = ''/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/regressors/' num2str(subj) '/Run' num2str(runN) '/fcontrast/SPM.mat'';\nmatlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;\nmatlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;\n']);
fprintf(fileID,['matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep(''fMRI model specification: SPM.mat File'', substruct(''.'',''val'', ''{}'',{1}, ''.'',''val'', ''{}'',{1}, ''.'',''val'', ''{}'',{1}), substruct(''.'',''spmmat''));\nmatlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;\nmatlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;\n']);

%-----end of file contents-----%

fclose(fileID);

end % of function

