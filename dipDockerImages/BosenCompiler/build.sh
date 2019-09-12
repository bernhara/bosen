#! /bin/bash

# $Id: $

HERE=$( dirname "$0" )
ABS_HERE=$( readlink -f "${HERE}" )

image_name=dip_bosen_compiler
image_tag=latest

docker build  \
    --force-rm \
    --pull \
    -t "${image_name}:${image_tag}" \
    --build-arg http_proxy=http://proxy:3128 \
    --build-arg https_proxy=http://proxy:3128 \
    --file "${HERE}/Dockerfile" \
    ${HERE}

rm -rf ${HERE}/tmp_out
mkdir ${HERE}/tmp_out

docker run \
    --rm \
    -v ${ABS_HERE}/tmp_out:/tmp_out \
    "${image_name}:${image_tag}" \
    /bin/bash -c "cp -r /PETUUM/bosen/app/mlr/bin /tmp_out"



#    /bin/bash -c "cp -r /PETUUM/bosen/app/mlr/bin /tmp_out; chmod -R a+rwx /tmp_out/*"


