#! /bin/bash

# $Id: trainWorker.sh,v 1.3 2017/11/22 14:09:16 orba6563 Exp orba6563 $

HERE=`dirname $0`
CMD=`basename $0`

ARGarray=( "$@" )

if [ -r "${HERE}/${CMD}-config" ]
then
    . "${HERE}/${CMD}-config"
fi

# Globals
: ${PETUUM_INSTALL_DIR:=/share/PLMS}
: ${MLR_MAIN:="${PETUUM_INSTALL_DIR}/bosen/app/mlr/bin/mlr_main"}
: ${NB_THREADS:=2}
: ${DATASETS_DIR:="${HERE}/datasets"}

Usage ()
{
    if [ -n "$1" ]
    then
	echo "ERROR: $1" 1>&2
    fi
    echo "Usage: ${CMD} [--dryrun] [--output_prefix_file <prefix for generated loss file>] <this worker index> <worker specification> [<worker specification>]*" 1>&2
    echo "with <worker specification> having the following form: <worker hostname>:<petuum interworker tcp port>" 1>&2
    echo "NOTES:" 1>&2
    echo "\tworkers are indexed in appearing order (first specified worker has index 0)" 1>&2
    echo "\torder of arguments is relevant" 1>&2
    exit 1
}

realpath () {
    readlink --canonicalize "$1"
}

set -- "${ARGarray[@]}"

dryrun=false
if [ "$1" = "--dryrun" ]
then
    dryrun=true
    shift 1
fi

if [ "$1" = "--output_prefix_file" ]
then
    shift 1
    output_prefix_file="$1"

    if [ -z "${output_prefix_file}" ]
    then
	Usage "no argument provided to --output_prefix_file"
    fi

    shift 1
fi

this_worker_index="$1"
shift 1

if [ -z ${this_worker_index} ]
then
    Usage "Missing <this worker index> argument"
fi

declare -a petuum_workers_specification_list

list_index=0
while [ -n "$1" ]
do
    worker_specification="$1"

    worker_index="${list_index}"

    worker_hostname="${worker_specification%:*}"
    if [ "${worker_hostname}" = "${worker_specification}" ]
    then
	Usage "Missing port in <worker specification>"
    fi

    petuum_interworker_tcp_port="${worker_specification#*:}"

    petuum_workers_specification_list[${worker_index}]="'${list_index}' '${worker_hostname}' '${petuum_interworker_tcp_port}'"
    list_index=$(( ${list_index} + 1 ))

    shift

done

if [ ${#petuum_workers_specification_list[@]} -eq 0 ]
then
    Usage "Missing worker specification"
fi

##############################################################################################
#
# Utils
#

##############################################################################################

#
# Manage tmp storage

: ${remove_tmp:=true}
: ${tmp_dir:=`mktemp -u -p "${HERE}/tmp"`}

if ${remove_tmp}
then
    trap 'rm -rf "${tmp_dir}"' 0
fi

# import_logs_dir is supposed to exist
mkdir -p "${tmp_dir}"

# generate server file
(
    for worker_specification in "${petuum_workers_specification_list[@]}"
    do

        # transform the list into an array (all elements are quoted to handle empty elements (=> eval)
        eval worker_specification_array=( ${worker_specification} )
        worker_index="${worker_specification_array[0]}"
        worker_hostname="${worker_specification_array[1]}"
        petuum_interworker_tcp_port="${worker_specification_array[2]}"

        echo ${worker_index} ${worker_hostname} ${petuum_interworker_tcp_port}
    done
) > ${tmp_dir}/localserver

#
# Launch MLR on all workerd
#

nb_workers=${#petuum_workers_specification_list[@]}

if [ ${nb_workers} -ge 2 ]
then
    # Distributed version
    partitioned_mode=true
else
    partitioned_mode=false
fi



if [ -z "${TRAIN_FILE}" ]
then

    if ${partitioned_mode}
    then
	train_file="${DATASETS_DIR}/BIG.x${nb_workers}.libsvm.X"
	mlr_arg_global_data=false
    else
	train_file="${DATASETS_DIR}/BIG.x1.libsvm.X.0"
	mlr_arg_global_data=true
    fi

else

    train_file="${TRAIN_FILE}"

fi


# TODO: which args should be parametrized

if [ -z "${output_prefix_file}" ]
then
    output_prefix_file="${tmp_dir}/rez"
fi

command='GLOG_logtostderr=true GLOG_v=-1 GLOG_minloglevel=0 \
"${MLR_MAIN}" \
   --num_comm_channels_per_client=1 \
   --staleness=2 \
   --client_id="${this_worker_index}" \
   --num_app_threads=${NB_THREADS} \
   --num_clients=${nb_workers} \
   --use_weight_file=false --weight_file= \
   --num_batches_per_epoch=10 --num_epochs=40 \
   --output_file_prefix="${output_prefix_file}" \
   --lr_decay_rate=0.99 --num_train_eval=10000 \
   --global_data=${mlr_arg_global_data} \
   --init_lr=0.01 \
   --num_test_eval=20 --perform_test=false --num_batches_per_eval=10 --lambda=0 \
   --hostfile=${tmp_dir}/localserver \
   --train_file=${train_file} \
'

command='
MLR="${MLR_MAIN}" \
\
GLOG_logtostderr=true \
GLOG_v=-1 GLOG_minloglevel=0 \
\
train_file="${TRAIN_FILE}" \
hostfile=${tmp_dir}/localserver \
num_app_threads=${NB_THREADS} \
num_clients="${nb_workers}" \
client_id="${this_worker_index}" \
global_data="${mlr_arg_global_data}" \
output_file_prefix="${output_prefix_file}" \
lr_decay_rate=0.99 \
num_train_eval=10000 \
\
"${HERE}/mlrWrapper.sh}"
'

if ${dryrun}
then
    echo "${command}"
else
    eval "${command}"
fi
