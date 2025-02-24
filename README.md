# CIBERSORTx Application

This repository tools the CIBERSORTx docker container as needed to reproduce the results in HARP: Platform Independent Deconvolution Tool (Nozari et al.)

The script `run_cibersort.sh` provides deconvolution with the official CIBERSORTx/fractions
docker container, that can be requested via the original web page https://cibersortx.stanford.edu

The main intention of the script is to have a local docker container with CIBERSORT running and provide `.txt` files as input resulting from
prior preprocessing steps.

In order to apply our script in your environment, fill out the `template.env` with your credentials and env variables and rename the file `.env`

