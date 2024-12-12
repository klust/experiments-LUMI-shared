# OpenMP header files cannot compile in C++-20 mode in clang++

This is actually not a Cray or AMD bug, but a general clang++ issue as
[this thread in the LLVM GitHub shows](https://github.com/llvm/llvm-project/issues/113207).
Given that this discussion is from October and November 2024, a fix should not be expected
before Clang 20.

Reproduce:

```
module load LUMI/24.03
module load partition/G
module load cpeCray/24.03

CC -O3 -fopenmp -std=c++20 test.cpp
```

or

```
module load LUMI/24.03
module load partition/G
module load cpeAMD/24.03

CC -O3 -fopenmp -std=c++20 test.cpp
```

It seems related to using OpenMP offload: With `cpeAMD` loaded,

```
amdclang++ -O3 -fopenmp -std=c++20 test.cpp
```

works, but

```
amdclang++ -O3 -fopenmp -fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx90a -std=c++20 test.cpp
```

doesn't.

Similarly, with `cpeCray/24.03` loaded, 

```
crayCC -O3 -fopenmp -std=c++20 test.cpp
```

works, but 

```
crayCC -O3 -fopenmp -fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx90a -std=c++20 test.cpp
```

doesn't.
