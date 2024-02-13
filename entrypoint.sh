#!/bin/bash

set -xe

export NAMESPACE
export POD_NAME=$(kubectl get pods -n "$NAMESPACE" | grep $JOB_NAME | awk '{print $1}');
export JOB_NAME=$(kubectl get job -n "$NAMESPACE" | grep $JOB_NAME | awk '{print $1}');
export SLEEP_TIME
export LOG_FOLLOW_DURATION
export JOB_FILEPATH

echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG="${PWD}kubeconfig"
chmod 600 "${PWD}/kubeconfig"

function job_status() {
  local response=""

  while true; do
      POD_STATUS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}')

      if [ "$POD_STATUS" == "Running" ]; then
          response+="Pod $POD_NAME is running. Following logs for $LOG_FOLLOW_DURATION seconds..."
          # Follow the logs for a specified duration
          log_output=$(timeout $LOG_FOLLOW_DURATION kubectl logs -f "$POD_NAME" -n "$NAMESPACE")
          response+="$log_output\n"
          break # Exit the loop
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
          break
      elif [ "$STATUS" == "False" ]; then
          response+="Job failed"
      else
          response+="Job is still running"
          sleep $SLEEP_TIME
      fi
  done

  echo "$response"
}

env

# Check if JOB_NAME is set
if [ -z "$JOB_NAME" ]; then
  echo "JOB_NAME is not set. Exiting..."
  exit 1
fi

jobStatusOutput=$(job_status)
jobLogsOutput=$(job_logs)

output="${jobStatusOutput}\n${jobLogsOutput}"
{
  echo "response<<EOF";
  echo "$output";
  echo "EOF";
} >> "${GITHUB_OUTPUT}"
