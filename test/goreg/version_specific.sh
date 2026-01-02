#!/bin/bash

# Test goreg installation with specific version (1.2.10)
# This scenario verifies that a specific version can be installed

set -e

source dev-container-features-test-lib

# Basic installation checks
check "goreg is installed" command -v goreg
check "goreg can execute" goreg --help

# Version-specific check
check "goreg version is 1.2.10" bash -c "goreg --version 2>&1 | grep -q 'v1.2.10'"

# Functional test to ensure the specified version works correctly
cat > /tmp/test_version_specific.go << 'EOF'
package main

import (
	"fmt"
	"os"
	"github.com/pkg/errors"
)

func main() {
	err := errors.New("test")
	fmt.Fprintln(os.Stdout, err)
}
EOF

# Run goreg to ensure it functions with this version
check "goreg v1.2.10 can format" goreg -w /tmp/test_version_specific.go

# Clean up
rm -f /tmp/test_version_specific.go

reportResults
