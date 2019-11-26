%% Define subject parameters
% By tec31 adapted by ccn30 08/19

cnt = 0;
% run 3
cnt = cnt + 1;
subjects{cnt} = '29780';
dates{cnt} = '20191125';
fullid{cnt} = '20191125_U-ID47173';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'Series_005_mp2rage_sag_p3_0.75mm_UNI_Images','Series_004_mp2rage_sag_p3_0.75mm_INV2','Series_035_cmrr_ep2d_bold_1.5x1.5x1_TrueForm','Series_035_cmrr_ep2d_bold_1.5x1.5x1_TrueForm/topup','Series_033_cmrr_ep2d_bold_1.5x1.5x1_TrueForm_inv'};
blocksin{cnt} = {'Series_005_mp2rage_sag_p3_0.75mm_UNI_Images.nii','Series_004_mp2rage_sag_p3_0.75mm_INV2.nii','Series_035_cmrr_ep2d_bold_1.5x1.5x1_TrueForm.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','INV2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 240;
group(cnt) = 1;

% run 2
cnt = cnt + 1;
subjects{cnt} = '29780';
dates{cnt} = '20191125';
fullid{cnt} = '20191125_U-ID47173';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'Series_005_mp2rage_sag_p3_0.75mm_UNI_Images','Series_004_mp2rage_sag_p3_0.75mm_INV2','Series_029_cmrr_ep2d_bold_1.5x1.5x1_PatientSpecTrue','Series_029_cmrr_ep2d_bold_1.5x1.5x1_PatientSpecTrue/topup','Series_027_cmrr_ep2d_bold_1.5x1.5x1_PatientSpecTrue_inv'};
blocksin{cnt} = {'Series_005_mp2rage_sag_p3_0.75mm_UNI_Images.nii','Series_004_mp2rage_sag_p3_0.75mm_INV2.nii','Series_029_cmrr_ep2d_bold_1.5x1.5x1_PatientSpecTrue.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','INV2','Run_2','Pos_topup','Neg_topup'};
minvols(cnt) = 240;
group(cnt) = 1;

% run 1
cnt = cnt + 1;
subjects{cnt} = '29780';
dates{cnt} = '20191125';
fullid{cnt} = '20191125_U-ID47173';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'Series_005_mp2rage_sag_p3_0.75mm_UNI_Images','Series_004_mp2rage_sag_p3_0.75mm_INV2','Series_023_cmrr_ep2d_bold_1.5x1.5x1_PatientSpec','Series_023_cmrr_ep2d_bold_1.5x1.5x1_PatientSpec/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_PatientSpec_inv'};
blocksin{cnt} = {'Series_005_mp2rage_sag_p3_0.75mm_UNI_Images.nii','Series_004_mp2rage_sag_p3_0.75mm_INV2.nii','Series_023_cmrr_ep2d_bold_1.5x1.5x1_PatientSpec.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','INV2','Run_1','Pos_topup','Neg_topup'};
minvols(cnt) = 240;
group(cnt) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
%1
cnt = cnt + 1;
subjects{cnt} = '29358';
dates{cnt} = '20190905';
fullid{cnt} = '20190905_U-ID46106';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;


%2
cnt = cnt + 1;
subjects{cnt} = '28061';
dates{cnt} = '20190911';
fullid{cnt} = '20190911_U-ID46160';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;
%3
cnt = cnt + 1;
subjects{cnt} = '28428';
dates{cnt} = '20190903';
fullid{cnt} = '20190903_U-ID46074';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;
%4
cnt = cnt + 1;
subjects{cnt} = '29317';
dates{cnt} = '20190902';
fullid{cnt} = '20190902_U-ID46030';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmmr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmmr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmmr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmmr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmmr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;
%5
cnt = cnt + 1;
subjects{cnt} = '29321';
dates{cnt} = '20190902';
fullid{cnt} = '20190902_U-ID46038';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmmr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;
%6
cnt = cnt + 1;
subjects{cnt} = '29332';
dates{cnt} = '20190903';
fullid{cnt} = '20190903_U-ID46058';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;
%7
cnt = cnt + 1;
subjects{cnt} = '29336';
dates{cnt} = '20190903';
fullid{cnt} = '20190903_U-ID46066';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;
%8

%9
cnt = cnt + 1;
subjects{cnt} = '29382';
dates{cnt} = '20190911';
fullid{cnt} = '20190911_U-ID46164';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;
%10
cnt = cnt + 1;
subjects{cnt} = '29383';
dates{cnt} = '20190912';
fullid{cnt} = '20190912_U-ID46168';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmrr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmrr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmrr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmrr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;


% cnt = cnt + 1;
% subjects{cnt} = '25821';
% dates{cnt} = '20190627';
% fullid{cnt} = '20190814_U-ID45800';
% basedir{cnt} = 'ENCRYPT';
% blocksin_folders{cnt} = {'mp2rage','Series_026_bold_ep2d_1.5iso','Series_026_bold_ep2d_1.5iso','Series_025_bold_ep2d_1.5iso_INV'};
% blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run.nii','run1posblip.nii','run1negblip.nii'};
% blocksout{cnt} = {'structural','Run_1','Pos_topup','Neg_topup'};
% minvols(cnt) = 359;
% group(cnt) = 1;
% 
% cnt = cnt + 1;
% subjects{cnt} = '28545';
% dates{cnt} = '20190627';
% fullid{cnt} = '20190627_U-ID45355';
% basedir{cnt} = 'ENCRYPT';
% blocksin_folders{cnt} = {'mp2rage','Series_030_cmrr_sb_bold_2iso_run1','Series_030_cmrr_sb_bold_2iso_run1','Series_028_cmrr_sb_bold_2iso_run1_INV'};
% blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run1sbref.nii','run1sbrefinv.nii'};
% blocksout{cnt} = {'structural','Run_1','Pos_topup','Neg_topup'};
% minvols(cnt) = 493;
% group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = '27734';
dates{cnt} = '20190902';
fullid{cnt} = '20190902_U-ID46027';
basedir{cnt} = 'ENCRYPT';
blocksin_folders{cnt} = {'mp2rage','Series_023_cmmr_ep2d_bold_1.5x1.5x1_run1','Series_027_cmmr_ep2d_bold_1.5x1.5x1_run2','Series_031_cmmr_ep2d_bold_1.5x1.5x1_run3','Series_023_cmmr_ep2d_bold_1.5x1.5x1_run1/topup','Series_021_cmmr_ep2d_bold_1.5x1.5x1_run1_inv'};
blocksin{cnt} = {'n4mag0000_PSIR_skulled_std.nii','run1.nii','run2.nii','run3.nii','pos_topup.nii','neg_topup.nii'};
blocksout{cnt} = {'structural','Run_1','Run_2','Run_3','Pos_topup','Neg_topup'};
minvols(cnt) = 238;
group(cnt) = 1;

