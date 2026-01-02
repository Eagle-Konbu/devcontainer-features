#!/bin/bash

# Global integration test for goreg feature
# This test verifies that goreg works correctly with Go feature installed
# and validates common policies/requirements

set -e

source dev-container-features-test-lib

# Common policy checks
check "go is installed" command -v go
check "goreg is installed" command -v goreg

# Verify goreg is in PATH and accessible
check "goreg in PATH" bash -c "which goreg"

# Verify Go environment is properly set up
check "GOPATH is set" bash -c "[ -n \"$GOPATH\" ] || [ -n \"$(go env GOPATH)\" ]"

# Integration test: Ensure goreg works with the Go environment
cat > /tmp/integration_test.go << 'EOF'
package main

import (
	"fmt"
	"os"
	"time"
	
	"context"
)

func main() {
	ctx := context.Background()
	fmt.Printf("Context: %v, Time: %v\n", ctx, time.Now())
	os.Exit(0)
}
EOF

# Verify goreg can format with Go installed
check "goreg works with Go" goreg -w /tmp/integration_test.go

# Verify formatted file is valid Go code
check "formatted code is valid" go fmt /tmp/integration_test.go

# Verify the file can be run
check "formatted code runs" go run /tmp/integration_test.go

# Clean up
rm -f /tmp/integration_test.go

# Policy checks: Non-root user (if applicable)
# This ensures tools work for development users, not just root
if [ "$(id -u)" -ne 0 ]; then
    check "goreg works as non-root" goreg --help
fi

reportResults
