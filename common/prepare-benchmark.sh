#!/bin/true

# Prepare benchmark files to run test


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
mkdir -p ${BT_RUNBENCHMARKS_DIR} || serpentFail "Failed to create benchmark dir"
pushd ${BT_RUNBENCHMARKS_DIR}

# Setup benchmark for tests
runCommands "${benchmarkSetup[@]}" || serpentFail "Benchmark ${testName} setup failed"
