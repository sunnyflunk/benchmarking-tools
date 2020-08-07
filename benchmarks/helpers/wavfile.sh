#!/bin/true

benchmarkSources=("wavfile")
benchmarkSetup=("cp ${BT_CACHE_DIR}/pts-trondheim-wav-3.tar.gz ."
                "tar xf pts-trondheim-wav-3.tar.gz"
                "mv pts-trondheim-3.wav 1.wav")
