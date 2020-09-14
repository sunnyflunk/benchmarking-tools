#!/bin/true

# Run and record benchmark result
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    measuredTime=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        [ ! -z "${benchmarkPretest[0]}" ] && runCommands "${benchmarkPretest[$test]}"
        stepTime=$(runCommands "${benchmarkTest[$test]}")
        measuredTime=$(awk "BEGIN {print $measuredTime+$stepTime; exit}")
        [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[$test]}"
    done
    echo $measuredTime
}
