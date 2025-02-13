module load LUMI/24.03 partition/G cpeAMD
#module load buildtools/24.03
module unload cray-libsci cray-mpich
module unload craype-accel-amd-gfx90a

mkdir -p compile_01 && cd compile_01

#cmake .. -DCMAKE_CXX_COMPILER="CC" -D CMAKE_CXX_FLAGS="-O3 -craype-verbose"
cmake .. -DCMAKE_CXX_COMPILER="CC" -D CMAKE_CXX_FLAGS="-O2 -craype-verbose"

