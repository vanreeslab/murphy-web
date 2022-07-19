# Dependencies

The compilation uses a standard `Makefile`, which will call a specified MPI-based, `C++-17` compiler. Our dependencies are:

Mandatory:

* make
* C++-17 compiler : we typically use the GNU C++ compiler.
* [`OpenMPI`](https://www.open-mpi.org/) version >=4.1.2 : for parallel communication[^1]
* [`p4est`](https://p4est.github.io/) version XX : for the tree-based operations
* [`hdf5`](https://www.hdfgroup.org/solutions/hdf5) version >=1.10 : for the I/O operations

[^1]:
    [`MPICH`](https://www.mpich.org/) should in principle work, but we haven't exhaustively tested ths.

Optional:

* [`googletest`](https://google.github.io/googletest/) : for the regression tests
* [`flups`](https://github.com/vortexlab-uclouvain/flups) : a FFT-based Poisson solver for uniform grids.
* [`hypre`](https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods) version >=2.23 : a MG-based Poisson solver for uniform grids.