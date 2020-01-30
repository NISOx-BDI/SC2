#!/usr/bin/env tcsh
#
# Orthogonalizing the AFNI conditions for ds000001
#
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/3dDeconvolve                                                                              \
   -nodata 894 2                                                     			  \
   -concat '1D: 0 298 596'                                           			  \
   -polort -1                                                        		 	  \
   -num_stimts 7                                                    			  \
   -stim_times_AM2 1 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-15_combined_cash_demean_afni.1d  			  \
               'BLOCK(0.772,1)'                                     			  \
   -stim_label 1 cash_demean					     			  \
   -stim_times_AM1 2 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-15_combined_cash_RT_afni.1d      			  \
               'dmBLOCK'                                       	    			  \
   -stim_label 2 cash_RT					    			  \
   -stim_times_AM2 3 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-15_combined_control_pumps_demean_afni.1d               \
               'BLOCK(0.772,1)'                                     			  \
   -stim_label 3 control_pumps_demean					     		  \
   -stim_times_AM1 4 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-15_combined_control_pumps_RT_afni.1d      		  \
               'dmBLOCK'                                       	     			  \
   -stim_label 4 control_pumps_RT						          \
   -stim_times_AM2 5 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-15_combined_explode_demean_afni.1d   		  \
               'BLOCK(0.772,1)'                                       			  \
   -stim_label 5 explode_demean					      			  \
   -stim_times_AM2 6 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-15_combined_pumps_demean_afni.1d    			  \
               'BLOCK(0.772,1)'                                      			  \
   -stim_label 6 pumps_demean					     			  \
   -stim_times_AM1 7 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/ONSETS/sub-15_combined_pumps_RT_afni.1d       			  \
               'dmBLOCK'                                       	     			  \
   -stim_label 7 pumps_RT					     			  \
   -x1D temp.xmat.1D

singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/3dTproject -ort temp.xmat.1D'[0]' -input temp.xmat.1D'[2]'\'     \
           -prefix sub-15_combined_cash_RT_temp.ort.tr.1D
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/1dtranspose  sub-15_combined_cash_RT_temp.ort.tr.1D > sub-15_combined_cash_RT_ort_afni.1D

singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/3dTproject -ort temp.xmat.1D'[5]' -input temp.xmat.1D'[3]'\'     \
           -prefix sub-15_combined_control_pumps_RT_temp.ort.tr.1D
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/1dtranspose sub-15_combined_control_pumps_RT_temp.ort.tr.1D > sub-15_combined_control_pumps_RT_ort_afni.1D

singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/3dTproject -ort temp.xmat.1D'[10]' -input temp.xmat.1D'[8]'\'     \
           -prefix sub-15_combined_pumps_RT_temp.ort.tr.1D
singularity exec --cleanenv -B /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2 /apps/singularity/afni-fsl-spm12.sif /opt/afni-latest/1dtranspose sub-15_combined_pumps_RT_temp.ort.tr.1D > sub-15_combined_pumps_RT_ort_afni.1D
