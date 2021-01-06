import os
import sys
sys.path.append("..")

from config import paths
from lib.fsl_processing import create_fsl_onset_files, create_confound_files, run_run_level_analyses, run_subject_level_analyses, run_permutation_test, run_group_level_analysis, run_run_level_spm_design, run_run_level_spm_drift, fsl_spm_subject_level_files

locals().update(paths)

ds001_raw_dir = os.path.join(home_dir,'data','raw','ds001_R2.0.4')
ds001_processed_dir = os.path.join(home_dir,'data','processed','ds001')
fmriprep_dir = os.path.join(ds001_processed_dir,'fmriprep')
fsl_dir = os.path.join(home_dir,'results','ds001','FSL')

if not os.path.isdir(fsl_dir):
    os.mkdir(fsl_dir)

onsets_dir = os.path.join(fsl_dir, 'ONSETS')
confounds_dir = os.path.join(fsl_dir, 'MOTION_REGRESSORS')
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

# Extract motion regressors from fmriprep confounds .tsv
#create_confound_files(fmriprep_dir,confounds_dir,num_ignored_volumes)

cwd = os.path.dirname(os.path.realpath(__file__))
run_level_fsf = os.path.join(cwd,'template_ds001_FSL_level1.fsf')
sub_level_fsf = os.path.join(cwd,'template_ds001_FSL_level2.fsf')
grp_level_fsf = os.path.join(cwd,'template_ds001_FSL_level3.fsf')
perm_template = os.path.join(cwd,'template_ds001_FSL_perm_test')

# Run a GLM for each fMRI run of each subject
#run_run_level_analyses(fmriprep_dir, run_level_fsf, level1_dir, cond_files)

# Run a GLM combining all the fMRI runs of each subject
#run_subject_level_analyses(level1_dir, sub_level_fsf, level1_dir)

# Run the group-level GLM
#run_group_level_analysis(level1_dir, grp_level_fsf, level3_dir, '1')

# Run a permutation test
#run_permutation_test(level1_dir, perm_dir, perm_template)

## Analyses where SPM's design matrix is used at the run-level
spm_design_dir = os.path.join(home_dir,'results','ds001','SPM','DESIGN')
level1_dir_spm_design = os.path.join(fsl_dir, 'LEVEL1_SPM_DESIGN')
level3_dir_spm_design = os.path.join(fsl_dir, 'LEVEL2_SPM_DESIGN', 'group')
perm_dir_spm_design = os.path.join(fsl_dir, 'LEVEL2_SPM_DESIGN', 'permutation_test')
run_level_fsf_spm_design = os.path.join(cwd,'template_ds001_FSL_level1_SPM_design.fsf')
 
# Run a GLM for each fMRI run of each subject, using that subject's SPM design matrix
#run_run_level_spm_design(fmriprep_dir, run_level_fsf_spm_design, level1_dir_spm_design, spm_design_dir)
#run_subject_level_analyses(level1_dir_spm_design, sub_level_fsf, level1_dir_spm_design, 'spm_design')
#run_group_level_analysis(level1_dir_spm_design, grp_level_fsf, level3_dir_spm_design, '1', 'spm_design')
#run_permutation_test(level1_dir_spm_design, perm_dir_spm_design, perm_template, 'spm_design')

## Analyses where SPM's design matrix and SPM's drift model  is used at the run-level
level1_dir_spm_drift = os.path.join(fsl_dir, 'LEVEL1_SPM_DRIFT')
level3_dir_spm_drift = os.path.join(fsl_dir, 'LEVEL2_SPM_DRIFT', 'group')
perm_dir_spm_drift = os.path.join(fsl_dir, 'LEVEL2_SPM_DRIFT', 'permutation_test')
run_level_fsf_spm_drift = os.path.join(cwd,'template_ds001_FSL_level1_SPM_drift.fsf')

# Run a GLM for each fMRI run of each subject, using that subject's SPM design matrix and SPM's drift model
#run_run_level_spm_drift(fmriprep_dir, run_level_fsf_spm_drift, level1_dir_spm_drift, spm_design_dir)
#run_subject_level_analyses(level1_dir_spm_drift, sub_level_fsf, level1_dir_spm_drift, 'spm_drift')
#run_group_level_analysis(level1_dir_spm_drift, grp_level_fsf, level3_dir_spm_drift, '1', 'spm_drift')
#run_permutation_test(level1_dir_spm_drift, perm_dir_spm_drift, perm_template, 'spm_drift')

