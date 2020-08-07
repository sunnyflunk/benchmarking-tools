#!/bin/true

benchmarkSources=("linux-kernel")
benchmarkSetup=("cp ${BT_CACHE_DIR}/linux-4.0.tar.xz ."
                "xz -d linux-4.0.tar.xz"
                "mv linux-4.0.tar linux.tar")
benchmarkLabels=("Compress Kernel (-5)"
                 "Compress Kernel (--best)"
                 "Decompress Kernel")
benchmarkTest=("lz4 -z -f -5 linux.tar linux.tar.lz4"
               "lz4 -z -f --best linux.tar linux.tar.lz4"
               "lz4 -d -f linux.tar.lz4 linux.tar")
benchmarkValidation=("wc -c linux.tar.lz4 | cut -d ' ' -f 1"
                     "wc -c linux.tar.lz4 | cut -d ' ' -f 1"
                     "wc -c linux.tar | cut -d ' ' -f 1")
benchmarkRepetition=(2
                     1
                     10)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools lz4
