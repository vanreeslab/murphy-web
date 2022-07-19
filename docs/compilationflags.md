# Compilation Flags

Some compilations flags are available to change the behavior of the code:

- `-DBLOCK_GS=X` sets the number of ghost points to use (default `X=2`)
- `-DWAVELET_N=X` dictates the interpolation order of the wavelets (default `X=2`)
- `-DWAVELET_NT=X` dictates the moment order of the wavelets (default `X=2`)
- `-DLOG_ALLRANKS` will enable log on every processor. By default, only the master logs
- `-DVERBOSE` enable extended logs
- `-DNDEBUG` disable the assertion checks and the other debuging sections
- `-DLOG_MUTE` disable every logs
- `-DCOLOR_PROF` enable color output in the profiler (disabled by default)
- `-DMPI_NONASYNC` ask for non-asynchronous MPI calls + remove the fancy optimization options
- `-DOLD_GCC` replaces the `aligned_alloc` by `posix_memalign` to support GCC 8
<!-- - ```-DMG_GAUSSSEIDEL``` uses the gauss-seidel smoother instead of the Jacobi one -->

To use them, you can append the make command, e.g. to change the wavelet behavior
```sh
make OPTS="-DBLOCK_GS=4 -DWAVELET_N=4"
```
or add it to the `ARCH` file:
```makefile
override OPTS += -DBLOCK_GS=4 -DWAVELET_N=2
```

In doubts, you should always run `make info` to test the different options.

:warning: the order of the wavelet must be compatible with the number of ghost points!