# Nginx Ingress Helm deployment

## Summary
This guide will show how to install the Nginx Ingress Controller via Helm, this will allow you to declare Ingresses and route http/https traffic along with declaring SSL backed subdomains with cert-manager. The process is the same independently of the kubernetes version.

| Software | Version |
| ------ | ------ |
| K8s | v1.27.3 |
| Nginx Ingress | v1.9.5 |
| Nginx Ingress Helm Chart | v4.9.0 |

#### Prerequisite:
- A Kubernetes cluster
- A bastion server with kubectl and helm

## Steps to install Nginx Ingress Controller

Modify the values fit your use case, these are some examples:

Assign an ELB to Nginx Ingress Controller on Huawei requires to declare two annotations to the service, autocreate which defines public ip and class which declares the type of ELB(Union means shared load balancer).
```sh
kubernetes.io/elb.class: union
kubernetes.io/elb.autocreate: 
          '{
              "type": "public",
              "bandwidth_name": "cce-bandwidth-1551163379627",
              "bandwidth_chargemode": "traffic",
              "bandwidth_size": 5,
              "bandwidth_sharetype": "PER",
              "eip_type": "5_bgp",
              "name": "dev-ingress-controller"
            }'   
```

Set policy to preserve source IP when passing requests to services.
```sh
externalTrafficPolicy: "Local"
```

Install Nginx Ingress Constroller
```sh
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace nginx --create-namespace --values=values.yaml
```
