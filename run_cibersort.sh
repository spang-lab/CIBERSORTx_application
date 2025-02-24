source .env
# Get the input files from the remote
mkdir $INPUT_BASE_DIR/$SIMULATION
for irun in $(seq 1 $NUMBER_RUNS)
do
    scp $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_sigmatrix_harp_reference_run_$irun.txt $INPUT_BASE_DIR/$SIMULATION
    scp $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_sigmatrix_mean_reference_run_$irun.txt $INPUT_BASE_DIR/$SIMULATION
    scp $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_bulks_hgnc_run_$irun.txt $INPUT_BASE_DIR/$SIMULATION
    scp $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_bulks_run_$irun.txt $INPUT_BASE_DIR/$SIMULATION
    scp $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_refsample_run_$irun.txt $INPUT_BASE_DIR/$SIMULATION
    scp $SERVER_NAME:$SERVER_HOME/data/source/LM22.txt $INPUT_BASE_DIR/$SIMULATION
done 

# Mode 1: Let CIBERSORT use the LM22 signature matrix
for irun in $(seq 1 $NUMBER_RUNS)
do
    input_dir=$INPUT_BASE_DIR/$SIMULATION
    output_dir=$input_dir
    # run CIBERSORTin fractions mode using B-mode batch correction
    docker run \
        -v $input_dir:/src/data \
        -v $output_dir:/src/outdir \
        cibersortx/fractions \
        --username $MAIL \
        --token $TOKEN \
        --sigmatrix LM22.txt \
        --mixture CIBERSORTx_bulks_hgnc_run_$irun.txt \
        --rmbatchBmode TRUE
    mv $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted.txt $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_lm22_run_$irun.txt
    scp $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_lm22_run_$irun.txt $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_Adjusted_lm22_run_$irun.txt
done

# Mode 2: Let CIBERSORT automatically build sigmatrix from sc data
for irun in $(seq 1 $NUMBER_RUNS)
do
    input_dir=$INPUT_BASE_DIR/$SIMULATION
    output_dir=$input_dir
    # run CIBERSORTin fractions mode using S-mode batch correction
    docker run \
        -v $input_dir:/src/data \
        -v $output_dir:/src/outdir \
        cibersortx/fractions \
        --username $MAIL \
        --token $TOKEN \
        --single_cell TRUE \
        --refsample CIBERSORTx_refsample_run_$irun.txt \
        --mixture CIBERSORTx_bulks_run_$irun.txt \
        --rmbatchSmode TRUE
    mv $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted.txt $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_sc_run_$irun.txt
    scp $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_sc_run_$irun.txt $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_Adjusted_sc_run_$irun.txt
done


# Mode 3: Let CIBERSORT use X1 (i.e. mean_reference)
for irun in $(seq 1 $NUMBER_RUNS)
do
    input_dir=$INPUT_BASE_DIR/$SIMULATION
    output_dir=$input_dir
    # run CIBERSORTin fractions mode using B-mode batch correction
    docker run \
        -v $input_dir:/src/data \
        -v $output_dir:/src/outdir \
        cibersortx/fractions \
        --username $MAIL \
        --token $TOKEN \
        --sigmatrix CIBERSORTx_sigmatrix_mean_reference_run_$irun.txt \
        --mixture CIBERSORTx_bulks_run_$irun.txt \
        --rmbatchBmode TRUE
    mv $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted.txt $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_mean_reference_run_$irun.txt
    scp $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_mean_reference_run_$irun.txt $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_Adjusted_mean_reference_run_$irun.txt
done

# Mode 4: Let CIBERSORT use the reference learnt by HARP
for irun in $(seq 1 $NUMBER_RUNS)
do
    input_dir=$INPUT_BASE_DIR/$SIMULATION
    output_dir=$input_dir
    # here we show the full capability of the HARP reference without Batch Correction
    docker run \
        -v $input_dir:/src/data \
        -v $output_dir:/src/outdir \
        cibersortx/fractions \
        --username $MAIL \
        --token $TOKEN \
        --sigmatrix CIBERSORTx_sigmatrix_harp_reference_run_$irun.txt \
        --mixture CIBERSORTx_bulks_run_$irun.txt \
        --rmbatchBmode FALSE
    mv $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Results.txt $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_harp_run_$irun.txt
    scp $INPUT_BASE_DIR/$SIMULATION/CIBERSORTx_Adjusted_harp_run_$irun.txt $SERVER_NAME:$SERVER_STORAGE/$SIMULATION/CIBERSORTx_Adjusted_harp_run_$irun.txt
done