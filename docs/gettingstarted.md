# Getting started
Here we go over some of the main, high-level operations required to perform a simple operation in MURPHY. The full code is here..

### 1. Grid initialization
```c++
int  L[3]      = {2, 1, 3};
bool periodic[3] = {false, false, false};
Grid* grid       = new Grid(1, periodic, L, M_GRIDBLOCK, MPI_COMM_WORLD, nullptr);
```
We create a distributed (MPI) forest of octrees, organized in a rectangular shape. The number of tree in each direction is given by `L[0]`x`L[1]`x`L[2]` (each octree is a unit cube of physical size `1`x`1`x`1`);
The tree management operations are performed by the library `p4est`. Additionally to the forest size, the periodicity of its boundary is given to p4est and cannot change during the simulation. Other boundary conditions are given afterwards. Each leaf of the tree contains a `GridBlock`, a continuous memory space of fixed size. The block size in a direction is given by the number of unknowns in its core, `M_N`, and the number of ghost points, `M_GS`. The memory stride in each direction is then given by `M_STRIDE = 2 * M_GS + M_N`.

### 2. Field creation
```c++
Field* vort = new Field("vorticity", 3);
```
This command defines a field by a unique `name`, here `vorticity`, and a dimensionality `lda`, here `3`. The field does not contain its own memory and is almost an empty shell. However, its `name` and `lda` are used each time one wants to perform an operation on it.

### 3. Grid-Field association
```c++
grid->AddField(vort);
```
The association of a field to a grid will perform the real memory allocation. A field can be associated to multiple grids and each grid contains a map of all the fields it is associated with. When a field is added to a grid, this  will trigger a loop on all the grid blocks to initialize the memory. The memory is allocated continuously, each component separated by `M_STRIDE * M_STRIDE * M_STRIDE`. This means that, in memory, we have `[Field(ida=0) Field(ida=1) Field(ida=2)]` in one continuous array.

### 4. Boundary conditions
```c++
vort->bctype(M_BC_ODD);
```
The imposition of a boundary condition is done on the field. Each dimension, `ida`, will get 6 boundary conditions, one for each of the faces. These are ordered as follows: `x-`, `x+`, `y-`, `y+`, `z-`, `z+`. The boundary conditions will be used any time ghost points are needed for the field. If a simulation direction is periodic,  **which is set globally on the grid and not on individual fields**, the boundary conditions on the field in that direction will be discarded automatically. 

### 5. Fill the field with values

### 7. Grid adaptation

### 8. DoOp functions
MURPHY implements three high-level functions to loops on the `GridBlocks`:

- `DoOpMesh`: loops on the blocks using the `p4est_mesh`, i.e. requires the ghosts to be up to date with the grid (not the ghost values!)
- `DoOpMeshLevel`: same but only on a considered level
- `DoOpTree`: loops on the blocks using the trees, i.e. do not require the ghosts to be up to date with the grid.

The functions operates using a similar interface:

- an object that owns the function you want to call on the blocks
- the function of the object that will be called, as a lambda function
- the grid
- any other arguments that the user wants forward to the function.

For example, here is a list of different values

:warning: it's the responsibility of every operation that involves a `DoOp`, to update the ghost status of a field once the job is done.


### 9. Ghost update
```c++
grid->GhostPull(vort);
```
The ghost points computation is done using the wavelets to reconstruct missing information in the case of a level mismatch. The ghost reconstruction is done dimension by dimension, allowing to overlap wavelet reconstruction with the communication for the next dimension. Each field owns a boolean to indicate if the ghost points are up-to-date. Hence, calling the `GhostPull` with an already up-to-date field will return immediately. To ensure consistency of this boolean, please make sure the operator classes set this value accurately.


### 10. Dump 

