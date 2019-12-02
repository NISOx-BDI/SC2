import os, glob, re, string

def run_fmriprep(raw_dir, out_dir, template_script, packages_dir, fmriprep_singularity_image, FS_license):	
	# Make the directory where all fmriprep scripts and outputs will be stored
	if not os.path.isdir(out_dir):
    		os.mkdir(out_dir)

	# Directory where subject-level fmriprep scripts will be made
	scripts_dir = os.path.join(out_dir, os.pardir, 'scripts')

	if not os.path.isdir(scripts_dir):
		os.mkdir(scripts_dir)


	# Obtain the list of subjects from the raw data directory
	sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))
	subs     = [os.path.basename(w) for w in sub_dirs]
	
	# Obtain the study id from the output dir name
	study = os.path.basename(out_dir)
	
	# Creating and running an fmriprep script for each subjects
	for s in subs:
		# New dict for each subject
		values = dict()
		values["packages_dir"] = packages_dir
		values["singularity_image"] = fmriprep_singularity_image
		values["FS_license"] = FS_license
		values["raw_dir"] = raw_dir
		values["out_dir"] = out_dir
		values["study"] = study
		sub_reg = re.search('sub-\d+', s)
		sub = sub_reg.group(0)
		values["sub"] = sub
		sub_id = sub.split("-")[1]
		values["sub_id"] = sub_id
		
	if not os.path.isfile(os.path.join(scripts_dir, study + '_' + sub + '_fmriprep.sh')):
		# Fill-in the subject-level fmriprep template
		with open(template_script) as f:
		    tpm = f.read()
		    t = string.Template(tpm)
		    sub_script = t.substitute(values)
	
		sub_script_file = os.path.join(scripts_dir, study + '_' + sub + '_fmriprep.sh')

		with open(sub_script_file, "w") as f:
		    f.write(sub_script)

		# Make the script executable
		st = os.stat(sub_script_file)
		os.chmod(sub_script_file, st.st_mode | stat.S_IEXEC)


		#cmd = os.path.join('.', sub_script_file)
		#print(cmd)
		#check_call(cmd, shell=True)

		# Putting the proc. script in the correct directory, making it executable, and running
		#sub_proc_script_file = os.path.join(sub_results_dir, 'proc.' + shortsub)
		#cmd = os.path.join('tcsh -xef ' + sub_proc_script_file)
		#print(cmd)
		#check_call(cmd, shell=True)
