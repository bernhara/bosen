#! /bin/bash

# FIXME: minimal version

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
