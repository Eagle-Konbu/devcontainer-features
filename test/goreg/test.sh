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
	"encoding/json"
	"context"
	"os"
	"fmt"
	"time"
	"go.uber.org/zap"
	"github.com/google/uuid"
	"github.com/pkg/errors"
)

type User struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	CreatedAt time.Time `json:"created_at"`
}

var logger *zap.Logger

func saveToFile(filename string, data []byte) error {
	if err := os.WriteFile(filename, data, 0644); err != nil {
		return errors.Wrap(err, "failed to write file")
	}
	logger.Info("File saved", zap.String("filename", filename))
	return nil
}

func main() {
	logger, _ = zap.NewProduction()
	defer logger.Sync()

	ctx := context.Background()

	user := User{
		ID:        uuid.New().String(),
		Name:      "John Doe",
		Email:     "john@example.com",
		CreatedAt: time.Now(),
	}

	logger.Info("Creating user", zap.String("user_id", user.ID))

	jsonData, err := json.MarshalIndent(user, "", "  ")
	if err != nil {
		logger.Error("Marshal failed", zap.Error(err))
		os.Exit(1)
	}

	fmt.Println(string(jsonData))

	if err := saveToFile("user.json", jsonData); err != nil {
		logger.Error("Save failed", zap.Error(err))
		os.Exit(1)
	}

	_, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
}
EOF

# Run goreg to format the file in-place
check "goreg can format Go imports" goreg -w /tmp/test_goreg.go

# Create the expected output file
cat > /tmp/expected_goreg.go << 'EOF'
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/google/uuid"
	"github.com/pkg/errors"
	"go.uber.org/zap"
)

type User struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	CreatedAt time.Time `json:"created_at"`
}

var logger *zap.Logger

func saveToFile(filename string, data []byte) error {
	if err := os.WriteFile(filename, data, 0644); err != nil {
		return errors.Wrap(err, "failed to write file")
	}
	logger.Info("File saved", zap.String("filename", filename))
	return nil
}

func main() {
	logger, _ = zap.NewProduction()
	defer logger.Sync()

	ctx := context.Background()

	user := User{
		ID:        uuid.New().String(),
		Name:      "John Doe",
		Email:     "john@example.com",
		CreatedAt: time.Now(),
	}

	logger.Info("Creating user", zap.String("user_id", user.ID))

	jsonData, err := json.MarshalIndent(user, "", "  ")
	if err != nil {
		logger.Error("Marshal failed", zap.Error(err))
		os.Exit(1)
	}

	fmt.Println(string(jsonData))

	if err := saveToFile("user.json", jsonData); err != nil {
		logger.Error("Save failed", zap.Error(err))
		os.Exit(1)
	}

	_, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
}
EOF

# Verify the output matches expected format
check "goreg produces expected output" diff -u /tmp/expected_goreg.go /tmp/test_goreg.go

# Clean up
rm -f /tmp/test_goreg.go /tmp/expected_goreg.go

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
