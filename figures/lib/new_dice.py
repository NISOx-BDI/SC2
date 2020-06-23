import nibabel as nib
from nibabel.processing import resample_from_to
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from matplotlib import cm as cm
import scipy
import os
import warnings

def sorrenson_dice(data1_file, data2_file, reslice=True):
    if (data1_file is None) and (data2_file is not None):
        dices=(0,0,100)
    elif (data1_file is not None) and (data2_file is None):
        dices=(0,100,0)
    elif (data1_file is None) and (data2_file is None):
        dices=(0,0,0)
    else:
        # Load nifti images
        data1_img = nib.load(data1_file)
        data2_img = nib.load(data2_file)

        # Load data from images
        data2 = data2_img.get_data()
        data1 = data1_img.get_data()

        # Get absolute values (positive and negative blobs are of interest)
        data2 = np.absolute(data2)
        data1 = np.absolute(data1)

        if reslice:
            # Resample data1 on data2 using nearest nneighbours
            data1_resl_img = resample_from_to(data1_img, data2_img, order=0)
            # Load data from images
            data1_res = data1_resl_img.get_data()
            data1_res = np.absolute(data1_res)

            # Resample data2 on data1 using nearest nneighbours
            data2_resl_img = resample_from_to(data2_img, data1_img, order=0)        
            data2_res = data2_resl_img.get_data()
            data2_res = np.absolute(data2_res)

        # Masking (compute Dice using intersection of both masks)
            background_1 = np.logical_or(np.isnan(data1), np.isnan(data2_res))
            background_2 = np.logical_or(np.isnan(data1_res), np.isnan(data2))

            data1 = np.nan_to_num(data1)
            data1_res = np.nan_to_num(data1_res)
            data2 = np.nan_to_num(data2)
            data2_res = np.nan_to_num(data2_res)

            num_activated_1 = np.sum(data1 > 0)
            num_activated_res_1 = np.sum(data1_res>0)
            num_activated_2 = np.sum(data2>0)
            num_activated_res_2 = np.sum(data2_res>0)

            dark_dice_1 = np.zeros(2)
            if num_activated_1 != 0:
                dark_dice_1[0] = np.sum(data1[background_1]>0).astype(float)/num_activated_1*100
            if num_activated_res_1 != 0:
                dark_dice_1[1] = np.sum(data1_res[background_2]>0).astype(float)/num_activated_res_1*100

            dark_dice_2 = np.zeros(2)
            if num_activated_2 != 0:
                dark_dice_2[0] = np.sum(data2[background_2]>0).astype(float)/num_activated_2*100
            if num_activated_res_2 != 0:
                dark_dice_2[1] = np.sum(data2_res[background_1]>0).astype(float)/num_activated_res_2*100

            data1[background_1] = 0
            data2_res[background_1] = 0

            data1_res[background_2] = 0
            data2[background_2] = 0
        else:
            background = np.logical_or(np.isnan(data1), np.isnan(data2))

            data1 = np.nan_to_num(data1)
            data2 = np.nan_to_num(data2)

            num_activated_1 = np.sum(data1 > 0)
            num_activated_2 = np.sum(data2>0)

            dark_dice = np.zeros(2)
            if num_activated_1 !=0:
                dark_dice[0] = np.sum(data1[background]>0).astype(float)/num_activated_1*100

            if num_activated_2 !=0:
                dark_dice[1] = np.sum(data2[background]>0).astype(float)/num_activated_2*100

            data1[background] = 0
            data2[background] = 0

        # Vectorize
        data1 = np.reshape(data1, -1)
        data2 = np.reshape(data2, -1)
        if reslice:
            data1_res = np.reshape(data1_res, -1)
            data2_res = np.reshape(data2_res, -1)
            
            dice_res_1 = 1-scipy.spatial.distance.dice(data1_res>0, data2>0)
            dice_res_2 = 1-scipy.spatial.distance.dice(data1>0, data2_res>0)

            if not np.isclose(dice_res_1, dice_res_2, atol=0.01):
                warnings.warn("Resliced 1/2 and 2/1 dices are not close")

            if not np.isclose(dark_dice_1[0], dark_dice_1[1], atol=0.01):
                warnings.warn("Resliced 1/2 and 2/1 dark dices 1 are not close")

            if not np.isclose(dark_dice_2[0], dark_dice_2[1], atol=0.01):
                warnings.warn("Resliced 1/2 and 2/1 dark dices 2 are not close")

            dices = (dice_res_1, dark_dice_1[1], dark_dice_2[1])
        else:
            dices = (1-scipy.spatial.distance.dice(data1>0, data2>0), dark_dice[0], dark_dice[1])
    
    return dices


