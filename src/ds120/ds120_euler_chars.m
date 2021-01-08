base_dir = '/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/';
study = 'ds120';

if ~exist('euler_chars', 'file')
    addpath(fullfile(base_dir, 'src', 'lib'))
end 

study_dir = fullfile(base_dir, 'results', study);
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmF_0002.nii');
afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'group', 'Group_f_stat_masked.nii.gz');
spm_mask = fullfile(study_dir, 'SPM', 'LEVEL2', 'mask.nii');
afni_mask = fullfile(study_dir, 'AFNI', 'LEVEL2', 'group', 'mask.nii.gz');

euler_array = {spm_stat_file, afni_stat_file};
mask_array = {spm_mask, afni_mask};


for i=1:length(euler_array)
	euler_chars_f_statistic(euler_array{i}, mask_array{i});
end
