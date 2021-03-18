function image_prepare_func(pathstem,subjectvec,dateIDvec,seriesvec)
% function to:
% iterate through HPHI DICOM files and convert to nifti with dcm2niix
% create topup pos and neg blips in topup subdir in nifti format
% prepare mp2rage input files by moving to mp2rage dir and renaming
% Coco Newton 27.08.29

subjectvec = {'29780','27734','28061','28428','29317','29321','29332','29336','29358','29382','29383'};
dateIDvec = {'20191125_U-ID47173','20190902_U-ID46027','20190911_U-ID46160','20190903_U-ID46074','20190902_U-ID46030','20190902_U-ID46038','20190903_U-ID46058','20190903_U-ID46066','20190905_U-ID46106','20190911_U-ID46164','20190912_U-ID46168'};
pathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/images';
seriesvec = [27,29,33,35,39];
%seriesvec = [4,5,21,23,27,29,33,35,39];
%seriesvec=33;

%% convert to nifti and create pos/neg blips for epis
fsldir='/applications/fsl/fsl-5.0.10/bin/';
global fsldir

setenv('FSL_DIR',fsldir);  % this to tell where FSL folder is
setenv('FSLOUTPUTTYPE', 'NIFTI'); % this to tell what the output type
setenv('FSF_OUTPUT_FORMAT', 'nii'); % this to tell what the output type

% outer loop for subjects
%for j = 1:length(subjectvec)
for j = 1
    imagepathstem = [pathstem '/' subjectvec{j} '/' dateIDvec{j}];
    cd(imagepathstem);
    
    % inner loop through series for dcm2niix
    for i = 1:length(seriesvec)
        d = dir([imagepathstem '/Series_0' sprintf('%02d', seriesvec(i)) '_*']);
        if contains(d.name,'PhysioLog')
            continue
        else
            cd([imagepathstem '/' d.name]);
            fprintf(['\n Moving to... ' d.name '\n']);
            
            % quick section to reorientate images 
%             cmd = 'fslreorient2std Series_033_Highresolution_TSE_PAT2_100_c32.nii reorientSeries_033_Highresolution_TSE_PAT2_100_c32.nii';
%             system(cmd);
%             cd ../mp2rage
%             cmd = 'fslreorient2std n4mag0000_PSIR_skulled_std_struc_brain.nii reorientn4mag0000_PSIR_skulled_std_struc_brain.nii';
%             system(cmd);
%             cmd = 'fslreorient2std c2n4mag0000_PSIR_skulled_std.nii reorientc2n4mag0000_PSIR_skulled_std.nii';
%             system(cmd);
%             cmd = 'fslreorient2std n4mag0000_PSIR_skulled_std.nii reorientn4mag0000_PSIR_skulled_std.nii';
%             system(cmd);
%         end
%     end
% end
            
            % quick section to make odd no. volumes - remove in real
            % function
            %delete(fullfile([d.name '_c32a.nii']))
            %delete(fullfile([d.name '_c32a.json']))
            %delete(fullfile(['DATA_00' num2str(seriesvec(i)) '_00100.dcm']));
            
            if ~isempty(dir('*.nii'))
                warning('NII already exists!');
            else
                cmd = 'dcm2niix -f %f *.dcm';
                [status,cmdout] = system(cmd);
                disp('Converting dicoms to nifti');
                if status == 0
                    disp('Done dcm2niix.');
                else
                    warning(['dcm2niix issue - check ' d.name 'files']);
                    fileid = fopen(['dcm2niixout_' d.name '.txt'],'w');
                    fprintf(fileid,cmdout);
                    fclose(fileid);
                end
            end
            
            % loop for making reference blips for topup
            if contains(d.name,'bold')
                if contains(d.name,'inv')
                    fprintf('\n EPIs: creating neg blip for topup \n');
                    cmd = 'fslmaths *.nii -Tmean neg_topup';
                    [status,~] = system(cmd);
                    if status == 0
                        disp('** Neg topup done **');
%                        delete([d.name '_c32.nii'])
                    else
                        warning('neg topup issue');
                    end
                else
                    fprintf('\n EPIs: creating pos blip for topup \n');
                    mkdir('topup');
                    cd topup
                    copyfile('../DATA_*_00001.dcm');
                    copyfile('../DATA_*_00002.dcm');
                    copyfile('../DATA_*_00003.dcm');
                    copyfile('../DATA_*_00004.dcm');
                    copyfile('../DATA_*_00005.dcm');
                    cmd = 'dcm2niix -f pos_topup_all *.dcm';
                    system(cmd);
                    cmd2 = 'fslmaths pos_topup_all -Tmean pos_topup';
                    [status,~] = system(cmd2);
                    if status == 0
                        disp('** pos topup done **');
                        delete('pos_topup_all.nii')
                        delete('pos_topup_all.json')
                    else
                        warning('pos topup issue');
                    end
                    % rename .nii of each functional run to runX
                    cd ..
                    if contains(d.name, 'run1') == 1
                        cmd = ['mv ' d.name '_c32.nii run1.nii'];
                        system(cmd);
                    elseif contains(d.name, 'run2') == 1
                        cmd = ['mv ' d.name '_c32.nii run2.nii'];
                        system(cmd);
                    else
                        cmd = ['mv ' d.name '_c32.nii run3.nii'];
                        system(cmd);
                    end
                end
            else
                cd(imagepathstem);
            end
        end
    end
    
