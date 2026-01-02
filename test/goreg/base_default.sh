#!/bin/bash

# Test goreg installation on base image with Go installed via feature
# This scenario tests that the feature works when Go is installed via devcontainer feature

set -e

source dev-container-features-test-lib

# Source common test functions
source "$(dirname "$0")/common_tests.sh"

# Run common installation tests
common_installation_tests

# Run common functional tests
common_functional_test

reportResults
