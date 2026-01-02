#!/bin/bash

# Test goreg installation with version="latest"
# This scenario tests the default installation behavior with latest version

set -e

source dev-container-features-test-lib

# Basic installation checks
check "goreg is installed" command -v goreg
check "goreg can execute" goreg --help

# Functional test: Create a test Go file with unorganized imports
cat > /tmp/test_goreg_scenario.go << 'EOF'
package main

import (
	"encoding/json"
	"context"
	"fmt"
	"os"
	"github.com/google/uuid"
	"time"
)

func main() {
	ctx := context.Background()
	id := uuid.New().String()
	t := time.Now()
	data := map[string]interface{}{
		"id":   id,
		"time": t,
		"ctx":  ctx,
	}
	json.NewEncoder(os.Stdout).Encode(data)
	fmt.Println("done")
}
EOF

# Run goreg to format the file
check "goreg can format Go imports" goreg -w /tmp/test_goreg_scenario.go

# Verify the output has organized imports (stdlib before external)
check "imports are organized" bash -c "head -20 /tmp/test_goreg_scenario.go | grep -A 10 'import' | grep -q 'context' && head -20 /tmp/test_goreg_scenario.go | grep -A 10 'import' | grep -q 'github.com'"

# Clean up
rm -f /tmp/test_goreg_scenario.go

reportResults
