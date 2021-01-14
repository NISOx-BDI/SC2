function run_subject_level_analyses_afni_drift(sub_template, level1_dir_afni_design, level1_dir_afni_drift, afni_regressors_dir)
    
    if ~isdir(level1_dir_afni_drift)
        mkdir(level1_dir_afni_drift)
    end

    scripts_dir = fullfile(level1_dir_afni_drift, '..', 'SCRIPTS');

    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    sub_dirs = cellstr(spm_select('FPList',level1_dir_afni_design, 'dir','sub-*'));

    % Load in the afni drift basis
    afni_drift = load(fullfile(afni_regressors_dir, 'afni_drift_basis.mat'));   
    afni_drift_mat = afni_drift.afni_drift_mat;
    
    for i = 1:numel(sub_dirs)
        
        copyfile(sub_dirs{i}, level1_dir_afni_drift);
        [~,sub,~] = fileparts(sub_dirs{i});

        % Load the subject's SPM.mat and replace the drift basis
        load(fullfile(level1_dir_afni_drift, sub, 'SPM.mat'));
        SPM.xX.K(1).X0 = afni_drift_mat;

        % Also change the working directory to the new LEVEL1_DRIFT directory
        SPM.swd = level1_dir_afni_drift;

        save(fullfile(level1_dir_afni_drift, sub, 'SPM.mat'), 'SPM');
    end
end