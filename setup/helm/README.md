# Helm Install

## Summary
This guide will show how to install Helm in a server in order to install Charts.

#### Prerequisite:
- A bastion server with kubectl

## Steps to install Kubed

```sh
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
