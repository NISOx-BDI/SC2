function create_confound_files(fmriprep_dir, confounds_dir, varargin)
    % Extracts the motion regressors from the confounds.tsv files outputted by fmriprep

    if ~isdir(confounds_dir)
        mkdir(confounds_dir)
    end
    
    if length(varargin) == 0 
        removed_TRs = 0;
    else
        removed_TRs = varargin{1};
    end

    % All fmriprep subject-level directories
    fmriprep_dirs = cellstr(spm_select('FPList', fmriprep_dir, 'dir', 'sub-??'));

    % For each subject
    for i = 1:numel(fmriprep_dirs)
        [~,sub,~] = fileparts(fmriprep_dirs{i});

        % All regressor files for this subject
        regressor_files = cellstr(spm_select('FPList', fullfile(fmriprep_dirs{i},'func'), '.*\-confounds_regressors.tsv'));

        % For each run
        for j = 1:numel(regressor_files)
            regressor_data = importdata(regressor_files{j}, '\t');
            motion_regressor_mat = [regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'trans_x'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'trans_y'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'trans_z'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'rot_x'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'rot_y'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'rot_z'),1))];
            R = motion_regressor_mat(removed_TRs+1:end,:);
            save(fullfile(confounds_dir, [sub '_run-' num2str(j,'%02d') '_motion_regressors.mat']), 'R')
        end
    end
end
