# benchmarking-tools
Scripts to easily facilitate benchmarking on Linux.

This is a rewrite of my current bash/R benchmarking scripts to bring them into the 21st century, remove their dependence on R and make it fully available for anyone to use. Contributions welcome once the basics are in place.

## Requirements
- Runs on a barebone system/container/chroot
- Is portable and not reliant on the downloaded directory
- Tests actual packages/tools installed on the system/container/chroot
- Ability to make a new test in under a minute (once you know the test to run)
- Tools to analyze the results (these can use R)

## Roadmap
- [ ] Import boiler plate functions from [bootstrap-scripts](https://github.com/serpent-linux/bootstrap-scripts)
- [ ] Create script to run a zstd benchmark
- [ ] Create script to run a compile time benchmark
- [ ] Create script to analyze benchmarks
- [ ] Generate charts from the results
- [ ] Make some simple documentation/templates
