# benchmarking-tools
Scripts to easily facilitate benchmarking on Linux.

This is a rewrite of my current bash/R benchmarking scripts to bring them into the 21st century, remove their dependence on R and make it fully available for anyone to use. Contributions welcome once the basics are in place.

## How to use
Clone the repo and run a benchmark. To run the zstd benchmark simply:

```
git clone https://github.com/sunnyflunk/benchmarking-tools.git
cd benchmarking-tools
./run-benchmark.sh zstd ${testidentifier}
```

## Requirements
- Runs on a barebone system/container/chroot
- Is portable and not reliant on the downloaded directory
- Tests actual packages/tools installed on the system/container/chroot
- Ability to make a new test in under a minute (once you know the test to run)
- Tools to analyze the results (these can use R)

## Roadmap
- [x] Import boiler plate functions from [bootstrap-scripts](https://github.com/serpent-linux/bootstrap-scripts)
- [x] Create script to run a zstd benchmark
- [x] Create script to run a compile time benchmark
- [x] Create script to analyze benchmarks
- [ ] Generate charts from the results
- [ ] Cleanup the codebase
- [ ] Make some simple documentation/templates
