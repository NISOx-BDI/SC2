import os
paths = dict()
# Set packages_dir to the directory where the main modules are stored on your HPC (i.e. the directory given from inputting 'module avail' into the HPC's command line)
paths["packages_dir"] = '/well/win/software/packages'
# Set home_dir to the main SC2 directory
paths["home_dir"] = '/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2'
# Set fmriprep_singluarity_image to the fMRIPrep singularlity container .simg
paths["fmriprep_singularity_image"] = '/well/nichols/users/bas627/fmriprep/fmriprep-20.0.2.simg'
# Set FS_license to your freesurfer license .txt file
paths["FS_license"] = os.path.join(paths.get("home_dir"),'license.txt')
# Set AFNI_SPM_singularity_image to the AFNI singlurity container (only needed for running AFNI analyses)
paths["AFNI_SPM_singularity_image"] = '/apps/singularity/afni-r-python3-2020-03-26-v1.sif'
# Set AFNI_BIN as the path to the AFNI directory within the singularity container
paths["AFNI_bin"] = '/opt/afni-latest'
