# Panduan Instalasi — Windows 10/11 dengan WSL2

> **Estimasi waktu**: 25–35 menit (termasuk restart Windows)

## Overview

Di Windows, kita menggunakan **WSL2** (Windows Subsystem for Linux 2) sebagai environment Linux kita, dan **Docker Desktop** yang terintegrasi dengan WSL2. Semua perintah lab dijalankan di dalam terminal WSL2, bukan di PowerShell/CMD.

---

## Step 1: Aktifkan WSL2

Buka **PowerShell sebagai Administrator** dan jalankan:

```powershell
wsl --install
```

Perintah ini akan:
- Mengaktifkan fitur WSL dan Virtual Machine Platform
- Menginstall Ubuntu sebagai distro default
- Me-restart komputer otomatis

Setelah restart, Ubuntu akan terbuka dan meminta Anda membuat username + password Linux.

Verifikasi WSL2 aktif:
```powershell
wsl --status
# Default Version: 2
```

> **Sudah punya WSL tapi versi 1?** Upgrade ke WSL2:
> ```powershell
> wsl --set-default-version 2
> wsl --set-version Ubuntu 2
> ```

---

## Step 2: Install Docker Desktop

1. Download Docker Desktop dari: https://www.docker.com/products/docker-desktop/
2. Install dengan opsi default
3. Saat ditanya, **aktifkan "Use WSL 2 based engine"**
4. Buka Docker Desktop → Settings → Resources → **WSL Integration**
5. Aktifkan toggle untuk distro Ubuntu Anda
6. Klik **Apply & Restart**

Verifikasi (dari terminal WSL2/Ubuntu):
```bash
docker version
docker run --rm hello-world
```

---

## Step 3: Install Tool di WSL2

Buka terminal Ubuntu (dari Start Menu atau ketik `wsl` di PowerShell).

### Install KinD

```bash
# Download binary KinD
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

Verifikasi:
```bash
kind version
```

### Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
```

Verifikasi:
```bash
kubectl version --client
```

### Install Helm

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Verifikasi:
```bash
helm version
```

### Install Terraform

```bash
# Install via apt (HashiCorp repository)
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
```

Verifikasi:
```bash
terraform version
```

### Pastikan Git Terinstall

```bash
sudo apt install git -y
git --version
```

---

## Troubleshooting Umum WSL2

### Docker perintah tidak ditemukan di WSL2
- Pastikan Docker Desktop berjalan (ikon di system tray)
- Pastikan integrasi WSL2 diaktifkan di Docker Desktop Settings → Resources → WSL Integration
- Restart Docker Desktop dan buka ulang terminal WSL2

### WSL2 sangat lambat atau hang
- Batasi resource WSL2. Buat file `C:\Users\<YourName>\.wslconfig`:
  ```ini
  [wsl2]
  memory=6GB
  processors=4
  ```
- Restart WSL2: `wsl --shutdown` lalu buka ulang Ubuntu

### KinD cluster gagal start: "failed to create cluster: node(s) already exist"
```bash
kind delete cluster
kind create cluster --name devops-lab
```

### Port sudah dipakai
Jika port 80 atau 8080 sudah dipakai Windows:
```bash
# Cek process yang menggunakan port
sudo lsof -i :8080
# Kill process yang konflik
sudo kill -9 <PID>
```

---

## Tips Khusus WSL2

- Selalu jalankan perintah lab dari **terminal WSL2 (Ubuntu)**, bukan PowerShell atau CMD
- File repo ini sebaiknya di-clone di dalam filesystem WSL2 (`~/projects/`), bukan di `/mnt/c/` (performa lebih baik)
- Untuk akses port dari browser Windows, gunakan `localhost:PORT` (WSL2 sudah forward otomatis)

---

## Langkah Berikutnya

```bash
cd /path/to/01-cicd-local-track
./00-preflight/check-env.sh
```
