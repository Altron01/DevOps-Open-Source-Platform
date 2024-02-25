# Rancher Helm deployment

## Summary
This guide will show how to install the Rancher operator via Helm, this will allow you to manage multiple clusters in a centralize manner without worrying about vendors. The process is the same independently of the kubernetes or rancher version. Just be ware of Rancher-Kubernetes compatibility.

| Software | Version |
| ------ | ------ |
| K8s | v1.27.3 |
| Rancher | v2.8.1 |
| Rancher Helm Chart | v2.16.8-rancher2 |
| Cert-Manager | v1.13.2 |
| Kubed | v0.13.2 |
| Nginx Ingress | v1.9.5 |
| Nginx Ingress Helm Chart | v4.9.0 |

#### Prerequisite:
- A Kubernetes cluster
- A bastion server with kubectl and helm
- Cert-Manager already installed and configured (check the "cert-manager" guide)
- Kubed already installed (check the "kubed" guide)

## Steps to install Rancher

Pull the Helm chart into the bastion
```sh
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update
```
Create the namespace
```sh
kubectl create namespace cattle-system
```
Label the namespace to copy the certificate
```sh
kubectl label ns rancher cert-manager-tls=ops-wildcard
```
Install Rancher
```sh
helm upgrade --install rancher rancher-latest/rancher --namespace cattle-system --set hostname=[your domain for rancher] --set bootstrapPassword=admin --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=[email configured in cert-manager] --set letsEncrypt.ingress.class=nginx
```
