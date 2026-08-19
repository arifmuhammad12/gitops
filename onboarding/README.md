# Onboarding — Be A DevOps Employee (Local Machine Track)

Selamat datang! Halaman ini adalah titik awal perjalanan belajar DevOps Anda.

## Langkah 1: Pilih Panduan Instalasi Sesuai OS Anda

| OS | Panduan |
|----|---------|
| Mac Apple Silicon (M1/M2/M3) | [mac-as/README.md](./mac-as/README.md) |
| Windows 10/11 (WSL2) | [windows-wsl2/README.md](./windows-wsl2/README.md) |
| Ubuntu / Debian Linux | [linux/README.md](./linux/README.md) |

## Langkah 2: Jalankan Pre-flight Check

Setelah instalasi selesai, verifikasi semua tool berjalan dengan benar:

```bash
cd ..
./00-preflight/check-env.sh
```

Output yang Anda harapkan:
```
✅ Docker        → 27.x.x
✅ KinD          → 0.23.x
✅ kubectl       → 1.32.x
✅ Helm          → 3.15.x (or Helm 4.x)
✅ Terraform     → 1.9.x
✅ Git           → 2.x.x
✅ RAM           → 16 GB (minimum: 8 GB)
✅ Disk Free     → 45 GB (minimum: 20 GB)

🎉 Environment siap! Lanjutkan ke stage 01-local-infra/
```
35: 
36: ## Langkah 3: Kenali DevOps
37: 
38: Sebelum lanjut ke lab teknikal, pahami dulu:
39: 
40: - **Apa itu DevOps?** Budaya + praktik untuk mempercepat delivery software secara aman dan dapat diandalkan
41: - **DevOps vs SRE** — DevOps adalah filosofi; SRE adalah implementasi Google-style
42: - **SDLC Modern** — Plan → Code → Build → Test → Release → Deploy → Operate → Monitor → (loop)
43: - **Mengapa local-first?** — Skill yang sama dengan cloud, tapi tanpa biaya; cocok untuk belajar dan eksperimen
44: 
## Tool yang Akan Kita Install

| Tool | Fungsi | Versi Target |
|------|--------|--------------|
| Docker Desktop / Engine | Container runtime | 27.x+ |
| KinD | Kubernetes in Docker | 0.26.x+ |
| kubectl | Kubernetes CLI | 1.32.x |
| Helm | Kubernetes package manager | 3.15.x |
| Terraform | Infrastructure as Code | 1.9.x |
| Git | Version control | 2.x |
