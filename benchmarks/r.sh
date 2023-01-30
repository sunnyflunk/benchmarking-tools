#!/bin/true

export DATA_BENCHMARK=1
benchmarkSources=("rbenchmarks")
benchmarkSetup=("tar xf ${BT_CACHE_DIR}/rbenchmarks-20160105.tar.bz2")
benchmarkLabels=("R-benchmark-25")
benchmarkTest=("Rscript rbenchmarks/R-benchmark-25/R-benchmark-25.R | grep 'Total time for all 15 tests' | cut -d: -f2")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

requireTools cut grep Rscript
