#!/bin/true

# Record the time taken for a command to run
function recordTime() {
    eval "perf stat -e task-clock,cycles,instructions,L1-icache-misses,cache-references,cache-misses,branches,branch-misses -o ${BT_RUNBENCHMARKS_DIR}/perf-$test -- ${1}"
    echo $(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }' )
}

# Record the time taken for each of x runs
function recordTimeRepeat() {
    eval "perf stat -e task-clock,cycles,instructions,L1-icache-misses,cache-references,cache-misses,branches,branch-misses -o ${BT_RUNBENCHMARKS_DIR}/perf-$test --repeat=${benchmarkRepetition[$test]} -- ${1}"
    echo $(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }' )
}

# Run and record benchmark information
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    measuredTime=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        [ ! -z "${benchmarkPretest[$test]}" ] && runCommands "${benchmarkPretest[$test]}"
        stepTime=$(recordTime "${benchmarkTest[$test]}")
        measuredTime=$(awk "BEGIN {print $measuredTime+$stepTime; exit}")
        [ ! -z "${benchmarkPosttest[$test]}" ] && runCommands "${benchmarkPosttest[$test]}"
    done
    echo $(awk "BEGIN {print $measuredTime/${benchmarkRepetition[$test]}; exit}")
}

# Run and record benchmark information
function runBenchmarkRepeat()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    echo $(recordTimeRepeat "${benchmarkTest[$test]}")
}

requireTools awk grep perf seq