## Analyses where AFNI's design matrix is used at the run-level
afni_design_dir = os.path.join(home_dir,'results','ds001','AFNI','DESIGN')
level1_dir_afni_design = os.path.join(fsl_dir, 'LEVEL1_AFNI_DESIGN')
level3_dir_afni_design = os.path.join(fsl_dir, 'LEVEL2_AFNI_DESIGN', 'group')
perm_dir_afni_design = os.path.join(fsl_dir, 'LEVEL2_AFNI_DESIGN', 'permutation_test')
run_level_fsf_afni_design = os.path.join(cwd,'template_ds001_FSL_level1_AFNI_design.fsf')

# Run a GLM for each fMRI run of each subject, using that subject's AFNI design matrix
#run_run_level_spm_design(fmriprep_dir, run_level_fsf_afni_design, level1_dir_afni_design, afni_design_dir, 'afni')
#run_subject_level_analyses(level1_dir_afni_design, sub_level_fsf, level1_dir_afni_design, 'afni_design')
#run_group_level_analysis(level1_dir_afni_design, grp_level_fsf, level3_dir_afni_design, '1', 'afni_design')
#run_permutation_test(level1_dir_afni_design, perm_dir_afni_design, perm_template, 'afni_design')

## Analyses where AFNI's design matrix and AFNI's drift model  is used at the run-level
level1_dir_afni_drift = os.path.join(fsl_dir, 'LEVEL1_AFNI_DRIFT')
level3_dir_afni_drift = os.path.join(fsl_dir, 'LEVEL2_AFNI_DRIFT', 'group')
perm_dir_afni_drift = os.path.join(fsl_dir, 'LEVEL2_AFNI_DRIFT', 'permutation_test')
run_level_fsf_afni_drift = os.path.join(cwd,'template_ds001_FSL_level1_AFNI_drift.fsf')

# Run a GLM for each fMRI run of each subject, using that subject's AFNI design matrix and AFNI's drift model
#run_run_level_spm_drift(fmriprep_dir, run_level_fsf_afni_drift, level1_dir_afni_drift, afni_design_dir, 'afni')
#run_subject_level_analyses(level1_dir_afni_drift, sub_level_fsf, level1_dir_afni_drift, 'afni_drift')
#run_group_level_analysis(level1_dir_afni_drift, grp_level_fsf, level3_dir_afni_drift, '1', 'afni_drift')
#run_permutation_test(level1_dir_afni_drift, perm_dir_afni_drift, perm_template, 'afni_drift')

## Analyses where SPM's subject-level results are run through FSL's group-level model
spm_level1_dir = os.path.join(home_dir,'results','ds001','SPM','LEVEL1')
level1_dir_spm_subject_level = os.path.join(fsl_dir, 'LEVEL1_SPM_SUBJECT')
level3_dir_spm_subject_level = os.path.join(fsl_dir, 'LEVEL2_SPM_SUBJECT','group')
perm_dir_spm_subject_level = os.path.join(fsl_dir, 'LEVEL2_SPM_SUBJECT','permutation_test')
#fsl_spm_subject_level_files(spm_level1_dir, level1_dir, level1_dir_spm_subject_level)
#run_group_level_analysis(level1_dir_spm_subject_level, grp_level_fsf, level3_dir_spm_subject_level, '1', 'spm_subject_level')
#run_permutation_test(level1_dir_spm_subject_level, perm_dir_spm_subject_level, perm_template, 'spm_subject_level')

## Analyses where AFNI's subject-level results are run through FSL's group-level model
afni_level1_dir = os.path.join(home_dir,'results','ds001','AFNI','LEVEL1')
level1_dir_afni_subject_level = os.path.join(fsl_dir, 'LEVEL1_AFNI_SUBJECT')
level3_dir_afni_subject_level = os.path.join(fsl_dir, 'LEVEL2_AFNI_SUBJECT','group')
perm_dir_afni_subject_level = os.path.join(fsl_dir, 'LEVEL2_AFNI_SUBJECT','permutation_test')
#fsl_spm_subject_level_files(afni_level1_dir, level1_dir, level1_dir_afni_subject_level, 'afni')
#run_group_level_analysis(level1_dir_afni_subject_level, grp_level_fsf, level3_dir_afni_subject_level, '1', 'afni_subject_level')
run_permutation_test(level1_dir_afni_subject_level, perm_dir_afni_subject_level, perm_template, 'afni_subject_level')
