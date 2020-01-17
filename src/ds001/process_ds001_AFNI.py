import os
import sys
sys.path.append("..")

from config import paths
from lib.afni_processing import run_orthogonalize, create_afni_onset_files, run_subject_level_analyses

locals().update(paths)

ds001_raw_dir = os.path.join(home_dir,'data','raw','ds001_R2.0.4')
ds001_processed_dir = os.path.join(home_dir,'data','processed','ds001')
fmriprep_dir = os.path.join(ds001_processed_dir,'fmriprep')
afni_dir = os.path.join(home_dir,'results','ds001','AFNI')

if not os.path.isdir(afni_dir):
    os.mkdir(afni_dir)

onsets_dir = os.path.join(afni_dir, 'ONSETS')
level1_dir = os.path.join(afni_dir, 'LEVEL1')
level3_dir = os.path.join(afni_dir, 'LEVEL2', 'group')
perm_dir = os.path.join(afni_dir, 'LEVEL2', 'permutation_test')
mni_dir = os.path.join(afni_dir, 'mean_mni_images')

# Set default orientation to origin (instead of standardised space) for
# ambiguous NIfTi (required for ds001)
os.environ["AFNI_NIFTI_VIEW"] = "orig"

# Specify the number of functional volumes ignored in the study
TR = 2
num_ignored_volumes = 2

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR 

# Directory to store the onset files
onset_dir = os.path.join(afni_dir, 'ONSETS')

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

# Create onset files based on BIDS tsv files
cond_files = create_afni_onset_files(ds001_raw_dir, onsets_dir, conditions, removed_TR_time)

cwd = os.path.dirname(os.path.realpath(__file__))
orthogonalize_template = os.path.join(cwd, 'template_ds001_AFNI_orthogonalize')
sub_level_template = os.path.join(cwd, 'template_ds001_AFNI_level1')
grp_level_template = os.path.join(cwd, 'template_ds001_AFNI_level2')
perm_template = os.path.join(cwd, 'template_ds001_AFNI_perm_test')

# Orthogonalize conditions following the original study
run_orthogonalize(fmriprep_dir, onsets_dir, orthogonalize_template, home_dir, AFNI_SPM_singularity_image)

# Run a GLM combining all the fMRI runs of each subject
#run_subject_level_analyses(preproc_dir, onset_dir, level1_dir, sub_level_template)

# Run the group-level GLM
#run_group_level_analysis(level1_dir, level2_dir, grp_level_template)

# Run a permutation test
#run_permutation_test(level1_dir, perm_dir, perm_template)

# Create mean and standard deviations maps of the mean func and anat images in MNI space
#mean_mni_images(preproc_dir, level1_dir, mni_dir)
