#!/usr/bin/env bash

testName=${1}
testLabel=${2}
executionPath=$(dirname $(realpath -s $0))

# Import shared variables
. ${executionPath}/common/variables.sh
. ${executionPath}/common/functions.sh

printInfo "Preparing benchmark environment"
. ${executionPath}/common/prepare-benchmark.sh

requireTools perf
printInfo "Running analysis tools"
for test in "${!benchmarkAnalyze[@]}"; do
    printInfo "Begin analysis test $((test+1)) of ${#benchmarkAnalyze[@]}"
    [ ! -z "${benchmarkPretest[0]}" ] && runCommands "${benchmarkPretest[@]}"

    # Run analyze function
    eval perf record -z -F 15000 -o ${BT_RUNBENCHMARKS_DIR}/perf-$test.data -- "${benchmarkAnalyze[$test]}" || serpentFail "Failed to record perf"

    eval perf report --stdio --sort dso,sym --percent-limit 0.05 -i ${BT_RUNBENCHMARKS_DIR}/perf-$test.data | grep -v "^#" > ${BT_RESULTS_DIR}/perf-$testName-$testLabel-$testDate-$test
    echo "" >> ${BT_RESULTS_DIR}/perf-$testName-$testLabel-$testDate-$test
    eval perf report --stdio --sort dso -i ${BT_RUNBENCHMARKS_DIR}/perf-$test.data | grep -v "^#" >> ${BT_RESULTS_DIR}/perf-$testName-$testLabel-$testDate-$test
    [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[@]}"
done
