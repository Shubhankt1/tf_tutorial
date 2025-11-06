#!/bin/bash
set -e

# Usage:
# ./tf_manage.sh init         -> terraform init for all resources in order
# ./tf_manage.sh plan         -> plan all resources in order
# ./tf_manage.sh apply        -> apply all resources in order
# ./tf_manage.sh destroy      -> destroy all resources in reverse order
# ./tf_manage.sh plan ec2 sg  -> plan only ec2 and sg
# ./tf_manage.sh apply vpc    -> apply only vpc

# Define the folder order for creation and destruction
APPLY_ORDER=(vpc subnet igw sg ec2)
DESTROY_ORDER=(ec2 sg igw subnet vpc)

# Define helper function
usage() {
    echo "Usage: $0 <init|plan|apply|destroy> [resource_folders...]"
    echo
    echo "Examples:"
    echo "  $0 init                  # terraform init for all resources"
    echo "  $0 plan                  # terraform plan for all resources"
    echo "  $0 apply ec2 sg          # apply only ec2 and sg"
    echo "  $0 destroy               # destroy all in reverse order"
    exit 1
}

# Parse arguments
ACTION=$1
shift || true  # shift away the first argument, avoid error if none

if [[ -z "$ACTION" ]]; then
    echo "❌ No action provided."
    usage
fi

if [[ "$ACTION" != "apply" && "$ACTION" != "destroy" && "$ACTION" != "plan" && "$ACTION" != "init" ]]; then
    echo "❌ Invalid action: $ACTION"
    usage
fi

# Determine folders to operate on
if [[ $# -gt 0 ]]; then
    FOLDERS=("$@")  # user-specified folders
else
    case "$ACTION" in
        init|apply|plan)
            FOLDERS=("${APPLY_ORDER[@]}")
            ;;
        destroy)
            FOLDERS=("${DESTROY_ORDER[@]}")
            ;;
    esac
fi

# Function to run terraform commands in a folder
run_terraform() {
    local folder=$1
    echo
    echo "======================================="
    echo "Processing folder: $folder"
    echo "Action: $ACTION"
    echo "======================================="
    cd "$folder"

    case "$ACTION" in
        init)
            echo "Initializing Terraform..."
            terraform init
            ;;
        plan)
            echo "Planning Terraform changes..."
            terraform plan
            ;;
        apply)
            echo "Applying Terraform..."
            terraform apply -auto-approve
            ;;
        destroy)
            echo "Destroying Terraform..."
            terraform destroy -auto-approve
            ;;
    esac

    cd - > /dev/null
}

# Loop through folders
for folder in "${FOLDERS[@]}"; do
    if [[ ! -d "$folder" ]]; then
        echo "Resource folder '$folder' does not exist. Skipping..."
        continue
    fi
    run_terraform "$folder"
done

echo
echo "=============================="
echo "Terraform $ACTION completed!"
echo "=============================="
