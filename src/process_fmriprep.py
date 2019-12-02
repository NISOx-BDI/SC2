# Preprocessing of ds001, ds109 and ds120 with fmriprep
import os
from lib.run_fmriprep import run_fmriprep

# Specifiy the directory containing all the packages needed for fmriprep
packages_dir = '/well/win/software/packages'
# Specifiy the home directory 
home_dir = '/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2'
# Specify the location of the fmriprep singularity image
fmriprep_singularity_image = '/well/nichols/users/bas627/fmriprep/fmriprep-1.5.1.simg'
# Specifiy the freesurfer license file, needed to run fmriprep
FS_license = os.path.join(home_dir,'license.txt')

# Raw data directories for ds001, ds109, and ds120
raw_data_dir  = os.path.join(home_dir,'data','raw')
ds001_raw_dir = os.path.join(raw_data_dir,'ds001_R2.0.4')
ds109_raw_dir = os.path.join(raw_data_dir,'ds000109_R2.0.1')
ds120_raw_dir = os.path.join(raw_data_dir,'ds120_R1.0.0')

# Template subject-level processing scripts
scripts_dir             = os.path.join(home_dir,'src')
ds001_fmriprep_template = os.path.join(scripts_dir,'ds001','ds001_fmriprep_template')
ds109_fmriprep_template = os.path.join(scripts_dir,'ds109','ds109_fmriprep_template')
ds120_fmriprep_template = os.path.join(scripts_dir,'ds120','ds120_fmriprep_template')

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
run_fmriprep(ds001_raw_dir, ds001_processed_dir, ds001_fmriprep_template, packages_dir, fmriprep_singularity_image, FS_license)

# Run fmriprep on all ds109 subjects
run_fmriprep(ds109_raw_dir, ds109_processed_dir, ds109_fmriprep_template, packages_dir, fmriprep_singularity_image, FS_license, ds109_subject_ids)

# Run fmriprep on all ds120 subjects
run_fmriprep(ds120_raw_dir, ds120_processed_dir, ds120_fmriprep_template, packages_dir, fmriprep_singularity_image, FS_license, ds120_subject_ids)
