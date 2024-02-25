# Cert-Manager Helm deployment

## Summary
This guide will show how to install the Cert-Manager via Helm, this allows you to automaticly generate autorenewable SSL certificates signed by a third party authority such as lets encrypt. In order to retreive a valid signed certificate you will need to own a domain to attach to it. For this guide we are using Cloudflare as our domain and DNS provider.

Source: https://nolifelover.medium.com/create-cert-manager-clustterissuer-with-cloudflare-for-automate-issue-and-renew-lets-encrypt-ssl-4877d3f12b44
Source: https://cert-manager.io/docs/installation/helm/

| Software | Version |
| ------ | ------ |
| K8s | v1.27.3 |
| Cert-Manager | v1.13.2 |

#### Prerequisite:
- A Kubernetes cluster
- A bastion server with kubectl and helm
- Kubed already installed (check the "kubed" guide)

## Steps to install Cert-Manager

Pull the Helm chart into the bastion
```sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
```
Install Cert-Manager
```sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.crds.yaml
helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.14.0
```
Write cf_token.yaml to a file in bastion
```sh
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: cert-manager
type: Opaque
stringData:
  api-token: [Non encoded token here]
```
Create secret on K8s
```sh
kubectl apply -f cf_token.yaml 
```
Write cluster_issuer.yaml to a file in bastion
```sh
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod-cloudflare
  namespace: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: [email of domain owner]
    privateKeySecretRef:
      name: letsencrypt-prod-private-key-cloudflare
    solvers:
    - dns01:
        cloudflare:
          email: [email of domain owner]
          apiTokenSecretRef:
            name: cloudflare-api-token
            key: api-token
```
Create cluster issuer on K8s
```sh
kubectl apply -f cluster_issuer.yaml 
```
Write certificate.yaml to a file in bastion
```sh
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ops-altronstudio-com-wildcard-certificate
  namespace: cert-manager
spec:
  secretName: ops-altronstudio-com-wildcard-cert-tls ## Name of certificate on K8s
  issuerRef:
    name: letsencrypt-prod-cloudflare
    kind: ClusterIssuer
  dnsNames:
  - "[SUBDOMAINS COVERED BY CERTIFICATE]" ## Wildcard is allowed eg: *.hwcops.altronstudio.com
  secretTemplate:
    annotations:
      kubed.appscode.com/sync: "cert-manager-tls=ops-wildcard" ## Kubed annotation to sync on all namespace with this values
```
Create certificate on K8s
```sh
kubectl apply -f certificate.yaml 
```