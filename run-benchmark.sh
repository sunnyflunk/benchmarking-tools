#!/usr/bin/env bash

executionPath=$(dirname $(realpath -s $0))

# Import test information
testName=${1}
[ ! -z "${executionPath}/benchmarks/${testName}.sh" ] || serpentFail "Benchmark ${testName} doesn't exist"
. ${executionPath}/benchmarks/${testName}.sh || serpentFail "Benchmark ${testName} malformed"

# Run benchmark in RAM to save SSD writes
mkdir -p /tmp/benchmark/${testName} && pushd /tmp/benchmark/${testName}


# For debugging
echo ${1}
echo $executionPath
