%% cmrr phys extraction from dcm, and tapas regressor extraction from cmrr files
% make into function

scriptdir = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/scripts/physio_extraction';
addpath(scriptdir);

% initialise (read in from parent main script?)
subjectvec = {'27734','28061','28428','29317','29321','29332','29336','29358','29382','29383'};
dateIDvec = {'20190902_U-ID46027','20190911_U-ID46160','20190903_U-ID46074','20190902_U-ID46030','20190902_U-ID46038','20190903_U-ID46058','20190903_U-ID46066','20190905_U-ID46106','20190911_U-ID46164','20190912_U-ID46168'};
rawpathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/raw_data/images';
outpathstem = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/gridcellpilot/preprocessed_data';
seriesvec = [24,28,32];
runvec = {'Run1','Run2','Run3'};
% read in from json file?
nslices = 42;
tr = 2.53;
nvolumes = 238;

% outer loop through subjects
for i =1 %:length(subjectvec)
    subjpath = [rawpathstem '/' subjectvec{i} '/' dateIDvec{i}];
    outsubjpath = [outpathstem '/regressors/' subjectvec{i}];
    %mkdir(outsubjpath);
    
    % inner loop through runs
    for j=1 %:length(seriesvec)
       
        % get phys dicom file from scanner + make output dir for each run
        d = dir([subjpath '/Series_0' num2str(seriesvec(j)) '_*/*.dcm']);
        physfilepath = [d.folder '/' d.name];
        outrunpath = [outsubjpath '/' runvec{j}];
        %mkdir(outrunpath);
        
        % extract and make puls and resp logs
        %extractCMRRPhysio(physfilepath,outrunpath);
        
        % use PhysIO function that globs puls and resp files in output dir to make regressors
        cd(outrunpath);
        %getPhysRegressors_CMRR(nslices,tr,nvolumes);
        
        % combine movement and phys regressors into single .txt file
        cd ..
        movregressors = [outpathstem '/images/' subjectvec{i} '/rp_topup_Run_' num2str(j) '.txt'];
        physregressors = [outrunpath '/Physio_regressors/multiple_regressors.txt'];
        cmd = ['paste ' movregressors ' ' physregressors ' > total_regressors.txt'];
        [status,~] = system(cmd);
        if status == 0
            disp(['total_regressors.txt successfully created for subject ' subjectvec{i}]);
        else
            disp('ERROR');
        end
        
    end
    
end

