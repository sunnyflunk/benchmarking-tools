#!/bin/true

export DATA_BENCHMARK=1
benchmarkSources=("pybench")
benchmarkSetup=("tar xf ${BT_CACHE_DIR}/pybench-2018-02-16.tar.gz"
                "cd pybench-2018-02-16")
benchmarkLabels=("Pybench")
benchmarkTest=("python3 pybench.py | grep ^Totals | cut -ds -f3 | cut -dm -f1")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

requireTools cut grep python3
