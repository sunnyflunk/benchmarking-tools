#!/bin/true

. ${executionPath}/benchmarks/helpers/linux-kernel.sh
. ${executionPath}/common/compiler.sh
benchmarkSetup=("${benchmarkSetup[@]}"
                "wget https://raw.githubusercontent.com/madler/zlib/master/test/minigzip.c"
                "${CC} ${CFLAGS} minigzip.c -o minigzipsh -lz"
                "cp linux.tar linux.tar.tmp"
                "./minigzipsh linux.tar"
                "cp linux.tar.gz linux.tar.gz.tmp")
benchmarkLabels=("Compress Kernel"
                 "Decompress Kernel")
benchmarkPretest=("cp linux.tar.tmp linux.tar && rm -f linux.tar.gz"
                  "cp linux.tar.gz.tmp linux.tar.gz && rm -f linux.tar")
benchmarkTest=("./minigzipsh linux.tar"
               "./minigzipsh -d linux.tar.gz")
benchmarkValidation=("wc -c linux.tar.gz | cut -d ' ' -f 1"
                     "wc -c linux.tar | cut -d ' ' -f 1")
benchmarkRepetition=(1
                     3)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools cut wc wget
