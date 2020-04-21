# run afni_proc.py to create a single subject processing script
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-2020-03-26-v1.sif /opt/afni-latest/afni_proc.py -subj_id sub01 \
        -script proc.sub01 -scr_overwrite                                    \
        -blocks tshift blur mask scale regress               \
        -copy_anat /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/fmriprep/sub-01/anat/sub-01_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz                                 \
        -anat_has_skull no                         \
        -tcat_remove_first_trs 4                                               \
        -dsets                                                                 \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/fmriprep/sub-01/func/sub-01_task-antisaccadetaskwithfixedorder_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/fmriprep/sub-01/func/sub-01_task-antisaccadetaskwithfixedorder_run-02_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/fmriprep/sub-01/func/sub-01_task-antisaccadetaskwithfixedorder_run-03_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz    \
        -tshift_opts_ts -tpattern alt+z                                        \
        -blur_size 5.0                                                         \
        -regress_stim_times                                                    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/sub-01_combined_neutral_afni.1d                          \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/sub-01_combined_reward_afni.1d                           \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/../MOTION_REGRESSORS/sub-01_combined_trans_x.1d                  \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/../MOTION_REGRESSORS/sub-01_combined_trans_y.1d                  \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/../MOTION_REGRESSORS/sub-01_combined_trans_z.1d                  \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/../MOTION_REGRESSORS/sub-01_combined_rot_x.1d                    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/../MOTION_REGRESSORS/sub-01_combined_rot_y.1d                    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds120/AFNI/ONSETS/../MOTION_REGRESSORS/sub-01_combined_rot_z.1d                    \
        -regress_stim_labels                                                   \
            neutral reward trans_x trans_y trans_z rot_x rot_y rot_z           \
        -regress_basis_multi                                                   \
            'SIN(0,24,8)' 'SIN(0,24,8)' 'NONE' 'NONE' 'NONE' 'NONE' 'NONE' 'NONE' \
        -regress_stim_types                                                    \
            times times file file file file file file                          \
	-regress_3dD_stop						       \
	-regress_reml_exec 						       \
        -regress_opts_3dD                                                      \
            -gltsym 'SYM: neutral'                                             \
        -glt_label 1 neutral_vs_baseline                                       \
             -gltsym 'SYM: reward'                                             \
        -glt_label 2 reward_vs_baseline                                        \
        -regress_make_ideal_sum sum_ideal.1D                                   \
        -regress_est_blur_epits                                                \
        -regress_est_blur_errts
        
