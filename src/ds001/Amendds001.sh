#!/bin/bash
#
# Script: Amendds001.sh
# Purpose: Amends the sub-04 t1w image by applying a custom brain mask. 
# Author: A Bowring a.bowring@warwick.ac.uk
# Version: 1.0   20 April 2017
#

Usage() {
cat <<EOF
Usage: `basename $0` Dir 

Applies a custom brain mask to the sub-04_T1w.nii.gz image.
EOF
exit
}

if (( $# < 1 )) ; then
    Usage
fi

Dir="$1"
sub04_anat_dir=$1/sub-04/anat
bet $sub04_anat_dir/sub-04_T1w.nii.gz $sub04_anat_dir/sub-04_T1w_brain.nii.gz
fslmaths $sub04_anat_dir/sub-04_T1w.nii.gz -roi 0 -1 0 -1 107 -1 0 1 $sub04_anat_dir/sub-04_T1w_top_of_head.nii.gz
fslmaths $sub04_anat_dir/sub-04_T1w.nii.gz -roi 70 21 112 -1 0 -1 0 1 $sub04_anat_dir/sub-04_T1w_between_eyes.nii.gz
fslmaths $sub04_anat_dir/sub-04_T1w.nii.gz -roi 0 -1 0 70 0 -1 0 1 $sub04_anat_dir/sub-04_T1w_back_of_head.nii.gz
fslmaths $sub04_anat_dir/sub-04_T1w_brain.nii.gz -add $sub04_anat_dir/sub-04_T1w_top_of_head.nii.gz -add $sub04_anat_dir/sub-04_T1w_between_eyes.nii.gz -add $sub04_anat_dir/sub-04_T1w_back_of_head.nii.gz -bin -mul $sub04_anat_dir/sub-04_T1w.nii.gz $sub04_anat_dir/sub-04_T1w.nii.gz
fslmaths $sub04_anat_dir/sub-04_T1w.nii.gz -thr 400 -bin -mul 200 $sub04_anat_dir/sub-04_T1w_above_420.nii.gz
fslmaths $sub04_anat_dir/sub-04_T1w.nii.gz -uthr 399 -add $sub04_anat_dir/sub-04_T1w_above_420.nii.gz $sub04_anat_dir/sub-04_T1w.nii.gz
rm -rf $sub04_anat_dir/sub-04_T1w_*
