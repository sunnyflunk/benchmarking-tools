#!/bin/true

. ${executionPath}/benchmarks/helpers/wavfile.sh
benchmarkLabels=("Encode (-3)"
                 "Encode (-8)"
                 "Decode")
benchmarkTest=("flac -f -3 *.wav"
               "flac -f -8 *.wav"
               "flac -d -f *.flac")
benchmarkValidation=("wc -c 1.flac | cut -d ' ' -f 1"
                     "wc -c 1.flac | cut -d ' ' -f 1"
                     "wc -c 1.wav | cut -d ' ' -f 1")
benchmarkRepetition=(8
                     3
                     8)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools flac
