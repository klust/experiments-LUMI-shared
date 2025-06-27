#!/bin/bash
set -e

# This script compiles ompt-printf and the three test cases.

# --- 1. Build ompt-printf if not already built ---
TOOL_LIB_PATH="ompt-printf/build/src/libompt-printf.so"
if [ ! -f "$TOOL_LIB_PATH" ]; then
    echo "ompt-printf library not found at '$TOOL_LIB_PATH'. Building it now..."

    # Check if ompt-printf source directory exists, clone if not
    if [ ! -d "ompt-printf" ]; then
        echo "ompt-printf directory not found. Cloning it from GitHub..."
        git clone https://github.com/FZJ-JSC/ompt-printf.git
    fi

    (
        cd ompt-printf
        echo "--- Configuring ompt-printf with CMake ---"
        cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCOMPILER_TOOLCHAIN=Cray
        echo
        echo "--- Building ompt-printf ---"
        cmake --build build
    )
    echo
    echo "Build complete. The tool is available in ompt-printf/build/"
    echo
fi
echo "ompt-printf library is available."
echo

# --- 2. Compile the test cases ---

echo "--- Listing modules ---"
module list
echo "-----------------------"
ftn --version
echo "-----------------------"

echo "--- Compiling Case 1: copyprivate ---"
(
  cd copyprivate
  rm -f test.x > /dev/null 2>&1
  echo "Executing: ftn -fopenmp test.f90 -o test.x"
  ftn -fopenmp test.f90 -o test.x
)
echo "Success."
echo

echo "--- Compiling Case 2: task ---"
(
  cd task
  rm -f test.x > /dev/null 2>&1
  echo "Executing: cc -fopenmp test.c -o test.x"
  cc -fopenmp test.c -o test.x
)
echo "Success."
echo

echo "--- Compiling Case 3: taskloop ---"
(
  cd taskloop
  rm -f test.x > /dev/null 2>&1
  echo "Executing: cc -fopenmp test.c -o test.x"
  cc -fopenmp test.c -o test.x
)
echo "Success."
echo

echo "All compilations finished."
echo "You can now run the tests using the './run_tests.sh' script." 