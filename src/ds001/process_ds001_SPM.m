[config_dir,~,~] = fileparts(pwd);
load(fullfile(config_dir,'config.mat'))

ds001_raw_dir = fullfile(home_dir,'data','raw','ds001_R2.0.4');
ds001_processed_dir = fullfile(home_dir,'data','processed','ds001');
fmriprep_dir = fullfile(ds001_processed_dir,'fmriprep');
spm_dir = fullfile(home_dir,'results','ds001','SPM');

if ~isdir(spm_dir)
    mkdir(spm_dir) 
end

onsets_dir = fullfile(spm_dir, 'ONSETS');
level1_dir = fullfile(spm_dir, 'LEVEL1');
level2_dir = fullfile(spm_dir, 'LEVEL2');
perm_dir = fullfile(level2_dir, 'permutation_test');
mni_dir = fullfile(spm_dir, 'mean_mni_images');

% Specify the number of functional volumes ignored in the study
TR = 2;
num_ignored_volumes = 2;

% Specify the TR that will be removed from onsets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR;

% Define conditions and parametric modulations (if any)
% FORMAT
%   {VariableLabel,{TrialType,Durations}}
%   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
%  
CondNames = {...
    {{'pumps_fixed','pumps_demean'}, {'pumps_demean', 0, 'pumps_demean'}},...
    {'pumps_RT', {'pumps_demean', 'response_time'}},...
    {{'cash_fixed','cash_demean'}, {'cash_demean', 0, 'cash_demean'}},...
    {'cash_RT', {'cash_demean', 'response_time'}},...
    {{'explode_fixed','explode_demean'}, {'explode_demean', 0, 'explode_demean'}},...
    {{'control_pumps_fixed','control_pumps_demean'}, {'control_pumps_demean', 0, 'control_pumps_demean'}},...
    {'control_pumps_RT', {'control_pumps_demean', 'response_time'}}};

create_onset_files(study_dir, onsetDir, CondNames, removed_TR_time);
%spm('defaults','FMRI');
%run_subject_level_analyses(study_dir, preproc_dir, 'template_ds001_SPM_level1', level1_dir, num_ignored_volumes, TR);
%run_group_level_analysis(level1_dir, 'template_ds001_SPM_level2', level2_dir, '0001');
%run_permutation_test(level1_dir, 'template_ds001_SPM_perm_test', perm_dir, '0001');
%mean_mni_images(preproc_dir, level1_dir, mni_dir);
