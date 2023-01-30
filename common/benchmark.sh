#!/bin/true

# Run and record benchmark information
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    measuredResult=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        [ ! -z "${benchmarkPretest[$test]}" ] && runCommands "${benchmarkPretest[$test]}"
        if [ -z ${DATA_BENCHMARK} ]; then
            eval "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test -- ${benchmarkTest[$test]} > /dev/null 2>&1"
            stepResult=$(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }')
        else
            stepResult=$(runCommands "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test -- ${benchmarkTest[$test]}")
        fi
        measuredResult=$(awk "BEGIN {print $measuredResult+$stepResult; exit}")
        [ ! -z "${benchmarkPosttest[$test]}" ] && runCommands "${benchmarkPosttest[$test]}"
    done
    echo $(awk "BEGIN {print $measuredResult/${benchmarkRepetition[$test]}; exit}")
}

# Run and record benchmark information
function runBenchmarkRepeat()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    eval "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test --repeat=${benchmarkRepetition[$test]} -- ${benchmarkTest[$test]} > /dev/null 2>&1"
    echo $(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }')
}

requireTools awk grep perf seq
