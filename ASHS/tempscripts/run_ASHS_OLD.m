%% prepare environment for ASHS and coregistration
% copy t1 (brain, whole, white matter segmentation) and t2 to
% /Segmentation/subject/inputs


function prepare_segmentation(subj,T1dir,T2dir,segmentdirpath)
subj = 29273;
T1dir = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/raw_images/29273/20190823_U-ID45920/mp2rage';
T2dir = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/raw_images/29273/20190823_U-ID45920/Series_049_Highresolution_TSE_PAT2_100';
segmentdirpath = '/lustre/scratch/wbic-beta/ccn30/ENCRYPT/Segmentation';
%% prepare output folders and input files

files2segmentpath = [segmentdirpath '/' num2str(subj) '/inputs'];
if ~exist(files2segmentpath,'dir')
    mkdir(files2segmentpath);
end

% add this to command below
%ASHSoutputpath = [segmentdirpath '/' num2str(subj) '/ASHSoutput'];

% Move T2
T2file = dir([T2dir '/*.nii']);
T2in = [T2dir '/' T2file.name];
T2out = [files2segmentpath '/t2_PADS.nii'];
if ~exist(T2out,'file')
    fprintf([ '\n\nMoving ' T2file.name ' to ' T2out '...\n\n' ]);
    copyfile(T2in,T2out);
else
    fprintf([ '\n\n ' T2out ' already exists, moving on...\n\n' ]);
end

% Move T1
T1wholein = fullfile([T1dir '/n4mag0000_PSIR_skulled_std.nii']);
T1brainin = fullfile([T1dir '/n4mag0000_PSIR_skulled_std_struc_brain.nii']);
T1wholeout = [files2segmentpath '/t1whole.nii'];  
T1brainout = [files2segmentpath '/t1brain.nii'];
if ~exist(T1wholeout,'file')
    fprintf([ '\n\nMoving ' T1wholein ' to ' T1wholeout '...\n\n' ]);
    copyfile(T1wholein,T1wholeout);
else
    fprintf([ '\n\n ' T1wholeout ' already exists, moving on...\n\n' ]);
end
if ~exist(T1brainout,'file')
    fprintf([ '\n\nMoving ' T1brainin ' to ' T1brainout '...\n\n' ]);
    copyfile(T1brainin,T1brainout);
else
    fprintf([ '\n\n ' T1brainout ' already exists, moving on...\n\n' ]);
end

% Move t1 white matter segmentation
T1wmsegin = fullfile([T1dir '/c2n4mag0000_PSIR_skulled_std.nii']);
T1wmsegout = [files2segmentpath '/t1wmseg.nii']; 
if ~exist(T1wmsegout,'file')
    fprintf([ '\n\nMoving ' T1wmsegin ' to ' T1wmsegout '...\n\n' ]);
    copyfile(T1wmsegin,T1wmsegout);
else
    fprintf([ '\n\n ' T1wmsegout ' already exists, moving on...\n\n' ]);
end

%% run ASHS
% command doesn't seem to work via system(cmd) - rewrite in bash script
cmd = ['cd ' files2segmentpath];
system(cmd);
cmd2 = ['nohup $ASHS_ROOT/bin/ashs_main.sh -I 29273 -a ~/privatemodules/ASHS/atlases/magdeburgatlas -g inputs/t1brain.nii -f inputs/t2.nii -w /lustre/scratch/wbic-beta/ccn30/ENCRYPT/Segmentation/29273/ASHS_output_nopads &'];
status = system(cmd2);

if status == 0
    disp('ASHS s');
else
    error('ASHS command line error');
end
end
