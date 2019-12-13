import os
import sys
sys.path.append("..")

from config import paths
from lib.fsl_processing import create_fsl_onset_files, run_run_level_analyses

locals().update(paths)

ds120_raw_dir = os.path.join(home_dir,'data','raw','ds120_R1.0.0')
ds120_processed_dir = os.path.join(home_dir,'data','processed','ds120')
fmriprep_dir = os.path.join(ds120_processed_dir,'fmriprep')
fsl_dir = os.path.join(home_dir,'results','ds120','FSL')

if not os.path.isdir(fsl_dir):
    os.mkdir(fsl_dir)

onsets_dir = os.path.join(fsl_dir, 'ONSETS')
level1_dir = os.path.join(fsl_dir, 'LEVEL1')
level3_dir = os.path.join(fsl_dir, 'LEVEL2', 'group')
perm_dir = os.path.join(fsl_dir, 'LEVEL2', 'permutation_test')
mni_dir = os.path.join(fsl_dir, 'mean_mni_images')

# Specify the subjects of interest from the raw data
subject_ids = [1, 2, 3, 4, 6, 8, 10, 11, 14, 17, 18, 19, 21, 22, 25, 26, 27]
subject_ids = ['{num:02d}'.format(num=x) for x in subject_ids]

# Specify the number of functional volumes ignored in the study
TR = 1.5
num_ignored_volumes = 4

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR 

# Directory to store the onset files
onsetDir = os.path.join(fsl_dir, 'ONSETS')

# Define conditions and parametric modulations (if any)
conditions = (
    ('neutral', ('neutral_resp', 'duration')),
    ('reward', ('reward_resp', 'duration')))

# Create 3-columns onset files based on BIDS tsv files
cond_files = create_fsl_onset_files(ds120_raw_dir, onsets_dir, conditions, removed_TR_time)

cwd = os.path.dirname(os.path.realpath(__file__))
run_level_fsf = os.path.join(cwd,'template_ds120_FSL_level1.fsf')

# Run a GLM for each fMRI run of each subject
run_run_level_analyses(fmriprep_dir, run_level_fsf, level1_dir, cond_files)

# Run a GLM combining all the fMRI runs of each subject
#run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir)

# Run the group-level GLM
#run_group_level_analysis(level2_dir, grp_level_fsf, level3_dir, '1')

# Run a permutation test
#run_permutation_test(level1_dir, perm_dir, perm_template)

# Create mean and standard deviations maps of the mean func and anat images in MNI space
#mean_mni_images(preproc_dir, level1_dir, mni_dir)
