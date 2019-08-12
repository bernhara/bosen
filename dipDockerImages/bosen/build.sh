#! /bin/bash

: ${HERE=`dirname "$0"`}
: ${MLR_ROOT_DIR:="${HERE}/../../app/mlr"}
: ${tmp_root:="${HERE}/tmp_root"}
: ${REGISTRY_HOSTNAME_IMAGE_NAME_PREFIX="s-eunuc:5000"}

#
# Create the file system which will be copied to the container
#

architecture=$( uname -m )

: ${_use_http_proxy_from_env:=false}
if [ -n "${USE_PROXY_ENV}" ]
then
    _use_http_proxy_from_env=true
fi


rm -rf "${tmp_root}"
mkdir -p "${tmp_root}/home/dip"
mkdir -p "${tmp_root}/home/dip/bin"
cp -a "${MLR_ROOT_DIR}/bin/mlr_main" "${tmp_root}/home/dip/bin"

mkdir -p "${tmp_root}/home/dip/datasets"
cp -a \
    "${MLR_ROOT_DIR}/datasets/covtype.scale.test.small" \
    "${MLR_ROOT_DIR}/datasets/covtype.scale.test.small.meta" \
    "${MLR_ROOT_DIR}/datasets/covtype.scale.train.small" \
    "${MLR_ROOT_DIR}/datasets/covtype.scale.train.small.meta" \
    "${tmp_root}/home/dip/datasets"

cp -a \
    "${HERE}/mlrWrapper.sh" \
    "${HERE}/trainWorker.sh" \
    "${HERE}/testit.sh" \
    "${tmp_root}/home/dip/bin"


#
# build image
#

image_name="${REGISTRY_HOSTNAME_IMAGE_NAME_PREFIX}/dip/mlr-worker"
image_tag="${architecture}-latest"

build_arg_element=""

if [ -n "${_use_http_proxy_from_env}"
then

    http_proxy_to_use=$(
	if [ -n "${HTTP_PROXY}" ]
	then
	    echo "${HTTP_PROXY}"
	else
	if [ -n "${http_proxy}" ]
	    echo "${http_proxy}"
	else
	    echo ''
	fi
    )
    if [ -z "${http_proxy_to_use}" ]
	echo "No value provided for HTTP_PROXY" 1>&2
	exit 1
    fi

    https_proxy_to_use=$(
	if [ -n "${HTTPS_PROXY}" ]
	then
	    echo "${HTTPS_PROXY}"
	else
	if [ -n "${https_proxy}" ]
	    echo "${https_proxy}"
	else
	    # We use the same as for HTTP
	    echo "${http_proxy_to_use}"
	fi
    )
	    
	    
    if [ -n "${http_proxy_to_use}" ]
    then
	build_arg_element="${build_arg_element} http_proxy=${http_proxy_to_use}"
    fi

    if [ -n "${https_proxy_to_use}" ]
    then
	build_arg_element="${build_arg_element} https_proxy=${https_proxy_to_use}"
    fi
fi

build_arg_switch_list=""
for a in ${build_arg_element}
do
    build_arg_switch_list="${build_arg_switch_list} --build-arg ${a}"
done
    
docker build  --force-rm --pull -t "${image_name}:${image_tag}" --file "${HERE}/Dockerfile.${architecture}" ${build_arg_switch_list} ${HERE}
