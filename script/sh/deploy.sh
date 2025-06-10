#!/bin/bash

# Default to dry run (no broadcast)
BROADCAST=""


# Process command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        broadcast)
            BROADCAST="--broadcast"
            shift
            ;;
        *)
            ENV=$1
            shift
            ;;
    esac
done

if [ -z "$ENV" ]; then
     echo "Usage: ./script/deploy.sh <env> [--broadcast]"
    echo "Example: ./script/deploy.sh dev        # Dry run"
    echo "Example: ./script/deploy.sh dev broadcast  # Real deployment"
    echo "Example: ./script/deploy.sh prod broadcast"
    exit 1
fi

# Check if source env file exists
if [ ! -f ".env.${ENV}" ]; then
    echo "Error: .env.${ENV} not found"
    exit 1
fi

# Copy the environment-specific file to .env
echo "Copying .env.${ENV} to .env"
cp ".env.${ENV}" .env

# Run the deployment
echo "Starting deployment with ${ENV} environment..."
forge script script/DeployScript.s.sol \
    --rpc-url rpc \
    $BROADCAST \
    -vvvv

# chmod +x script/sh/deploy.sh
# ./script/sh/deploy.sh dev 