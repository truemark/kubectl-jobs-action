#!/bin/bash

set -xe

function job_status() {
  local response=""

  while true; do

    POD_NAME=$(kubectl get pods -n "$NAMESPACE" | grep $JOB_NAME | awk '{print $1}');
    POD_STATUS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}')

    if [ "$POD_STATUS" == "Running" ]; then
        response+="Pod $POD_NAME is running. Following logs for $LOG_FOLLOW_DURATION seconds..."
        # Follow the logs for a specified duration
        log_output=$(timeout $LOG_FOLLOW_DURATION kubectl logs -f "$POD_NAME" -n "$NAMESPACE")
        response+="$log_output\n"
        break # Exit the loop
    elif [ "$POD_STATUS" == "Error" ]; then
        kubectl delete pod $POD_NAME -n "$NAMESPACE"
    else
        response+="Pod $POD_NAME is not in 'Running' status. Current status is $POD_STATUS. Retrying in $SLEEP_TIME seconds..."
        sleep $SLEEP_TIME
    fi
  done

  echo "$response"
}

function job_logs() {
  local response=""

  while true; do
      STATUS=$(kubectl get job $JOB_NAME -n $NAMESPACE -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}')

      if [ "$STATUS" == "True" ]; then
          response+="\nJob: $JOB_NAME completed successfully\n"
          sleep 1
          kubectl delete -f $JOB_FILEPATH -n "$NAMESPACE"
          exit 0
      elif [ "$STATUS" == "False" ]; then
          response+="Job failed"
      else
          response+="Job is still running"
          sleep $SLEEP_TIME
      fi
  done

  echo "$response"
}


echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG="${PWD}/kubeconfig"
chmod 600 "${PWD}/kubeconfig"

if [ ! -z "$INPUT_COMMAND" ]; then
  output=$(bash -c "${INPUT_COMMAND}")
else
  # Check if JOB_NAME is set
  if [ -z "$JOB_NAME" ]; then
    echo "JOB_NAME is not set. Exiting..."
    exit 1
  fi
  jobStatusOutput=$(job_status)
  jobLogsOutput=$(job_logs)
  output="${jobStatusOutput}\n${jobLogsOutput}"
fi

{
  echo "response<<EOF";
  echo "$output";
  echo "EOF";
} >> "${GITHUB_OUTPUT}"
