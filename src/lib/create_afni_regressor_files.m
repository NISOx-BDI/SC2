function create_afni_regressor_files(fmriprep_dir, out_dir, afni_regressors_dir, varargin)
    % Extracts the regressors from AFNI's design matrix into a .mat file compatible with SPM

    if ~isdir(out_dir)
        mkdir(out_dir)
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

            % Getting all the AFNI sine basis regressors into one matrix
            afni_regressor_files = cellstr(spm_select('FPList', afni_regressors_dir, [sub '_run-' sprintf('%02d',j) '_regressor_.*\.txt']))
            afni_first_regressor = importdata(afni_regressor_files{1}, '\t');
            afni_regressor_mat = zeros(length(afni_first_regressor), length(afni_regressor_files));
            afni_regressor_mat(:,1) = afni_first_regressor;
            
            for k = 2:numel(afni_regressor_files)
                afni_regressor_data = importdata(afni_regressor_files{k}, '\t');
                afni_regressor_mat(:,k) = afni_regressor_data;
            end

            % Getting the motion regressors into one matrix
            regressor_data = importdata(regressor_files{j}, '\t');
            motion_regressor_mat = [regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'trans_x'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'trans_y'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'trans_z'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'rot_x'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'rot_y'),1)), regressor_data.data(:,find(strcmp(regressor_data.colheaders, 'rot_z'),1))];
            motion_regressor_mat = motion_regressor_mat(removed_TRs+1:end,:);

            % Concatenate the AFNI sine basis regressors and motion regressors 
            R = [afni_regressor_mat, motion_regressor_mat];
            save(fullfile(out_dir, [sub '_run-' num2str(j,'%02d') '_afni_regressors.mat']), 'R')
        end
    end
end
