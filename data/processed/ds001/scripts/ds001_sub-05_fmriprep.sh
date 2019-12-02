#!/bin/bash
#$ -N ds001_sub-05
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/logs/
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/logs/

singularity run --cleanenv -B /well/win/software/packages,/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds001_R2.0.4/../../.. /well/nichols/users/bas627/fmriprep/fmriprep-1.5.1.simg \
    /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds001_R2.0.4 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001 \
    participant \
    --participant-label 05 \
    --ignore slicetiming \
    --fs-license-file /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/license.txt \
    --fs-no-reconall \
    -w /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds001/ds001_sub-05_work \
    --mem-mb 13000 \
    --low-mem \
    --resource-monitor \
    --nthreads 4 \
    -vvv

