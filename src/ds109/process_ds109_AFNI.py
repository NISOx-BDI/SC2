import os
import sys
sys.path.append("..")

from config import paths
from lib.afni_processing import create_afni_onset_files, run_subject_level_analyses, create_confound_files

locals().update(paths)

ds109_raw_dir = os.path.join(home_dir,'data','raw','ds000109_R2.0.1')
ds109_processed_dir = os.path.join(home_dir,'data','processed','ds109')
fmriprep_dir = os.path.join(ds109_processed_dir,'fmriprep')
afni_dir = os.path.join(home_dir,'results','ds109','AFNI')

if not os.path.isdir(afni_dir):
    os.mkdir(afni_dir)

onsets_dir = os.path.join(afni_dir, 'ONSETS')
confounds_dir = os.path.join(afni_dir, 'MOTION_REGRESSORS')
level1_dir = os.path.join(afni_dir, 'LEVEL1')
level3_dir = os.path.join(afni_dir, 'LEVEL2', 'group')
perm_dir = os.path.join(afni_dir, 'LEVEL2', 'permutation_test')
mni_dir = os.path.join(afni_dir, 'mean_mni_images')

# Set default orientation to origin (instead of standardised space) for
# ambiguous NIfTi (required for ds001)
os.environ["AFNI_NIFTI_VIEW"] = "orig"

# Specify the subjects of interest from the raw data
subject_ids = [1, 2, 3, 8, 9, 10, 11, 14, 15, 17, 18, 21, 22, 26, 27, 28, 30, 31, 32, 43, 48]
subject_ids = ['{num:02d}'.format(num=x) for x in subject_ids]

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = 0

# Specify the subjects of interest from the raw data
subject_ids = [1, 2, 3, 8, 9, 10, 11, 14, 15, 17, 18, 21, 22, 26, 27, 28, 30, 31, 32, 43, 48]
subject_ids = ['{num:02d}'.format(num=x) for x in subject_ids]

# Define conditions and parametric modulations (if any)
# FORMAT
#   {VariableLabel,{TrialType,Durations}}
#   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
conditions = (
    ('false_belief_story', ('false belief story', 'duration')),
    ('false_belief_question', ('false belief question', 'duration')),
    ('false_photo_story', ('false photo story', 'duration')),
    ('false_photo_question', ('false photo question', 'duration')))

# Create onset files based on BIDS tsv files
cond_files = create_afni_onset_files(ds109_raw_dir, onsets_dir, conditions, removed_TR_time, subject_ids)

# Extract motion regressors from fmriprep confounds .tsv
create_confound_files(fmriprep_dir, confounds_dir)

cwd = os.path.dirname(os.path.realpath(__file__))
sub_level_template = os.path.join(cwd, 'template_ds109_AFNI_level1')
#grp_level_template = os.path.join(cwd, 'template_ds109_AFNI_level2')
#perm_template = os.path.join(cwd, 'template_ds109_AFNI_perm_test')

# Run a GLM combining all the fMRI runs of each subject
run_subject_level_analyses(fmriprep_dir, onsets_dir, level1_dir, sub_level_template, home_dir, AFNI_SPM_singularity_image, AFNI_bin)

# Run the group-level GLM
#run_group_level_analysis(level1_dir, level2_dir, grp_level_template)

# Run a permutation test
#run_permutation_test(level1_dir, perm_dir, perm_template)

# Create mean and standard deviations maps of the mean func and anat images in MNI space
#mean_mni_images(preproc_dir, level1_dir, mni_dir)
