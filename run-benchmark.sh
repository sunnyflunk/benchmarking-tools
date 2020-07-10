#!/usr/bin/env bash

testName=${1}
# Default number of times to run the tests
benchmarkRuns=3
testDistro=`cat /etc/os-release | grep NAME | tail -n1 | cut -d '"' -f 2`
testKernel=`uname -r`
testDate=`date +"%d-%b-%Y"`
executionPath=$(dirname $(realpath -s $0))
BT_BENCHMARKS_DIR=${executionPath}/benchmarks
BT_RUNBENCHMARKS_DIR=/tmp/benchmark/${testName}
BT_SOURCES_DIR=${executionPath}/sources
# Want this to be shared across installs etc
BT_RESULTS_DIR=~/BT-Results # Find better dir
BT_CACHE_DIR=~/.cache/benchmark-tools


# Import shared functions
. ${executionPath}/common/functions.sh

# Import test information
[ ! -z "${BT_BENCHMARKS_DIR}/${testName}.sh" ] || serpentFail "Benchmark ${testName} doesn't exist"
. ${BT_BENCHMARKS_DIR}/${testName}.sh || serpentFail "Benchmark ${testName} malformed"

# Check needed variables exist (to-do)
# Check arrays are of same length

# Check basic requirements and fetch sources
requireTools curl tar
downloadSource $benchmarkSources


# Run benchmark in RAM to save SSD writes
rm -rf ${BT_RUNBENCHMARKS_DIR} || serpentFail "Failed to remove pre-existing benchmark dir"
mkdir -p ${BT_RESULTS_DIR} || serpentFail "Failed to create results dir"
mkdir -p ${BT_RUNBENCHMARKS_DIR} || serpentFail "Failed to create benchmark dir"
pushd ${BT_RUNBENCHMARKS_DIR}

# Setup benchmark for tests
runCommands "${benchmarkSetup[@]}" || serpentFail "Benchmark ${testName} setup failed"


# Run benchmarks
for run in $(seq 1 1 $benchmarkRuns); do
    for test in "${!benchmarkTest[@]}"; do
        testResult=$(runBenchmark "${benchmarkTest[$test]}")
        testValidation=$(runCommands "${benchmarkValidation[$test]}")

        # Record results
        echo "$testDistro, $testKernel, $testDate, ${benchmarkLabels[$test]}, $testResult, $testValidation" >> ${BT_RESULTS_DIR}/$testName.csv
    done
done
