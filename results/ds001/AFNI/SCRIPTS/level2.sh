cd /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL2/group

# Group analysis with weighted least squares
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dMEMA -prefix 3dMEMA_result.nii.gz       \
          -set controls                   \
             01 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             02 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             03 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             04 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-04/sub04.results/stats.sub04_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-04/sub04.results/stats.sub04_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             05 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-05/sub05.results/stats.sub05_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-05/sub05.results/stats.sub05_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             06 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-06/sub06.results/stats.sub06_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-06/sub06.results/stats.sub06_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             07 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-07/sub07.results/stats.sub07_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-07/sub07.results/stats.sub07_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             08 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             09 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             10 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             11 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             12 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-12/sub12.results/stats.sub12_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-12/sub12.results/stats.sub12_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             13 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-13/sub13.results/stats.sub13_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-13/sub13.results/stats.sub13_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             14 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             15 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
             16 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-16/sub16.results/stats.sub16_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Coef'] /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-16/sub16.results/stats.sub16_REML+tlrc['pumps_demean_vs_ctrl_demean#0_Tstat'] \
	-missing_data 0		

# Create a group mask
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dmask_tool                                                 \
    -prefix mask.nii.gz                                     \
    -input `ls /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-*/sub*/mask_epi_anat.*.HEAD` \
    -frac 1.0

# Obtaining the three group-level ACF parameters by averaging the subject-level ACF parameters in the blur_est.sub_xx.1D files
grep -h "err_reml ACF" /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1/sub-*/sub*/blur_est*   \
    | cut -d\  -f1-3                                   	  \
    > group_ACF_ests.1D

blur_est=`singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dTstat -mean -prefix - group_ACF_ests.1D\'` 
echo "++ The group average ACF params are: $blur_est"

# Simulations for FWE corrected cluster-size inference
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dClustSim                                       \
    -both                                        \
    -mask   mask.nii.gz                          \
    -acf    $blur_est                            \
    -prefix ClustSim 

# Obtaining cluster extent threshold from the ClustSim.*.1D table
clust_thrvol=`singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/1d_tool.py -verb 0                                 \
                        -infile ClustSim.NN1_1sided.1D           \
                        -csim_pthr   0.01                        \
                        -csim_alpha "0.05"`
echo "++ The final cluster volume threshold is: $clust_thrvol"

# Obtaining cluster-forming threshold
voxstat_thr=`singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/p2dsetstat -quiet                                   \
                    -pval 0.01                                   \
                    "-1sided"                                    \
                    -inset 3dMEMA_result.nii.gz'[controls:t]'`
echo "++ The voxelwise stat value threshold is: $voxstat_thr"

# Masking t-stat
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dcalc                                          	      \
    -a 3dMEMA_result.nii.gz		                      \
    -b mask.nii.gz                              	      \
    -expr 'a*b'                                               \
    -prefix 3dMEMA_result_t_stat_masked_4d.nii.gz 

# Obtaining thresholded results
# Positive clusters
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dclust                                                           \
    -1Dformat -nosum -1tindex 1 -1dindex 0                        \
    -2thresh -1e+09 $voxstat_thr  -dxyz=1                         \
    -savemask Positive_clust_mask.nii.gz                          \
    1.01 ${clust_thrvol} 3dMEMA_result_t_stat_masked_4d.nii.gz

# Binarizing
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dcalc \
    -a Positive_clust_mask.nii.gz                                      \
    -b 3dMEMA_result.nii.gz'[1]'                                       \
    -expr "step(a)*b"                                                  \
    -prefix Positive_clustered_t_stat.nii.gz                           \
    -float

# Negative clusters
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dclust                                                           \
    -1Dformat -nosum -1tindex 1 -1dindex 0                        \
    -2thresh -$voxstat_thr 1e+09 -dxyz=1                          \
    -savemask Negative_clust_mask.nii.gz                          \
    1.01 ${clust_thrvol} 3dMEMA_result_t_stat_masked_4d.nii.gz

# Binarizing
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dcalc \
    -a Negative_clust_mask.nii.gz                                      \
    -b 3dMEMA_result.nii.gz'[1]'                                       \
    -expr "-step(a)*b"                                                 \
    -prefix Negative_clustered_t_stat.nii.gz                           \
    -float


# Obtain 3d volumes from 4d volume to upload to Neurovault
  singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dTcat -prefix 3dMEMA_result_t_stat_masked.nii.gz 3dMEMA_result_t_stat_masked_4d.nii.gz'[1]'
  singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dTcat -prefix 3dMEMA_result_B.nii.gz 3dMEMA_result.nii.gz'[0]'
  singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-r-python3-spm12-conda-2020-03-02.sif /opt/afni-latest/3dTcat -prefix 3dMEMA_result_t_stat.nii.gz 3dMEMA_result.nii.gz'[1]'
