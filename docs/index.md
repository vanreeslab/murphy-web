# MURPHY - Multiresolution Multiphysics Solver

MURPHY is a library to perform high-performance computing simulations of partial differential equations on multiresolution adaptive grids. It uses an immersed interface method to handle domain boundaries. MURPHY is written in `C++` and `MPI`. We have provided more information about the motivation and theoretical background on a couple of key components:

* multiresolution grid adaptation through wavelets
* high-order discretization of boundaries through immersed interface method
* high performance computing using one-sided MPI communication
* integration with `FLUPS` for Fast Fourier Transforms (uniform grids only)

Further, we have a couple of clients:

* `vortexdyn` : discretization of 3D Navier-Stokes equations using vorticity-velocity formulation
* TBD

The scientific paper can be found [here](https://arxiv.org/abs/2112.07537) while the Github code is [here](https://github.com/vanreeslab/murphy).


## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.
