function run_subject_level_analyses_afni_drift(sub_template, level1_dir_afni_design, level1_dir_afni_drift, afni_regressors_dir)
    
    if ~isdir(level1_dir_afni_drift)
        mkdir(level1_dir_afni_drift)
    end

    scripts_dir = fullfile(level1_dir_afni_drift, '..', 'SCRIPTS');

    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    sub_dirs = cellstr(spm_select('FPList',level1_dir_afni_design, 'dir','sub-*'));   
    
    for i = 1:numel(sub_dirs)
        
        copyfile(sub_dirs{i}, level1_dir_afni_drift);

    end
end