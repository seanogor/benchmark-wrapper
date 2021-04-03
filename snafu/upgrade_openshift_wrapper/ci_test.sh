#!/bin/bash

set -x

# Defaults
timeout=60
poll_interval=60
uuid=$(uuidgen)

# Setup benchmark-wrapper
echo "Installing benchmark-wrapper in python virtual environment"
if [[ -d "$PWD/upgrade" ]]; then
  rm -rf upgrade
fi
python3 -m venv upgrade
source upgrade/bin/activate
pip3 install -e benchmark-wrapper

# Set the upgrade version
# Upgrade version is same as the current clusterversion to avoid upgrading the CI cluster
upgrade_version=$(oc get clusterversion -o=jsonpath="{.items[].status.desired.version}")
echo "Running cluster upgrade to $upgrade_version"
run_snafu --tool upgrade -u $uuid --version $upgrade_version --timeout $timeout --poll_interval $poll_interval
