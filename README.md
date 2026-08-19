# Be A DevOps Employee — Local Machine Track

Platform DevOps production-grade end-to-end, **100% berjalan di laptop/PC Anda** menggunakan KinD (Kubernetes in Docker). Tidak memerlukan akun cloud atau biaya cloud.

## Prasyarat Minimum

| Kebutuhan | Minimum |
|-----------|---------|
| RAM | 8 GB (16 GB direkomendasikan) |
| Disk | 20 GB free |
| OS | Mac (Apple Silicon), Windows 10/11 (WSL2), Ubuntu/Debian |

## Cara Mulai

```bash
# 1. Install semua tool yang dibutuhkan (pilih sesuai OS Anda)
./scripts/install-mac-as.sh    # Mac Apple Silicon
./scripts/install-linux.sh     # Ubuntu/Debian (atau di dalam WSL2)

# 2. Verifikasi semua tool sudah siap
./00-preflight/check-env.sh

# 3. Mulai dari onboarding
cat onboarding/README.md
```

## Urutan Stage

| Stage | Folder | Fokus |
|-------|--------|-------|
| Onboarding | `onboarding/` | Install tool, intro DevOps mindset |
| 00 | `00-preflight/` | Verifikasi environment siap |
| 01 | `01-ci-jenkins/` | Official Jenkins Container, Shared Library, DevSecOps Trivy |
| 02 | `02-local-infra/` | Terraform: provisioning KinD Kubernetes cluster |
| 03 | `03-gitops/` | ArgoCD app-of-apps + Kustomize |
| 04 | `04-secrets-vault/` | HashiCorp Vault di KinD + External Secrets |
| 05 | `05-sso-keycloak/` | Keycloak SSO di KinD |
| 06 | `06-gateway-envoy/` | Envoy Gateway (Gateway API) di KinD |
| 07 | `07-observability/` | Prometheus + Grafana |
| 08 | `08-capstone/` | End-to-end flow + troubleshooting lab |

## Stack Teknologi

- **KinD** — Kubernetes lokal di atas Docker
- **Terraform** — IaC dengan `provider-kind`, `provider-helm`, `provider-docker`
- **Helm** — Deploy semua service ke KinD
- **Ansible** — Configuration management
- **Jenkins** — CI/CD pipeline
- **ArgoCD** — GitOps continuous delivery
- **Vault** — Secrets management
- **Keycloak** — SSO & identity
- **Envoy Gateway** — API gateway
- **Prometheus + Grafana** — Observability

## Aturan Repo

- Nilai environment selalu via `*.example` files; tidak hardcoded
- `terraform.tfstate` tidak di-commit (local backend)
- Tidak ada secret plaintext di repo
- Tiap stage punya `teardown.sh` untuk cleanup

---

> **Track GCP**: Lihat `../course-project/` untuk versi yang di-deploy ke Google Cloud.
> Kedua track tidak saling mempengaruhi.
