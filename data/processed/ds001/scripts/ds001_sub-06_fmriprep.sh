#!/bin/bash
#$ -N ds001_sub-06
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/logs/
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/logs/

singularity run -B /well/win/software/packages,/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds001_R2.0.4_AMENDED/../../.. --home /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds001_R2.0.4_AMENDED/../../.. --cleanenv /well/nichols/users/bas627/fmriprep/fmriprep-20.0.2.simg \
    /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds001_R2.0.4_AMENDED /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001 \
    participant \
    --participant-label 06 \
    --ignore slicetiming \
    --fs-license-file /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/license.txt \
    -w /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/ds001_sub-06_work \
    --mem-mb 15000 \
    --low-mem \
    --resource-monitor \
    --nthreads 4 \
    -vvv 

