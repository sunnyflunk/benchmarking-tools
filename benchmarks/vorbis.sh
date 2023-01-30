#!/bin/true

# Import functions for this benchmark
. ${executionPath}/benchmarks/helpers/wavfile.sh

benchmarkLabels=("Encode (-b 128)"
                 "Encode (-q 10)"
                 "Decode")
benchmarkTest=("oggenc -b 128 *.wav"
               "oggenc -q 10 *.wav"
               "oggdec *.ogg > /dev/null")
benchmarkValidation=("wc -c 1.ogg | cut -d ' ' -f 1"
                     "wc -c 1.ogg | cut -d ' ' -f 1"
                     "echo '0'")
benchmarkRepetition=(2
                     2
                     3)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

requireTools cut oggenc oggdec wc
