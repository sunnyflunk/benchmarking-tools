#!/bin/true

. ${executionPath}/benchmarks/helpers/linux-kernel.sh
benchmarkLabels=("Compress Kernel (-3 -T1)"
                 "Compress Kernel (-9 -T4)"
                 "Decompress Kernel")
benchmarkTest=("xz -z -k -f -3 -T1 linux.tar"
               "xz -z -k -f -9 -T4 linux.tar"
               "xz -d -k -f linux.tar.xz")
benchmarkValidation=("wc -c linux.tar.xz | cut -d ' ' -f 1"
                     "wc -c linux.tar.xz | cut -d ' ' -f 1"
                     "wc -c linux.tar | cut -d ' ' -f 1")
benchmarkRepetition=(1
                     1
                     2)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools cut xz wc
