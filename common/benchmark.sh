#!/bin/true

# Run and record benchmark information
function runBenchmark()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    measuredResult=0
    measuredPsys=0
    measuredPkg=0
    measuredCores=0
    measuredGPU=0
    measuredRam=0
    for run in $(seq 1 1 "${benchmarkRepetition[$test]}"); do
        [ ! -z "${benchmarkPretest[$test]}" ] && runCommands "${benchmarkPretest[$test]}"
        if [ -z ${DATA_BENCHMARK} ]; then
            eval "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test -- ${benchmarkTest[$test]} > /dev/null 2>&1"
            stepResult=$(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }')
        else
            stepResult=$(runCommands "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test -- ${benchmarkTest[$test]}")
        fi
        measuredResult=$(awk "BEGIN {print $measuredResult+$stepResult; exit}")

        if [ ! -z ${POWER_BENCHMARK} ]; then
            stepPsys=$(grep "/energy-psys" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
            stepPkg=$(grep "/energy-pkg" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
            stepCores=$(grep "/energy-cores" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
            stepGPU=$(grep "/energy-gpu" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
            stepRam=$(grep "/energy-ram" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')

            measuredPsys=$(awk "BEGIN {print $measuredPsys+$stepPsys; exit}")
            measuredPkg=$(awk "BEGIN {print $measuredPkg+$stepPkg; exit}")
            measuredCores=$(awk "BEGIN {print $measuredCores+$stepCores; exit}")
            measuredGPU=$(awk "BEGIN {print $measuredGPU+$stepGPU; exit}")
            measuredRam=$(awk "BEGIN {print $measuredRam+$stepRam; exit}")
        fi
        [ ! -z "${benchmarkPosttest[$test]}" ] && runCommands "${benchmarkPosttest[$test]}"
    done

    avgResult=$(awk "BEGIN {print $measuredResult/${benchmarkRepetition[$test]}; exit}")
    if [ ! -z ${POWER_BENCHMARK} ]; then
        avgPsys=$(awk "BEGIN {print $measuredPsys/${benchmarkRepetition[$test]}; exit}")
        avgPkg=$(awk "BEGIN {print $measuredPkg/${benchmarkRepetition[$test]}; exit}")
        avgCores=$(awk "BEGIN {print $measuredCores/${benchmarkRepetition[$test]}; exit}")
        avgGPU=$(awk "BEGIN {print $measuredGPU/${benchmarkRepetition[$test]}; exit}")
        avgRam=$(awk "BEGIN {print $measuredRam/${benchmarkRepetition[$test]}; exit}")
    fi
    echo $avgResult $avgPsys $avgPkg $avgCores $avgGPU $avgRam
}

# Run and record benchmark information
function runBenchmarkRepeat()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of runBenchmark"
    eval "${perfCommand} -o ${BT_RUNBENCHMARKS_DIR}/perf-$test --repeat=${benchmarkRepetition[$test]} -- ${benchmarkTest[$test]} > /dev/null 2>&1"
    avgResult=$(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-$test | awk '{ print $1 }')
    if [ ! -z ${POWER_BENCHMARK} ]; then
        avgPsys=$(grep "/energy-psys" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        avgPkg=$(grep "/energy-pkg" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        avgCores=$(grep "/energy-cores" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        avgGPU=$(grep "/energy-gpu" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        avgRam=$(grep "/energy-ram" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
    fi
    echo $avgResult $avgPsys $avgPkg $avgCores $avgGPU $avgRam

}

requireTools awk grep perf seq
