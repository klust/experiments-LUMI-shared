module purge
module load LUMI/24.03 partition/G cpeAMD
module load buildtools/24.03
module unload cray-libsci cray-mpich
#module unload craype-accel-amd-gfx90a

dir='cmake_failure_03'

mkdir -p $dir && cd $dir

echo -e "Checking the CMake version:\n$(cmake --version)\n\n"

echo -e "\nNow configuring with CMake\n"
cmake .. -DCMAKE_CXX_COMPILER="CC" -DCMAKE_CXX_FLAGS="-O2 -craype-verbose" \
         -DOpenMP_C_FLAGS="-fopenmp=libomp" -DOpenMP_C_LIB_NAMES="" \
         -DOpenMP_CXX_FLAGS="-fopenmp=libomp" -DOpenMP_CXX_LIB_NAMES=""

echo -e "\n\n\nBuilding with make\n"
make VERBOSE=1

