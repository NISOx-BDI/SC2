AFNI_LEVEL1_DIR=/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/LEVEL1

mkdir -p $AFNI_LEVEL1_DIR/subject_beta_niftis
cp $AFNI_LEVEL1_DIR/sub-*/sub*.results/stats.sub*_REML+tlrc.BRIK $AFNI_LEVEL1_DIR/subject_beta_niftis

cd $AFNI_LEVEL1_DIR/subject_beta_niftis

for f in $AFNI_LEVEL1_DIR/subject_beta_niftis/* ; do
	echo /opt/afni-latest/3dAFNItoNIFTI -prefix $(basename $f) $(echo $f)['pumps_demean_vs_ctrl_demean#0_Coef']
done