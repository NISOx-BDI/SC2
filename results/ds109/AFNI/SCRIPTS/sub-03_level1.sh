# run afni_proc.py to create a single subject processing script
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/fsl-afni-spm12-conda.sif /opt/afni-latest/afni_proc.py -subj_id sub03 \
        -script proc.sub03 -scr_overwrite                                    \
        -blocks blur mask scale regress                                        \
        -script proc.sub03 -scr_overwrite                                    \
        -blocks tshift align tlrc volreg blur mask scale regress               \
        -copy_anat /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/fmriprep/sub-03/anat/sub-03_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz \
		-anat_has_skull no \
        -dsets                                                                 \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/fmriprep/sub-03/func/sub-03_task-theoryofmindwithmanualresponse_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz     \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/fmriprep/sub-03/func/sub-03_task-theoryofmindwithmanualresponse_run-02_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz     \
        -blur_size 8.0                                                         \
        -regress_stim_times                                                    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/sub-03_combined_false_belief_story_afni.1d               \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/sub-03_combined_false_belief_question_afni.1d            \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/sub-03_combined_false_photo_story_afni.1d                \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/sub-03_combined_false_photo_question_afni.1d             \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/../MOTION_REGRESSORS/sub-03_combined_trans_x.1d                  \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/../MOTION_REGRESSORS/sub-03_combined_trans_y.1d                  \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/../MOTION_REGRESSORS/sub-03_combined_trans_z.1d                  \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/../MOTION_REGRESSORS/sub-03_combined_rot_x.1d                    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/../MOTION_REGRESSORS/sub-03_combined_rot_y.1d                    \
            /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/ONSETS/../MOTION_REGRESSORS/sub-03_combined_rot_z.1d                    \
        -regress_stim_labels                                                   \
            false_belief_story false_belief_question false_photo_story         \
            false_photo_question trans_x trans_y trans_z rot_x rot_y rot_z     \
        -regress_basis_multi                                                   \
            'SPMG1(10)' 'SPMG1(6)' 'SPMG1(10)' 'SPMG1(6)'                      \
            'NONE' 'NONE' 'NONE' 'NONE' 'NONE' 'NONE'                          \
        -regress_stim_types                                                    \
            times times times times file file file file file file              \
    -regress_3dD_stop                                                          \
    -regress_reml_exec                                                         \
        -regress_opts_3dD                                                      \
            -gltsym 'SYM: false_belief_story -false_photo_story'               \
        -glt_label 1 false_belief_vs_false_photo                               \
        -regress_make_ideal_sum sum_ideal.1D                                   \
        -regress_est_blur_epits                                                \
        -regress_est_blur_errts
        
