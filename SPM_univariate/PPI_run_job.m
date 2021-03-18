%% Run PPI
% RH, CN 03.2021
% Matlab 2019a SPM v6906

clear
pathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/fMRI/gridcellpilot';
cd([ pathstem '/scripts/SPM_univariate']);
spm('defaults', 'FMRI');

Nscan = [238 238 238];

%% Create VOIs per run (note: could use SPM threshold to reduce voxels)
for sess = 1:3 
    jobfile = cellstr([pathstem '/scripts/SPM_univariate/batch_voi_job.m']);
    inputs = {};
    inputs{1} = cellstr([pathstem '/results/SPM_univariate/28428/SPM.mat']);
    inputs{2} = 3; % MUST MATCH EFFECTS OF INTEREST CONTRAST IN SPM.MAT FIL
    inputs{3} = sess; 
    inputs{4} = 'rightpmEC';
    inputs{5} = cellstr([pathstem '/preprocessed_data/segmentation/28428/epimasks/pmEC_rightWarped_ITKaffine.nii']); % for single subject now
    spm_jobman('run', jobfile, inputs{:});
end

for sess = 1:3
    inputs = {};
    inputs{1} = cellstr('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/results/SPM_univariate/28428/SPM.mat');
    inputs{2} = 3; % MUST MATCH EFFECTS OF INTEREST CONTRAST IN SPM.MAT FILE
    inputs{3} = sprintf('%d',sess);
    inputs{4} = 'leftpmEC';
    inputs{5} = cellstr('/lustre/scratch/wbic-beta/ccn30/ENCRYPT/fMRI/gridcellpilot/preprocessed_data/segmentation/28428/epimasks/pmEC_leftWarped_ITKaffine.nii');
    spm_jobman('run', jobfile, inputs{:});
end
%% Batch PPI isn't very helpful, unless want to do de-convolution
%% So just do PPI between pairs of ROIs
cd stats

y1 = load('VOI_ROI1_1.mat');
y1 = zscore(y1.Y); % source eigenvector
y2 = load('VOI_ROI2_1.mat');
y2 = zscore(y2.Y); % target

load SPM
neoi = 3;
psyc = SPM.xX.X(:,1:neoi)*[1 -0.5 -0.5; 0 1 -1]'; % Care here - assumes single session at moment from SPM- set contrast
eoni = SPM.xX.X(:,(neoi+1):end); % Care here - assumes single session at moment

phys = zscore(y1,0); 

%% Conventional PPI
c = [0 1 -1];  % Contrast of interets, eg aligned-misaligned
e = eye(3) - c'*pinv(c')*eye(3); e = unique(round(e*10)/10,'rows'); % hacky null space!
psyc = detrend(eoi*c');
eoni = [eoi*e' eoni];
X = [y1.*psyc y1 psyc eoni];
[t,F,p,df,R2,cR2,B,r,aR2,iR2,Bcov] = glm(y2,X,[1 0 0 zeros(1,size(X,2)-3)]'); % PPI
[t,F,p,df,R2,cR2,B,r,aR2,iR2,Bcov] = glm(y2,X,[0 1 0 zeros(1,size(X,2)-3)]'); % func conn
[t,F,p,df,R2,cR2,B,r,aR2,iR2,Bcov] = glm(y2,X,[1 0 0 zeros(1,size(X,2)-3)]'); % psych effect

ppi = [];
for e=1:neoi
    ppi(:,e) = psyc(:,e).*phys;
end

 %% Deconvolved PPI
% jobfile = {'/imaging/rh01/Collaborations/CoCo/batch_ppi_deconv_job.m'};
% inputs = {};
% inputs{1} = cellstr('/imaging/rh01/Collaborations/CoCo/stats/SPM.mat');
% inputs{2} = cellstr('/imaging/rh01/Collaborations/CoCo/stats/VOI_ROI1_1.mat');
% spm_jobman('run', jobfile, inputs{:});
% load('/imaging/rh01/Collaborations/CoCo/stats/PPI_deconv.mat');

phys_n = zscore(PPI.xn); ppi = [];
for e=1:neoi
    psyc_n = full(SPM.Sess(1).U(e).u((2*SPM.xBF.T+1):end));
    ppi_n  = psyc_n.*phys_n;
    ppi_h  = conv(ppi_n,SPM.xBF.bf,'same');
    ppi(:,e) = ppi_h(SPM.xBF.T0:SPM.xBF.T:end);
end

%% Do PPI
X = [ppi psyc phys eoni];
figure,imagesc(zscore(X)); corrcoef(X)

[t,F,p,df,R2,cR2,B,r,aR2,iR2,Bcov] = glm(y2,X,[0 1 -1  0 0 0   0  zeros(1,size(X,2)-7)]'); % PPI: aligned-misaligned 
[t,F,p,df,R2,cR2,B,r,aR2,iR2,Bcov] = glm(y2,X,[0 0 0   0 0 0   1  zeros(1,size(X,2)-7)]'); % func conn
%[t,F,p,df,R2,cR2,B,r,aR2,iR2,Bcov] = glm(y2,X,[0 0 0   0 -1 0  0  zeros(1,size(X,2)-7)]'); % psych effect: aligned-misaligned


    







