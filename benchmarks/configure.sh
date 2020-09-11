#!/bin/true

benchmarkSources=("gettext")
benchmarkSetup=("cp ${BT_CACHE_DIR}/gettext-0.21.tar.xz ."
                "tar xf gettext-0.21.tar.xz")
benchmarkLabels=("Configure gettext")
benchmarkPretest=("cd $BT_RUNBENCHMARKS_DIR/gettext-0.21"
                  "rm -rf build"
                  "mkdir build"
                  "cd build")
benchmarkTest=("../configure > $BT_RUNBENCHMARKS_DIR/build.log")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh
. ${executionPath}/common/compiler.sh
