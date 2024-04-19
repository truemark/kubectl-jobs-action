#!/bin/bash

JOB_NAME=$1
NAMESPACE=$2
SLEEP_TIME=$3
LOG_FOLLOW_DURATION=$4
KUBE_CONFIG_DATA=$5
JOB_FILEPATH=$6
INPUT_COMMAND=$7
CLUSTER_NAME=$8

# Function to delete manifests
delete_manifests() {
  echo "No pod found matching job name $JOB_NAME in namespace $NAMESPACE. Deleting manifests..."
  kubectl delete -f "$JOB_FILEPATH" -n "$NAMESPACE"
  exit 1
}

# Function to print logs of failed integration tests to a file.
print_logs() {
  echo "Tests appear to have failed. Printing logs to file..."
  if [ ! -d "failed_tests" ]; then
    mkdir -p failed_tests
  fi
  kubectl logs "$pod_name" -n "$NAMESPACE" > failed_tests/${pod_name}-failed_tests.log
}


echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG="${PWD}/kubeconfig"
chmod 600 "${PWD}/kubeconfig"
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --kubeconfig "${PWD}/kubeconfig"

if [ ! -z "$INPUT_COMMAND" ]; then
  eval "${INPUT_COMMAND}"
else
  # Check if NAMESPACE is set
  if [ -z "$NAMESPACE" ]; then
    echo "NAMESPACE is not set. Exiting..."
    exit 1
  fi

  while true; do

    # Get all pods with 'integration' in their name and their status
    readarray -t pod_lines <<< "$(kubectl get pods --no-headers -n "$NAMESPACE" | grep integration | awk '{print $1, $3}')"

    if [ ${#pod_lines[@]} -eq 0 ]; then
      delete_manifests
      exit 1
    fi

    for line in "${pod_lines[@]}"; do
        pod_name=$(echo $line | awk '{print $1}')
        pod_status=$(echo $line | awk '{print $2}')

        case $pod_status in
            Running)
              timeout $LOG_FOLLOW_DURATION kubectl logs -f "$pod_name" -n "$NAMESPACE"
              break
              ;;
            Error)
              print_logs
              kubectl delete pod "$pod_name" -n "$NAMESPACE"
              ;;
            Completed)
              echo "Tests have completed successfully."
              kubectl delete -f $JOB_FILEPATH -n $NAMESPACE
              exit 0
              ;;
            *)
              echo "Pod $pod_name is not in 'Running' status. Current status is $pod_status. Retrying in $SLEEP_TIME seconds..."
              sleep "$SLEEP_TIME"
              ;;
        esac
        if [ -z "$pod_name" ]; then
          delete_manifests
          exit 1
        fi
    done
  done
fi
