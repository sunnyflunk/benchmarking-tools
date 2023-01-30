#!/usr/bin/env bash

testName=${1}
testLabel=${2}
executionPath=$(dirname $(realpath -s $0))
# Default number of times to run the tests
benchmarkRuns=4
kernelPerf=$(cat /proc/sys/kernel/perf_event_paranoid)
perfCommand="perf stat -e power/energy-psys/,power/energy-pkg/,power/energy-cores/,power/energy-gpu/,power/energy-ram/"
# Make benchmark function also report the power average power data
POWER_BENCHMARK=1

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
. ${executionPath}/common/benchmark.sh

for run in $(seq 1 1 ${benchmarkRuns}); do
    printInfo "Begin iteration $run of ${benchmarkRuns}"
    for test in "${!benchmarkTest[@]}"; do
        # Wait to settle system after previous test
        sleep 10

        # If possible run the repeats through perf
        if [ -z "${benchmarkPretest[$test]}" ] && [ -z "${benchmarkPosttest[$test]}" ] && [ -z "${DATA_BENCHMARK}" ]; then
            tmpResult=$(runBenchmarkRepeat "${benchmarkTest[$test]}")
        else
            tmpResult=$(runBenchmark "${benchmarkTest[$test]}")
        fi
        testResult=$(echo ${tmpResult} | cut -f1 -d' ')
        testValidation=$(runCommands "${benchmarkValidation[$test]}")

        testPsys=$(echo ${tmpResult} | cut -f2 -d' ')
        testPkg=$(echo ${tmpResult} | cut -f3 -d' ')
        testCores=$(echo ${tmpResult} | cut -f4 -d' ')
        testGPU=$(echo ${tmpResult} | cut -f5 -d' ')
        testRam=$(echo ${tmpResult} | cut -f6 -d' ')

        # Record results
        echo "$testName,$testLabel,$testDistro,$testKernel,$testDate,${benchmarkLabels[$test]},$testResult,$testValidation,$testPsys,$testPkg,$testCores,$testGPU,$testRam" >> ${BT_RESULTS_DIR}/results-power.csv
    done
done
