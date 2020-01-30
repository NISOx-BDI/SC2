# run afni_proc.py to create a single subject processing script
SINGULARITYENV_PREPEND_PATH=/well/nichols/shared/miniconda3/envs/py3/bin/ singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2,/well/nichols/shared/miniconda3/envs/py3/bin/python /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/afni_proc.py -subj_id sub10                                                  \
        -script proc.sub10 -scr_overwrite                                    \
        -blocks blur mask scale regress               \
        -copy_anat /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/fmriprep/sub-10/anat/sub-10_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz                                 \
		-anat_has_skull yes					       \
        -tcat_remove_first_trs 2                                               \
        -dsets                                                                 \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/fmriprep/sub-10/func/sub-10_task-balloonanalogrisktask_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz     \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/fmriprep/sub-10/func/sub-10_task-balloonanalogrisktask_run-02_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/fmriprep/sub-10/func/sub-10_task-balloonanalogrisktask_run-03_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz   \
        -blur_size 5.0                                                         \
        -regress_stim_times                                                    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-10_combined_cash_demean_afni.1d                      \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-10_combined_cash_RT_ort_afni.1D                          \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-10_combined_control_pumps_demean_afni.1d             \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-10_combined_control_pumps_RT_ort_afni.1D                 \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-10_combined_explode_demean_afni.1d                   \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-10_combined_pumps_demean_afni.1d                     \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-10_combined_pumps_RT_ort_afni.1D                         \
        -regress_stim_labels                                                   \
            cash_demean cash_RT control_pumps_demean                           \
            control_pumps_RT explode_demean pumps_demean                       \
            pumps_RT                                                           \
        -regress_basis_multi                                                   \
            'BLOCK(0.772,1)' 'NONE' 'BLOCK(0.772,1)' 'NONE'              \
        'BLOCK(0.772,1)' 'BLOCK(0.772,1)' 'NONE'                            \
        -regress_stim_types                                                    \
            AM2 file AM2 file AM2 AM2 file                                        \
	-regress_3dD_stop						       \
	-regress_reml_exec 						       \
        -regress_opts_3dD                                                      \
            -gltsym 'SYM: pumps_demean[1] -control_pumps_demean[1]'            \
        -glt_label 1 pumps_demean_vs_ctrl_demean                               \
        -regress_make_ideal_sum sum_ideal.1D                                   \
        -regress_est_blur_epits                                                \
        -regress_est_blur_errts
