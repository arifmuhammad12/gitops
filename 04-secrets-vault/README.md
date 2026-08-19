# 05 — Secret Management (HashiCorp Vault + ESO di Local Machine Track)

**Prasyarat:** 03-local-infra (KinD cluster berjalan) & 04-gitops (ArgoCD aktif).

## Tujuan
Mengelola data rahasia (*secrets*) aplikasi seperti Database Passwords, JWT Tokens, dan API Keys secara terpusat menggunakan **HashiCorp Vault** dan mendistribusikannya ke Pod Kubernetes via **External Secrets Operator (ESO)**.

## Arsitektur Secret Injection (Level 3 Security)

```
Docker Build (Bebas .env / No Baked Secrets) ──> Image Bersih
                                                        │
HashiCorp Vault (KV Secrets Engine v2)                 │ (Deploy)
            │                                           │
   External Secrets Operator ◄──────────────────────────┘
            │ (Sync)
   Kubernetes Secret Native (Opaque)
            │ (Mount)
   ┌────────┴────────┐
   ▼                 ▼
[ envFrom ]     [ volumeMount ]
 (DB, JWT)     (private_key.pem)
```

## Langkah Eksekusi

```bash
# 1. Install External Secrets Operator (ESO) & Vault via Helm di KinD
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace

# 2. Port-forward Vault UI untuk verifikasi
kubectl port-forward svc/vault 8200:8200 -n vault
```
