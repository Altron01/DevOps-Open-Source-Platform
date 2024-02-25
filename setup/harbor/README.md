# Harbor Helm deployment

## Summary
This guide will show how to install the Harbor via Helm, this allows store Docker images and Helm charts on scalable storages like buckets. Harbor can replica TO and FROM other vendors in order to optimize image download speeds and allow true centralization of artifacts. Harbor can scan images to look for vulnerabilities and provide robot account to be accesed by third-party services

| Software | Version |
| ------ | ------ |
| K8s | v1.27.3 |
| Cert-Manager | v1.13.2 |
| Kubed | v0.13.2 |
| Nginx Ingress | v1.9.5 |
| Nginx Ingress Helm Chart | v4.9.0 |

#### Prerequisite:
- A Kubernetes cluster
- A bastion server with kubectl and helm
- Kubed already installed (check the "kubed" guide)
- A Postgres 13 database

## Steps to install Harbor

Write secrets.yaml to a file in bastion
```sh
apiVersion: v1
kind: Secret
metadata:
  name: harbor-db-password
  namespace: harbor
type: Opaque
stringData:
  password: [Non-encoded value]

---

apiVersion: v1
kind: Secret
metadata:
  name: harbor-registry
  namespace: default
  annotations:
    kubed.appscode.com/sync: ""
type: Opaque
stringData:
  password: [Non-encoded value]
```
Create secret on K8s
```sh
kubectl apply -f secrets.yaml 
```
Modify values.yaml to your use case
```sh
database:
  external:
    host: [EXTERNAL DATABASE IP] ## Line 34
expose:
  ingress:
    hosts:
      core: [YOUR HARBOR DOMAIN] ## Line 102
      notary: [YOUR HARBOR NOTARY DOMAIN]
  tls:
    secret:
      notarySecretName: [YOUR CERTIFICATE NAME] ## Line 135
      secretName: [YOUR CERTIFICATE NAME]
externalURL: [YOUR HARBOR DOMAIN] ## Line 138
persistence:
  enabled: true
  imageChartStorage:
    s3: ## Line 278
      bucket: [BUCKET NAME]
      region: [BUCKET REGION]
      accesskey: [ACCESS KEY]
      secretkey: [SECRET KEY]
      regionendpoint: [SERVICE ENDPOINT]
      secure: true
    type: s3
    
redis:
  external:
    addr: [IP:PORT OF REDIS] ##Line 354
```
Pull the Helm chart into the bastion
```sh
helm repo add harbor https://helm.goharbor.io
helm repo update
```
Create namespace and tag with annotation to get SSL certificate
```sh
kubectl create ns harbor
kubectl label ns harbor cert-manager-tls=ops-wildcard
```
Install Harbor
```sh
helm upgrade --install harbor-helm harbor/harbor --namespace harbor --values values.yaml
```