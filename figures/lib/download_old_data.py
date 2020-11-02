from urllib3.exceptions import HTTPError
import requests
from shutil import copyfile
import json
import os

def download_old_data(nv_collection, study, output_dir):
    url = 'http://neurovault.org/api/collections/' + nv_collection + '/nidm_results/?limit=184&format=json'
    response = requests.get(url)
    data = response.json()

    pwd = os.path.dirname(os.path.realpath('__file__'))
    input_dir = os.path.join(pwd, "input")
    root = os.path.dirname(pwd)
    data_dir = os.path.join(input_dir, output_dir)

    if not os.path.isdir(data_dir):
        if not os.path.isdir(input_dir):
            os.makedirs(input_dir)
        os.makedirs(data_dir)

    # --- Download all NIDM-Results packs available on NeuroVault
    for nidm_result in data["results"]:
        url = nidm_result["zip_file"]
        study_name = nidm_result["name"]

        localzip = os.path.join(data_dir,"old_" + study_name + ".zip")
        localzip_rel = localzip.replace(pwd, '.')
        if not os.path.isfile(localzip):
            # Copy .nidm.zip export locally in a the data directory
            try:
                f = requests.get(url)
                print("downloading " + url + " at " + localzip_rel)
                with open(localzip, "wb") as local_file:
                    local_file.write(f.content)
            except (HTTPError, e):
                raise Exception(["HTTP Error:" + str(e.code) + url])
        else:
            print(url + " already downloaded at " + localzip_rel)

    # --- Copy remaining images from NeuroVault
    afni_images = (
            ('mask.nii.gz', 'old_afni_mask.nii.gz'),
        )

    if study not in ('ds120'):
        afni_images = (
            afni_images +
            # There is no deactivations in ds120 with AFNI
            (('Negative_clustered_t_stat.nii.gz', 'old_afni_exc_set_neg.nii.gz'),) +
            # ds120 uses F-stats no T-stats
            (('Positive_clustered_t_stat.nii.gz', 'old_afni_exc_set_pos.nii.gz'),) +
            (('3dMEMA_result_t_stat_masked.nii.gz', 'old_afni_stat.nii.gz'),))
    else:
        # ds120 uses F-stats no T-stats
        afni_images = (
            afni_images +
            # ds120 uses F-stats no T-stats
            (('Positive_clustered_f_stat.nii.gz', 'old_afni_exc_set_pos.nii.gz'),) + 
            (('Group_f_stat_masked.nii.gz', 'old_afni_stat.nii.gz'),)
            )


    if study not in ('ds120'):
        perm_images = (
            ('perm_ttest++_Clustsim_result_t_stat_masked.nii.gz', 'old_afni_perm_z.nii.gz'), 
            ('perm_Positive_clustered_t_stat.nii.gz', 'old_afni_perm_exc_set_pos.nii.gz'),
            ('OneSampT_tstat1.nii.gz', 'old_fsl_perm.nii.gz'),
            ('05FWECorrected_OneSampT_pos_exc_set.nii.gz', 'old_fsl_perm_exc_set_pos.nii.gz'),
            ('05FWECorrected_OneSampT_neg_exc_set.nii.gz', 'old_fsl_perm_exc_set_neg.nii.gz'),
            ('snpmT%2B.nii.gz', 'old_spm_perm.nii.gz'),
            ('SnPM_pos_filtered.nii.gz', 'old_spm_perm_exc_set_pos.nii.gz')
        )
    else:
        # No permutation analyses for ds120
        perm_images = ()

    if study not in ('ds120'):
        # There is no deactivations in ds109 and ds120 with AFNI perm
        # There is no deactivations in ds109 with SnPM (SPM perm)
        # No permutation analyses for ds120
        if study not in ('ds109'):
            perm_images = (
                perm_images +
                (('perm_Negative_clustered_t_stat.nii.gz', 'old_afni_perm_exc_set_neg.nii.gz'),
                 ('SnPM_neg_filtered.nii.gz', 'old_spm_perm_exc_set_neg.nii.gz'),)
                )

    if study in ('ds120'):
        # R^2 maps created for ds120 to compare effect sizes
        #r_squared_images = (('afni_r_squared.nii.gz', 'afni_r_squared.nii.gz'),
        #                    ('spm_r_squared.nii.gz','spm_r_squared.nii.gz'))        
        
        to_download = (
            afni_images + perm_images)
    else:
        # BOLD maps
        #bold_images= (('afni_bold.nii.gz','afni_bold.nii.gz'),
        #              ('fsl_bold.nii.gz','fsl_bold.nii.gz'),
        #              ('spm_bold.nii.gz','spm_bold.nii.gz'))
        
        to_download = (
            afni_images + perm_images)

    for image, local_name in to_download:
        url = "http://neurovault.org/media/images/" + nv_collection + '/' + image
        local_file = os.path.join(data_dir, local_name)
        if not os.path.isfile(local_file):
            # Copy file locally in a the data directory
            try:
                f = requests.get(url)
                print("downloading " + url + " at " + local_file)
                with open(local_file, "wb") as local_fid:
                    local_fid.write(f.content)
            except (HTTPError, e):
                raise Exception(["HTTP Error:" + str(e.code) + url])
        else:
            print(url + " already downloaded at " + local_file)