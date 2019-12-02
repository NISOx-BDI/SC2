# Preprocessing of ds001, ds109 and ds120 with fmriprep
import os
from lib

# Specifiy the home directory 
home_dir = '/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2'

# Raw data directories for ds001, ds109, and ds120
raw_data_dir  = os.path.join(home_dir,'data','raw')
ds001_raw_dir = os.path.join(raw_data_dir,'ds001_R2.0.4')
ds109_raw_dir = os.path.join(raw_data_dir,'ds000109_R2.0.1')
ds120_raw_dir = os.path.join(raw_data_dir,'ds120_R1.0.0')

# Output directories for preprocessed ds001, ds109, and ds120
processed_data_dir  = os.path.join(home_dir,'data','processed')
ds001_processed_dir = os.path.join(processed_data_dir,'ds001')
ds109_processed_dir = os.path.join(processed_data_dir,'ds109')
ds120_processed_dir = os.path.join(processed_data_dir,'ds120')

# Template subject-level processing scripts
scripts_dir             = os.path.join(home_dir,'src')
ds001_fmriprep_template = os.path.join(scripts_dir,'ds001','ds001_fmriprep_template')
ds109_fmriprep_template = os.path.join(scripts_dir,'ds109','ds109_fmriprep_template')
ds120_fmriprep_template = os.path.join(scripts_dir,'ds120','ds120_fmriprep_template')

# Run fmriprep on all ds001 subjects
run_fmriprep(ds001_raw_dir, ds001_processed_dir, ds001_fmriprep_template)

# Run fmriprep on all ds109 subjects
run_fmriprep(ds109_raw_dir, ds109_processed_dir, ds109_fmriprep_template)

# Run fmriprep on all ds120 subjects
run_fmriprep(ds120_raw_dir, ds120_processed_dir, ds120_fmriprep_template)