# Menjadi DevOps Engineer — Local Machine Track

Platform pembelajaran DevOps production-grade end-to-end, **100% berjalan di laptop/PC lokal Anda** menggunakan KinD (Kubernetes in Docker). Tidak memerlukan akun cloud berbayar dan bebas dari biaya langganan.

---

## 🎯 Visi & Tujuan

Membekali mahasiswa, dosen, dan praktisi dengan kurikulum arsitektur DevOps nyata (CI/CD, IaC, GitOps, dan API Gateway) yang siap dijadikan **portofolio presentasi interview kerja** serta **blueprint script siap pakai** di perusahaan.

---

## 💻 Prasyarat Minimum Hardware

| Komponen | Spesifikasi Minimum | Rekomendasi |
|---|---|---|
| **RAM** | 8 GB | 16 GB |
| **Disk Space** | 20 GB free space | 30 GB SSD |
| **OS** | macOS (Apple Silicon / Intel), Windows 10/11 (WSL2), Linux (Ubuntu/Debian) | macOS / Linux |
| **Tools** | Docker Desktop / Docker Engine, Git | Docker Desktop aktif |

---

## 🚀 Panduan Mulai Cepat

```bash
# 1. Install seluruh tooling DevOps otomatis sesuai OS Anda
./scripts/install-mac-as.sh    # macOS (Apple Silicon M1/M2/M3/M4)
./scripts/install-linux.sh     # Ubuntu / Debian / WSL2

# 2. Verifikasi kesiapan environment & hardware
./00-preflight/check-env.sh

# 3. Akses materi pembelajaran interaktif
cd ../learning-platform && npm install && npm run dev
```

---

## 🏗️ Struktur Stage Pembelajaran

```
01-cicd-local-track/
├── 00-preflight/          # Script validasi kesiapan hardware & CLI tools
├── 01-ci-jenkins/         # Jenkins Container (JCasC) + Shared Library + Trivy
│   └── shared-library/    # [Submodule] Groovy Shared Library untuk CI/CD
├── 02-local-infra/        # Terraform: Provisioning KinD 3-Node Cluster (Port 80/443)
├── 03-gitops/             # [Submodule] ArgoCD GitOps, Kustomize & Envoy Gateway API
├── apps/
│   └── backend-go/        # [Submodule] Microservice Go dengan metadata CI di /healthz
├── onboarding/            # Panduan pengenalan & mindset DevOps
└── scripts/               # Script installer otomatis per OS
```

---

## 📑 Alur Pipeline End-to-End

```
[Developer Push] ➔ [GitHub Webhook] ➔ [Jenkins CI + Trivy] ➔ [Docker Build & KinD Load] ➔ [Update GitOps Repo] ➔ [ArgoCD Auto-Sync] ➔ [Envoy Gateway (localhost:80)]
```

| Phase / Stage | Folder | Fokus Materi & Praktik |
|---|---|---|
| **Phase 0: Preflight** | `00-preflight/` | Diagnostic script kesiapan OS, Docker, KinD, kubectl, Helm, Terraform. |
| **Phase 1: CI Pipeline** | `01-ci-jenkins/` | Jenkins Container (JCasC), Shared Library, Trivy Security Scan, auto-trigger PR Webhook. |
| **Phase 2: IaC Terraform** | `02-local-infra/` | Multi-node KinD cluster (1 control-plane, 2 workers) dengan port mapping 80/443. |
| **Phase 3: GitOps ArgoCD** | `03-gitops/` | App-of-Apps pattern, Kustomize base/overlay, automated reconciliation workload. |
| **Phase 4: API Gateway** | `03-gitops/infrastructure/gateway-api/` | Kubernetes Gateway API, EnvoyProxy KinD hostPort, routing microservice `backend-go`. |

---

## 🛠️ Tech Stack yang Digunakan

* **Container Orchestration**: KinD (Kubernetes in Docker)
* **Infrastructure as Code (IaC)**: Terraform (`provider-kind`, `provider-helm`, `provider-docker`)
* **Continuous Integration (CI)**: Jenkins Official Container + JCasC + Groovy Shared Library
* **Continuous Delivery / GitOps**: ArgoCD + Kustomize Overlays
* **Security & Vulnerability Scanner**: Aqua Security Trivy (DevSecOps)
* **API Gateway & Routing**: Envoy Gateway (Kubernetes Gateway API SIG-Network)
* **Sample Application**: `backend-go` (Go 1.22 Chi router dengan build metadata)

---

## 👥 Komunitas & Networking

* 💬 **WhatsApp Group Community**: [Gabung Diskusi](https://chat.whatsapp.com/JT6wmUPj2nKJEfPuYXIX7J?s=cl&p=i&mlu=4)
* 💼 **LinkedIn Instructor**: [M. Reza Zulfikar Naipospos](https://www.linkedin.com/in/m-reza-zulfikar-naipospos/)
