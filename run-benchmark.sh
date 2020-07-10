#!/usr/bin/env bash

testName=${1}
executionPath=$(dirname $(realpath -s $0))
BT_BENCHMARKS_DIR=${executionPath}/benchmarks
BT_RUNBENCHMARKS_DIR=/tmp/benchmark/${testName}
BT_SOURCES_DIR=${executionPath}/sources
# Want this to be shared across installs etc
BT_RESULTS_DIR=~/BT-Results # Find better dir
BT_CACHE_DIR=~/.cache/benchmark-tools


# Import shared functions
. ${executionPath}/common/shared.sh

# Import test information
[ ! -z "${BT_BENCHMARKS_DIR}/${testName}.sh" ] || serpentFail "Benchmark ${testName} doesn't exist"
. ${BT_BENCHMARKS_DIR}/${testName}.sh || serpentFail "Benchmark ${testName} malformed"

# Check needed variables exist (to-do)

# Check basic requirements and fetch sources
requireTools curl tar
downloadSource $benchmarkSources


# Run benchmark in RAM to save SSD writes
rm -rf ${BT_RUNBENCHMARKS_DIR} || serpentFail "Failed to remove pre-existing benchmark dir"
mkdir -p ${BT_RUNBENCHMARKS_DIR} || serpentFail "Failed to create benchmark dir"
pushd ${BT_RUNBENCHMARKS_DIR}

# Setup benchmark for tests
runCommands "${benchmarkSetup[@]}" || serpentFail "Benchmark ${testName} setup failed"


# Run benchmarks
runCommands "${benchmarkTest[@]}"


# For debugging
echo ${1}
echo $executionPath
echo $benchmarkSources
ls ${BT_RUNBENCHMARKS_DIR}
