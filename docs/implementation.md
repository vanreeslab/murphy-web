# Implementation

Wim: should explain more from a practical, coding perspective what are the different terms. Or maybe a glossary of the structures/data/block etc being used. eg field, cartesianblock, localdataaccess, etc

## Adding block types to MURPHY
In MURPHY, the type of block managed by a grid can be specified at runtime. To make this possible, 
each block type is given a label of enumerated type `BlockDataType`. Operations that create blocks, destroy blocks, or cast between block pointer types use this enum to track type information and perform type checking.

The downside to this approach is that adding a new block type to MURPHY requires, depending on the case, modifying both the `BlockDataType` enumeration and all functions that make use of it. The full process is as follows:

 - Create a header defining a new block type that inherits from `CartBlock` or one of its child classes. If the block will require any kind of ghosting operation, it should inherit from `GridBlock` or one of its child classes.
 - If the new blocktype contains extra data that must be transmitted between ranks during partitioning, override the methods `CartBlock::PartitionDataOffset()`, `CartBlock::PartitionDataPack()`, and `CartBlock::PartitionDataUnPack()`. 
 - Add a label for the new block type to the `BlockDataType` enumeration in `core/types.hpp`.
 - Include the new block header in `tools/blocktypetools.hpp`. Then add the new block type/enum to all of the template specializations in `tools/blocktypetools.hpp`and all of the implementations in `tools/toolsblocktypes.cpp`.
 - Add the new block type/enum to the implementation of `get_cback_CreateBlock()` and `get_cback_DestroyBlock` in `grid/gridcallback.cpp`.
 - If needed, add a new template specialization `Stencil<~new block type~>` to `operator/stencil.cpp`.

## Ghosting - implementation choice
The ghosting implementation is highly linked to the p4est library, please consider reading [this](doc/p4est.md) as well Considering a block, the ghosting procedure relies on the 2:1 constraint, i.e. one coarse neighbor will **never** be adjacent to a fine neighbor.

This comes handy when we consider the interpolation required from one neighbor to another. Given we use moment conservating wavelets, there is a local inter-dependence between several neighbors, especially at the corners, where the refinement operation for a ghost point might need the contribution of the 3 faces, the 3 edges, the diagonal neighbor and the block itself.

Instead of solving this dependency list, we rather use the fact that to compute this refinement, only the values of my neighbors are needed.
Hence, we use a _coarse myself_, i.e. a coarse representation of myself, as a temporary storage of the needed values and then we compute the refinement needed.

The first step of our ghosting is then to fill this coarse representation with neighbors on the same level, aka _siblings_ as me and neighbors coarser than me, aka _parents_.

Once we have that, we can compute the refinement in a simple way and I obtain the needed values.

The ghost points that need to be refined from a finer neigbor's values often require a very large number of values. Instead of asking all those values, my neighbor will refine itself to the temporary area and I will just take the resulting values.

### The ghosting procedure
At the end of the day, I need to perform the following operations, divided into 4 steps

------------------------
- copy the current data to the windows `PushToWindow4Block`
- start the epochs on the windows
------------------------
**STEP 1**: `GetGhost4Block_Post`

- copy my siblings values to my ghost area (using RMA + simple copy)
- if I have at least one coarse neighbor:
    - copy my siblings values to the coarse temporary memory.
    - copy the values of my coarser neighbors to the coarse temporary memory.
- wait for the comm to finish


**STEP 2**: `GetGhost4Block_Wait`

- if I have at least one coarse neighbor:
    - coarsen myself (:warning: the coarsening will be wrong in the areas with a finer neighbor but will be correct in the area of a coarser neighbors)
    - compute the refinement from the `tmp` to the coarser ghost points
-  start the epochs on the windows


**STEP 3**: `PutGhost4Block_Post`
- if I have at least one coarse neighbor
    - reset the `tmp` array
    - compute the physical boundary condition (:warning: it will be wrong in some location but correct where it matters: the intersections with siblings and coarse ghost points)
    - compute the coarsening for my neighbors and store it in `tmp`
    - Copy/RMA the result to the parent's window
- wait for the comm to finish
- get the updated info: `PullFromWindow4Block`

**STEP 4**: `PutGhost4Block_Wait`
- compute the physical boundary conditions with the correct data


As a summary, I need to take care of the ghost points from same level and coarser neighbors. My finer neighbors will fill my ghost points. This works only because of the 2:1 constraint, ensuring that the fine ghost points do not influence the coarse ones. 

------------------------------------------------------------------
### Implementation choice
Here is a few implementation choice:

##### The temp memory
The problem is that the temp memory has to remain untouched while the RMA calls complete. Hence, one single tmp memory for all the block is not possible and each block has to own its temp memory.

I decided to have the temp memory linked to the grid block instead of the ghost object.
The reason behind this is that many ghost objects can be declared on the same mesh, e.g. the MG, and by doing that, we avoid a double useless allocation
