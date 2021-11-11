# benchmarking-tools
Scripts to easily facilitate benchmarking on Linux.

This is a rewrite of my current bash/R benchmarking scripts to bring them into the 21st century, remove their dependence
on R and make it fully available for anyone to use. This has extended substantially to allow for easy measurements for
power consumptions for machines that support the RAPL framework. Contributions welcome.

## How to Use
Clone the repo and run a benchmark. To run the `zstd` benchmark simply (${testidentifier} is optional):

```
git clone https://github.com/sunnyflunk/benchmarking-tools.git
cd benchmarking-tools
./run-benchmark.sh zstd ${testidentifier}
./run-power-benchmark.sh zstd ${testidentifier}
```

To view an organized summary of the results of the `zstd` benchmark:

```
./generate-results.sh zstd
./generate-power-results.sh zstd
```

To generate a perf analysis of the `zstd` benchmark run:

```
./analyze-benchmark.sh zstd ${testidentifier}
```

## Benchmarks

Benchmarks are very simple to create, once you know the commands to run. Converting it to the right format is extremely
easy and can probably just copy an existing one. A list of benchmarks can be found [here](https://github.com/sunnyflunk/benchmarking-tools/tree/main/benchmarks)
