function run_subject_level_analyses_afni_drift(sub_template, level1_dir_afni_design, level1_dir_afni_drift, afni_design_dir)
    
    if ~isdir(level1_dir_afni_design)
        mkdir(level1_dir_afni_design)
    end

    scripts_dir = fullfile(level1_dir, '..', 'SCRIPTS');

    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    sub_dirs = cellstr(spm_select('FPList',level1_dir_afni_drift, 'dir','sub-*'));   
    
    for i = 1:numel(sub_dirs)
        
        copyfile(sub_dirs{i}, level1_dir_afni_design)

    end
end