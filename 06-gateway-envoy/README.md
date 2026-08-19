# 07 — API Gateway (Envoy Gateway & Gateway API di KinD)

## Tujuan
Memahami arsitektur modern **Kubernetes Gateway API** dan menggunakan **Envoy Gateway** untuk mengatur lalu lintas data (*traffic routing*), TLS termination, dan akses domain lokal microservices.

## Langkah Eksekusi

```bash
# 1. Install Envoy Gateway via Helm
helm install eg oci://docker.io/envoyproxy/gateway-helm \
  --version v1.8.2 \
  -n envoy-gateway-system \
  --create-namespace

# 2. Label namespace agar diizinkan di-route oleh Envoy Gateway
kubectl label namespace argocd shared-gateway-access=true --overwrite

# 3. Apply GatewayClass & Gateway resource
kubectl apply -f 07-gateway-envoy/manifests/
```
