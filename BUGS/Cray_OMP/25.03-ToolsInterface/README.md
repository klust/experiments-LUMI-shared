# Reported in ticket 6428 - CPE 25.03 -- OpenMP Tools Interface still using ompt_sync_region_barrier

Text from the ticket:

> since getting access to the CPE 25.03 container (thanks a lot again!), we were able to analyze a few more issues we run into.  In the meantime, we were already approached by users of other systems with the same Cray programming environment running into the very same issues.

> In this issue, we want to report a few remaining cases in the OpenMP Tools Interface, where the Cray OpenMP runtime continues to report the deprecated (and in OpenMP 6.0 removed) enum value of 'ompt_sync_region_barrier'. The general pattern seems similar, and we didn't want to send 130 of our test cases which failed in our testing.  We've originally reported the issue at LUMI #4110, and the situation has improved significantly since then. Some combination of the single and one of the tasking directives seem to still trigger this deprecated value, though.

> Attached are three simple test cases where we observed the OpenMP runtime to report 'ompt_sync_region_barrier'.  We've attached the full printf output of CPE 25.03 and the result of either ROCm 6.x (or in the case of the Fortran example the latest Clang trunk of June 23rd) for comparison. The printf outputs are generated with the following tool: [github.com/FZJ-JSC/ompt-printf](https://github.com/FZJ-JSC/ompt-printf).

> Generally, it seems like 'ompt_sync_region_barrier' is used in cases where the runtime might not be able to pinpoint which kind of barrier it encounters. This could be some kind of optimization or data not being passed through tasks. This issue significantly impacts performance tools which rely on proper event sequencing, and differentiation between barrier types. For Score-P, we need to properly distinguish the end of a parallel region from all other barrier types. Unfortunately, 'ompt_sync_region_barrier' doesn't allow this. Using 'ompt_sync_region_barrier_implicit', even though also deprecated (and removed in 6.0), with properly setting 'parallel_data' to 'NULL' at the end of a parallel region would be sufficient for us, and is what LLVM/Clang is still doing.


## Running the examples (short output)

### Case 1: copyprivate

``` bash
cc -fopenmp -c ../tool.c
ftn -fopenmp test.f90 tool.o -o test.x
./test.x
rm core
```

### Case 2: task

``` bash
cc -fopenmp test.c ../tool.c -o test.x
./test.x
rm core
```

### Case 3: taskloop

``` bash
cc -fopenmp test.c ../tool.c -o test.x
./test.x
rm core
```

## Running the examples (with `ompt-printf`)

First build `ompt-printf` following the instructions in 
[the `ompt-printf` GitHub](https://github.com/FZJ-JSC/ompt-printf).

It looks like we also have an issue with `xpmem` in the container for 25.03 as it is not found when
running. The solution is to first set:

``` bash
LD_LIBRARY_PATH=${CRAY_XPMEM_POST_LINK_OPTS/-L/}:$LD_LIBRARY_PATH
```

Next we can simply recompile all applications, but without using `tool.c`.

### Case 1: copyprivate

``` bash
ftn -fopenmp test.f90 -o test.x
./test.x
rm core
```

### Case 2: task

``` bash
cc -fopenmp test.c -o test.x
./test.x
rm core
```

### Case 3: taskloop

``` bash
cc -fopenmp test.c -o test.x
./test.x
rm core
```

## Comparing Compiler Outputs

To analyze the difference in OMPT event reporting, you can generate logs for both compiler toolchains:
```bash
# Generate Cray Log
module load PrgEnv-cray
./compile.sh
./run_tests.sh > CRAY.log
# Generate AMD (AOMP) Log
module load PrgEnv-amd
./compile.sh
./run_tests.sh > AMD.log
```

You can then inspect `CRAY.log` and `AMD.log` to see the difference in the `kind` of barriers reported.
Logs from Lumi PrgEnv-amd/8.5.0 and PrgEnv-cray/8.5.0 are in `log_from_lumi` directory.
