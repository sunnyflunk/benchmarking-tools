#!/usr/bin/env bash

testName=${1}
testLabel=${2}
executionPath=$(dirname $(realpath -s $0))
# Default number of times to run the tests
benchmarkRuns=3

# Import shared variables
. ${executionPath}/common/variables.sh
. ${executionPath}/common/functions.sh

printInfo "Preparing benchmark environment"
. ${executionPath}/common/prepare-benchmark.sh

# Ensure results directory exists
mkdir -p ${BT_RESULTS_DIR} || serpentFail "Failed to create results dir"

for run in $(seq 1 1 ${benchmarkRuns}); do
    printInfo "Begin iteration $run of ${benchmarkRuns}"
    for test in "${!benchmarkTest[@]}"; do
        # If possible run the repeats through perf
        if [ -z "${benchmarkPretest[$test]}" ] && [ -z "${benchmarkPosttest[$test]}" ]; then
            testResult=$(runBenchmarkRepeat "${benchmarkTest[$test]}")
        else
            testResult=$(runBenchmark "${benchmarkTest[$test]}")
        fi
        testValidation=$(runCommands "${benchmarkValidation[$test]}")

        testInstructions=$(grep " instructions.u" perf-$test | grep -v "not counted" | awk '{ print $1 }' | sed 's/,//g')
        testCycles=$(grep " cycles.u" perf-$test | grep -v "not counted" | awk '{ print $1 }' | sed 's/,//g')
        testL1CacheMisses=$(grep " L1-icache-misses.u" perf-$test | grep -v "not counted" | awk '{ print $1 }' | sed 's/,//g')
        testCacheReferences=$(grep " cache-references.u" perf-$test | grep -v "not counted" | awk '{ print $1 }' | sed 's/,//g')
        testCacheMisses=$(grep " cache-misses.u" perf-$test | grep -v "not counted" | awk '{ print $1 }' | sed 's/,//g')
        testBranches=$(grep " branches.u" perf-$test | grep -v "not counted" | awk '{ print $1 }' | sed 's/,//g')
        testBranchMisses=$(grep " branch-misses.u" perf-$test | grep -v "not counted" | awk '{ print $1 }' | sed 's/,//g')

        # Record results
        echo "$testLabel,$testDistro,$testKernel,$testDate,${benchmarkLabels[$test]},$benchmarkNote,$testResult,$testValidation,$testInstructions,$testCycles,$testL1CacheMisses,$testCacheReferences,$testCacheMisses,$testBranches,$testBranchMisses" >> ${BT_RESULTS_DIR}/$testName.csv
    done
done
