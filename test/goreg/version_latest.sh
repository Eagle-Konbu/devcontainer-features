#!/bin/bash

# Test goreg installation with version="latest"

set -e

source dev-container-features-test-lib

check "goreg is installed" command -v goreg
check "goreg can execute" goreg --help

reportResults
