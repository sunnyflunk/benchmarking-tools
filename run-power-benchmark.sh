#!/usr/bin/env bash

testName=${1}
testLabel=${2}
executionPath=$(dirname $(realpath -s $0))
# Default number of times to run the tests
benchmarkRuns=3
kernelPerf=$(cat /proc/sys/kernel/perf_event_paranoid)
perfCommand="perf stat -e power/energy-psys/,power/energy-pkg/,power/energy-cores/,power/energy-gpu/,power/energy-ram/"

if [ ${kernelPerf} -ge 1 ];
then
    echo "You need to set /proc/sys/kernel/perf_event_paranoid to 0 or lower to get power events without sudo."
    exit 1
fi

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

# Override some values, we need timer function for per /s W values and force one repetition as that's all that's measured
. ${executionPath}/common/benchmark-timer.sh
benchmarkRepetition=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)

for run in $(seq 1 1 ${benchmarkRuns}); do
    printInfo "Begin iteration $run of ${benchmarkRuns}"
    for test in "${!benchmarkTest[@]}"; do
        # If possible run the repeats through perf
        testResult=$(runBenchmark "${benchmarkTest[$test]}")
        testValidation=$(runCommands "${benchmarkValidation[$test]}")

        testPsys=$(grep "/energy-psys" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        testPkg=$(grep "/energy-pkg" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        testCores=$(grep "/energy-cores" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        testGPU=$(grep "/energy-gpu" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')
        testRam=$(grep "/energy-ram" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g')

        # Record results
        echo "$testName,$testLabel,$testDistro,$testKernel,$testDate,${benchmarkLabels[$test]},$benchmarkNote,$testResult,$testValidation,$testPsys,$testPkg,$testCores,$testGPU,$testRam" >> ${BT_RESULTS_DIR}/results-power.csv

        # Sleep to let the system go back to normal
        sleep 2
    done
done
