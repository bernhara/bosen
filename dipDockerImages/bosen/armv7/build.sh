#! /bin/bash

: ${HERE=`dirname "$0"`}
: ${MLR_ROOT_DIR:="${HERE}/../../../app/mlr"}
: ${tmp_root:="${HERE}/tmp_root"}
: ${REGISTRY_HOSTNAME_IMAGE_NAME_PREFIX="s-eunuc:5000"}

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
    "${HERE}/trainWorker.sh" \
    "${HERE}/trainWorker.sh-config" \
    "${HERE}/testit.sh" \
    "${tmp_root}/home/dip/bin"


image_name="${REGISTRY_HOSTNAME_IMAGE_NAME_PREFIX}/dip/mlr-worker"
image_tag="latest"

build_arg_element=""
build_arg_element="${build_arg_element} http_proxy=http://proxy:8080"
build_arg_element="${build_arg_element} https_proxy=http://proxy:8080"

if [ -n "${skip_apt}" ]
then
    build_arg_element="${build_arg_element} skip_apt=true"
fi

build_arg_switch_list=""
for a in ${build_arg_element}
do
    build_arg_switch_list="${build_arg_switch_list} --build-arg ${a}"
done
    
docker build  --force-rm -t "${image_name}:${image_tag}" --file "${HERE}/Dockerfile" ${build_arg_switch_list} ${HERE}
