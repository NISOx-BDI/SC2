import os 

def run_fmriprep(input_dir, output_dir, template_script, packages_dir, FS_license)
	
	# Make the directory where all fmriprep scripts and outputs will be stored
	if not os.path.isdir(output_dir):
    	os.mkdir(output_dir)

	# Directory where subject-level fmriprep scripts will be made
	scripts_dir = os.path.join(output_dir, os.pardir, 'scripts')

	if not os.path.isdir(scripts_dir):
		os.mkdir(scripts_dir)


	sub_dirs = glob.glob(os.path.join(study_dir, 'sub-*'))
	print(sub_dirs)