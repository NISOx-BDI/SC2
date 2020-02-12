import os
import sys
sys.path.append("..")

from config import paths
from lib.fsl_processing import create_fsl_onset_files, create_confound_files, run_run_level_analyses, run_subject_level_analyses, run_group_level_analysis

locals().update(paths)

ds109_raw_dir = os.path.join(home_dir,'data','raw','ds000109_R2.0.1')
ds109_processed_dir = os.path.join(home_dir,'data','processed','ds109')
fmriprep_dir = os.path.join(ds109_processed_dir,'fmriprep')
fsl_dir = os.path.join(home_dir,'results','ds109','FSL')

if not os.path.isdir(fsl_dir):
    os.mkdir(fsl_dir)

onsets_dir = os.path.join(fsl_dir, 'ONSETS')
confounds_dir = os.path.join(fsl_dir, 'MOTION_REGRESSORS')
level1_dir = os.path.join(fsl_dir, 'LEVEL1')
level3_dir = os.path.join(fsl_dir, 'LEVEL2', 'group')
perm_dir = os.path.join(fsl_dir, 'LEVEL2', 'permutation_test')
mni_dir = os.path.join(fsl_dir, 'mean_mni_images')

# Specify the subjects of interest from the raw data
subject_ids = [1, 2, 3, 8, 9, 10, 11, 14, 15, 17, 18, 21, 22, 26, 27, 28, 30, 31, 32, 43, 48]
subject_ids = ['{num:02d}'.format(num=x) for x in subject_ids]

removed_TR_time = 0

# Directory to store the onset files
onsetDir = os.path.join(fsl_dir, 'ONSETS')

# Define conditions and parametric modulations (if any)
conditions = (
    ('false_belief_story', ('false belief story', 'duration')),
    ('false_belief_question', ('false belief question', 'duration')),
    ('false_photo_story', ('false photo story', 'duration')),
    ('false_photo_question', ('false photo question', 'duration')))

# Create 3-columns onset files based on BIDS tsv files
#cond_files = create_fsl_onset_files(ds109_raw_dir, onsets_dir, conditions, removed_TR_time)

# Extract motion regressors from fmriprep confounds .tsv
#create_confound_files(fmriprep_dir,confounds_dir)

cwd = os.path.dirname(os.path.realpath(__file__))
run_level_fsf = os.path.join(cwd,'template_ds109_FSL_level1.fsf')
sub_level_fsf = os.path.join(cwd,'template_ds109_FSL_level2.fsf')
grp_level_fsf = os.path.join(cwd,'template_ds109_FSL_level3.fsf')

# Run a GLM for each fMRI run of each subject
run_run_level_analyses(fmriprep_dir, run_level_fsf, level1_dir, cond_files)

# Run a GLM combining all the fMRI runs of each subject
#run_subject_level_analyses(level1_dir, sub_level_fsf, level1_dir)

# Run the group-level GLM
#run_group_level_analysis(level1_dir, grp_level_fsf, level3_dir, '1')

# Run a permutation test
#run_permutation_test(level1_dir, perm_dir, perm_template)

# Create mean and standard deviations maps of the mean func and anat images in MNI space
#mean_mni_images(preproc_dir, level1_dir, mni_dir)
