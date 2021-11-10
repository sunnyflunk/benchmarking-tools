#!/bin/true

# Run and record benchmark information
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    measuredTime=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        [ ! -z "${benchmarkPretest[$test]}" ] && runCommands "${benchmarkPretest[$test]}"
        eval "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test ${benchmarkTest[$test]} -- > /dev/null 2>&1"
        stepTime=$(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }')
        measuredTime=$(awk "BEGIN {print $measuredTime+$stepTime; exit}")
        [ ! -z "${benchmarkPosttest[$test]}" ] && runCommands "${benchmarkPosttest[$test]}"
    done
    echo $(awk "BEGIN {print $measuredTime/${benchmarkRepetition[$test]}; exit}")
}

# Run and record benchmark information
function runBenchmarkRepeat()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    eval "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test --repeat=${benchmarkRepetition[$test]} -- ${benchmarkTest[$test]} > /dev/null 2>&1"
    echo $(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }')
}

requireTools awk grep perf seq
