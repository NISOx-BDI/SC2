[config_dir,~,~] = fileparts(pwd);
load(fullfile(config_dir,'config.mat'))

ds109_raw_dir = fullfile(home_dir,'data','raw','ds000109_R2.0.1');
ds109_processed_dir = fullfile(home_dir,'data','processed','ds109');
fmriprep_dir = fullfile(ds109_processed_dir,'fmriprep');
spm_dir = fullfile(home_dir,'results','ds109','SPM');

if ~isdir(spm_dir)
    mkdir(spm_dir) 
end

onsets_dir = fullfile(spm_dir, 'ONSETS');
confounds_dir = fullfile(spm_dir, 'MOTION_REGRESSORS');
level1_dir = fullfile(spm_dir, 'LEVEL1');
level2_dir = fullfile(spm_dir, 'LEVEL2');
perm_dir = fullfile(level2_dir, 'permutation_test');
mni_dir = fullfile(spm_dir, 'mean_mni_images');

% Specify the subjects of interest from the raw data
subject_ids = [1,2,3,8,9,10,11,14,15,17,18,21,22,26,27,28,30,31,32,43,48];

% Specify the number of functional volumes ignored in the study
TR = 2;
num_ignored_volumes = 0;

% Specify the TR that will be removed from onsets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR;

% Define conditions and parametric modulations (if any)
% FORMAT
%   {VariableLabel,{TrialType,Durations}}
%   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
%  
conditions = {...
    {'false_belief_story', {'false belief story', 'duration'}},...
    {'false_belief_question', {'false belief question', 'duration'}},...
    {'false_photo_story', {'false photo story', 'duration'}},...
    {'false_photo_question', {'false photo question', 'duration'}}};

%create_onset_files(ds109_raw_dir, onsets_dir, conditions, 0, subject_ids);
%create_confound_files(fmriprep_dir,confounds_dir);
spm('defaults','FMRI');
%copy_unzip_func(fmriprep_dir, spm_dir)
%run_subject_level_analyses(fmriprep_dir, 'template_ds109_SPM_level1', level1_dir, num_ignored_volumes, TR);
run_group_level_analysis(level1_dir, 'template_ds109_SPM_level2', level2_dir, '0001');
%run_permutation_test(level1_dir, 'template_ds109_SPM_perm_test', perm_dir, '0001');
%mean_mni_images(preproc_dir, level1_dir, mni_dir);
