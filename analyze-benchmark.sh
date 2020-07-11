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
    rm -rf ${BT_RUNBENCHMARKS_DIR}/{callgrind*,perf} || serpentFail "Failed to clean up temporary files"
    eval valgrind --trace-children=yes --tool=callgrind "${benchmarkAnalyze[$test]}" || serpentFail "Failed to execute valgrind"
    eval perf stat -B -e task-clock,cycles,instructions,L1-icache-misses,iTLB-load-misses,cache-references,cache-misses,branches,branch-misses,faults,migrations -o ${BT_RUNBENCHMARKS_DIR}/perf -- "${benchmarkAnalyze[$test]}" || serpentFail "Failed to execute perf"
    eval perf record -e cycles:u -j any,u -F 12000 -o ${BT_RUNBENCHMARKS_DIR}/perf.data -- "${benchmarkAnalyze[$test]}" || serpentFail "Failed to execute perf"

    callgrind_annotate ${BT_RUNBENCHMARKS_DIR}/callgrind.out.* | grep PROGRAM | awk '{ print $1 }' | sed 's/,//g' > ${BT_RUNBENCHMARKS_DIR}/callgrindtotalevents || serpentFail "Failed to execute callgrind_annotate"
    callgrind_annotate --threshold=99.99 ${BT_RUNBENCHMARKS_DIR}/callgrind.out.* | grep ]$ > ${BT_RUNBENCHMARKS_DIR}/callgrindevents || serpentFail "Failed to execute callgrind_annotate"
    echo "" >> ${BT_RUNBENCHMARKS_DIR}/callgrindevents

    LIBS=`callgrind_annotate --threshold=99.99 ${BT_RUNBENCHMARKS_DIR}/callgrind.out.* | grep ]$ | cut -d '[' -f 2 | sed -e 's/\]//' | sort | uniq`
    for i in ${LIBS}; do
        SIZE=`cat ${BT_RUNBENCHMARKS_DIR}/callgrindevents | grep ${i} | sed 's/,//g' | awk '{s+=$1} END {printf "%.0f", s}'`

        echo "${i},${SIZE}" >> ${BT_RUNBENCHMARKS_DIR}/callgrindresults
        echo "${SIZE} ${i}" >> ${BT_RUNBENCHMARKS_DIR}/callgrindtmp
    done
    cat ${BT_RUNBENCHMARKS_DIR}/callgrindtotalevents >> ${BT_RUNBENCHMARKS_DIR}/callgrindtmp
    cat ${BT_RUNBENCHMARKS_DIR}/callgrindtmp | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | sort -n | column -t -R1 >> ${BT_RUNBENCHMARKS_DIR}/callgrindevents
    echo "" >> ${BT_RUNBENCHMARKS_DIR}/callgrindevents
    cat ${BT_RUNBENCHMARKS_DIR}/perf >> ${BT_RUNBENCHMARKS_DIR}/callgrindevents

    cp ${BT_RUNBENCHMARKS_DIR}/callgrindevents ${BT_RESULTS_DIR}/Perf-$testName-$testDate-$test
    rm -rf ${BT_RUNBENCHMARKS_DIR}/{callgrind*,perf} || serpentFail "Failed to clean up temporary files"
    [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[@]}"
done
