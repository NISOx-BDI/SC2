from scipy import stats
import nibabel as nib
import numpy as np
import nilearn.input_data
import os
from nibabel.processing import resample_from_to
from statsmodels.stats.multitest import multipletests
import matplotlib.pyplot as plt
import nibabel
from nilearn.image import math_img

def t_corr(y, res_mean=None, res_var=None, Q=None):
    """
    perform a one-sample t-test on correlated data
    y = data (n observations X n vars)
    res_mean = Common mean over voxels and results
    res_var  = Common variance over voxels and results
    Q = "known" correlation across observations
    - (use empirical correlation based on maps)
    """

    npts = y.shape[0]
    X = np.ones((npts, 1))

    if res_mean is None:
        res_mean = 0

    if res_var is None:
        res_var = 1

    if Q is None:
        Q = np.eye(npts)

    VarMean = res_var * X.T.dot(Q).dot(X) / npts**2

    # T  =  mean(y,0)/s-hat-2
    # use diag to get s_hat2 for each variable
    T = (np.mean(y, 0)-res_mean
         )/np.sqrt(VarMean)*np.sqrt(res_var) + res_mean

    # Assuming variance is estimated on whole image
    # and assuming infinite df
    p = 1 - stats.norm.cdf(T)

    return(T, p)

def t_to_z(t_stat_file, z_stat_file, N):
    # Convert t-statistic images to z-statistic images used for the consensus analysis
    df = N-1

    t_stat_img = nib.load(t_stat_file)

    t_stat = t_stat_img.get_data()
    z_stat = np.zeros_like(t_stat)

    # Handle large and small values differently to avoid underflow
    z_stat[t_stat < 0] = -stats.norm.ppf(stats.t.cdf(-t_stat[t_stat < 0], df))
    z_stat[t_stat > 0] = stats.norm.ppf(stats.t.cdf(t_stat[t_stat > 0], df))

    z_stat_img = nib.Nifti1Image(z_stat, t_stat_img.affine)
    z_stat_img.to_filename(z_stat_file)
    return(z_stat_file)

def resample(z_stat_file, MNI152_mask):
    MNI152_img = nib.load(MNI152_mask)
    z_stat_img = nib.load(z_stat_file)
    
    z_stat_resl_img = resample_from_to(z_stat_img, MNI152_img, order=0)
    
    z_stat_resl_img_reshape = np.reshape(z_stat_resl_img.get_data(), -1)
    MNI152_img_reshape = np.reshape(MNI152_img.get_data(), -1)

    in_mask_indices = np.logical_not(np.logical_or(np.isnan(MNI152_img_reshape), np.absolute(MNI152_img_reshape) == 0))
    
    z_stat_resl_img_reshape[~in_mask_indices] = 0 
    z_stat_data = np.reshape(z_stat_resl_img_reshape, z_stat_resl_img.shape)
    
    z_stat_img = nib.Nifti1Image(z_stat_data, MNI152_img.affine)
    z_stat_img.to_filename(z_stat_file.replace('.nii.gz', '_consensus.nii.gz'))
    z_stat_file = z_stat_file.replace('.nii.gz', '_consensus.nii.gz')
    return(z_stat_file)

