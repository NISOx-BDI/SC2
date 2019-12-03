#!/bin/bash
#$ -N ds109_sub-32
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/logs/
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/logs/

singularity run --cleanenv -B /well/win/software/packages,/well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds000109_R2.0.1/../../.. /well/nichols/users/bas627/fmriprep/fmriprep-1.5.1.simg \
    /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/raw/ds000109_R2.0.1 /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109 \
    participant \
    --participant-label 32 \
    --ignore slicetiming \
    --fs-license-file /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/license.txt \
    --fs-no-reconall \
    -w /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/data/processed/ds109/ds109_sub-32_work \
    --mem-mb 13000 \
    --low-mem \
    --resource-monitor \
    --nthreads 4 \
    -vvv

