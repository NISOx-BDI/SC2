# Isolating the sources of pipeline-variability in group-level task-fMRI results

Supporting code to perform the analyses and create the figures of the manuscript with the same title available at [10.1002/hbm.25713](https://doi.org/10.1002/hbm.25713).

  
## Table of contents
   * [How to cite?](#how-to-cite)
   * [Contents overview](#contents-overview)
   * [Reproducing figures and tables](#reproducing-figures-and-tables)
      * [Fig. 2](#fig-2)
      * [Fig. 3](#fig-3)
      * [Fig. 4](#fig-4)
      * [Fig. 5](#fig-5)
      * [Fig. 6](#fig-6)
   * [Reproducing full analysis](#reproducing-full-analysis)

## How to cite?

To cite this repository, please cite the corresponding manuscript: 

Alexander Bowring, Thomas Nichols*, Camille Maumet* "Isolating the sources of pipeline-variability in group-level task-fMRI results" (2021). _Human Brain Mapping_, https://doi.org/10.1002/hbm.25713 .


## Reproducing figures and tables

### Fig. 2

1. From a Terminal, run:

    ```
    jupyter notebook ./figures/ds001_notebook.ipynb
    ```
2. Run all cells

#### First row: ds001 AFNI to FSL parametric

#### Second row: ds001  AFNI to FSL non-parametric

#### Last row: ds001 AFNI to FSL correlations

##### Correlation AFNI/FSL PARAMETRIC: 

Displayed by the cell that includes: 
```
correlation_tables.new_correlation_tables(old_afni_stat_file, afni_stat_file, fsl_afni_subject_level_stat_file, afni_drift_stat_file, afni_design_stat_file, fsl_stat_file, old_fsl_stat_file, title= "Correlations: AFNI and FSL")
```

##### Correlation AFNI/FSL PERMUTATION:

Displayed by the cell that includes: 
```
correlation_tables.new_correlation_tables(old_afni_perm_z, afni_perm, fsl_afni_subject_level_perm, afni_drift_perm, afni_design_perm, fsl_perm, old_fsl_perm, "Perm Correlations: AFNI and FSL", 15)
```

##### DICE (+ve Activations): AFNI/FSL PARAMETRIC

Displayed by the cell that includes: 
```
new_dice.new_dice(old_afni_exc_set_file, afni_exc_set_file, fsl_afni_subject_level_exc_set_file, afni_drift_exc_set_file, afni_design_exc_set_file, fsl_exc_set_file, old_fsl_exc_set_file,
                  old_afni_stat_file, afni_stat_file, fsl_afni_subject_level_stat_file, afni_drift_stat_file, afni_design_stat_file, fsl_stat_file, old_fsl_stat_file,
                 Title='Dice (Positive Activations): AFNI and FSL')
```


##### DICE (+ve Activations): AFNI/FSL PERMUTATION
Displayed by the cell that includes: 
```
new_dice.new_dice(old_afni_perm_pos_exc, afni_perm_pos_exc, fsl_afni_subject_level_perm_pos_exc, afni_drift_perm_pos_exc, afni_design_perm_pos_exc, fsl_perm_pos_exc, old_fsl_perm_pos_exc,
                  old_afni_perm_z, afni_perm, fsl_afni_subject_level_perm, afni_drift_perm, afni_design_perm, fsl_perm, old_fsl_perm,
                 Title='Perm Dice (Positive Activations): AFNI and FSL')
```
### Fig. 3

1. From a Terminal, run:

    ```
    jupyter notebook ./figures/ds109_notebook.ipynb
    ```
2. Run all cells

### Fig. 4

1. From a Terminal, run:

    ```
    jupyter notebook ./figures/ds120_notebook.ipynb
    ```
2. Run all cells

### Fig. 5

1. From a Terminal, run:

    ```
    jupyter notebook ./figures/ds001_notebook.ipynb
    ```
2. The consensus analysis is displayed by the cell that stars with:
```
from lib import consensus_analysis
```

### Fig. 6

1. From a Terminal, run:

    ```
    jupyter notebook ./figures/ds109_notebook.ipynb
    ```
2. The consensus analysis is displayed by the cell that stars with:
```
from lib import consensus_analysis
```




## Reproducing full analysis

### Obtaining the raw data

We have used three publicly available datasets from the [OpenNeuro](https://openneuro.org/) online data repository: [ds000001 (version 00006)](https://openneuro.org/datasets/ds000001/versions/00006), [ds000109 (version 00001)](https://openneuro.org/datasets/ds000109/versions/00001) and [ds000120 (version 00001)](https://openneuro.org/datasets/ds000120/versions/00001).

For compatibility with the analysis scripts, the ds000001 data should be downloaded to `./data/raw/ds001_R2.0.4`, the ds000109 data should be downloaded to `./data/raw/ds000109_R2.0.1`, and the ds000120 data should be downloaded to `./data/raw/ds120_R1.0.0`. 

### Config files 
Users will need to edit the `./src/config.py` and `./src/config.mat` configuration files, providing absolute paths to the fundamental directories and files needed to run the analyses.

#### config.py
In `./src/config.py`, set each of the variables following the instructions provided as comments in the file. Users can obtain a freesurfer license from [here](https://surfer.nmr.mgh.harvard.edu/registration.html) if they do not already have one. 

#### config.mat
Open up matlab and load the `./src/config.mat` file with `A = load('./src/config.mat')` . Then set `A.home_dir = PATH_TO_SC2_DIR` and save with `save('./src/config.mat','A')` 

### Preprocessing the data with fMRIprep
The preprocessing of all the data with fMRIprep is carried out from the `./src/process_fmriprep.py` master script. For each of the three studies, the master script creates a shell script to preprocess each subject saved to `./data/processed/STUDY_DIR/scripts/STUDY_SUB_fmriprep.sh` and submits the job to the HPC. From the terminal, run `python ./src/process_fmriprep.py`.

Each subject's preprocessed data is outputted to `./data/processed/STUDY_DIR/fmriprep/SUB_DIR`.

### Analysis of ds000001

#### Data processing using AFNI, FSL, and SPM

#### AFNI

The AFNI analysis is conducted via the master script `./src/ds001/process_ds001_ANFI.py`. From a terminal, run:

`python ./src/ds001/process_ds001_AFNI.py` 

This will create the onsets, extract the motion regressors from the fMRIprep'd preprocessed data, orthogonalize the relevant onset files, run the first- and group-level analyses, and finally, extract the columns of the subject-level design matrices and convert the AFNI .BRIK files to .NII files (for further, intermixed analyses within FSL).

All results will be outpped to `./results/ds001/AFNI`

#### FSL

The FSL analysis is conducted via the master script `./src/ds001/process_ds001_FSL.py`. To run just the FSL analysis (with fMRIprep'd preprocessed data) users should comment out all lines from `process_ds001_FSL.py` after the first instance where `run_permutation_test` is called. Then, from a terminal, run:

`python ./src/ds001/process_ds001_FSL.py`

This will create the onsets, extract the motion regressors from the fMRIprep'd preprocessed data, and run the first- and group-level analyses.

All results will be outputted to `./results/ds001/FSL`


#### SPM

The SPM analysis is conducted via the master script `./src/ds001/process_ds001_SPM.m`. The analysis is carried out within Octave using the standalone version of SPM12 (SPM12-r7771). The permutation analysis is carried out using the SnPM13 toolbox. To run the analysis, open Octave, add the relevant directories to the Octave path using the `addpath()` function (i.e. the SC2 directory, the standalone SPM12 directory and SnPM toolbox), and then run:

```
save_default_options('-mat-binary');
process_ds001_SPM.m
```

This will create the onsets, extract the motion regressors from the fMRIprep'd preprocessed data, unzip the relevant files from the preprocessed data so they can be used for first-level analyses, run the first- and group-level analyses, and finally, extract the columns of the subject-level design matrices (for further, intermixed analyses within FSL).

All results will be outputted to `./results/ds001/SPM`

### Analysis of ds000109

Same as for ds000001, except replacing all occurences of 001 with 109. 


