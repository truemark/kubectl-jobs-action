#!/bin/bash

#JOB_NAME=$1
#NAMESPACE=$2
#SLEEP_TIME=$3
#LOG_FOLLOW_DURATION=$4
#KUBE_CONFIG_DATA=$5
#JOB_FILEPATH=$6
#INPUT_COMMAND=$7
#CLUSTER_NAME=$8

JOB_NAME='integration-tests-qa'
NAMESPACE='perf-qa'
SLEEP_TIME=5
LOG_FOLLOW_DURATION=60
KUBE_CONFIG_DATA='YXBpVmVyc2lvbjogdjEKY2x1c3RlcnM6Ci0gY2x1c3RlcjoKICAgIGNlcnRpZmljYXRlLWF1dGhvcml0eS1kYXRhOiBMUzB0TFMxQ1JVZEpUaUJEUlZKVVNVWkpRMEZVUlMwdExTMHRDazFKU1VSQ1ZFTkRRV1V5WjBGM1NVSkJaMGxKU0ZkVGJHbHFXalZYVFhkM1JGRlpTa3R2V2tsb2RtTk9RVkZGVEVKUlFYZEdWRVZVVFVKRlIwRXhWVVVLUVhoTlMyRXpWbWxhV0VwMVdsaFNiR042UVdWR2R6QjVUWHBGZDAxNlFYbE5lbFV3VFZSYVlVWjNNSHBOZWtWM1RXcGplVTE2VlRWTlZGcGhUVUpWZUFwRmVrRlNRbWRPVmtKQlRWUkRiWFF4V1cxV2VXSnRWakJhV0UxM1oyZEZhVTFCTUVkRFUzRkhVMGxpTTBSUlJVSkJVVlZCUVRSSlFrUjNRWGRuWjBWTENrRnZTVUpCVVVOcFFqVjVRV3hMWWpseFIwOVpWMjlrUm13MlZWY3daSHAxT0RBeVZsTkZlazkxU1hocE1qZFhPV3BMU1VNdlZ6UlZTRGRuT0RGaVpqRUtZekZzTUhwUVVXbFVWVFZ2Tm1SQ2NFOVpkRUZTWm1kbFoxWnRjM05VWkRoVlFXMU9MMVl6V2paUWIxQlJiVlY2YVRSSE4yZEtXblZzVTIxWmJYSmFNUXBYVDJWS04wb3phR0poVWpsSGFuUjBibTQyUzBkNk9FTkxPVmRpU0RBeGVVdHJWR3hYUkVOT1Iwc3JjeTlQTVVOM2NIZERUWE5aWlZWUk5IZzNVMmc0Q2tWcVl6VXJSVlJxU21RMGVWTkJOVWhwYTFwaVpXVjFVRUppZVd0UWFubFRNMkZ1YmprMlZEbE5WV3hJZWtWcEsxbFlXRWx2ZG5kV2NsRnJVU3RKWmpJS1UyUnNjVlI0V1ZOUWMydDJXSEpaVlVsRE5FOTFZM2MxZG5WWmFTczJjamR6ZG05amJXeHFVR0k0ZGtOM1JVRnpMMU52VTFrclEyTnRPVEJKUVZsYU9BcGpNSFZVZWs1dVZHTjNWR1p0U0VWSE16WnJOVzVyVERCSWVuaGtRV2ROUWtGQlIycFhWRUpZVFVFMFIwRXhWV1JFZDBWQ0wzZFJSVUYzU1VOd1JFRlFDa0puVGxaSVVrMUNRV1k0UlVKVVFVUkJVVWd2VFVJd1IwRXhWV1JFWjFGWFFrSlNhazU0TVRSNE1uRjNiek5pUW1GYWFFVTBNMnRGUlhkbVdVUkVRVllLUW1kT1ZraFNSVVZFYWtGTloyZHdjbVJYU214amJUVnNaRWRXZWsxQk1FZERVM0ZIVTBsaU0wUlJSVUpEZDFWQlFUUkpRa0ZSUVVaTFZVVllWM2hYUWdvdmJFMXRRbWxGYkdaUmJqRlRjelpGY25RcldpdHdZbVpsY1dOdVUyaE9RazgxWnpkWVVtdHROVlZRVTA0eWFWTnhPV05KZGxJeWVFMXRURGRYZEhjMkNqRmtWbVJDY21kVlRWYzVRa2xHZDA1VmJIVnZPRFJvUkROallWRm1ZVXRLYzA5a2JrOWhSVEJwU0U1RlVDdDZaRkVyUlRWS2QybzROalJ1YW10bk1EZ0taMGxZTkZSalpYazFNVzFUVTNWbmJqTlBkMGRZVkZCa2FFcFROR0YwTTFwNGNXZDJNekJJVVVreVNESnhUa1ZYYXpSTFFuVk1jVEpIUVVWTWRrMDRaUXA2V21jMkwxVlJlalYxZFd0NVJXTlRkMnh2VFhOamR6WnRURVJSTTNRNGNXUk9kRmN3VW1Wd1IwTkVaelJvUm1kTFVscGtTRW95ZDFKcGN6WkdjVVI0Q21sT01FTlVUMHRSTmtoc1ozUkhXaXN5WTJodFJIRXZVVWhNVnpGdVZIQTNjVmRpVUdWTWJVTk5WMDlQVjNsSFVHTkJaRWxIU0RscVNucDRlVWd4YjNBS09VWk9PVGhxTUhkcFlWcHdDaTB0TFMwdFJVNUVJRU5GVWxSSlJrbERRVlJGTFMwdExTMEsKICAgIHNlcnZlcjogaHR0cHM6Ly8wOUQ0OUI4QzFBQzhBMzc2N0NCMTU0MzNFRkFDRDc5Qi5ncjcudXMtd2VzdC0yLmVrcy5hbWF6b25hd3MuY29tCiAgbmFtZTogYXJuOmF3czpla3M6dXMtd2VzdC0yOjMxMzA3MDAzMjQxMjpjbHVzdGVyL3NlcnZpY2VzCmNvbnRleHRzOgotIGNvbnRleHQ6CiAgICBjbHVzdGVyOiBhcm46YXdzOmVrczp1cy13ZXN0LTI6MzEzMDcwMDMyNDEyOmNsdXN0ZXIvc2VydmljZXMKICAgIHVzZXI6IGFybjphd3M6ZWtzOnVzLXdlc3QtMjozMTMwNzAwMzI0MTI6Y2x1c3Rlci9zZXJ2aWNlcwogIG5hbWU6IGFybjphd3M6ZWtzOnVzLXdlc3QtMjozMTMwNzAwMzI0MTI6Y2x1c3Rlci9zZXJ2aWNlcwpjdXJyZW50LWNvbnRleHQ6IGFybjphd3M6ZWtzOnVzLXdlc3QtMjozMTMwNzAwMzI0MTI6Y2x1c3Rlci9zZXJ2aWNlcwpraW5kOiBDb25maWcKcHJlZmVyZW5jZXM6IHt9CnVzZXJzOgotIG5hbWU6IGFybjphd3M6ZWtzOnVzLXdlc3QtMjozMTMwNzAwMzI0MTI6Y2x1c3Rlci9zZXJ2aWNlcwogIHVzZXI6CiAgICBleGVjOgogICAgICBhcGlWZXJzaW9uOiBjbGllbnQuYXV0aGVudGljYXRpb24uazhzLmlvL3YxYmV0YTEKICAgICAgYXJnczoKICAgICAgLSAtLXJlZ2lvbgogICAgICAtIHVzLXdlc3QtMgogICAgICAtIGVrcwogICAgICAtIGdldC10b2tlbgogICAgICAtIC0tY2x1c3Rlci1uYW1lCiAgICAgIC0gc2VydmljZXMKICAgICAgY29tbWFuZDogYXdzCg=='
JOB_FILEPATH='/Users/jcelli/Documents/bitbucket-repos/OCT/perf-give-api/integration-tests/qa'
INPUT_COMMAND=$7
CLUSTER_NAME='services'

echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG="${PWD}/kubeconfig"
chmod 600 "${PWD}/kubeconfig"
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --kubeconfig "${PWD}/kubeconfig"

# Function to delete manifests
delete_manifests() {
  echo "No pod found matching job name $JOB_NAME in namespace $NAMESPACE. Deleting manifests..."
  kubectl delete -f "$JOB_FILEPATH" -n "$NAMESPACE"
  exit 1
}

if [ ! -z "$INPUT_COMMAND" ]; then
  eval "${INPUT_COMMAND}"
else
  # Check if NAMESPACE is set
  if [ -z "$NAMESPACE" ]; then
    echo "NAMESPACE is not set. Exiting..."
    exit 1
  fi

  while true; do

    POD_NAME=$(kubectl get pods -n "$NAMESPACE" | grep $JOB_NAME | awk '{print $1}');

    # Check if POD_NAME is empty
    if [ -z "$POD_NAME" ]; then
      delete_manifests
      exit 1
    fi

    POD_STATUS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}')

    if [ "$POD_STATUS" == "Running" ]; then
        echo "Pod $POD_NAME is running. Following logs for $LOG_FOLLOW_DURATION seconds..."
        timeout $LOG_FOLLOW_DURATION kubectl logs -f "$POD_NAME" -n "$NAMESPACE"
        break
    elif [ "$POD_STATUS" == "Error" ]; then
        kubectl delete pod "$POD_NAME" -n "$NAMESPACE"
    else
        echo "Pod $POD_NAME is not in 'Running' status. Current status is $POD_STATUS. Retrying in $SLEEP_TIME seconds..."
        sleep "$SLEEP_TIME"
    fi
  done

  COUNTER=0
  MAX_RETRIES=5

  while true; do

    # Increment counter
    COUNTER=$((COUNTER+1))

    # Check if counter has reached the max retries
    if [ "$COUNTER" -ge "$MAX_RETRIES" ]; then
        echo "Maximum retries ($MAX_RETRIES) reached. Exiting..."
        delete_manifests
        exit 1
        break
    fi
    STATUS=$(kubectl get job "$JOB_NAME" -n "$NAMESPACE" -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}')

    if [ "$STATUS" == "True" ]; then
        echo -e "\nJob: $JOB_NAME completed successfully\n"
        sleep 1
        kubectl delete -f "$JOB_FILEPATH" -n "$NAMESPACE"
        exit 0
    elif [ "$STATUS" == "False" ]; then
        echo "Job failed"
    else
        echo "Job is still running"
        sleep "$SLEEP_TIME"
    fi
  done
fi
