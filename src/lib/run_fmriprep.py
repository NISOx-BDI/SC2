import os, glob, re

def run_fmriprep(raw_dir, out_dir, template_script, packages_dir, FS_license):
	
	# Make the directory where all fmriprep scripts and outputs will be stored
	if not os.path.isdir(out_dir):
    		os.mkdir(out_dir)

	# Directory where subject-level fmriprep scripts will be made
	scripts_dir = os.path.join(out_dir, os.pardir, 'scripts')

	if not os.path.isdir(scripts_dir):
		os.mkdir(scripts_dir)


	# Obtain the list of subjects from the raw data directory
	sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))
	subs     = [os.path.basename(w) for w in sub_dirs

	# Creating and running an fmriprep script for each subjects
	for s in subs:
		# New dict for each subject
		values = dict()
		values["packages_dir"] = packages_dir
		values["FS_license"] = FS_license
		values["out_dir"] = out_dir
		sub_reg = re.search('sub-\d+', s)
		sub = sub_reg.group(0)
		values["sub"] = sub
		sub_id = sub.split("-")[1]
		values["sub_id"] = sub_id
		study = os.path.basename(out_dir)
		print(study) 
