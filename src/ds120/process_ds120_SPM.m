[config_dir,~,~] = fileparts(pwd);
load(fullfile(config_dir,'config.mat'))

ds120_pre_raw_dir = fullfile(home_dir,'data','raw','ds120_R1.0.0');
ds120_raw_dir = fullfile(home_dir,'data','raw','ds120_R1.0.0_AMENDED');
ds120_processed_dir = fullfile(home_dir,'data','processed','ds120');
fmriprep_dir = fullfile(ds120_processed_dir,'fmriprep');
spm_dir = fullfile(home_dir,'results','ds120','SPM');

if ~isdir(spm_dir)
    mkdir(spm_dir) 
end

onsets_dir = fullfile(spm_dir, 'ONSETS');
confounds_dir = fullfile(spm_dir, 'MOTION_REGRESSORS');
level1_dir = fullfile(spm_dir, 'LEVEL1');
level2_dir = fullfile(spm_dir, 'LEVEL2');
perm_dir = fullfile(level2_dir, 'permutation_test');
mni_dir = fullfile(spm_dir, 'mean_mni_images');

% The original event files are not compatible with Bidsto3col.sh, so we copy the raw data and amend the events
if ~exist(ds120_raw_dir)
	copyfile(ds120_pre_raw_dir, ds120_raw_dir);
	system(['Amendds120tsv.sh ' ds120_raw_dir]);
end 

% Specify the subjects of interest from the raw data
subject_ids = [1,2,3,4,6,8,10,11,14,17,18,19,21,22,25,26,27];

% Specify the number of functional volumes ignored in the study
TR = 1.5;
num_ignored_volumes = 4;

% Specify the TR that will be removed from onsets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR;

% Define conditions and parametric modulations (if any)
% FORMAT
%   {VariableLabel,{TrialType,Durations}}
%   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
%  
conditions = {...
    {'neutral', {'neutral_resp', 0}},...
    {'reward', {'reward_resp', 0}}};

%create_onset_files(ds120_raw_dir, onsets_dir, conditions, removed_TR_time, subject_ids);
%create_confound_files(fmriprep_dir,confounds_dir,num_ignored_volumes)
spm('defaults','FMRI');
copy_unzip_func(fmriprep_dir, spm_dir)
run_subject_level_analyses(fmriprep_dir, 'template_ds001_SPM_level1', level1_dir, num_ignored_volumes, TR);
%run_group_level_analysis(level1_dir, 'template_ds120_SPM_level2', level2_dir, '0001');
%mean_mni_images(preproc_dir, level1_dir, mni_dir);
