#!/bin/true

# Import functions for this benchmark
. ${executionPath}/benchmarks/helpers/linux-kernel.sh

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

requireTools bzip2 cut wc
