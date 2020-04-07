cd /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL2/group

# Group analysis with weighted least squares
/opt/afni-latest/3dMEMA -prefix 3dMEMA_result.nii.gz       \
          -set controls                   \
             01 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             02 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             03 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             04 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             05 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             06 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             07 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             08 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             09 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             10 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             11 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             12 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             13 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             14 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             15 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             16 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             17 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             18 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             19 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             20 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
             21 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48_REML+tlrc['false_belief_vs_false_photo#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48_REML+tlrc['false_belief_vs_false_photo#0_Tstat'] \
	-missing_data 0
	
# Create a group mask
/opt/afni-latest/3dmask_tool                                                 \
    -prefix mask.nii.gz                                     \
    -input `ls /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-*/sub*/mask_epi_anat.*.HEAD` \
    -frac 1.0

# Obtaining the three group-level ACF parameters by averaging the subject-level ACF parameters in the blur_est.sub_xx.1D files
grep -h "err_reml ACF" /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds109/AFNI/LEVEL1/sub-*/sub*/blur_est*   \
    | cut -d\  -f1-3                                   	  \
    > group_ACF_ests.1D

blur_est=`/opt/afni-latest/3dTstat -mean -prefix - group_ACF_ests.1D\'` 
echo "++ The group average ACF params are: $blur_est"

 Simulations for FWE corrected cluster-size inference
/opt/afni-latest/3dClustSim                                       \
    -both                                        \
    -mask   mask.nii.gz                          \
    -acf    $blur_est                            \
    -prefix ClustSim 

# Obtaining cluster extent threshold from the ClustSim.*.1D table
clust_thrvol=`/opt/afni-latest/1d_tool.py -verb 0                                 \
                        -infile ClustSim.NN1_1sided.1D           \
                        -csim_pthr   0.005                        \
                        -csim_alpha "0.05"`
echo "++ The final cluster volume threshold is: $clust_thrvol"

# Obtaining cluster-forming threshold
voxstat_thr=2.84534
echo "++ The voxelwise stat value threshold is: $voxstat_thr"

# Masking t-stat
/opt/afni-latest/3dcalc                                          	      \
    -a 3dMEMA_result.nii.gz		                      \
    -b mask.nii.gz                              	      \
    -expr 'a*b'                                               \
    -prefix 3dMEMA_result_t_stat_masked_4d.nii.gz 

# Obtaining thresholded results
# Positive clusters
/opt/afni-latest/3dclust                                                           \
    -1Dformat -nosum -1tindex 1 -1dindex 0                        \
    -2thresh -1e+09 $voxstat_thr  -dxyz=1                         \
    -savemask Positive_clust_mask.nii.gz                          \
    1.01 ${clust_thrvol} 3dMEMA_result_t_stat_masked_4d.nii.gz

# Binarizing
/opt/afni-latest/3dcalc \
    -a Positive_clust_mask.nii.gz                                      \
    -b 3dMEMA_result.nii.gz'[1]'                                       \
    -expr "step(a)*b"                                                  \
    -prefix Positive_clustered_t_stat.nii.gz                           \
    -float

# Negative clusters
/opt/afni-latest/3dclust                                                           \
    -1Dformat -nosum -1tindex 1 -1dindex 0                        \
    -2thresh -$voxstat_thr 1e+09 -dxyz=1                          \
    -savemask Negative_clust_mask.nii.gz                          \
    1.01 ${clust_thrvol} 3dMEMA_result_t_stat_masked_4d.nii.gz

# Binarizing
/opt/afni-latest/3dcalc \
    -a Negative_clust_mask.nii.gz                                      \
    -b 3dMEMA_result.nii.gz'[1]'                                       \
    -expr "-step(a)*b"                                                 \
    -prefix Negative_clustered_t_stat.nii.gz                           \
    -float


# Obtain 3d volumes from 4d volume to upload to Neurovault
  /opt/afni-latest/3dTcat -prefix 3dMEMA_result_t_stat_masked.nii.gz 3dMEMA_result_t_stat_masked_4d.nii.gz'[1]'
  /opt/afni-latest/3dTcat -prefix 3dMEMA_result_B.nii.gz 3dMEMA_result.nii.gz'[0]'
  /opt/afni-latest/3dTcat -prefix 3dMEMA_result_t_stat.nii.gz 3dMEMA_result.nii.gz'[1]'
