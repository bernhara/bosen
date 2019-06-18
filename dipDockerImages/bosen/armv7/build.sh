#! /bin/bash

: ${HERE=`dirname "$0"`}
: ${MLR_ROOT_DIR:="${HERE}/../../../app/mlr"}
: ${tmp_root:="${HERE}/tmp_root"}
: ${REGISTRY_HOSTNAME_IMAGE_NAME_PREFIX="s-eunuc:5000"}

#
# Create the file system which will be copied to the container
#

architecture=$( uname -m )

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
#!!build_arg_element="${build_arg_element} http_proxy=http://192.168.2.2:3128"
#!!build_arg_element="${build_arg_element} https_proxy=http://192.168.2.2:3128"
build_arg_element="${build_arg_element} http_proxy=http://proxy:3128"
build_arg_element="${build_arg_element} https_proxy=http://proxy:3128"

build_arg_switch_list=""
for a in ${build_arg_element}
do
    build_arg_switch_list="${build_arg_switch_list} --build-arg ${a}"
done
    
docker build  --force-rm --pull -t "${image_name}:${image_tag}" --file "${HERE}/Dockerfile.${architecture}" ${build_arg_switch_list} ${HERE}
