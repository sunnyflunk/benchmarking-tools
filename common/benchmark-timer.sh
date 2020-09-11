#!/bin/true

# Record the time taken for a command to run
function recordTime () {
    START=`date +%s.%N`
    eval "${1}"
    FINISH=`date +%s.%N`
    echo "$FINISH-$START" | bc
}

# Run and record benchmark information
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    measuredTime=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        [ ! -z "${benchmarkPretest[0]}" ] && runCommands "${benchmarkPretest[@]}"
        stepTime=`recordTime "${benchmarkTest[$test]}"`
        measuredTime=`echo "$measuredTime+$stepTime" | bc`
        [ ! -z "${benchmarkPosttest[0]}" ] && runCommands "${benchmarkPosttest[@]}"
    done
    echo $measuredTime
}
