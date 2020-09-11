#!/usr/bin/env bash

testName=${1}
executionPath=$(dirname $(realpath -s $0))

# Import shared variables
. ${executionPath}/common/variables.sh
. ${executionPath}/common/functions.sh

printInfo "Preparing benchmark environment"
. ${executionPath}/common/prepare-benchmark.sh

requireTools perf valgrind callgrind_annotate
printInfo "Running analysis tools"
for test in "${!benchmarkAnalyze[@]}"; do
    printInfo "Begin analysis test $((test+1)) of ${#benchmarkAnalyze[@]}"
    [ ! -z "${benchmarkPretest[0]}" ] && runCommands "${benchmarkPretest[@]}"

    # Run analyze function
    rm -rf ${BT_RUNBENCHMARKS_DIR}/perf* || serpentFail "Failed to clean up temporary files"
    eval perf record -z -F 15000 -o ${BT_RUNBENCHMARKS_DIR}/perf.data -- "${benchmarkAnalyze[$test]}" || serpentFail "Failed to record perf"
    [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[@]}"
    [ ! -z "${benchmarkPretest[0]}" ] && runCommands "${benchmarkPretest[@]}"
    eval perf stat -B -e task-clock,cycles,instructions,L1-icache-misses,iTLB-load-misses,cache-references,cache-misses,branches,branch-misses,faults,migrations -o ${BT_RUNBENCHMARKS_DIR}/perf -- "${benchmarkAnalyze[$test]}" || serpentFail "Failed to execute perf"

    eval perf report --stdio --sort dso,sym --percent-limit 0.05 -i ${BT_RUNBENCHMARKS_DIR}/perf.data | grep -v "^#" > ${BT_RESULTS_DIR}/Perf-$testName-$testDate-$test
    echo "" >> ${BT_RESULTS_DIR}/Perf-$testName-$testDate-$test
    eval perf report --stdio --sort dso -i ${BT_RUNBENCHMARKS_DIR}/perf.data | grep -v "^#" >> ${BT_RESULTS_DIR}/Perf-$testName-$testDate-$test
    echo "" >> ${BT_RESULTS_DIR}/Perf-$testName-$testDate-$test
    cat ${BT_RUNBENCHMARKS_DIR}/perf >> ${BT_RESULTS_DIR}/Perf-$testName-$testDate-$test
    rm -rf ${BT_RUNBENCHMARKS_DIR}/perf* || serpentFail "Failed to clean up temporary files"
    [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[@]}"
done
