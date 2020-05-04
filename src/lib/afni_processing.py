import os
import stat
from subprocess import check_call
import glob
import re
import string
import shutil
from lib.fsl_processing import create_fsl_onset_files
import stat
import numpy as np
import pandas as pd


def copy_raw(raw_dir, preproc_dir, *args):
    """
    Copy to raw data (anatomical and functional) from 'raw_dir' (organised
    according to BIDS) to 'preproc_dir' and run BET on the anatomical images.
    """
    # All subject directories
    if args:
        subject_ids = args[0]
        sub_dirs = []
        for s in subject_ids:
            sub_dirs.append(os.path.join(raw_dir, 'sub-' + s))
    else:
        sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))

    if not os.path.isdir(preproc_dir):
        os.mkdir(preproc_dir)

    # For each subject
    for sub_folder in sub_dirs:
        anat_regexp = '*_T1w.nii.gz'
        fun_regexp = '*_bold.nii.gz'

        # Find the anatomical MRI
        amri = glob.glob(
            os.path.join(sub_folder, 'anat', anat_regexp))[0]

        # Find the fMRI
        fmris = glob.glob(
            os.path.join(sub_folder, 'func', fun_regexp))

        # Copy the anatomical image
        anat_preproc_dir = os.path.join(preproc_dir, 'ANATOMICAL')
        if not os.path.isdir(anat_preproc_dir):
            os.mkdir(anat_preproc_dir)
        shutil.copy(amri, anat_preproc_dir)

        # For each run, copy the fMRI image
        func_preproc_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
        if not os.path.isdir(func_preproc_dir):
            os.mkdir(func_preproc_dir)

        for fmri in fmris:
            shutil.copy(fmri, func_preproc_dir)


def create_afni_onset_files(study_dir, onset_dir, conditions, removed_TR_time, *args):
    """
    Create AFNI onset files based on BIDS tsv files. Input data in
    'study_dir' is organised according to BIDS, the 'conditions' variable
    specifies the conditions of interest with respect to the regressors defined
    in BIDS. After completion, the onset files are saved in 'onset_dir'.
    """

    # Create FSL onset files from BIDS
    if args:
        subject_ids = args[0]
        create_fsl_onset_files(study_dir, onset_dir, conditions, removed_TR_time, subject_ids)
    else:
        create_fsl_onset_files(study_dir, onset_dir, conditions, removed_TR_time)

    # Convert FSL onset files to AFNI onset files
    cmd = '3coltoAFNI.sh ' + onset_dir
    print(cmd)
    check_call(cmd, shell=True)

    # Delete FSL onset files
    filelist = glob.glob(os.path.join(onset_dir, "*.txt"))
    for f in filelist:
        os.remove(f)

    if args:
        subject_ids = args[0]
        sub_dirs = []
        for s in subject_ids:
            sub_dirs.append(os.path.join(study_dir, 'sub-' + s))
    else:
        sub_dirs = glob.glob(os.path.join(study_dir, 'sub-*'))

    subs = [os.path.basename(w) for w in sub_dirs]

    # Get the condition names
    condition_names = list()
    for cond_names, cond_info in conditions:
        if isinstance(cond_names, tuple):
            for cond_name in cond_names:
                condition_names.append(cond_name)
        else:
            condition_names.append(cond_names)

    # Combine all runs into one .1d combined onset for each condition/subject
    for sub in subs:
        for cond in condition_names:
            # All onset files for this subject and condition
            onset_files = sorted(glob.glob(
                os.path.join(onset_dir, sub + '_run-[0-9][0-9]_' + cond + '*.1d')))
            combined_onset_file = os.path.join(
                onset_dir, sub + '_combined_' + cond + '_afni.1d')
            if not onset_files:
                raise Exception('No onset files for ' + sub + ' ' + cond)

            with open(combined_onset_file, 'w') as outfile:
                for fname in onset_files:
                    with open(fname) as infile:
                        # Replace n/a with 0 as AFNI cannot handle them
                        onsets = infile.read().replace("465.166:n/a", "")
                        outfile.write(onsets)
                    os.remove(fname)


