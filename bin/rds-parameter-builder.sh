#!/bin/bash

# Function to get available RDS engines
get_engines() {
    aws rds describe-db-engine-versions --query "DBEngineVersions[].Engine" --output text | tr '\t' '\n' | sort -u
}

# Function to get available engine versions for a specific engine
get_engine_versions() {
    local engine=$1
    aws rds describe-db-engine-versions --engine "$engine" --query "DBEngineVersions[].EngineVersion" --output text | tr '\t' '\n' | sort -V
}

# Function to get available log types for a specific engine and version
get_log_types() {
    local engine=$1
    local version=$2
    aws rds describe-db-engine-versions --engine "$engine" --engine-version "$version" --query "DBEngineVersions[].SupportedLogTypes[]" --output text | tr '\t' '\n' | sort
}

# Get available engines
engines=($(get_engines))

# Display available engines
echo "Available RDS Engines:"
for i in "${!engines[@]}"; do
    echo "$((i+1)). ${engines[$i]}"
done

# Prompt user to select an engine
while true; do
    read -p "Select an engine (1-${#engines[@]}): " selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#engines[@]}" ]; then
        selected_engine=${engines[$((selection-1))]}
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

echo "Selected engine: $selected_engine"

# Get available engine versions for the selected engine
versions=($(get_engine_versions "$selected_engine"))

# Display available engine versions
echo "Available Engine Versions for $selected_engine:"
for i in "${!versions[@]}"; do
    echo "$((i+1)). ${versions[$i]}"
done

# Prompt user to select an engine version
while true; do
    read -p "Select an engine version (1-${#versions[@]}): " selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#versions[@]}" ]; then
        selected_version=${versions[$((selection-1))]}
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

echo "Selected engine version: $selected_version"

# Get available log types for the selected engine and version
log_types=($(get_log_types "$selected_engine" "$selected_version"))

# Display available log types
echo "Available Log Types for $selected_engine version $selected_version:"
if [ ${#log_types[@]} -eq 0 ]; then
    echo "No log types available for this engine and version."
else
    for log_type in "${log_types[@]}"; do
        echo "- $log_type"
    done
fi

echo "You can use these values for the Engine, EngineVersion, and EnableCloudwatchLogsExports properties of the AWS::RDS::DBInstance resource."