function copy_unzip_func(fmriprep_dir, spm_dir)

    func_dir = fullfile(spm_dir, 'FUNCTIONAL');

    if ~isdir(func_dir)
        mkdir(func_dir)
    end

    sub_dirs = cellstr(spm_select('FPList',fmriprep_dir, 'dir','sub-*'));
    
    % Copying all fmriprep functional files and mask files to a new directory and unzipping
    matlabbatch = cell(0);
    for i = 1:numel(sub_dirs)
        [~,sub,~] = fileparts(sub_dirs{i}); 
        fmriprep_func_dir = fullfile(fmriprep_dir, sub, 'func');
        func_files = cellstr(spm_select('FPList', fmriprep_func_dir, ['.*\-preproc_bold.nii.gz']));
        for r = 1:numel(func_files)
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files = {func_files{r}};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {func_dir};
            func_files{r} = spm_file(func_files{r}, 'path', func_dir);
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = func_files(r);
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {func_dir};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = false;  
        end
        mask_files = cellstr(spm_select('FPList', fmriprep_func_dir, ['.*-brain_mask.nii.gz']));
        for k = 1:numel(mask_files)
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files = {mask_files{k}};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {func_dir};
            func_files{r} = spm_file(mask_files{k}, 'path', func_dir);
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = func_files(k);
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {func_dir};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = false;  
        end

    end
    spm_jobman('run', matlabbatch);
end