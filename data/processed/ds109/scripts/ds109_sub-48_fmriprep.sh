#!/bin/bash
#$ -N ds109_sub-48
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/logs/
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/logs/

singularity run -B /well/win/software/packages,/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds000109_R2.0.1/../../.. --home /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds000109_R2.0.1/../../.. --cleanenv /well/nichols/users/bas627/fmriprep/fmriprep-20.0.2.simg \
    /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds000109_R2.0.1 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109 \
    participant \
    --participant-label 48 \
    --ignore slicetiming \
    --fs-license-file /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/license.txt \
    -w /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/ds109_sub-48_work \
    --mem-mb 15000 \
    --low-mem \
    --resource-monitor \
    --nthreads 4 \
    -vvv 

