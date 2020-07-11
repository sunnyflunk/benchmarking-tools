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
    arrayCommands=( "${@}" )
    measuredTime=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        for step in ${!arrayCommands[@]}; do
            stepTime=`recordTime "${arrayCommands[$step]}"`
            measuredTime=`echo "$measuredTime+$stepTime" | bc`
        done
    done
    echo $measuredTime
}