def run_subject_level_analyses(fmriprep_dir, onsets_dir, level1_dir,
    sub_level_template, home_dir, AFNI_SPM_singularity_image, AFNI_bin):

    scripts_dir = os.path.join(onsets_dir, os.pardir, 'SCRIPTS')
    motion_regressors_dir = os.path.join(onsets_dir, os.pardir, 'MOTION_REGRESSORS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    if not os.path.isdir(level1_dir):
        os.mkdir(level1_dir)

    # Obtaining all subjects to shuffle through
    html_files = glob.glob(os.path.join(fmriprep_dir, 'sub-*.html'))

    # For each subject
    for html in html_files:
        # New dict for each subject
        values = dict()
        # Getting subject ID
        subreg = re.search('sub-\d+', html)
        sub = subreg.group(0)
        values["sub"] = sub
        shortsub = sub.replace("-", "")
        values["subj"] = shortsub
        # Specifying subject's fmriprep anat and func dirs
        anat_dir = os.path.join(fmriprep_dir,sub,'anat')
        values["anat_dir"] = anat_dir
        func_dir = os.path.join(fmriprep_dir,sub,'func')
        values["func_dir"] = func_dir
        # Specifying values for the other place holders
        values["stim_dir"] = onsets_dir
        values["home_dir"] = home_dir
        values["motion_regressors_dir"] = motion_regressors_dir
        values["AFNI_SPM_singularity_image"] = AFNI_SPM_singularity_image
        values["AFNI_bin"] = AFNI_bin

        if not os.path.isfile(os.path.join(scripts_dir, sub + '_level1.sh')):
            # Fill-in the subject-level template
            with open(sub_level_template) as f:
                tpm = f.read()
                t = string.Template(tpm)
                sub_script = t.substitute(values)

            sub_script_file = os.path.join(scripts_dir, sub + '_level1.sh')

            with open(sub_script_file, "w") as f:
                f.write(sub_script)

            # Make the script executable
            st = os.stat(sub_script_file)
            os.chmod(sub_script_file, st.st_mode | stat.S_IEXEC)

            # Run subject-level analysis
            sub_results_dir = os.path.join(level1_dir, sub)
            if not os.path.isdir(sub_results_dir):
                os.mkdir(sub_results_dir)

            os.chdir(sub_results_dir)

            cmd = os.path.join('.', sub_script_file)
            print(cmd)
            check_call(cmd, shell=True)

            # Putting the proc. script in the correct directory, making it executable, and running
            sub_proc_script_file = os.path.join(sub_results_dir, 'proc.' + shortsub)
            cmd = os.path.join('singularity exec --cleanenv -B ' + home_dir + ' ' + AFNI_SPM_singularity_image + ' tcsh -xef ' + sub_proc_script_file)
            print(cmd)
            check_call(cmd, shell=True)

def run_group_level_analysis(level1_dir, level2_dir, grp_level_template, home_dir, AFNI_SPM_singularity_image, AFNI_bin, fmriprep_dir):

    scripts_dir = os.path.join(level1_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    if not os.path.isdir(level2_dir):
        os.makedirs(level2_dir, exist_ok=True)


    # Fill-in the group-level template
    values = dict()
    values["level2_dir"] = level2_dir
    values["level1_dir"] = level1_dir
    values["AFNI_bin"] = AFNI_bin
    values["fmriprep_dir"] = fmriprep_dir

    with open(grp_level_template) as f:
        tpm = f.read()
        t = string.Template(tpm)
        group_script = t.substitute(values)

    group_script_file = os.path.join(scripts_dir, 'level2.sh')

    with open(group_script_file, "w") as f:
            f.write(group_script)

    # Make the script executable and run
    st = os.stat(group_script_file)
    os.chmod(group_script_file, st.st_mode | stat.S_IEXEC)

    cmd = os.path.join('singularity exec --cleanenv -B ' + home_dir + ' ' + AFNI_SPM_singularity_image + ' ' + group_script_file)
    print(cmd)
    check_call(cmd, shell=True)

def run_permutation_test(level1_dir, perm_dir, perm_template, home_dir, AFNI_SPM_singularity_image, AFNI_bin, fmriprep_dir):

    scripts_dir = os.path.join(level1_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    if not os.path.isdir(perm_dir):
        os.mkdir(perm_dir)

    # Fill-in the permutation template
    values = dict()
    values["perm_dir"] = perm_dir
    values["level1_dir"] = level1_dir
    values["AFNI_bin"] = AFNI_bin
    values["fmriprep_dir"] = fmriprep_dir

    with open(perm_template) as f:
        tpm = f.read()
        t = string.Template(tpm)
        group_script = t.substitute(values)

    group_script_file = os.path.join(scripts_dir, 'permutation_test.sh')

    with open(group_script_file, "w") as f:
            f.write(group_script)

    # Make the script executable and run
    st = os.stat(group_script_file)
    os.chmod(group_script_file, st.st_mode | stat.S_IEXEC)

    cmd = os.path.join('singularity exec --cleanenv -B ' + home_dir + ' ' + AFNI_SPM_singularity_image + ' ' + group_script_file)
    print(cmd)
    check_call(cmd, shell=True)

def mean_mni_images(preproc_dir, level1_dir, mni_dir):
    
    if not os.path.isdir(mni_dir):
        os.mkdir(mni_dir)

    anat_images = []

    # Creating the mean func in MNI space for each subject across runs
    sub_dirs = glob.glob(os.path.join(level1_dir, 'sub-*'))

    # For each subject
    for sub_dir in sub_dirs:
        subreg_dash = re.search('sub-\d+', sub_dir)
        sub_dash = subreg_dash.group(0)

        results_dir = glob.glob(os.path.join(sub_dir, 'sub??.results'))[0]
        subreg = re.search('sub\d+', results_dir)
        sub = subreg.group(0)

        # MNI anat images 
        # Converting mni anatomical from BRIK to NIFTI
        anat_BRIK = os.path.join(results_dir, 'anat_final.' + sub + '+tlrc.BRIK')
        cmd = '3dAFNItoNIFTI -prefix ' + mni_dir + '/' + sub_dash + '_mni_anat.nii.gz ' + anat_BRIK
        check_call(cmd, shell=True)

        anat = os.path.join(mni_dir, sub_dash + '_mni_anat.nii.gz')
        anat_images.append(anat)

        run_mean_func_BRIKS = glob.glob(os.path.join(results_dir, 'pb02.' + sub + '.r??.volreg+tlrc.BRIK'))

        # Array of mean func images across runs
        run_mean_funcs = []
        for func_BRIK in run_mean_func_BRIKS:
            runreg = re.search('r\d+', func_BRIK)
            run = runreg.group(0)
            cmd = '3dAFNItoNIFTI -prefix ' + mni_dir + '/' + sub_dash + '_' + run + '_mean_func.nii.gz ' + func_BRIK
            check_call(cmd, shell=True)
            run_mean_func = os.path.join(mni_dir, sub_dash + '_' + run + '_mean_func.nii.gz')
            run_mean_funcs.append(run_mean_func)

        # Concatenate the mean func images
        run_mean_funcs = image.concat_imgs(run_mean_funcs)

        # Create the mean func image across runs
        mean_func = image.mean_img(run_mean_funcs)

        # Save the image
        mean_func.to_filename(os.path.join(mni_dir, sub_dash + '_mni_mean_func.nii.gz'))

    # MNI mean func images
    mean_func_images = glob.glob(os.path.join(mni_dir, 'sub-*_mni_mean_func.nii.gz'))

    # Standardising
    standardised_mean_func_images = []
    standardised_anat_images = []

    # Standardising mean func images
    for mean_func in mean_func_images:
        img = image.load_img(mean_func)
        data_array = img.get_data()
        # Copying the spm_global function in SPM
        global_mean = np.mean(data_array)
        masked_array = data_array[data_array > global_mean/8]
        g = np.mean(masked_array)
        data_array = data_array*(100/g)
        standardised_mean_func = image.new_img_like(mean_func, data_array)
        standardised_mean_func_images.append(standardised_mean_func)

    # Standardising anat images
    for anat in anat_images:
        img = image.load_img(anat)
        data_array = img.get_data()
        # Copying the spm_global function in SPM
        global_mean = np.mean(data_array)
        masked_array = data_array[data_array > global_mean/8]
        g = np.mean(masked_array)
        data_array = data_array*(100/g)
        standardised_anat = image.new_img_like(anat, data_array)
        standardised_anat_images.append(standardised_anat)

    # MNI mean and std dev mean func and anat images
    # Mean mean func images 
    mean_mni_mean_func = image.mean_img(standardised_mean_func_images)
    mean_mni_mean_func.to_filename(os.path.join(mni_dir, 'afni_mean_mni_mean_func.nii.gz'))

    # Mean anat images 
    mean_mni_anat = image.mean_img(standardised_anat_images)
    mean_mni_anat.to_filename(os.path.join(mni_dir, 'afni_mean_mni_anat.nii.gz'))

    # Std dev mni mean func image
    img = image.load_img(mean_mni_mean_func)
    data_array = img.get_data()
    tmp = image.new_img_like(mean_func, data_array*0)
    tmp_data = tmp.get_data()
    for mean_func in standardised_mean_func_images:
        img = image.load_img(mean_func)
        data_array = img.get_data()
        tmp_data = tmp_data + np.square(data_array)

    tmp_data = tmp_data/len(standardised_mean_func_images)
    tmp = image.new_img_like(tmp, tmp_data)

    std_mni_mean_func = image.math_img("np.sqrt(img1 - np.square(img2))", img1=tmp, img2=mean_mni_mean_func)
    std_mni_mean_func.to_filename(os.path.join(mni_dir, 'afni_std_mni_mean_func.nii.gz'))

    # Std dev mni anat image
    img = image.load_img(anat)
    data_array = img.get_data()
    tmp = image.new_img_like(anat, data_array*0)
    tmp_data = tmp.get_data()
    for anat in standardised_anat_images:
        img = image.load_img(anat)
        data_array = img.get_data()
        tmp_data = tmp_data + np.square(data_array)

    tmp_data = tmp_data/len(standardised_mean_func_images)
    tmp = image.new_img_like(tmp, tmp_data)

    std_mni_anat = image.math_img("np.sqrt(img1 - np.square(img2))", img1=tmp, img2=mean_mni_anat)
    std_mni_anat.to_filename(os.path.join(mni_dir, 'afni_std_mni_anat.nii.gz'))

def run_SSWarper(preproc_dir, SSWarper_template):

    scripts_dir = os.path.join(preproc_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    # Pre-processing directory storing the aMRIs for all subjects
    anat_dir = os.path.join(preproc_dir, 'ANATOMICAL')

    # All aMRI files (for all subjects)
    amri_files = glob.glob(os.path.join(anat_dir, 'sub-*_T1w.nii.gz'))

    # For each subject
    for amri in amri_files:
        # New dict for each subject
        values = dict()
        subreg = re.search('sub-\d+', amri)
        sub = subreg.group(0)
        values["sub"] = sub

    if not os.path.isfile(os.path.join(scripts_dir, sub + '_SSWarper.sh')):
        # Fill-in template
        with open(SSWarper_template) as f:
            tpm = f.read()
            t = string.Template(tpm)
            sub_script = t.substitute(values)

        sub_script_file = os.path.join(scripts_dir, sub + '_SSWarper.sh')

        with open(sub_script_file, "w") as f:
            f.write(sub_script)

        # Make the script executable
        st = os.stat(sub_script_file)
        os.chmod(sub_script_file, st.st_mode | stat.S_IEXEC)

        # Run SSWarper on subject
        os.chdir(anat_dir)

        cmd = os.path.join('.', sub_script_file)
        print(cmd)
        check_call(cmd, shell=True)

def run_orthogonalize(fmriprep_dir, onsets_dir, orthogonalize_template, home_dir, AFNI_SPM_singularity_image, AFNI_bin):

    scripts_dir = os.path.join(onsets_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    # Obtaining all subjects to shuffle through
    html_files = glob.glob(os.path.join(fmriprep_dir, 'sub-*.html'))

    # For each subject
    for html in html_files:
        # New dict for each subject
        values = dict()
        values["stim_dir"] = onsets_dir

        subreg = re.search('sub-\d+', html)
        sub = subreg.group(0)
        values["sub"] = sub
        values["home_dir"] = home_dir
        values["AFNI_SPM_singularity_image"] = AFNI_SPM_singularity_image
        values["AFNI_bin"] = AFNI_bin


        if not os.path.isfile(os.path.join(scripts_dir, sub + '_orthorgonalize.sh')):
            # Fill-in the subject-level template
            with open(orthogonalize_template) as f:
                tpm = f.read()
                t = string.Template(tpm)
                sub_script = t.substitute(values)
        
            sub_script_file = os.path.join(scripts_dir, sub + '_orthogonalize.sh')

            with open(sub_script_file, "w") as f:
                f.write(sub_script)

            # Make the script executable
            st = os.stat(sub_script_file)
            os.chmod(sub_script_file, st.st_mode | stat.S_IEXEC)

            # Run subject-level analysis
            if not os.path.isdir(onsets_dir):
                os.mkdir(onsets_dir)

            os.chdir(onsets_dir)

            cmd = os.path.join('.', sub_script_file)
            print(cmd)
            check_call(cmd, shell=True)

def create_confound_files(fmriprep_dir, confounds_dir, *args):
    """
    Extracts the motion regressors from the confounds.tsv files outputted by fmriprep, outputting a text files for each motion regressor (combined across runs)
    """
    if not os.path.isdir(confounds_dir):
        os.mkdir(confounds_dir)

    # If removed TRs = c, we drop the first c rows of the regressors files
    if args:
        removed_TRs = args[0]
    else:
        removed_TRs = 0

    # All fmriprep subject-level directories
    fmriprep_dirs = glob.glob(os.path.join(fmriprep_dir, 'sub-??'))

    # For each subject
    for fmriprep_dir in fmriprep_dirs:
        subreg = re.search('sub-\d+', fmriprep_dir)
        sub = subreg.group(0)
        
        # All regressor files for this subject
        regressor_files = glob.glob(os.path.join(fmriprep_dir, 'func', '*-confounds_regressors.tsv'))

        combined_regressor_data = pd.DataFrame(columns=['trans_x','trans_y','trans_z','rot_x','rot_y','rot_z'])
        # For each run we combine the .tsv files into one dataframe
        for regressor_file in regressor_files:
            runreg = re.search('run-\d+', regressor_file)
            run = runreg.group(0)

            regressor_data = pd.read_csv(regressor_file, delimiter='\t')
            df = pd.DataFrame(regressor_data)
            df_motion = df[["trans_x","trans_y","trans_z","rot_x","rot_y","rot_z"]]
            df_motion = df_motion.iloc[removed_TRs:]
            combined_regressor_data = combined_regressor_data.append(df_motion)

        trans_x_data = combined_regressor_data[["trans_x"]]
        trans_x_data.to_csv(os.path.join(confounds_dir, sub + '_' + 'combined_trans_x.1d'), index=None, sep='\t', header=False)
        trans_y_data = combined_regressor_data[["trans_y"]]
        trans_y_data.to_csv(os.path.join(confounds_dir, sub + '_' + 'combined_trans_y.1d'), index=None, sep='\t', header=False)
        trans_z_data = combined_regressor_data[["trans_z"]]
        trans_z_data.to_csv(os.path.join(confounds_dir, sub + '_' + 'combined_trans_z.1d'), index=None, sep='\t', header=False)
        rot_x_data = combined_regressor_data[["rot_x"]]
        rot_x_data.to_csv(os.path.join(confounds_dir, sub + '_' + 'combined_rot_x.1d'), index=None, sep='\t', header=False)
        rot_y_data = combined_regressor_data[["rot_y"]]
        rot_y_data.to_csv(os.path.join(confounds_dir, sub + '_' + 'combined_rot_y.1d'), index=None, sep='\t', header=False)
        rot_z_data = combined_regressor_data[["rot_z"]]
        rot_z_data.to_csv(os.path.join(confounds_dir, sub + '_' + 'combined_rot_z.1d'), index=None, sep='\t', header=False)

def extract_design_columns(level1_dir, design_dir):
    """
    For each sucject, exports each column of the run-level design matrix to a text-file so that the design can be inputted into FSL FEAT
    """
    if not os.path.isdir(design_dir):
        os.mkdir(design_dir)

    sub_dirs = glob.glob(os.path.join(level1_dir, 'sub-*'))

    # Getting the number of condition regressors from the onset dir
    onsets_dir = os.path.join(level1_dir, os.pardir, 'ONSETS')
    sub_regressors = glob.glob(os.path.join(onsets_dir,'sub-01*.1d'))
    nregressors = len(sub_regressors)

    for sub_dir in sub_dirs:
        # Copying each subjects X.xmat.1D file to the design_dir and removing all the comment lines so the file only contains the X-matrix
        subreg_dash = re.search('sub-\d+', sub_dir)
        sub_dash = subreg_dash.group(0)

        results_dir = glob.glob(os.path.join(sub_dir, 'sub??.results'))[0]
        subreg = re.search('sub\d+', results_dir)
        sub = subreg.group(0)

        design_file = os.path.join(results_dir, 'X.xmat.1D')
        output_filename = os.path.join(design_dir, sub_dash + '_design_matrix.txt')

        cmd = os.path.join('grep -v \'^#\' ' + design_file + ' > ' + output_filename)
        print(cmd)
        check_call(cmd, shell=True)

        # Load the design matrix up as dataframe (note, the first column (i.e. column [0]) are NaNs)
        design_matrix_data = pd.read_csv(output_filename, sep=" ", header=None)
        df = pd.DataFrame(design_matrix_data)

        ntimepoints = df[1].sum()
        nruns = len(df)/ntimepoints
        nruns = int(nruns)
        ndrift_basis = (len(df.columns) - 7 - nregressors)/3
        ndrift_basis = int(ndrift_basis)

        # For each run, extract all the run-level regressors in the design matrix to a text file
        for r in range(1,nruns):
            for q in range(1,nregressors):
                regressor_run_data = df.iloc[ntimepoints*(r-1):ntimepoints*r, q + ndrift_basis*nruns]
                out_name = os.path.join(design_dir, sub_dash + '_run-' + format(r,'02') + '_regressor_' + format(q,'02') + '.txt')
                regressor_run_data.to_csv(out_name, index=None, header=False)

    # Finally, get the drift basis 
    for t in range(1,ndrift_basis):
        drift_basis_data = df.iloc[0:ntimepoints, t]
        out_name = os.path.join(design_dir, ['afni_drift_basis_' + format(t,'02') + '.txt'])
        drift_basis_data.to_csv(out_name, index=None, header=False)







