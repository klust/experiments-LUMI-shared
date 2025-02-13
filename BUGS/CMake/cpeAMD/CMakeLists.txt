cmake_minimum_required(VERSION 3.16)
project(openmp_helloworld)


# Find HIP.
# The user may override AMDGPU_TARGETS defined in the HIP config file
# to select the AMDGPU archs to compile for.
# ex. set(AMDGPU_TARGETS "gfx803;gfx900;gfx906")
find_package(hip REQUIRED)

# Find OpenMP.
find_package(OpenMP REQUIRED)

set(CMAKE_BUILD_TYPE Release)

# Source files.
set(CPP_SOURCES ${CMAKE_SOURCE_DIR}/hello.cpp)

# Preparing the executable.
add_executable(test_openmp_helloworld ${CPP_SOURCES})

# Link Libraries - HIP Device and OpenMP.
target_compile_options(test_openmp_helloworld PRIVATE ${OpenMP_CXX_FLAGS})
target_link_libraries(test_openmp_helloworld PRIVATE hip::device ${OpenMP_CXX_FLAGS})

