# Preprocessing of ds001, ds109 and ds120 with fmriprep
import os, shutil
from subprocess import check_call
from config import paths
from lib.run_fmriprep import run_fmriprep

# Get any absolute paths from the config.py file
locals().update(paths)

# Raw data directories for ds001, ds109, and ds120
raw_data_dir  = os.path.join(home_dir,'data','raw')
ds001_pre_raw_dir = os.path.join(raw_data_dir,'ds001_R2.0.4')
ds001_raw_dir = os.path.join(raw_data_dir,'ds001_R2.0.4_AMENDED')
ds109_raw_dir = os.path.join(raw_data_dir,'ds000109_R2.0.1')
ds120_raw_dir = os.path.join(raw_data_dir,'ds120_R1.0.0')

# Template fmriprep processing script
fmriprep_template       = os.path.join(home_dir,'src','lib','fmriprep_template')

# The original ds001 sub-04 T1w image has been badly skull-stripped, so we copy the data and apply a custom mask for a better brain extraction
Amendds001_script = os.path.join(home_dir,'src','ds001','Amendds001.sh')
if not os.path.isdir(ds001_raw_dir):
        shutil.copytree(ds001_pre_raw_dir, ds001_raw_dir)
        cmd = Amendds001_script + " " + ds001_raw_dir
        check_call(cmd, shell=True)

# Output directories for preprocessed ds001, ds109, and ds120
processed_data_dir  = os.path.join(home_dir,'data','processed')
ds001_processed_dir = os.path.join(processed_data_dir,'ds001')
ds109_processed_dir = os.path.join(processed_data_dir,'ds109')
ds120_processed_dir = os.path.join(processed_data_dir,'ds120')

# Specifying the subjects to include for ds109 and ds120
ds109_subject_ids = [1, 2, 3, 8, 9, 10, 11, 14, 15, 17, 18, 21, 22, 26, 27, 28, 30, 31, 32, 43, 48]
ds109_subject_ids = ['{num:02d}'.format(num=x) for x in ds109_subject_ids]

ds120_subject_ids = [1, 2, 3, 4, 6, 8, 10, 11, 14, 17, 18, 19, 21, 22, 25, 26, 27]
ds120_subject_ids = ['{num:02d}'.format(num=x) for x in ds120_subject_ids]

# Run fmriprep on all ds001 subjects
run_fmriprep(ds001_raw_dir, ds001_processed_dir, fmriprep_template, packages_dir, fmriprep_singularity_image, FS_license)

# Run fmriprep on all ds109 subjects
run_fmriprep(ds109_raw_dir, ds109_processed_dir, fmriprep_template, packages_dir, fmriprep_singularity_image, FS_license, ds109_subject_ids)

# Run fmriprep on all ds120 subjects
run_fmriprep(ds120_raw_dir, ds120_processed_dir, fmriprep_template, packages_dir, fmriprep_singularity_image, FS_license, ds120_subject_ids)
