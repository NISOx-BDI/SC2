function make_varcopes(level1_dir)

	out_dir = fullfile(level1_dir, 'varcopes')

	if ~isdir(out_dir)
		mkdir(out_dir)
	end

	sub_dirs = cellstr(spm_select('FPList',level1_dir, 'dir','sub-*'));   

	for i = 1:numel(sub_dirs)

		[~,sub,~] = fileparts(sub_dirs{i});
		subject_mat_file = fullfile(sub_dirs{i}, 'SPM.mat');

		ic = 1; % select the contrast index
		load(subject_mat_file)
		disp(sprintf('Selecting con %d "%s"\n', ic, SPM.xCon(ic).name))
		vsca = SPM.xCon(ic).c'*SPM.xX.Bcov*SPM.xCon(ic).c;
		varfn = fullfile(out_dir, sprintf('%s_convar_%04d.nii', sub, ic));
		cd(sub_dirs{i})
		spm_imcalc(SPM.VResMS,varfn,'i1*vsca',{[],[],[],spm_type('float32'),sprintf('Contrast %d variance', ic)},vsca);

		error_dof = SPM.xX.erdf;
		fileID = fopen(sprintf('%s_error_dof.txt', sub)),'w');
		fprintf(fprintf(fileID,"%4.1f",error_dof));
		fclose(fildID);
	end
end
