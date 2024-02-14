#!/bin/bash


JOB_NAME=$1
NAMESPACE=$2
SLEEP_TIME=$3
LOG_FOLLOW_DURATION=$4
KUBE_CONFIG_DATA=$5
JOB_FILEPATH=$6
INPUT_COMMAND=$7
CLUSTER_NAME=$8

echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG="${PWD}/kubeconfig"
chmod 600 "${PWD}/kubeconfig"
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --kubeconfig "${PWD}/kubeconfig"

if [ ! -z "$INPUT_COMMAND" ]; then
  bash -c "${INPUT_COMMAND}"
else
  # Check if NAMESPACE is set
  if [ -z "$NAMESPACE" ]; then
    echo "NAMESPACE is not set. Exiting..."
    exit 1
  fi

  while true; do

    POD_NAME=$(kubectl get pods -n "$NAMESPACE" | grep $JOB_NAME | awk '{print $1}');
    POD_STATUS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}')

    if [ "$POD_STATUS" == "Running" ]; then
        echo "Pod $POD_NAME is running. Following logs for $LOG_FOLLOW_DURATION seconds..."
        # Follow the logs for a specified duration
        timeout $LOG_FOLLOW_DURATION kubectl logs -f "$POD_NAME" -n "$NAMESPACE"
        break
    elif [ "$POD_STATUS" == "Error" ]; then
        kubectl delete pod $POD_NAME -n "$NAMESPACE"
    else
        echo "Pod $POD_NAME is not in 'Running' status. Current status is $POD_STATUS. Retrying in $SLEEP_TIME seconds..."
        sleep $SLEEP_TIME
    fi
  done

  while true; do
      STATUS=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}')

      if [ "$STATUS" == "True" ]; then
          echo "\nJob: $JOB_NAME completed successfully\n"
          sleep 1
          kubectl delete -f $JOB_FILEPATH -n "$NAMESPACE"
          exit 0
      elif [ "$STATUS" == "False" ]; then
          echo "Job failed"
      else
          echo "Job is still running"
          sleep $SLEEP_TIME
      fi
  done
fi

