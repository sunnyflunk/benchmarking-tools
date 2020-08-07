#!/bin/true

. ${executionPath}/benchmarks/helpers/linux-kernel.sh
benchmarkLabels=("Compress Kernel (-3)"
                 "Compress Kernel (-9)"
                 "Decompress Kernel")
benchmarkTest=("gzip -k -f -3 linux.tar"
               "gzip -k -f -9 linux.tar"
               "gzip -d -k -f linux.tar.gz")
benchmarkValidation=("wc -c linux.tar.gz | cut -d ' ' -f 1"
                     "wc -c linux.tar.gz | cut -d ' ' -f 1"
                     "wc -c linux.tar | cut -d ' ' -f 1")
benchmarkRepetition=(1
                     1
                     3)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools gzip
