function run_group_level_analysis(level1_dir, group_batch_template, level2_dir, contrast_id, varargin)
    sub_dirs = cellstr(spm_select('FPList',level1_dir, 'dir','sub-*'));

    scripts_dir = fullfile(level1_dir, '..', 'SCRIPTS');

    LEVEL1_DIR = level1_dir;
    OUT_DIR = level2_dir;
    
    if length(varargin) == 0 
        end_of_file_name = 0;
    else
        end_of_file_name = varargin{1};
    end

    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    if ~isdir(level2_dir)
        mkdir(level2_dir)
    end
    
    num_sub = numel(sub_dirs);
    CON_FILES = cell(num_sub,0);
    for i = 1:num_sub
        CON_FILES{i,1} = spm_select(...
            'FPList', sub_dirs{i}, ['con_' contrast_id '\.nii']);
    end

    % Create the matlabbatch for this subject
    eval(group_batch_template);
    
    if end_of_file_name == 0
        save(fullfile(scripts_dir, 'level2.mat'), 'matlabbatch');
    else 
        save(fullfile(scripts_dir, sprintf('level2_%s.mat', end_of_file_name)), 'matlabbatch');
    end

    spm_jobman('run', matlabbatch);
end