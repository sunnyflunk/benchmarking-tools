#!/bin/true

benchmarkSources=("pybench")
benchmarkSetup=("tar xf ${BT_CACHE_DIR}/pybench-2018-02-16.tar.gz"
                "cd pybench-2018-02-16")
benchmarkLabels=("Pybench")
benchmarkTest=("python3 pybench.py > /tmp/pybench 2>&1 && cat /tmp/pybench | grep ^Totals | cut -ds -f3 | cut -dm -f1")
benchmarkPosttest=("rm /tmp/pybench")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-result.sh

requireTools cut grep python3
