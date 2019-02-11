#! /bin/bash

: ${mlr:="/share/Petuum/SRCs_sync_with_git/branches/port_to_raspberry_pi2/bosen/app/mlr/bin/mlr_main"}

# Petuum Parameters
#  hostfile, "", "Path to file containing server ip:port."
#  num_clients, 1, "Total number of clients"
#  num_app_threads, 1, "Number of app threads in this client"
#  client_id, 0, "Client ID"
#  consistency_model, "SSPPush", "SSP or SSPPush"
#  stats_path, "", "Statistics output file"
#  num_comm_channels_per_client, 1, "number of comm channels per client"
#
# Data Parameters
#  num_train_data, 0, "Number of training data. Cannot exceed the "
#      "number of data in train_file. 0 to use all train data."
#  train_file, "", "The program expects 2 files: train_file, "
#      "train_file.meta. If global_data = false, then it looks for train_file.X, "
#      "train_file.X.meta, where X is the client_id."
#  global_data, false, "If true, all workers read from the same "
#      "train_file. If false, append X. See train_file."
#  test_file, "", "The program expects 2 files: test_file, "
#      "test_file.meta, test_file must have format specified in read_format "
#      "flag. All clients read test file if FLAGS_perform_test == true."
#  num_train_eval, 20, "Use the next num_train_eval train data "
#      "(per thread) for intermediate eval."
#  num_test_eval, 20, "Use the first num_test_eval test data for "
#      "intermediate eval. 0 for using all. The final eval will always use all "
#      "test data."
#  perform_test, false, "Ignore test_file if true."
#  use_weight_file, false, "True to use init_weight_file as init"
#  weight_file, "", "Use this file to initialize weight. "
#    "Format of the file is libsvm (see SaveWeight in MLRSGDSolver)."
#
# MLR Parameters
#  num_epochs, 1, "Number of data sweeps."
#  num_batches_per_epoch, 10, "Since we Clock() at the end of each batch, "
#      "num_batches_per_epoch is effectively the number of clocks per epoch (iteration)"
#  init_lr, 0.1, "Initial learning rate"
#  lr_decay_rate, 1, "multiplicative decay"
#  num_batches_per_eval, 10, "Number of batches per evaluation"
#  lambda, 0, "L2 regularization parameter."
#
# Misc
#  output_file_prefix, "", "Results go here."
#  w_table_id, 0, "Weight table's ID in PS."
#  loss_table_id, 1, "Loss table's ID in PS."
#  staleness, 0, "staleness for weight tables."
#  row_oplog_type, petuum::RowOpLogType::kDenseRowOpLog,
#      "row oplog type"
#  oplog_dense_serialized, false, "True to not squeeze out the 0's "
#      "in dense oplog."
#  num_secs_per_checkpoint, 600, "# of seconds between each saving "
#      "to disk"
#  w_table_num_cols, 1000000,
#      "# of columns in w_table. Only used for binary LR."

: ${train_file:="/NO_TRAIN_FILE"}
: ${global_data:="true"}
: ${perform_test:="false"}
: ${use_weight_file:="false"}
: ${weight_file:=""}
: ${num_epochs:=40}
: ${num_batches_per_epoch:=10}
: ${init_lr:=0.01} # initial learning rate
: ${lr_decay_rate:=0.95} # lr = init_lr * (lr_decay_rate)
: ${num_batches_per_eval:=300}
: ${num_train_eval:=10000} # compute train error on these many train.
: ${num_test_eval:=20}
: ${lambda:=0}
: ${output_file_prefix:="/NO_OUTPUT_PREXIX"}

: ${hostfile:="/NO_HOSTFILE"}
: ${num_app_threads:=4}
: ${staleness:=2}
: ${num_comm_channels_per_client:=1} # 1~2 are usually enough

set -a
: ${GLOG_logtostderr:=true}
: ${GLOG_v:=-1}
: ${GLOG_minloglevel=:0}
set +a

${mlr} \
    --train_file="${train_file}" \
    --global_data="${global_data}" \
    --perform_test="${perform_test}" \
    --test_file="${test_file}" \
    --use_weight_file="${use_weight_file}" \
    --weight_file="${weight_file}" \
    --num_epochs="${num_epochs}" \
    --num_batches_per_epoch="${num_batches_per_epoch}" \
    --init_lr="${init_lr}" \
    --lr_decay_rate="${lr_decay_rate}" \
    --num_batches_per_eval="${num_batches_per_eval}" \
    --num_train_eval="${num_train_eval}" \
    --num_test_eval="${num_test_eval}" \
    --lambda="${lambda}" \
    --output_file_prefix="${output_file_prefix}" \
    --hostfile="${hostfile}" \
    --num_app_threads="${num_app_threads}" \
    --staleness="${staleness}" \
    --num_comm_channels_per_client="${num_comm_channels_per_client}"
