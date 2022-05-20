# Multiresolution Adaptive Grids

## Approach
MURPHY uses block-structured grids organized in octree data structures. Each block contains a fixed number of $N_b$ grid points in each direction at a uniform resolution. Grid adaptation is performed by splitting an existing grid block into eight finer grid blocks, or combining eight existing grid blocks into one coarser grid block. To decide when to refine or compress, MURPHY regularly performs a wavelet transform of key indicator fields. With this transform MURPHY can quantify the smoothness of the field as compared to a chosen polynomial basis, and this smoothness is used to decide whether each blocks can compress, should refine, or stay at the same level of resolution. We further use the wavelet basis to consistently create or discard information when adapting the grid, as well as create ghost points for blocks neighboring resolution jumps. 

## Mathematical basis

## Implementation
