import os
import sys
sys.path.append("..")

from config import paths
from lib.fsl_processing import create_fsl_onset_files, run_run_level_analyses, run_subject_level_analyses

locals().update(paths)

ds001_raw_dir = os.path.join(home_dir,'data','raw','ds001_R2.0.4')
ds001_processed_dir = os.path.join(home_dir,'data','processed','ds001')
fmriprep_dir = os.path.join(ds001_processed_dir,'fmriprep')
fsl_dir = os.path.join(home_dir,'results','ds001','FSL')

if not os.path.isdir(fsl_dir):
    os.mkdir(fsl_dir)

onsets_dir = os.path.join(fsl_dir, 'ONSETS')
level1_dir = os.path.join(fsl_dir, 'LEVEL1')
level3_dir = os.path.join(fsl_dir, 'LEVEL2', 'group')
perm_dir = os.path.join(fsl_dir, 'LEVEL2', 'permutation_test')
mni_dir = os.path.join(fsl_dir, 'mean_mni_images')

# Specify the number of functional volumes ignored in the study
TR = 2
num_ignored_volumes = 2

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR 

# Define conditions and parametric modulations (if any)
conditions = (
    (('pumps_fixed', 'pumps_demean'), ('pumps_demean',)),
    ('pumps_RT', ('pumps_demean', 'response_time')),
    (('cash_fixed', 'cash_demean'), ('cash_demean',)),
    ('cash_RT', ('cash_demean', 'response_time')),
    (('explode_fixed', 'explode_demean'), ('explode_demean',)),
    (('control_pumps_fixed', 'control_pumps_demean'),
     ('control_pumps_demean',)),
    ('control_pumps_RT', ('control_pumps_demean', 'response_time')))

# Create 3-columns onset files based on BIDS tsv files
#cond_files = create_fsl_onset_files(ds001_raw_dir, onsets_dir, conditions, removed_TR_time)

cwd = os.path.dirname(os.path.realpath(__file__))
run_level_fsf = os.path.join(cwd,'template_ds001_FSL_level1.fsf')
sub_level_fsf = os.path.join(cwd,'template_ds001_FSL_level2.fsf')
grp_level_fsf = os.path.join(cwd,'template_ds001_FSL_level3.fsf')

# Run a GLM for each fMRI run of each subject
#run_run_level_analyses(fmriprep_dir, run_level_fsf, level1_dir, cond_files)

# Run a GLM combining all the fMRI runs of each subject
run_subject_level_analyses(level1_dir, sub_level_fsf, level1_dir)

# Run the group-level GLM
#run_group_level_analysis(level2_dir, grp_level_fsf, level3_dir, '1')

# Run a permutation test
#run_permutation_test(level1_dir, perm_dir, perm_template)

# Create mean and standard deviations maps of the mean func and anat images in MNI space
#mean_mni_images(preproc_dir, level1_dir, mni_dir)
