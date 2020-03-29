import os, glob, re, string, stat, shutil
from subprocess import check_call

def run_fmriprep(raw_dir, out_dir, template_script, packages_dir, fmriprep_singularity_image, FS_license, subject_ids=0):

	# Runs fmriprep on all (or a specified number of) subjects in a BIDS dataset
	# Inputs:
	#	raw_dir:			Directory of the raw BIDS dataset
	#	out_dir:			Directory where all subject-level fmriprep scripts and dervied data will be outputted
	#	template_script:		A template script specifying the fmriprep pipeline that will be ran on all subjects
	#	packages_dir:			Directory containing all the modules on the Linux HPC. i.e. the directory where 'module avail' packages are stored
	#	fmriprep_singularity_image:	The version of fmriprep that will be used (installed as a .simg file)
	#	FS_license:			FreeSurfer license.txt file required for fmriprep
	#	subject_ids:			(optional) a vector of subject ids specifying the subjects fmriprep will be run on (i.e. [01, 02] to run fmriprep on sub-01 and sub-02)
	# Outputs:
	#	out_dir/scripts/ :		Subject specific fmriprep scripts will be stored here
	#	out_dir/ds???_sub-??_work/ :	Directory containing the intermediate files fmriprep creates for the subject
	#	out_dir/fmriprep/ :		Directory containing each subjects fmriprep preprocessed data
	#	out_dir/logs/ :			Directory containg each subjects fmriprep log files

	# Make the directory where all fmriprep scripts and outputs will be stored
	if not os.path.isdir(out_dir):
    		os.mkdir(out_dir)

	# Directory where subject-level fmriprep scripts will be made
	scripts_dir = os.path.join(out_dir, 'scripts')

	if not os.path.isdir(scripts_dir):
		os.mkdir(scripts_dir)


	# Obtain the list of subjects from the raw data directory
	if subject_ids == 0:
		sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))
	else:
		sub_dirs = []
		for i in subject_ids:
			sub_dirs.append(os.path.join(raw_dir, 'sub-' + i))
	subs = [os.path.basename(w) for w in sub_dirs]		
	# Obtain the study id from the output dir name
	study = os.path.basename(out_dir)
	
	# Singularity needs to see the home_dir, so we obtain the path relative to the raw_dir
	home_dir = os.path.join(raw_dir, os.pardir, os.pardir, os.pardir)
	 
	# Creating and running an fmriprep script for each subjects
	for s in subs:
		# New dict for each subject
		values = dict()
		values["packages_dir"] = packages_dir
		values["singularity_image"] = fmriprep_singularity_image
		values["FS_license"] = FS_license
		values["raw_dir"] = raw_dir
		values["out_dir"] = out_dir
		values["home_dir"] = home_dir
		values["study"] = study
		sub_reg = re.search('sub-\d+', s)
		sub = sub_reg.group(0)
		values["sub"] = sub
		sub_id = sub.split("-")[1]
		values["sub_id"] = sub_id

		# If fmriprep failed last time (i.e. the summary report sub-??.html was not created), then we delete all subject's fmriprep files and re-run
		if os.path.isdir(os.path.join(out_dir, 'fmriprep', sub)):
			if not os.path.isfile(os.path.join(out_dir, 'fmriprep', sub + '.html')):
				shutil.rmtree(os.path.join(out_dir, 'fmriprep', sub))
				shutil.rmtree(os.path.join(out_dir, study + '_' + sub + '_work'))
				os.remove(os.path.join(scripts_dir, study + '_' + sub + '_fmriprep.sh'))
				shutil.rmtree(os.path.join(out_dir, 'freesurfer', sub))
		
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

			cmd = "qsub " + sub_script_file
			check_call(cmd, shell=True)
