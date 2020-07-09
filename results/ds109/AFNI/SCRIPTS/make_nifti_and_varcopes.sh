cd /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes

for f in /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub*; do
    subID=`echo $(basename $f) | awk -F '[-]' '{print $2}'`

    # Make COPE NIFTI
    /opt/afni-latest/3dAFNItoNIFTI -prefix /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_cope.nii.gz /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-$subID/sub$subID.results/stats.sub${subID}_REML+tlrc['false_belief_vs_false_photo#0_Coef']

    # Make T-STAT NIFTI
    /opt/afni-latest/3dAFNItoNIFTI -prefix /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_tstat.nii.gz /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-$subID/sub$subID.results/stats.sub${subID}_REML+tlrc['false_belief_vs_false_photo#0_Tstat']

    # Create subject-level masks
    /opt/afni-latest/3dmask_tool                                             \
        -prefix /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_mask.nii.gz                    \
        -input `ls /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/fmriprep/sub-$subID/func/*brain_mask.nii.gz` \
        -frac 1.0

    # Masking COPE
    /opt/afni-latest/3dcalc                                \
    -a /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_cope.nii.gz		    \
    -b /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_mask.nii.gz           \
    -expr 'a*b'                                     \
    -prefix /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_cope_masked.nii.gz 

    # Masking TSTAT
    /opt/afni-latest/3dcalc                                \
    -a /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_tstat.nii.gz           \
    -b /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_mask.nii.gz           \
    -expr 'a*b'                                     \
    -prefix /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_tstat_masked.nii.gz 

    # Making VARCOPE
    /opt/afni-latest/3dcalc                                \
    -a /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_cope_masked.nii.gz           \
    -b /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_tstat_masked.nii.gz           \
    -expr '(a/b)^2'                                     \
    -prefix /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_varcope_masked.nii.gz 

    # Getting the estimated error dof
    awk '/final/{print $4}' /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-$subID/sub$subID.results/out.df_info.txt >> /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/varcopes/sub-${subID}_error_dof.txt
done