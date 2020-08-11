# Benchmarks for vroom

The benchmarks are run with a makefile, run `make` to run them.

## Personal notes on ~~running benchmarks on AWS~~ using `conda` to set up

`cudf` is not distributed as a Python wheel, only on conda. To install a nightly build,

```shell
conda create -n cudf
conda activate cudf
conda install -c rapidsai-nightly -c nvidia -c numba -c conda-forge cudf python=3.6 cudatoolkit=10.0
conda deactivate cudf
```

I used a separate conda env for R because I wanted to depend on a different version of `arrow-cpp` for `r-arrow` than `cudf` supports. This required some juggling.

```shell
conda create -n r
conda activate r
conda install -c conda-forge r r-arrow r-reticulate r-data.table r-vroom r-dplyr r-bench r-readr r-fs r-tidyr r-here r-sessioninfo
```

To install a dev version of the `arrow` R package *without also a dev build of arrow-cpp*, clone `apache/arrow` and set env vars to point to the libs and headers in the conda env:

```shell
export LIB_DIR=~/.conda/envs/r/lib/
export INCLUDE_DIR=~/.conda/envs/r/include/
R CMD INSTALL r
```

Finally, for the multiple-file example, it was necessary to move the taxi datasets to their own subdirectory because `arrow::open_dataset()` currently only accepts a path to a directory that must contain only data files for the dataset--it does not support providing a discrete list of files. 

### running

```
make -j 1 \
  TAXI_INPUTS='$(wildcard ~/data/taxi/trip_fare*csv)'  \
  FWF_INPUT=~/data/PUMS5_06.TXT \
  BENCH_LONG_ROWS=1000000 \
  BENCH_LOG_COLS=25 \
  BENCH_WIDE_ROWS=100000 \
  BENCH_WIDE_COLS=1000
```

### Tearing down
- Shut down instance
- Detach volume
- Create snapshot
- Delete volume