%     % loop to remerge resliced EPIs after topup
%     %         for i = 1:length(seriesvec)
%     %             d = dir([rawpathstem '/Series_0' num2str(seriesvec(i)) '_*']);
%     %             if contains(d.name,'PhysioLog') || contains(d.name,'inv') == 1 % can't convert
%     %                 continue
%     %             end
%     %             cd([rawpathstem '/' d.name]);
%     %             disp(['Moving to... ' d.name]);
%     %             if exist([rtopup_' d.name '_split0001.nii'],file)
%     %             cmd = [fsldir 'bin/fslmerge -t ' d.folder '/' d.name '/rtopup_' d.name ' ' d.folder '/' d.name '/rtopup_' d.name '_split*'];
%     %             system(cmd);
%     %         end
%     
%     % loop to prepare mp2rage inputs
%     fprintf('\n\n Now working on mp2rage prep \n\n');
%     pwd;
%     if ~isempty(dir('mp2rage'))
%         warning('mp2rage dir already exits!');
%     else
%         mkdir('mp2rage');
%         cd mp2rage
%         disp('Inside mp2rage dir, copying images.');
%         mag = dir([imagepathstem,'/Series_*_MP2RAGE_0.7_UniformSens_MAG']);
%         disp(['Magnitude image going in is ' mag.name]);
%         phs = dir([imagepathstem,'/Series_*_MP2RAGE_0.7_UniformSens_PHS']);
%         disp(['Phase image going in is ' phs.name]);
%         cmd = ['cp ../' mag.name '/' mag.name '_c32.nii mp2rage_magnitude.nii.gz'];
%         [status,cmdout] = system(cmd);
%         if status == 0
%             disp('Done with magnitude image.');
%         else
%             warning(['Image transfer for ' mag.name ' unsuccessful']);
%             fileid = fopen(['imtransfer_' mag.name '.txt'],'w');
%             fprintf(fileid,cmdout);
%             fclose(fileid);
%         end
%         cmd = ['cp ../' phs.name '/' phs.name '_c32.nii mp2rage_phase.nii.gz'];
%         [status,cmdout] = system(cmd);
%         if status == 0
%             disp('Done with phase image.');
%         else
%             warning(['Image transfer for ' phs.name ' unsuccessful']);
%             fileid = fopen(['imtransfer_' phs.name '.txt'],'w');
%             fprintf(fileid,cmdout);
%             fclose(fileid);
%         end
%         cd(imagepathstem);
%     end
% end
% end

%% loop to iterate through preprocessed EPIS and masks
fsldir='/applications/fsl/fsl-5.0.10/bin/';
subjectvec = {'27734','28061','28428','29317','29321','29332','29336','29382','29383'};
preprocesspathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data';
 
for subj = 1:length(subjectvec)
    % split resliced image and delete un-needed EPIS
%     for run = 1:3
%         disp(['Working on run ' num2str(run)]);
%         FOURDfile = [preprocesspathstem '/images/' subjectvec{subj} '/rtopup_Run_' num2str(run) '.nii'];
%         cmd = [fsldir 'fslsplit ' FOURDfile ' ' FOURDfile(1:end-4) '_split -t'];
%         system(cmd);
%         delete([preprocesspathstem '/images/old_data/' subjectvec{subj} '/topup_Run_' num2str(run) '_split*.nii']);
%          delete([preprocesspathstem '/images/old_data/' subjectvec{subj} '/Run_' num2str(run) '_split*.nii']);
%     end

    % combine right and left EC masks - FOR POS HC
       rightEC = [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/pmEC_rightWarped_ITKaffine.nii']; 
       leftEC = [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/pmEC_leftWarped_ITKaffine.nii'];
       bothEC = [preprocesspathstem '/segmentation/' subjectvec{subj} '/epimasks/pmEC_bothWarped_ITKaffine.nii'];
       cmd = [fsldir 'fslmaths ' rightEC ' -add ' leftEC ' ' bothEC];
       [status,cmdout] = system(cmd);
         if status == 0
             disp('Done merging masks.');
         else
             warning('Mask wrong');
             cmdout
         end

end





