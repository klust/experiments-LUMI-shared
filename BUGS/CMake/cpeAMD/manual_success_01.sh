module purge
module load LUMI/24.03 partition/G cpeAMD
#module load buildtools/24.03
module unload cray-libsci cray-mpich
module unload craype-accel-amd-gfx90a

dir='manual_success_01'

mkdir -p $dir && cd $dir

CC -O2 -craype-verbose -fopenmp=libomp -xhip -D__HIP_PLATFORM_AMD__=1 ../hello.cpp -o hello

