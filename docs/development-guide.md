# Development Guide

## Git management
We use the [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) approach to maintain a hierarchy and a clean repository.
It means that we have the following branches:
- `master` is the default working branch
- `develop` is the development branch, the source branch for every new development
- `dev-*` are the ongoing development branch
- `fix-*` fix a bug or solve an issue

To create a new development branch, simply do
```bash
# go on the develop branch
git checkout develop
# update your version
git pull
# create a new branch
git checkout -b dev-mynewfeature develop
```
To incorporate your development into the develop branch, use pull requests.
The automatic testing **must** be included and succeed in the code.

Additionally, for the commit we use the [gitmoji guide](https://gitmoji.carloscuesta.me) to describe your commit purpose.
It helps to automatically identify the reason of the commit. Here is a small non-exhaustive list

Action | Corresponding emoji
--------|-----------------------------
Solve a regular bug | :bug: `:bug:`
Sovle a critical bug | :ambulance: `:ambulance:`
Add documentation / comments / doxygen | :memo: `:memo:`
Compilation / makefile | :wrench: `:wrench:`
Docker | :whale: `:whale:`
Refactor | :recycle: `:recycle:`
Work in Progress | :construction: `:construction:`
Cleanup the code | :wastebasket: `:wastebasket:`
Refactor the code | :building_construction: `:::building_construction:::`

<!-- ----------------------------
### Typing variables
To ease the remplacement of the doubles into floats and handle the different types of ints, we define 3 types:


No `int` declarations are used in the code, except for MPI rank-related numbers, which are `int` by the MPI standard. -->

Create issues to keep track of the development and also to discuss any question you might have.
You can use the keywords **clos(e/es/ed)**, **resolv(e/es/ed)** and **fix(/es/ed)** followed by the issue number to close an issue once merged in the default branch
```bash
git commit -m ":sparkles: closes #9"
```


----------------------------
## Style Guide
To ensure a consistent style across murphy, we rely on the [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html#C++_Version).
Additionally, we use two tools to help the formatting:

- `cpplint` tool to detect style errors,
```bash
cpplint --filter=-whitespace/line_length,-runtime/printf myfile
```
- `clang-format` to help the formatting in VSCode. The file `.clang-format` should be automatically detected and loaded in VSCode, giving you access Immediately to the formatting behavior. You regenerate that file using 
```bash
# brew install clang-format if needed
clang-format -style='{BasedOnStyle: Google, ColumnLimit: 0, IndentWidth: 4, AlignConsecutiveAssignments: true, AlignConsecutiveDeclarations: true, AlignEscapedNewlines: true, AlignOperands: true }' -dump-config > .clang-format
```

There are some exceptions to the style guide as listed below:

- `typedef` defined types have a postfix: `*_t` (e.g. `real_t` for the real datatype, `iface_t` when lopping on the faces, ...)
- the macro definitions acting as functions have a prefix `m_`, which stands for MURPHY (e.g. `m_verb`)
- the files are names in lowercase with a `.cpp` and `.hpp` extension, with filenames copying the class it contains (e.g. class `Grid` in `grid.cpp`)
- callback functions used to interface with `p4est` start with `cback_`
