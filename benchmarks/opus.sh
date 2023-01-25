#!/bin/true

. ${executionPath}/benchmarks/helpers/wavfile.sh
benchmarkLabels=("Encode (256 kbit/s)"
                 "Encode (128 kbit/s)"
                 "Decode")
benchmarkTest=("opusenc --bitrate 256 1.wav 1.opus"
               "opusenc --bitrate 128 1.wav 1.opus"
               "opusdec 1.opus 2.wav")
benchmarkValidation=("wc -c 1.opus | cut -d ' ' -f 1"
                     "wc -c 1.opus | cut -d ' ' -f 1"
                     "wc -c 2.wav | cut -d ' ' -f 1")
benchmarkRepetition=(1
                     1
                     2)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools cut opusenc opusdec wc
