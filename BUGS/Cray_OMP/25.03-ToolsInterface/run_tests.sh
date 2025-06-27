#!/bin/bash
set -e

# This script runs the compiled test cases with the ompt-printf tool
# and filters the output to show only barrier events.

TOOL_LIB_PATH="ompt-printf/build/src/libompt-printf.so"

if [ ! -f "$TOOL_LIB_PATH" ]; then
    echo "Error: ompt-printf library not found at '$TOOL_LIB_PATH'."
    echo "Please run './compile.sh' first to build the tool and the tests."
    exit 1
fi

# Set environment variables for the tool
# For Cray environment, as per project README.md
if [ -n "${CRAY_XPMEM_POST_LINK_OPTS-}" ]; then
    export LD_LIBRARY_PATH=${CRAY_XPMEM_POST_LINK_OPTS/-L/}:$LD_LIBRARY_PATH
fi

# Set OMP_TOOL_LIBRARIES to use ompt-printf
export OMP_TOOL_LIBRARIES="$(pwd)/$TOOL_LIB_PATH"
export OMPT_PRINTF_MODE=3 # Ensure detailed output for grep

# Define the analysis command in an array for robust argument handling.
GREP_CMD=(grep --color -E 'kind = barrier[a-zA-Z_]*')

echo "================================================="
echo "=== Barrier Analysis (filtering for 'kind = barrier*') ==="
echo "================================================="
echo
module list

echo "--- Analysis for: copyprivate ---"
(cd copyprivate && ./test.x) 2>&1 | "${GREP_CMD[@]}" || echo "(No matching barrier events found)"
echo

echo "--- Analysis for: task ---"
(cd task && ./test.x) 2>&1 | "${GREP_CMD[@]}" || echo "(No matching barrier events found)"
echo

echo "--- Analysis for: taskloop ---"
(cd taskloop && ./test.x) 2>&1 | "${GREP_CMD[@]}" || echo "(No matching barrier events found)"
echo

echo "All tests finished." 