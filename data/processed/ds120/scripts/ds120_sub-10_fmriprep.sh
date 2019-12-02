#!/bin/bash
#$ -N ds120_sub-10
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/logs/
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/logs/

singularity run --cleanenv -B /well/win/software/packages,/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds120_R1.0.0/../../.. /well/nichols/users/bas627/fmriprep/fmriprep-1.5.1.simg \
    /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds120_R1.0.0 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120 \
    participant \
    --participant-label 10 \
    --ignore slicetiming \
    --fs-license-file /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/license.txt \
    --fs-no-reconall \
    -w /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds120/ds120_sub-10_work \
    --mem-mb 13000 \
    --low-mem \
    --resource-monitor \
    --nthreads 4 \
    -vvv

