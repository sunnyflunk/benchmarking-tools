#!/bin/true

# Record the time taken for a command to run
function recordTime () {
    START=$(date +%s.%N)
    eval "${1}"
    FINISH=$(date +%s.%N)
    echo $(awk "BEGIN {print $FINISH-$START; exit}")
}

# Run and record benchmark information
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    measuredTime=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        [ ! -z "${benchmarkPretest[0]}" ] && runCommands "${benchmarkPretest[$test]}"
        stepTime=$(recordTime "${benchmarkTest[$test]}")
        measuredTime=$(awk "BEGIN {print $measuredTime+$stepTime; exit}")
        [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[$test]}"
    done
    echo $measuredTime
}
