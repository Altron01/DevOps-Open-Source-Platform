# Kubed Helm deployment

## Summary
This guide will show how to install Kubed via Helm, this will allow you to sync secrets among your namespaces. The process is the same independently of the kubernetes version.

| Software | Version |
| ------ | ------ |
| K8s | v1.27.3 |
| Kubed | v0.13.2 |

#### Prerequisite:
- A Kubernetes cluster
- A bastion server with kubectl and helm

## Steps to install Kubed

```sh
helm install kubed appscode/kubed -n kube-system
```
