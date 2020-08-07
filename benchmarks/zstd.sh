#!/bin/true

benchmarkSources=("linux-kernel")
benchmarkSetup=("cp ${BT_CACHE_DIR}/linux-4.0.tar.xz ."
                "xz -d linux-4.0.tar.xz"
                "mv linux-4.0.tar linux.tar")
benchmarkLabels=("Compress Kernel (-8 -T1)"
                 "Compress Kernel (-19 -T4)"
                 "Decompress Kernel")
benchmarkTest=("zstd -k -f -8 -T1 linux.tar -o linux.tar.zst"
               "zstd -k -f -19 -T4 linux.tar -o linux.tar.zst"
               "zstd -d -k -f linux.tar.zst -o linux.tar")
benchmarkValidation=("wc -c linux.tar.zst | cut -d ' ' -f 1"
                     "wc -c linux.tar.zst | cut -d ' ' -f 1"
                     "wc -c linux.tar | cut -d ' ' -f 1")
benchmarkRepetition=(1
                     1
                     5)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools zstd