def consensus_analysis(t_stat_maps, N, study,  max_activation, x_coords, y_coords, z_coords):
    # Performs the IBMA consensus analysis to a collection of group-level t-statistic maps
    z_stat_maps = []
    for i in range(0, len(t_stat_maps)):
        # The first image in t_stat_maps is the old AFNI *Z* stat, so we don't need to convert
        if study == 'ds001':
            if i == 0:
                z_stat_maps.append(t_stat_maps[i])
            # For ds001, the 'old' t-statistic images had a larger N = 16
            if 0 < i <= 5:
                z_map = t_to_z(t_stat_maps[i], t_stat_maps[i].replace('.nii.gz', '_z.nii.gz'), N+1)
                z_stat_maps.append(z_map)
            elif i > 5:
                z_map = t_to_z(t_stat_maps[i], t_stat_maps[i].replace('.nii.gz', '_z.nii.gz'), N)
                z_stat_maps.append(z_map)
                
        elif study == 'ds109':
            if i == 0:
                z_stat_maps.append(t_stat_maps[i])
            else:
                z_map = t_to_z(t_stat_maps[i], t_stat_maps[i].replace('.nii.gz', '_z.nii.gz'), N)
                z_stat_maps.append(z_map)
            
             
    # Get the MNI152 image
    fsldir = os.environ['FSLDIR']
    MNI_152 = os.path.join(fsldir, 'data', 'standard', 'MNI152_T1_2mm_brain_mask.nii.gz')
    
    # Resample all z_stat_maps to MNI152 mask
    for i in range(0, len(z_stat_maps)):
        z_stat_maps[i] = resample(z_stat_maps[i], MNI_152)
    
    masker = nilearn.input_data.NiftiMasker(mask_img=MNI_152)
    
    z_stat_maps.sort()
        
    # Resample all z_stat_maps to the MNI152 Mask
        
    data = masker.fit_transform(z_stat_maps)
                
    # Get estimated mean, variance, and correlation for t_corr
    img_mean = np.mean(data)
    img_var = np.mean(np.var(data, 1))
    cc = np.corrcoef(data)
    
    # perform t-test
    tvals, pvals = t_corr(data,
                          res_mean=img_mean,
                          res_var=img_var,
                          Q=cc)
    
    timg = masker.inverse_transform(tvals)
    timg_file = timg.to_filename('./img/' + study + '_consensus_t.nii.gz')
    pimg = masker.inverse_transform(1-pvals)
    pimg_file = pimg.to_filename('./img/' + study + '_consensus_1-p.nii.gz')
    fdr_results = multipletests(pvals[0, :], 0.05, 'fdr_tsbh')
    fdrimg = masker.inverse_transform(1 - fdr_results[1])
    fdrimg.to_filename('./img/' + study + '_consensus_1-fdr.nii.gz')
    
    # Repeating for negative activations
    data_neg = data*-1 
                
    # Get estimated mean, variance, and correlation for t_corr
    img_mean_neg = np.mean(data_neg)
    img_var_neg = np.mean(np.var(data_neg, 1))
    cc_neg = np.corrcoef(data_neg)
    
    # perform t-test
    tvals_neg, pvals_neg = t_corr(data_neg,
                          res_mean=img_mean_neg,
                          res_var=img_var_neg,
                          Q=cc_neg)
    
    timg_neg = masker.inverse_transform(tvals_neg)
    timg_file_neg = timg_neg.to_filename('./img/' + study + '_consensus_t_neg.nii.gz')
    pimg_neg = masker.inverse_transform(1-pvals_neg)
    pimg_file_neg = pimg_neg.to_filename('./img/' + study + '_consensus_1-p_neg.nii.gz')
    fdr_results_neg = multipletests(pvals_neg[0, :], 0.05, 'fdr_tsbh')
    fdrimg_neg = masker.inverse_transform(1 - fdr_results_neg[1])
    fdrimg_neg.to_filename('./img/' + study + '_consensus_1-fdr_neg.nii.gz')
    
    
    # Make plots
    pmap = os.path.join('img', study + '_consensus_1-fdr.nii.gz')
    tmap = os.path.join('img', study + '_consensus_t.nii.gz')
    pimg = nibabel.load(pmap)
    timg = nibabel.load(tmap)
    pdata = pimg.get_fdata()
    tdata = timg.get_fdata()[:, :, :, 0]
    threshdata = (pdata > 0.95)*tdata
    threshimg = nibabel.Nifti1Image(np.nan_to_num(threshdata), affine=timg.affine)
    thresimg_file = threshimg.to_filename('./img/' + study + '_consensus_t_thresholded.nii.gz')
    
    pmap_neg = os.path.join('img', study + '_consensus_1-fdr_neg.nii.gz')
    tmap_neg = os.path.join('img', study + '_consensus_t_neg.nii.gz')
    pimg_neg = nibabel.load(pmap_neg)
    timg_neg = nibabel.load(tmap_neg)
    pdata_neg = pimg_neg.get_fdata()
    tdata_neg = timg_neg.get_fdata()[:, :, :, 0]
    threshdata_neg = (pdata_neg > 0.95)*tdata_neg
    threshimg_neg = nibabel.Nifti1Image(np.nan_to_num(threshdata_neg), affine=timg_neg.affine)
    threshimg_neg_file = threshimg_neg.to_filename('./img/' + study + '_consensus_t_neg_thresholded.nii.gz')

    
    # Combine activations and deactivations in a single image 
    to_display = math_img("img1-img2", img1=threshimg, img2=threshimg_neg)
    
    nilearn.plotting.plot_stat_map(
        to_display,
        threshold=0.1,
        display_mode="x",
        colorbar=True,
        title='Consensus:',
        vmax=max_activation,
        cut_coords=x_coords) 
    nilearn.plotting.plot_stat_map(
        to_display,
        threshold=0.1,
        display_mode="z",
        colorbar=False,
        vmax=max_activation,
        cut_coords=y_coords)    
    nilearn.plotting.plot_stat_map(
        to_display,
        threshold=0.1,
        display_mode="z",
        colorbar=False,
        title='Consensus:',
        vmax=max_activation,
        cut_coords=z_coords)    