(This is the template README.md for this template project sharing repository; please see [HOWTO.md](HOWTO.md) for usage guidelines for this repo.)

# Project/Paper Title

<Project description>
  
## Table of contents
   * [How to cite?](#how-to-cite)
   * [Contents overview](#contents-overview)
   * [Reproducing figures and tables](#reproducing-figures-and-tables)
      * [Table 1](#table-1)
      * [Fig. 1](#fig-1)
      * [Fig. 2](#fig-2)
   * [Reproducing full analysis](#reproducing-full-analysis)

## How to cite?

See [CITATION](CITATION).

# Contents overview

<Summarise what's in this repository>

## Reproducing figures and tables

<Instructions on how to use summary/derived data in the `results` directory to create figures and tables>

<Specify precise steps, including any datasets that need to be downloaded and path variables that need to be set>

### Table 1

### Fig. 1

### Fig. 2

## Reproducing full analysis

### Obtaining the raw data

We have used three publicly available datasets from the [OpenNeuro](https://openneuro.org/) online data repository: [ds000001 (version 00006)](https://openneuro.org/datasets/ds000001/versions/00006), [ds000109 (version 00001)](https://openneuro.org/datasets/ds000109/versions/00001) and [ds000120 (version 00001)](https://openneuro.org/datasets/ds000120/versions/00001).

For compatibility with the analysis scripts, the ds000001 data should be downloaded to `/PATH_TO_SC2_DIR/data/raw/ds001_R2.0.4`, the ds000109 data should be downloaded to `/PATH_TO_SC2_DIR/data/raw/ds000109_R2.0.1`, and the ds000120 data should be downloaded to `/PATH_TO_SC2_DIR/data/raw/ds120_R1.0.0`. 

### Config files 
Users will need to edit the `config.py` and `config.mat` files in `/PATH_TO_SC2_DIR/src/`, providing absolute paths to the fundamental directories and files needed to run the analyses.

#### config.py
In `/PATH_TO_SC2_DIR/src/config.py`, edit each of the variables as follows:
paths["packages_dir"] = path to the directory where main modules are stored on your HPC (i.e. the directory given from inputting `module avail` into the terminal when connected to the HPC)
path["home_dir"] = path to the SC2 directory
paths["fmriprep_singularity_image"] = path to the fMRIprep singularity image .simg
paths["FS_license"] = path to the freesurfer license (Users can obtain a freesurfer license from [here](https://surfer.nmr.mgh.harvard.edu/registration.html))
paths["AFNI_SPM_singularity_image"] = path to the AFNI singularity container (only needed for running AFNI analyses)
paths["AFNI_bin"] = path to the AFNI directory within the singularity container

#### config.mat
Open up matlab and load the `/PATH_TO_SC2_DIR/src/config.mat` file with `A = load('/PATH_TO_SC2_DIR/src/config.mat')` . Then set `A.home_dir = PATH_TO_SC2_DIR` and save with `save('/PATH_TO_SC2_DIR/src/config.mat','A')` 

### Preprocessing the data with fMRIprep
The preprocessing of all the data with fMRIprep is carried out from the `/PATH_TO_SC2_DIR/src/process_fmriprep.py` master script. For each of the three studies, the master script creates a shell script to preprocess each subject saved to `/PATH_TO_SC2_DIR/data/processed/STUDY_DIR/scripts/STUDY_SUB_fmriprep.sh` and submits the job to the HPC. From the terminal, run `python /PATH_TO_SC2_DIR/src/process_fmriprep.py`.

### Analysis of ds000001

#### Data processing using SPM, FSL and AFNI

