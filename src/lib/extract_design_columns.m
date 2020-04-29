function extract_design_columns(level1_dir, design_dir)
    
    if ~isdir(design_dir)
        mkdir(design_dir)
    end

    sub_dirs = cellstr(spm_select('FPList',level1_dir, 'dir','sub-*'));
    func_dir = fullfile(level1_dir, '..', 'FUNCTIONAL');   
    
    for i = 1:numel(sub_dirs)

        [~,sub,~] = fileparts(sub_dirs{i});
        SPM = load(fullfile(level1_dir, sub, 'SPM.mat'));
        sub = ['^' sub];

        % Using the number of bold files in the func dir to get the number of runs
        fmri_files = cellstr(spm_select('List', func_dir, [sub '.*\-preproc_bold.nii']));
        nruns = length(fmri_files);

        % Obtaining the number of run-level regressors in the design matrix for the subject
        nregressors = ((length(SPM.SPM.xX.name) - nruns)/nruns);

        % Obtaining the number of time-points in each run
        ntimepoints = size(SPM.SPM.xX.X, 1)/nruns;

        % For each run, extract all the run-level regressors in the design matrix to a text file 
        for r = 1:nruns
            % Exclude the motion regressors 
            for q = 1:(nregressors-6)
                column = SPM.SPM.xX.X((1+ntimepoints*(r-1)):ntimepoints*r,q+nregressors*(r-1));
                % writing the column to a text file
                output_filename = fullfile(design_dir, [strrep(sub,'^','') '_run-' sprintf('%02d',r) '_regressor_' sprintf('%02d', q) '.txt']);
                fid = fopen(output_filename,'w');
                fprintf(fid,'%07.6f\n',column);
                fclose(fid);
            end
        end

        % Also extract SPM's drift basis, which is the same for all subjects and runs
        if i == 1
            for t = 1:9
                column = SPM.SPM.xX.K.X0(:,t);
                % writing the column to a text file
                output_filename = fullfile(design_dir, ['spm_drift_basis_' sprintf('%02d', t) '.txt']);
                fid = fopen(output_filename,'w');
                fprintf(fid,'%07.6f\n',column);
                fclose(fid);
            end
        end
    end
end
