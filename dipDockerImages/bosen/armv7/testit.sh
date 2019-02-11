#! /bin/bash

mlr="${MLR_MAIN}"

echo "0 localhost 9999" > /tmp/sole_localhost_hostfile


# train file is the one embedded in the container
export train_file="/home/dip/datasets/covtype.scale.train.small"
export num_app_threads=${NB_THREADS}

export num_comm_channels_per_client=1
export num_clients=1
export client_id=0
export global_data=true
export perform_test=false
export hostfile="/tmp/sole_localhost_hostfile"
export output_file_prefix="/tmp/direct_mlr_out"
export num_test_eval=20
export num_batches_per_epoch=10
export num_epochs=40
export lr_decay_rate=0.99
export num_train_eval=10000
export init_lr=0.01
export num_batches_per_eval=10
export lambda=0

export mlr="${MLR_MAIN}"

/home/dip/bin/mlrWrapper.sh
