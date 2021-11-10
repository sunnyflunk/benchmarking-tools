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

# Import shared variables
. ${executionPath}/common/variables.sh
. ${executionPath}/common/functions.sh

printInfo "Preparing benchmark environment"
. ${executionPath}/common/prepare-benchmark.sh

# Override some values, we need timer function for per /s W values and force one repetition as that's all that's measured
. ${executionPath}/common/benchmark-timer.sh
benchmarkRepetition=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)

# Generate idle data for each field
perf stat -e power/energy-psys/,power/energy-pkg/,power/energy-cores/,power/energy-gpu/,power/energy-ram/ -o ${BT_RUNBENCHMARKS_DIR}/perf-idle -- sleep 10

idleTime=$(grep "time elapsed" ${BT_RUNBENCHMARKS_DIR}/perf-idle | awk '{ print $1 }')
idlePsys=$(echo "scale=2; $(grep "/energy-psys" ${BT_RUNBENCHMARKS_DIR}/perf-idle | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') / ${idleTime}" | bc)
idlePkg=$(echo "scale=2; $(grep "/energy-pkg" ${BT_RUNBENCHMARKS_DIR}/perf-idle | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') / ${idleTime}" | bc)
idleCores=$(echo "scale=2; $(grep "/energy-cores" ${BT_RUNBENCHMARKS_DIR}/perf-idle | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') / ${idleTime}" | bc)
idleGPU=$(echo "scale=2; $(grep "/energy-gpu" ${BT_RUNBENCHMARKS_DIR}/perf-idle | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') / ${idleTime}" | bc)
idleRam=$(echo "scale=2; $(grep "/energy-ram" ${BT_RUNBENCHMARKS_DIR}/perf-idle | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') / ${idleTime}" | bc)
echo "$idlePsys,$idlePkg,$idleCores,$idleGPU,$idleRam  ${idleTime}"

# Ensure results directory exists
mkdir -p ${BT_RESULTS_DIR} || serpentFail "Failed to create results dir"

for run in $(seq 1 1 ${benchmarkRuns}); do
    printInfo "Begin iteration $run of ${benchmarkRuns}"
    for test in "${!benchmarkTest[@]}"; do
        # If possible run the repeats through perf
        testResult=$(runBenchmark "${benchmarkTest[$test]}")
        testValidation=$(runCommands "${benchmarkValidation[$test]}")

        testPsys=$(echo "scale=2; $(grep "/energy-psys" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') - ${idlePsys} * ${testResult}" | bc)
        testPkg=$(echo "scale=2; $(grep "/energy-pkg" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') - ${idlePkg} * ${testResult}" | bc)
        testCores=$(echo "scale=2; $(grep "/energy-cores" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') - ${idleCores} * ${testResult}" | bc)
        testGPU=$(echo "scale=2; $(grep "/energy-gpu" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') - ${idleGPU} * ${testResult}" | bc)
        testRam=$(echo "scale=2; $(grep "/energy-ram" ${BT_RUNBENCHMARKS_DIR}/perf-$test | sed 's|<not|0|' | awk '{ print $1 }' | sed 's/,//g') - ${idleRam} * ${testResult}" | bc)

        # Record results
        echo "$testName,$testLabel,$testDistro,$testKernel,$testDate,${benchmarkLabels[$test]},$benchmarkNote,$testResult,$testValidation,$testPsys,$testPkg,$testCores,$testGPU,$testRam" >> ${BT_RESULTS_DIR}/results-power.csv
    done
done
