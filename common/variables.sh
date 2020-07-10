#!/bin/true

# Common variables between all scripts

testDistro=`cat /etc/os-release | grep NAME | tail -n1 | cut -d '"' -f 2`
testKernel=`uname -r`
testDate=`date +"%d-%b-%Y"`
BT_BENCHMARKS_DIR=${executionPath}/benchmarks
BT_RUNBENCHMARKS_DIR=/tmp/benchmark/${testName}
BT_SOURCES_DIR=${executionPath}/sources
# Want this to be shared across installs etc
BT_RESULTS_DIR=~/BT-Results # Find better dir
BT_CACHE_DIR=~/.cache/benchmark-tools
