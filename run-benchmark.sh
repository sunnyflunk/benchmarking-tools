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
        testResult=$(runBenchmark "${benchmarkTest[$test]}")
        testValidation=$(runCommands "${benchmarkValidation[$test]}")

        # Record results
        echo "$testLabel,$testDistro,$testKernel,$testDate,${benchmarkLabels[$test]},$benchmarkNote,$testResult,$testValidation" >> ${BT_RESULTS_DIR}/$testName.csv
    done
done
