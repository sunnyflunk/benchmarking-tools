#!/bin/true

benchmarkSources=("linux-kernel")
benchmarkSetup=("cp ${BT_CACHE_DIR}/linux-4.0.tar.xz ."
                "xz -d linux-4.0.tar.xz"
                "mv linux-4.0.tar linux.tar")
benchmarkLabels=("Compress Kernel (-3)"
                 "Compress Kernel (-9)"
                 "Decompress Kernel")
benchmarkTest=("bzip2 -z -k -f -3 linux.tar"
               "bzip2 -z -k -f -9 linux.tar"
               "bzip2 -d -k -f linux.tar.bz2")
benchmarkValidation=("wc -c linux.tar.bz2 | cut -d ' ' -f 1"
                     "wc -c linux.tar.bz2 | cut -d ' ' -f 1"
                     "wc -c linux.tar | cut -d ' ' -f 1")
benchmarkRepetition=(1
                     1
                     1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools bzip2
