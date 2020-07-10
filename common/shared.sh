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
    sourceFile="${executionPath}/sources/${1}"
    [ -f "${sourceFile}" ] || serpentFail "Missing source file: ${sourceFile}"
    sourceURL="$(cat ${sourceFile} | cut -d ' ' -f 1)"
    sourceHash="$(cat ${sourceFile} | cut -d ' ' -f 2)"
    [ ! -z "${sourceURL}" ] || serpentFail "Missing URL for source: $1"
    [ ! -z "${sourceHash}" ] || serpentFail "Missing hash for source: $1"
    sourcePathBase=$(basename "${sourceURL}")
    sourcePath="${downloadCache}/${sourcePathBase}"

    printInfo "Computing hash for ${sourcePathBase}"

    computeHash=$(sha256sum "${sourcePath}" | cut -d ' ' -f 1)
    [ $? -eq 0 ] || serpentFail "Failed to compute SHA256sum"

    [ "${computeHash}" == "${sourceHash}" ] || serpentFail "Corrupt download: ${sourcePath}"
}

# Download a file from sources/
function downloadSource()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of downloadSource"
    sourceFile="${executionPath}/sources/${1}"
    [ -f "${sourceFile}" ] || serpentFail "Missing source file: ${sourceFile}"
    sourceURL="$(cat ${sourceFile} | cut -d ' ' -f 1)"
    sourceHash="$(cat ${sourceFile} | cut -d ' ' -f 2)"
    [ ! -z "${sourceURL}" ] || serpentFail "Missing URL for source: $1"
    [ ! -z "${sourceHash}" ] || serpentFail "Missing hash for source: $1"
    sourcePathBase=$(basename "${sourceURL}")
    sourcePath="${downloadCache}/${sourcePathBase}"

    mkdir -p "${downloadCache}" || serpentFail "Failed to create download tree"

    if [[ -f "${sourcePath}" ]]; then
        printInfo "Skipping download of ${sourcePathBase}"
        return
    fi

    printInfo "Downloading ${sourcePathBase}"
    curl -L --output "${sourcePath}" "${sourceURL}"
    verifyDownload "${1}"
}
