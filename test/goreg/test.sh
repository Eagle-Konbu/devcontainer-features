#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'goreg' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.

# Verify goreg is installed and in PATH
check "goreg is installed" command -v goreg

# Verify goreg can execute
check "goreg can display help" goreg --help

# Create a test Go file with unorganized imports
cat > /tmp/test_goreg.go << 'EOF'
package main

import (
    "os"
    "github.com/example/external"
    "fmt"
)

func main() {
    fmt.Println("Hello")
    os.Exit(0)
}
EOF

# Verify goreg can process the file
check "goreg can format Go imports" goreg /tmp/test_goreg.go

# Clean up
rm -f /tmp/test_goreg.go

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
