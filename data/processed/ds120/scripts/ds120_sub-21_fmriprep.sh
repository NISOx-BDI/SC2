#!/bin/bash
#$ -N ds120_sub-21
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/logs/
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/logs/

singularity run -B /well/win/software/packages,/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds120_R1.0.0/../../.. --home /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds120_R1.0.0/../../.. --cleanenv /well/nichols/users/bas627/fmriprep/fmriprep-20.0.2.simg \
    /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds120_R1.0.0 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120 \
    participant \
    --participant-label 21 \
    --ignore slicetiming \
    --fs-license-file /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/license.txt \
    -w /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/ds120_sub-21_work \
    --mem-mb 15000 \
    --low-mem \
    --resource-monitor \
    --nthreads 4 \
    -vvv 

