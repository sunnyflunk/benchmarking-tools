#!/bin/true

benchmarkSetup=("yes 'SomeSampleText SomeOtherText 33 1970 YetAnotherText 777 abc 1 AndSomeMore' | head -12000000 > gawkdata.txt")
benchmarkLabels=("Gawk")
benchmarkTest=("gawk 'BEGIN {a = 0;} /YetAnotherText/ {a ++;} END {print \"a: \" a;}' gawkdata.txt > /dev/null")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(5)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh

requireTools gawk
