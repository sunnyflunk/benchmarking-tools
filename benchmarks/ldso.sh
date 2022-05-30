#!/bin/true

benchmarkLabels=("Load time")
benchmarkTest=("llvm-nm --help > /dev/null")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(7)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools llvm-nm
