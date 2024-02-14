# kubectl-jobs-action

GitHub Action for executing kubectl and helm commands on a Kubernetes cluster.
It will also pull the logs from a job that is running on the cluster.

The Helm version installed in the action is 3.8.0. <br />
The Kubectl version installed in the action is 1.21.2.

## Input Variables

### Required
* **namespace**: The namespace to use when getting information or where the job is running.
* **KUBE_CONFIG_DATA**: The base64 encoded kubeconfig file that is used to authenticate with the Kubernetes cluster.
* **cluster-name**: The name of the cluster to use for authenticating or getting information from the cluster.

### Optional
* **sleep-time**: The time to wait before pulling the logs from the job. Default is 5 seconds.
* **log-follow-duration**: The amount of time used to pull the logs. Default is 60 seconds.
* **job-filepath**: The path where the job manifest(s) are located.
* **command**: The command to run on the Kubernetes cluster. This can be either `kubectl` or `helm`.



# Example
```yaml
name: deploy

on:
  push:
    branches:
        - master
        - develop

jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      AWS_REGION: us-west-2
      CLUSTER_NAME: my-staging
    steps:
      - uses: actions/checkout@v3

      - name: AWS Credentials
        uses: aws-actions/configure-aws-credentials@v3
        with:
          role-to-assume: arn:aws:iam::<your account id>:role/github-actions
          role-session-name: ci-run-${{ github.run_id }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: kubeconfig
        run: |
          aws eks update-kubeconfig --name ${{ env.CLUSTER_NAME }} --region ${{ env.AWS_REGION }}  --kubeconfig ./kubeconfig
          echo 'KUBE_CONFIG_DATA<<EOF' >> $GITHUB_ENV
          echo $(cat ./kubeconfig | base64) >> $GITHUB_ENV
          echo 'EOF' >> $GITHUB_ENV

      - name: helm deploy
        uses: truemark/kubectl-logs-action@master
        with:
          KUBE_CONFIG_DATA: ${{ env.KUBE_CONFIG_DATA }}
          job-name: integration-tests-${{ inputs.deployment_env }}
          namespace: default
          job-filepath: integration-tests/${{ inputs.deployment_env }}
          sleep-time: 2
          log-follow-duration: 30
          cluster-name: ${{ env.CLUSTER_NAME }}
```
### Example of using the action to run a kubectl command
```yaml
- name: kubectl get pods
  uses: truemark/kubectl-logs-action@master
  with:
    KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
    namespace: default
    command: kubectl get pods
    cluster-name: ${{ env.CLUSTER_NAME }}
```
### Example of using the action pull logs from a job
```yaml
- name: pull logs from job
  uses: truemark/kubectl-logs-action@master
  with:
    KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
    namespace: default
    job-name: integration-tests-${{ inputs.deployment_env }}
    sleep-time: 2
    log-follow-duration: 30
    cluster-name: ${{ env.CLUSTER_NAME }}
```
