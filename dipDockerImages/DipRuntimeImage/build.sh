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


(
    ABS_HERE=$( readlink -f "${HERE}" )

    rm -rf ${HERE}/tmp_out
    mkdir ${HERE}/tmp_out
    docker run \
	--rm \
	-v ${ABS_HERE}/tmp_out:/tmp_out \
	"dip_bosen_compiler:latest" \
	/bin/bash -c "
cp -r /PETUUM/bosen/app/mlr/bin /tmp_out; chmod -R 777 /tmp_out/bin; 
cp -r /PETUUM/bosen/app/mlr/datasets /tmp_out; chmod -R 777 /tmp_out/datasets; 
"

    cp "${HERE}/tmp_out/bin/mlr_main" "${tmp_root}/home/dip/bin"
    chmod 755 "${tmp_root}/home/dip/bin/mlr_main"

    mkdir -p "${tmp_root}/home/dip/datasets"
    cp \
	"${HERE}/tmp_out/datasets/covtype.scale.test.small" \
	"${HERE}/tmp_out/datasets/covtype.scale.test.small.meta" \
	"${HERE}/tmp_out/datasets/covtype.scale.train.small" \
	"${HERE}/tmp_out/datasets/covtype.scale.train.small.meta" \
	\
	"${tmp_root}/home/dip/datasets"
    chmod 555 "${tmp_root}/home/dip/datasets/"*

exit 1
    rm -rf ${HERE}/tmp_out
)


cp -a \
    "${HERE}/mlrWrapper.sh" \
    "${HERE}/trainWorker.sh" \
    "${HERE}/testit.sh" \
    "${HERE}/pushStatsToElkLoop.sh" \
    "${tmp_root}/home/dip/bin"

cp -a -r \
    "${HERE}/misc" \
    "${tmp_root}/home/dip/bin/misc"

#
# rebuild VENVs for python
#

VENVs=$(
    find "${tmp_root}/home/dip/bin/misc/" -name ".venv" -print
)
for venv in ${VENVs}
do
    #
    # recreate it from scratch
    #
    rm -rf "${venv}"
    mkdir "${venv}"

    rm -f ${venv}/../Pipfile.lock
done

#
# remove __pycache__
#

for d in $( find "${tmp_root}" -type d -a -name __pycache__ -print )
do
    rm -rf $d
done

#
# build image
#

image_name="${REGISTRY_HOSTNAME_IMAGE_NAME_PREFIX}/dip/mlr-worker"
image_tag="${architecture}-latest"

build_arg_element=""

if ${_use_http_proxy_from_env}
then

    http_proxy_to_use=$(
	if [ -n "${HTTP_PROXY}" ]
	then
	    echo "${HTTP_PROXY}"
	elif [ -n "${http_proxy}" ]
	then
	    echo "${http_proxy}"
	else
	    echo ''
	fi
    )
    if [ -z "${http_proxy_to_use}" ]
    then
	echo "No value provided for HTTP_PROXY" 1>&2
	exit 1
    fi

    https_proxy_to_use=$(
	if [ -n "${HTTPS_PROXY}" ]
	then
	    echo "${HTTPS_PROXY}"
	elif [ -n "${https_proxy}" ]
	then
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
    
#
# generate Dockerfile
#

#!!!docker_file_components=$(
#!!!    (
#!!!	ls -1 ${HERE}/*-Dockerfile.${architecture}
#!!!	ls -1 ${HERE}/*-Dockerfile.noarch
#!!!    ) | \
#!!!	sort -n
#!!!)
#!!!
#!!!for i in ${docker_file_components}
#!!!do
#!!!    cat $i
#!!!done > "${HERE}/Dockerfile-merged.tmp"

docker build  \
    --force-rm \
    --pull \
    -t "${image_name}:${image_tag}" \
    ${build_arg_switch_list} \
    --file "${HERE}/Dockerfile" \
    ${HERE}
