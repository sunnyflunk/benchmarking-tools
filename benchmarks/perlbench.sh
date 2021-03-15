#!/bin/true

benchmarkSources=("perlbench")
benchmarkSetup=("tar xf ${BT_CACHE_DIR}/release-1.002.tar.gz"
                "cd perlbench-release-1.002")
benchmarkLabels=("PerlBench podhtml.b"
                 "PerlBench noprog.b")
benchmarkPretest=("rm -rf $BT_RUNBENCHMARKS_DIR/perlbench-release-1.002/perlbench-results/*/perls/*/tests/*.pb")
benchmarkTest=("./perlbench-runtests benchmarks/app/podhtml.b > /dev/null && cat perlbench-results/*/perls/*/tests/*.pb | grep Avg | cut -d' ' -f2"
               "./perlbench-runtests benchmarks/startup/noprog.b > /dev/null && cat perlbench-results/*/perls/*/tests/*.pb | grep Avg | cut -d' ' -f2")
benchmarkValidation=("echo '0'"
                     "echo '0'")
benchmarkRepetition=(1
                     1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-result.sh

requireTools cat cut grep perl
