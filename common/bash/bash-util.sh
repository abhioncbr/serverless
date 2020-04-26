function check_prereq() {
    COMMAND=$1
    which $COMMAND >/dev/null 2>&1 || export EXIT_CODE=$? && true
    if [ ${EXIT_CODE:-0} -ne 0 ]; then
        eerror "You need to install ${COMMAND}"
    fi
}

function validate_conf_file() {
    set +o nounset
    if [ -z $1 ]; then
        eerror "Please provide a valid conf file"
    fi
    set -o nounset

    CONF_FILE=$1
    if [ -f ${CONF_FILE} ]; then
        set -o allexport
        source ${CONF_FILE}
        set +o allexport
    else
        eerror "Please provide a valid conf file"
    fi
}

function download_file(){
    FILE=$1
    OUTPUT_PATH=$2
    wget ${FILE} -O "$OUTPUT_PATH/${FILE##*/}" --quiet
}