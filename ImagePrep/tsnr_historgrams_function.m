%% script to make histograms of tsnr EC maps

% %function tsnr_historgrams_function
% preprocess_pathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/preprocessed_images_29273_';
% mask_pathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/Segmentation/29273/epimasks';
% 
% %seriesvec = ["Run_2iso30_nopads" "Run_1.5iso30_nopads" "Run_1.5x1_nopads" "Run_1isoSB_nopads" "Run_1isoMB_nopads" "Run_1.5iso0_nopads" "Run_1.5iso90_nopads" "Run_1.5iso30_PADS" "Run_1.5iso0_PADS"]
% %runvec = [1 2 3 4 5 6 7 10 11];
% seriesvec = {'Run_1.5iso30_nopads','Run_1.5x1_nopads','Run_1.5iso0_nopads','Run_1.5iso90_nopads','Run_1.5iso30_PADS','Run_1.5iso0_PADS'};
% runvec = [2 3 6 7 10 11];
% %runvec = 2;
% % preallocate - row 1 = LEFT; row 2 = RIGHT
% ECimages = cell(2,length(runvec)); 
% ECmasks = cell(2,length(runvec));
% 
% imnonzerocolsleft = cell(1,length(runvec));
% masknonzerocolsleft = cell(1,length(runvec));
% imnonzerocolsright = cell(1,length(runvec));
% masknonzerocolsright = cell(1,length(runvec));
% 
% imnonzerovalsleft = cell(1,length(runvec));
% imnonzerovalsright = cell(1,length(runvec));
% masknonzerovalsleft = cell(1,length(runvec));
% masknonzerovalsright = cell(1,length(runvec));
% 
% zerospresentleft = nan(1,length(runvec));
% zerospresentright = nan(1,length(runvec));
% 
% minvalsleft = nan(1,length(runvec));
% minvalsright = nan(1,length(runvec));
% maxvalsleft = nan(1,length(runvec));
% maxvalsright = nan(1,length(runvec));
% meansright = nan(1,length(runvec));
% meansleft = nan(1,length(runvec));
% 
% set(0,'DefaultFigureWindowStyle','docked');
% 
% % read in tSNR images and masks
% for i = 1:length(runvec)
%     % left
%     image = niftiread(fullfile([preprocess_pathstem num2str(runvec(i)) '/leftEC_tSNR_' seriesvec{i} '.nii']));
%     mask = niftiread(fullfile([mask_pathstem '/leftECmask_' seriesvec{i} '.nii']));
%     ECimages{1,i} = reshape(image,1,[]);
%     ECmasks{1,i} = reshape(mask,1,[]);
%     % right
%     image2 = niftiread(fullfile([preprocess_pathstem num2str(runvec(i)) '/rightEC_tSNR_' seriesvec{i} '.nii']));
%     mask2 = niftiread(fullfile([mask_pathstem '/rightECmask_' seriesvec{i} '.nii']));
%     ECimages{2,i} = reshape(image2,1,[]);
%     ECmasks{2,i} = reshape(mask2,1,[]);
%     
%     % find if zero values for tSNR present by comparing length of non-zero vectors
%     % LEFT
%     [~,imnonzerocolsleft{i},imnonzerovalsleft{i}]=find(ECimages{1,i});
%     [~,masknonzerocolsleft{i},masknonzerovalsleft{i}]=find(ECmasks{1,i});
%         if length(imnonzerocolsleft{i})==length(masknonzerocolsleft{i})
%             zerospresentleft(i) = 0;
%         else
%             zerospresentleft(i) = 1;
%         end
%     % RIGHT
%     [~,imnonzerocolsright{i},imnonzerovalsright{i}]=find(ECimages{2,i});
%     [~,masknonzerocolsright{i},masknonzerovalsright{i}]=find(ECmasks{2,i});
%         if length(imnonzerocolsright{i})==length(masknonzerocolsright{i})
%             zerospresentright(i) = 0;
%         else
%             zerospresentright(i) = 1;    
%         end
%      
%      % plot histograms of non-zero values for each series/side
%      % LEFT
%      figure('Name', 'tSNR EC both');
%      histogram([imnonzerovalsleft{i} imnonzerovalsright{i}],'binwidth',2);
%      hold on;
%      title(['tSNR BOTH EC ' seriesvec{i}]);
%      xlabel('tSNR');
%      ylabel('Number Voxels');
%      xlim([0,50]);
%      ylim([0,80]);
%      hold off;
%      % RIGHT                               
% %      histogram(imnonzerovalsright{i},'binwidth',2);
% %      hold on;
% %      title(['tSNR right EC ' seriesvec{i}]);
% %      xlabel('tSNR');
% %      ylabel('Number Voxels');
% %      xlim([0,50]);
% %      ylim([0,50]);
% %      hold off;
% 
%       % calculate descriptive statistics
%       
%     minvalsleft(i) = min(imnonzerovalsleft{i});
%     minvalsright(i) = min(imnonzerovalsright{i});
%     maxvalsleft(i) = max(imnonzerovalsleft{i});
%     maxvalsright(i) = max(imnonzerovalsright{i});
%     meansright(i) = mean(imnonzerovalsleft{i});
%     meansleft(i) = mean(imnonzerovalsright{i});
%     
% end
% 
% one = niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/preprocessed_images_29273_1/tSNRrtopup_Run_2iso30_nopads.nii');
% four=niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/preprocessed_images_29273_4/tSNRrtopup_Run_1isoSB_nopads.nii');
% five=niftiread('
% %end

% for pTx pilot:
% left EC (ASHS mask)
image1 = niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/29780/tSNR/Left_tSNR_run1.nii');
image2 = niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/29780/tSNR/Left_tSNR_run2.nii');
image3 = niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/29780/tSNR/Left_tSNR_run3.nii');

image1EC = nonzeros(image1);
image2EC = nonzeros(image2);
image3EC = nonzeros(image3);

figure('Name', 'tSNR EC Left EC');
     histogram(image1EC,'binwidth',2);
     hold on;
     title('tSNR EC Left Volume Specific pTx');
     xlabel('tSNR');
     ylabel('Number Voxels');
     xlim([0,50]);
     ylim([0,80]);
     hold off;
figure('Name', 'tSNR EC Left EC');
     histogram(image2EC,'binwidth',2);
     hold on;
     title('tSNR EC Left Patient Specific pTx');
     xlabel('tSNR');
     ylabel('Number Voxels');
     xlim([0,50]);
     ylim([0,80]);
     hold off;
figure('Name', 'tSNR EC Left EC');    
     histogram(image3EC,'binwidth',2);
     hold on;
     title('tSNR EC Left non pTx (true Form)');
     xlabel('tSNR');
     ylabel('Number Voxels');
     xlim([0,50]);
     ylim([0,80]);
     hold off;
% right EC (manual quick ITK mask)
imager1 = niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/29780/tSNR/Right_tSNR_run1.nii');
imager2 = niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/29780/tSNR/Right_tSNR_run2.nii');
imager3 = niftiread('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data/images/29780/tSNR/Right_tSNR_run3.nii');

imager1EC = nonzeros(imager1);
imager2EC = nonzeros(imager2);
imager3EC = nonzeros(imager3);

figure('Name', 'tSNR EC Right EC');
     histogram(imager1EC,'binwidth',2);
     hold on;
     title('tSNR EC Right Volume Specific pTx');
     xlabel('tSNR');
     ylabel('Number Voxels');
     xlim([0,50]);
     ylim([0,80]);
     hold off;
figure('Name', 'tSNR EC Right EC');
     histogram(imager2EC,'binwidth',2);
     hold on;
     title('tSNR EC Right Patient Specific pTx');
     xlabel('tSNR');
     ylabel('Number Voxels');
     xlim([0,50]);
     ylim([0,80]);
     hold off;
figure('Name', 'tSNR EC Right EC');    
     histogram(imager3EC,'binwidth',2);
     hold on;
     title('tSNR EC Right non pTx (true Form)');
     xlabel('tSNR');
     ylabel('Number Voxels');
     xlim([0,50]);
     ylim([0,80]);
     hold off;

    