# Compiling the code

There are two ways to compile and run the code. The first one is to use the docker container, which pulls in all dependencies in a controlled environment. This is a good way to get started and for local development. The second one is to compile the dependencies and code outside of the docker container, which is the preferred way for large-scale simulations.

## Docker + VSCode
Within Visual Studio Code, you can use the remote container extension to open, build and run the code directly into a Docker container. To do so, install the *Remote Container* extension in VSCode, and open the folder where you cloned the murphy code in VSCode. A message will pop up that you can accept, which will download and build the container, and open a terminal in that container. You can go in that terminal, navigate to the main `murphy` folder, and type `
```sh
MAKE_ARCH=make_arch/make.docker_gcc make -j
```
and compilation should start and finish without errors.

## Direct compilation
To compile the code natively on any machine, you have to first download and install the required [dependencies](../dependencies). Once you have those, you can create your own architecture file for `make` to call, which should be placed in the `make_arch/`folder. You can take a look at some of the examples that are there. Specifically, you can specify the following variables:

- flags
    - `CXX_FLAGS`: the compilation flags you want to use (default: `none`)
    - `GIT_COMMIT`: the commit associated to the current version of the code (default: taken from the current repo using `git describe --always --dirty`)
- P4est library
    - `P4EST_INC`: the folder with the p4est headers (default `/usr/include`)
    - `P4EST_LIB`: the folder with the p4est libraries (default `/usr/lib`)
    - `P4EST_LIBNAME`: the name of the p4est library on your system (default: `-lsc -lp4est`)
- HDF5 library
    - `HDF5_INC`: the folder with the hdf5 headers (default `/usr/include`)
    - `HDF5_LIB`: the folder with the hdf5 libraries (default `/usr/lib`)
    - `HDF5_LIBNAME`: the name of the hdf5 library on your system (default: `-lhdf5`)
- FFTW library
    - `FFTW_INC`: the folder with the fftw headers (default `/usr/include`)
    - `FFTW_LIB`: the folder with the fftw libraries (default `/usr/lib`)
    - `FFTW_LIBNAME`: the name of the fftw library on your system (default: `-lfftw3_omp -lfftw3`)
- Google Test library
    - `GTEST_INC`: the folder with the google test headers (default `/usr/include`)
    - `GTEST_LIB`: the folder with the google test libraries (default `/usr/lib`)
    - `GTEST_LIBNAME`: the name of the google test library on your system (default: `-lgtest`)


---------------------
### Testing
See the details about automatic testing in [this page](doc/contribute.md).

To run the tests, you need to recompile all the sources (it's important to delete the old ones if you want to retrieve)
```
make destroy
ARCH_FILE=make_arch/make.docker_gcc_test make test -j
```
Then you can lunch the tests
```
./murphy_test
```

---------------------
### Documentation
To get the doxygen documentation, go to the main folder and enter
```
doxygen doc/Doxyfile
```
You will need `dot` to get a visual graphs (see `HAVE_DOT` option in the Doxyfile).
On MacOS, you can install it using homebrew: `brew install graphviz`.


---------------------
### Docker troubleshoot

- the compilation fails and the error indicates that files change sizes during the compilation:
you might be the victim of slow disk access between docker and your laptop. To solve that, you need to follow [this](https://code.visualstudio.com/docs/remote/containers-advanced#_update-the-mount-consistency-to-delegated-for-macos) and set the consistency to `delegated`.


---------------------
### Building on clusters
here are the links to the details needed to build murphy on different clusters
- [Engaging](doc/engaging.md)
- [NIC 5](doc/nic5.md)
- [Lemaitre 3](doc/lm3.md)

