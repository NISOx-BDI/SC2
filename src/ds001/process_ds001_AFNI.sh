#!/bin/bash
#$ -N run_AFNI
#$ -q long.qc
#$ -o /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/AFNI/ds001/logs
#$ -e /well/nichols/users/bas627/BIDS_Data/RESULTS/SC2/results/AFNI/ds001/logs

python /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/scripts/process_ds001_AFNI.py
