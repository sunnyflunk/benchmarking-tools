#!/bin/true

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh
. ${executionPath}/common/compiler-gcc.sh

benchmarkSources=("gettext")
benchmarkSetup=("cp ${BT_CACHE_DIR}/gettext-0.21.tar.xz ."
                "tar xf gettext-0.21.tar.xz"
                "echo \"CC=${CC} CXX=${CXX} ../configure > $BT_RUNBENCHMARKS_DIR/build.log\" > gettext-0.21/configure.sh")
benchmarkLabels=("Configure gettext")
benchmarkPretest=("cd $BT_RUNBENCHMARKS_DIR/gettext-0.21 && rm -rf build && mkdir build && cd build")
benchmarkTest=("sh ../configure.sh")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )
