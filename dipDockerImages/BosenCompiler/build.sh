#! /bin/bash

# FIXME: minimal version

HERE=$( dirname "$0" )
ABS_HERE=$( readlink -f "${HERE}" )

: ${tmp_root:="${HERE}/tmp_root"}

: ${git_branch:=log-minibatch-data}

if [ -d "${tmp_root}/bosen" ]
then
    (
	cd "${tmp_root}/bosen"
	http_proxy=http://proxy:3128 \
	    https_proxy=http://proxy:3128 \
	    git pull
    )
else

    mkdir -p "${tmp_root}"
    (
	cd "${tmp_root}"
	http_proxy=http://proxy:3128 \
	    https_proxy=http://proxy:3128 \
	    git clone -b "${git_branch}" https://github.com/bernhara/bosen.git
    )
fi


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
