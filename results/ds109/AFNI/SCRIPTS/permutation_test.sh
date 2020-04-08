cd /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL2/permutation_test

# Create a group mask
/opt/afni-latest/3dmask_tool                                                 \
    -prefix mask.nii.gz                                     \
    -input `ls /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-*/sub*/mask_epi_anat.*.HEAD` \
    -frac 1.0

# t-test analysis, note because we use -Clustsim the result is converted to a z-stat
/opt/afni-latest/3dttest++ 					       \
    -Clustsim 1 				       \
    -prefix perm_ttest++_Clustsim_result.nii.gz        \
    -prefix_clustsim Clustsim			       \
    -mask /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL2/permutation_test/mask.nii.gz   		       \
    -setA setA                    		       \
             01 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01_REML+tlrc.HEAD[32]" \
             02 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02_REML+tlrc.HEAD[32]" \
             03 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03_REML+tlrc.HEAD[32]" \
             04 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08_REML+tlrc.HEAD[32]" \
             05 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09_REML+tlrc.HEAD[32]" \
             06 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10_REML+tlrc.HEAD[32]" \
             07 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11_REML+tlrc.HEAD[32]" \
             08 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14_REML+tlrc.HEAD[32]" \
             09 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15_REML+tlrc.HEAD[32]" \
             10 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17_REML+tlrc.HEAD[32]" \
             11 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18_REML+tlrc.HEAD[32]" \
             12 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21_REML+tlrc.HEAD[32]" \
             13 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22_REML+tlrc.HEAD[32]" \
             14 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26_REML+tlrc.HEAD[32]" \
             15 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27_REML+tlrc.HEAD[32]" \
             16 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28_REML+tlrc.HEAD[32]" \
             17 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30_REML+tlrc.HEAD[32]" \
             18 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31_REML+tlrc.HEAD[32]" \
             19 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32_REML+tlrc.HEAD[32]" \
             20 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43_REML+tlrc.HEAD[32]" \
             21 "/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48_REML+tlrc.HEAD[32]" 

# This can be used to obtain cluster extent threshold from the ClustSim.*.1D table for AFNI versions > 18.2.04
clust_thrvol=`/opt/afni-latest/1d_tool.py -verb 0                                       \
                        -infile Clustsim.CSimA.NN1_1sided.1D           \
                        -csim_pthr   0.01                              \
                        -csim_alpha "0.05"`
echo "++ The final cluster volume threshold is: $clust_thrvol"

# Obtaining cluster-forming threshold
voxstat_thr=2.57583
echo "++ The voxelwise stat value threshold is: $voxstat_thr"

# Masking z-stat
/opt/afni-latest/3dcalc                                          \
    -a perm_ttest++_Clustsim_result.nii.gz      \
    -b mask.nii.gz                              \
    -expr 'a*b'                                 \
    -prefix perm_ttest++_Clustsim_result_z_stat_masked_4d.nii.gz 

# Obtaining masks for thresholded results
# Positive clusters
/opt/afni-latest/3dclust                                                                \
    -1Dformat -nosum -1tindex 1 -1dindex 0                             \
    -2thresh -1e+09 $voxstat_thr  -dxyz=1                             \
    -savemask perm_Positive_clust_mask.nii.gz                          \
    1.01 $clust_thrvol perm_ttest++_Clustsim_result_z_stat_masked_4d.nii.gz

# Negative clusters
/opt/afni-latest/3dclust                                                                \
    -1Dformat -nosum -1tindex 1 -1dindex 0                             \
    -2thresh -$voxstat_thr 1e+09 -dxyz=1                              \
    -savemask perm_Negative_clust_mask.nii.gz                          \
    1.01 $clust_thrvol perm_ttest++_Clustsim_result_z_stat_masked_4d.nii.gz

# Converting the masked z-stat result to a t-stat
/opt/afni-latest/3dcalc \
    -a perm_ttest++_Clustsim_result_z_stat_masked_4d.nii.gz'[1]'   \
    -expr 'cdf2stat(stat2cdf(a,5,0,0,0),3,20,0,0)' \
    -prefix perm_ttest++_Clustsim_result_t_stat_masked.nii.gz

# Applying cluster masks to the t-stat result image to get final thresholded maps
/opt/afni-latest/3dcalc \
    -a perm_Positive_clust_mask.nii.gz                                      \
    -b perm_ttest++_Clustsim_result_t_stat_masked.nii.gz                             \
    -expr "step(a)*b"                                                       \
    -prefix perm_Positive_clustered_t_stat.nii.gz                           \
    -float

# Binarizing
/opt/afni-latest/3dcalc \
    -a perm_Negative_clust_mask.nii.gz                                      \
    -b perm_ttest++_Clustsim_result_t_stat_masked.nii.gz                             \
    -expr "-step(a)*b"                                                      \
    -prefix perm_Negative_clustered_t_stat.nii.gz                           \
    -float

/opt/afni-latest/3dTcat -prefix perm_ttest++_Clustsim_result_z_stat_masked.nii.gz perm_ttest++_Clustsim_result_z_stat_masked_4d.nii.gz'[1]'
