# Keycloak Helm deployment

## Summary
This guide will show how to install the Keycloak via Helm, this allows you ho have a Single-Sign-On for all your other platforms. It supports SAMLv2/OIDC for connections and role management from a centralized platform. If needed I can be bound to IdPs such as Google Workspaces.

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

## Steps to install Keycloak

Write secrets.yaml to a file in bastion
```sh
apiVersion: v1
kind: Secret
metadata:
  name: keycloak-db-creds
  namespace: keycloak
type: Opaque
stringData:
  password.txt: [Non-encoded value]

---

apiVersion: v1
kind: Secret
metadata:
  name: keycloak-user-creds
  namespace: keycloak
type: Opaque
stringData:
  password.txt: [Non-encoded value]

```
Create secret on K8s
```sh
kubectl apply -f secrets.yaml 
```
Modify values.yaml to your use case
```sh
hostname: keycloak.hwcops.altronstudio.com ## Line 532
extraTls: ## Line 580
    - hosts:
        - keycloak.hwcops.altronstudio.com
      secretName: ops-altronstudio-com-wildcard-cert-tls
```
Pull the Helm chart into the bastion
```sh
helm repo add keycloak https://charts.bitnami.com/bitnami
helm repo update
```
Create namespace and tag with annotation to get SSL certificate
```sh
kubectl create ns keycloak
kubectl label ns keycloak cert-manager-tls=ops-wildcard
```
Install Keycloak
```sh
helm upgrade --install keycloak keycloak/keycloak --namespace keycloak --values values.yaml
```