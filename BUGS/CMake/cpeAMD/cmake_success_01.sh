module purge
module load LUMI/24.03 partition/G cpeAMD
#module load buildtools/24.03
module unload cray-libsci cray-mpich
module unload craype-accel-amd-gfx90a

dir='cmake_success_01'

mkdir -p $dir && cd $dir

echo -e "Checking the CMake version:\n$(cmake --version)\n\n"

echo -e "\nNow configureing with CMake\n"
cmake .. -DCMAKE_CXX_COMPILER="CC" -D CMAKE_CXX_FLAGS="-O2 -craype-verbose"

echo -e "\n\n\nBuilding with make\n"
make VERBOSE=1

