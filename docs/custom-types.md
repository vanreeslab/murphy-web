# Custom Types

To simplify the development of the code, we use a few custom types and macros: here is a summar and how/when to use them:

|`What`? | When
|--------|-----------------------------
| **TYPES**
`rank_t` | an MPI-rank
`lda_t` | a leading dimension numbers (typically 0,1,2)
`iblock_t` | a local block index
`iface_t` | a face id (0 to 26)
`level_t` | a level
`qdrt_t`| a `p8est_quadrant_t` variable
`real_t` | a floating point number
`data_ptr` | a memory address of the element (0,0,0)
`mem_ptr` | the raw memory address
`const_mem_ptr` | the constant raw memory address
| **MACROS** |
`m_verb` | displays information in the body of a function or when some diag of the function are not important
`m_log` | displays important information at the end of a function, to give info to the user
`m_min` | returns the min of two numbers
`m_max` | returns the max of two numbers
`m_sign` | returns the sign
`m_pos` | position of a 3D point in the domain
`m_pos_relative` | position of a 3D point in the block
`m_begin` | starts every function to have a timer in full verbose mode
`m_end` | ends every function to have a timer in full verbose mode
| **MEMORY**
`m_calloc` | allocate aligned memory
`m_free` | free aligned memory
`m_isaligned` | check the alignment
`m_assume_aligned` | tells the compiler the array is aligned (and check the assertion in debug mode)
`m_blockmemsize` | returns the number of elements in one block
`m_zeroidx` | shifts the memory to the element `(0,0,0)`
