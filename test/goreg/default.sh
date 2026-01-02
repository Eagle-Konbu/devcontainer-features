#!/bin/bash

# Test goreg installation with default options (no version specified)
# This scenario tests that the feature works when no options are provided

set -e

source dev-container-features-test-lib

# Basic installation checks
check "goreg is installed" command -v goreg
check "goreg can execute" goreg --help

# Functional test with default installation
cat > /tmp/test_default.go << 'EOF'
package main

import (
	"fmt"
	"time"
	"os"
)

func main() {
	fmt.Println(time.Now())
	os.Exit(0)
}
EOF

# Run goreg to ensure default installation works
check "goreg can format with default options" goreg -w /tmp/test_default.go

# Clean up
rm -f /tmp/test_default.go

reportResults
