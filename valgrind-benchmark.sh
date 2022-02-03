#!/usr/bin/env bash

testName=${1}
testLabel=${2}
executionPath=$(dirname $(realpath -s $0))

# If installed, change the path to where it is actually installed
if [ ! -f ${executionPath}/common/variables.sh ]; then
    if [ -f /usr/share/benchmarking-tools/common/variables.sh ]; then
        executionPath=/usr/share/benchmarking-tools
    else
        serpentFail "Can't find benchmarking-tools directory."
        exit 1
    fi
fi
# Import shared variables
. ${executionPath}/common/variables.sh
. ${executionPath}/common/functions.sh

printInfo "Preparing benchmark environment"
. ${executionPath}/common/prepare-benchmark.sh

requireTools valgrind callgrind_annotate
printInfo "Running analysis tools"
for test in "${!benchmarkAnalyze[@]}"; do
    printInfo "Begin analysis test $((test+1)) of ${#benchmarkAnalyze[@]}"
    [ ! -z "${benchmarkPretest[0]}" ] && runCommands "${benchmarkPretest[@]}"

    # Run analyze function
    eval valgrind --trace-children=yes --tool=callgrind  --dump-instr=yes --collect-jumps=yes --callgrind-out-file=${BT_RUNBENCHMARKS_DIR}/callgrind-$test -- "${benchmarkAnalyze[$test]}" || serpentFail "Failed to execute valgrind"

    callgrind_annotate ${BT_RUNBENCHMARKS_DIR}/callgrind-$test | grep PROGRAM | awk '{ print $1 }' | sed 's/,//g' > ${BT_RUNBENCHMARKS_DIR}/callgrindtotalevents || serpentFail "Failed to execute callgrind_annotate"
    callgrind_annotate --threshold=99.99 ${BT_RUNBENCHMARKS_DIR}/callgrind-$test | grep ]$ > ${BT_RUNBENCHMARKS_DIR}/callgrindevents || serpentFail "Failed to execute callgrind_annotate"
    echo "" >> ${BT_RUNBENCHMARKS_DIR}/callgrindevents

    LIBS=`callgrind_annotate --threshold=99.99 ${BT_RUNBENCHMARKS_DIR}/callgrind-$test | grep ]$ | cut -d '[' -f 2 | sed -e 's/\]//' | sort | uniq`
    for i in ${LIBS}; do
        SIZE=`cat ${BT_RUNBENCHMARKS_DIR}/callgrindevents | grep ${i} | sed 's/,//g' | awk '{s+=$1} END {printf "%.0f", s}'`

        echo "${i},${SIZE}" >> ${BT_RUNBENCHMARKS_DIR}/callgrindresults
        echo "${SIZE} ${i}" >> ${BT_RUNBENCHMARKS_DIR}/callgrindtmp
    done
    cat ${BT_RUNBENCHMARKS_DIR}/callgrindtotalevents >> ${BT_RUNBENCHMARKS_DIR}/callgrindtmp
    cat ${BT_RUNBENCHMARKS_DIR}/callgrindtmp | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | sort -n | column -t -R1 >> ${BT_RUNBENCHMARKS_DIR}/callgrindevents

    cp ${BT_RUNBENCHMARKS_DIR}/callgrindevents ${BT_RESULTS_DIR}/valgrind-$testName-$testLabel-$testDate-$test
    rm -rf ${BT_RUNBENCHMARKS_DIR}/{callgrind*,perf} || serpentFail "Failed to clean up temporary files"
    [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[@]}"
done
