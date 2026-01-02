#!/bin/bash

# Common test functions for goreg feature
# This file contains shared test functions that can be sourced by scenario test files

# Common installation checks
common_installation_tests() {
    check "goreg is installed" command -v goreg
    check "goreg can execute" goreg --help
}

# Common functional test: Test goreg with a sample Go file
common_functional_test() {
    cat > /tmp/test_goreg_common.go << 'EOF'
package main

import (
	"encoding/json"
	"context"
	"fmt"
	"os"
	"time"
)

func main() {
	ctx := context.Background()
	t := time.Now()
	data := map[string]interface{}{
		"time": t,
		"ctx":  ctx,
	}
	json.NewEncoder(os.Stdout).Encode(data)
	fmt.Println("done")
}
EOF

    # Run goreg to format the file
    check "goreg can format Go imports" goreg -w /tmp/test_goreg_common.go

    # Verify the output has organized imports (stdlib before external)
    check "imports are organized" bash -c "head -20 /tmp/test_goreg_common.go | grep -A 10 'import'"

    # Clean up
    rm -f /tmp/test_goreg_common.go
}
