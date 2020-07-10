#!/bin/true

# Common functionality between all scripts


# Emit a warning to tty
function printWarning()
{
    echo -en '\e[1m\e[93m[WARNING]\e[0m '
    echo $*
}

# Emit an error to tty
function printError()
{
    echo -en '\e[1m\e[91m[ERROR]\e[0m '
    echo $*
}

# Emit info to tty
function printInfo()
{
    echo -en '\e[1m\e[94m[INFO]\e[0m '
    echo $*
}

# Failed to do a thing. Exit fatally.
function serpentFail()
{
    printError $*
    exit 1
}

function requireTools()
{
    for tool in $* ; do
        which "${tool}" &>/dev/null  || serpentFail "Missing host executable: ${tool}"
    done
}

# Verify the download is correct
function verifyDownload()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of verifyDownload"
    sourceFile="${BT_SOURCES_DIR}/${1}"
    [ -f "${sourceFile}" ] || serpentFail "Missing source file: ${sourceFile}"
    sourceURL="$(cat ${sourceFile} | cut -d ' ' -f 1)"
    sourceHash="$(cat ${sourceFile} | cut -d ' ' -f 2)"
    [ ! -z "${sourceURL}" ] || serpentFail "Missing URL for source: $1"
    [ ! -z "${sourceHash}" ] || serpentFail "Missing hash for source: $1"
    sourcePathBase=$(basename "${sourceURL}")
    sourcePath="${BT_CACHE_DIR}/${sourcePathBase}"

    printInfo "Computing hash for ${sourcePathBase}"

    computeHash=$(sha256sum "${sourcePath}" | cut -d ' ' -f 1)
    [ $? -eq 0 ] || serpentFail "Failed to compute SHA256sum"

    [ "${computeHash}" == "${sourceHash}" ] || serpentFail "Corrupt download: ${sourcePath}"
}

# Download a file from sources/
function downloadSource()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of downloadSource"
    sourceFile="${BT_SOURCES_DIR}/${1}"
    [ -f "${sourceFile}" ] || serpentFail "Missing source file: ${sourceFile}"
    sourceURL="$(cat ${sourceFile} | cut -d ' ' -f 1)"
    sourceHash="$(cat ${sourceFile} | cut -d ' ' -f 2)"
    [ ! -z "${sourceURL}" ] || serpentFail "Missing URL for source: $1"
    [ ! -z "${sourceHash}" ] || serpentFail "Missing hash for source: $1"
    sourcePathBase=$(basename "${sourceURL}")
    sourcePath="${BT_CACHE_DIR}/${sourcePathBase}"

    mkdir -p "${BT_CACHE_DIR}" || serpentFail "Failed to create download tree"

    if [[ -f "${sourcePath}" ]]; then
        printInfo "Skipping download of ${sourcePathBase}"
        return
    fi

    printInfo "Downloading ${sourcePathBase}"
    curl -L --output "${sourcePath}" "${sourceURL}"
    verifyDownload "${1}"
}

# Run an array of commands
function runCommands()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runCommands"
    arrayCommands=( "${@}" )
    for step in ${!arrayCommands[@]}; do
        eval ${arrayCommands[$step]}
    done
}

# Record the time taken for a command to run
function recordTime () {
    START=`date +%s.%N`
    eval "${1}"
    FINISH=`date +%s.%N`
    echo "$FINISH-$START" | bc
}

# Run and record benchmark information
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    arrayCommands=( "${@}" )
    measuredTime=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        for step in ${!arrayCommands[@]}; do
            stepTime=`recordTime "${arrayCommands[$step]}"`
            measuredTime=`echo "$measuredTime+$stepTime" | bc`
        done
    done
    echo $measuredTime
}