def dice_matrix(df, Positive=True, Title=''):
    mask = np.tri(df.shape[0], k=0)
    mask = 1-mask
    dfmsk = np.ma.array(df[:,:,0], mask=mask)
    fig = plt.figure(figsize=(8,8))
    ax1 = fig.add_subplot(111)
    if Positive==True:
        cmap = cm.get_cmap('Reds')
    else:
        cmap = cm.get_cmap('Blues')
    cmap.set_bad('w')

    cax = ax1.imshow(dfmsk, interpolation="nearest", cmap=cmap, vmin=0, vmax=1)

    for (i, j, k), z in np.ndenumerate(df):
        if (j < i):
            if (k == 0):
                ax1.text(j, i, '{:0.3f}'.format(z), ha='center', va='center',
                         bbox=dict(boxstyle='round', facecolor='white', 
                         edgecolor='0.3'))
            else:
                if (k == 1):
                    offset = -.25
                else:
                    offset = +.25
                if round(z) > 0:
                    ax1.text(j+offset, i+.3, '{:0.0f}%'.format(z), ha='center',
                             va='center',
                             bbox=dict(boxstyle='round', facecolor='silver',
                             edgecolor='0.3'))


    plt.title(Title, fontsize=15)

    labels=['','1','2','3','4','5','6','7']
    
    
    ax1.set_xticklabels(labels,fontsize=12)
    ax1.set_yticklabels(labels,fontsize=12)
    # Add colorbar, make sure to specify tick locations to match desired ticklabels
    fig.colorbar(cax, ticks=[0,1/6,2/6,3/6,4/6,5/6,1], fraction=0.046, pad=0.04)
    ax1.spines['right'].set_visible(False)
    ax1.spines['top'].set_visible(False)
    ax1.yaxis.set_ticks_position('none')
    ax1.xaxis.set_ticks_position('none')
        
    plt.show()

def mask_using_nan(data_file, mask_file, filename=None):
    # Set masking using NaN's
    data_img = nib.load(data_file)
    data_orig = data_img.get_data()

    mask_img = nib.load(mask_file)
    mask_data = mask_img.get_data()

    if np.any(np.isnan(mask_data)):
        # mask already using NaN
        mask_data_nan = mask_data
    else:
        # Replace zeros by NaNs
        mask_data_nan = mask_data.astype(float)
        mask_data_nan[mask_data_nan == 0] = np.nan

    # If there are NaNs in data_file remove them (to mask using mask_file only)
    data_orig = np.nan_to_num(data_orig)

    # Replace background by NaNs
    data_nan = data_orig.astype(float)
    data_nan[np.isnan(mask_data_nan)] = np.nan

    # Save as image
    data_img_nan = nib.Nifti1Image(data_nan, data_img.get_affine())
    if filename is None:
        filename = data_file.replace('.nii', '_nan.nii')

    nib.save(data_img_nan, filename)

    return(filename)

        
