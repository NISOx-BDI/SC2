#!/bin/bash
#$ -N run_AFNI_ds001
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/logs/
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/ds001/AFNI/logs/

. /etc/profile
. ~/.bash_profile

cd /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/src/ds001
python process_ds001_AFNI.py
