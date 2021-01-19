function run_subject_level_analyses_afni_drift(sub_template, level1_dir_afni_drift, afni_regressors_dir)
    
    if ~isdir(level1_dir_afni_drift)
        mkdir(level1_dir_afni_drift)
    end

    scripts_dir = fullfile(level1_dir_afni_drift, '..', 'SCRIPTS');

    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    % Load in the afni drift basis
    afni_drift = load(fullfile(afni_regressors_dir, 'afni_drift_basis.mat'));   
    afni_drift_mat = afni_drift.afni_drift_mat;
    
    for i = 1:numel(sub_dirs)
        clear SPM_MAT matlabbatch

        copyfile(sub_dirs{i}, level1_dir_afni_drift);
        [~,sub,~] = fileparts(sub_dirs{i});

        % Load the subject's SPM.mat and replace the drift basis
        load(fullfile(level1_dir_afni_drift, sub, 'SPM.mat'));
        SPM.xX.K(1).X0 = afni_drift_mat;

        save(fullfile(level1_dir_afni_drift, sub, 'SPM.mat'), 'SPM');

        SPM_MAT = fullfile(level1_dir_afni_drift, sub, 'SPM.mat'); 

        % Create the matlabbatch for this subject
        eval(sub_template);
        
        save(fullfile(scripts_dir, [strrep(sub,'^','') '_level1_afni_drift_2.mat']), 'matlabbatch');
        spm_jobman('run', matlabbatch);
    end
end