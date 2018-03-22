#! /bin/bash

echo "0 localhost 9999" > /tmp/sole_localhost_hostfile

TRAIN_FILE="/home/dip/datasets/covtype.scale.train.small"

GLOG_logtostderr=true GLOG_v=-1 GLOG_minloglevel=0 \
/home/dip/bin/mlr_main \
    --num_comm_channels_per_client=1 \
    --num_clients=1 \
    --client_id=0 \
    --global_data=true \
    --perform_test=false \
    --hostfile=/tmp/sole_localhost_hostfile \
    --output_file_prefix=/tmp/direct_mlr_out \
    --use_weight_file=false \
    --num_test_eval=20 \
    --staleness=2 \
    --num_app_threads=4 \
    --weight_file= \
    --num_batches_per_epoch=10 \
    --num_epochs=40 \
    --lr_decay_rate=0.99 \
    --num_train_eval=10000 \
    --init_lr=0.01 \
    --num_batches_per_eval=10 \
    --lambda=0 \
    --train_file=${TRAIN_FILE}