def new_dice(exc_1=None, exc_2=None, exc_3 = None, exc_4=None, exc_5=None, exc_6=None, exc_7=None,
             stat_1=None, stat_2 = None, stat_3=None, stat_4=None, stat_5=None, stat_6=None, stat_7=None,
             Positive=True, Title=''):
    
    if exc_1 is not None:
        exc_1 = mask_using_nan(exc_1, stat_1)
    if exc_2 is not None:
        exc_2 = mask_using_nan(exc_2, stat_2)
    if exc_3 is not None:
        exc_3 = mask_using_nan(exc_3, stat_3)
    if exc_4 is not None:
        exc_4 = mask_using_nan(exc_4, stat_4)
    if exc_5 is not None:
        exc_5 = mask_using_nan(exc_5, stat_5)
    if exc_6 is not None:
        exc_6 = mask_using_nan(exc_6, stat_6)
    if exc_7 is not None:
        exc_7 = mask_using_nan(exc_7, stat_7)

    # *** Obtain Dice coefficient for each combination of images
    dice_11 = 1
    if (exc_1 is not None) or (exc_2 is not None):
        dice_12 = sorrenson_dice(exc_1, exc_2)
    if (exc_1 is not None) or (exc_3 is not None):
        dice_13 = sorrenson_dice(exc_1, exc_3)
    if (exc_1 is not None) or (exc_4 is not None):
        dice_14 = sorrenson_dice(exc_1, exc_4)
    if (exc_1 is not None) or (exc_5 is not None):
        dice_15 = sorrenson_dice(exc_1, exc_5)
    if (exc_1 is not None) or (exc_6 is not None):
        dice_16 = sorrenson_dice(exc_1, exc_6)
    if (exc_1 is not None) or (exc_7 is not None):
        dice_17 = sorrenson_dice(exc_1, exc_7)

    dice_22 = 1
    if (exc_2 is not None) or (exc_3 is not None):
        dice_23 = sorrenson_dice(exc_2, exc_3)
    if (exc_2 is not None) or (exc_4 is not None):
        dice_24 = sorrenson_dice(exc_2, exc_4)   
    if (exc_2 is not None) or (exc_5 is not None):
        dice_25 = sorrenson_dice(exc_2, exc_5)   
    if (exc_2 is not None) or (exc_6 is not None):
        dice_26 = sorrenson_dice(exc_2, exc_6) 
    if (exc_2 is not None) or (exc_7 is not None):
        dice_27 = sorrenson_dice(exc_2, exc_7) 

    dice_33 = 1
    if (exc_3 is not None) or (exc_4 is not None):
        dice_34 = sorrenson_dice(exc_3, exc_4)
    if (exc_3 is not None) or (exc_5 is not None):
        dice_35 = sorrenson_dice(exc_3, exc_5)
    if (exc_3 is not None) or (exc_6 is not None):
        dice_36 = sorrenson_dice(exc_3, exc_6)
    if (exc_3 is not None) or (exc_7 is not None):
        dice_37 = sorrenson_dice(exc_3, exc_7)

    dice_44 = 1
    if (exc_4 is not None) or (exc_5 is not None):
        dice_45 = sorrenson_dice(exc_4, exc_5)
    if (exc_4 is not None) or (exc_6 is not None):
        dice_46 = sorrenson_dice(exc_4, exc_6)
    if (exc_4 is not None) or (exc_7 is not None):
        dice_47 = sorrenson_dice(exc_4, exc_7)

    dice_55 = 1
    if (exc_5 is not None) or (exc_6 is not None):
        dice_56 = sorrenson_dice(exc_5, exc_6)
    if (exc_5 is not None) or (exc_7 is not None):
        dice_57 = sorrenson_dice(exc_5, exc_7) 

    dice_66 = 1
    if (exc_6 is not None) or (exc_7 is not None):
        dice_67 = sorrenson_dice(exc_6, exc_7)

    dice_77 = 1

        
    # Creating a table of the Dice coefficients
    dice_coefficients = np.zeros([7, 7, 3])
    for i in range(0, 3):
        dice_coefficients[:, 0, i] = [
            dice_11,
            dice_12[i],
            dice_13[i],
            dice_14[i],
            dice_15[i],
            dice_16[i],
            dice_17[i]
            ]
        dice_coefficients[:, 1, i] = [
            dice_12[i],
            dice_22,
            dice_23[i],
            dice_24[i],
            dice_25[i],
            dice_26[i],
            dice_27[i]
            ]
        dice_coefficients[:, 2, i] = [
            dice_13[i],
            dice_23[i],
            dice_33,
            dice_34[i],
            dice_35[i],
            dice_36[i],
            dice_37[i]
            ]
        dice_coefficients[:, 3, i] = [
            dice_14[i],
            dice_24[i],
            dice_34[i],
            dice_44,
            dice_45[i],
            dice_46[i],
            dice_47[i]
            ]
        dice_coefficients[:, 4, i] = [
            dice_15[i],
            dice_25[i],
            dice_35[i],
            dice_45[i],
            dice_55,
            dice_56[i],
            dice_57[i]
            ]
        dice_coefficients[:, 5, i] = [
            dice_16[i],
            dice_26[i],
            dice_36[i],
            dice_46[i],
            dice_56[i],
            dice_66,
            dice_67[i]
            ]
        dice_coefficients[:, 6, i] = [
            dice_17[i],
            dice_27[i],
            dice_37[i],
            dice_47[i],
            dice_57[i],
            dice_67[i],
            dice_77
            ]
    dice_matrix(dice_coefficients, Positive, Title)

