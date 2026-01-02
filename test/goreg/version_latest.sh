#!/bin/bash

# Test goreg installation with version="latest"
# This scenario tests the default installation behavior with latest version

set -e

source dev-container-features-test-lib

# Source common test functions
source "$(dirname "$0")/common_tests.sh"

# Run common installation tests
common_installation_tests

# Run common functional tests
common_functional_test

reportResults
