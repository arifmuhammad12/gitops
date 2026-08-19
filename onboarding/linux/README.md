# Panduan Instalasi — Ubuntu / Debian Linux

> **Estimasi waktu**: 15–20 menit

## Prasyarat

- Ubuntu 22.04 LTS / 24.04 LTS atau Debian 12+
- User dengan akses `sudo`
- Koneksi internet

---

## Opsi A: One-liner (Direkomendasikan)

```bash
curl -fsSL https://raw.githubusercontent.com/rezanaipospos/01-cicd-local-track/main/scripts/install-linux.sh | bash
```

---

## Opsi B: Manual Step-by-step

### Step 1: Update System

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git apt-transport-https ca-certificates gnupg lsb-release
```

### Step 2: Install Docker Engine

```bash
# Tambahkan Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Tambahkan Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Tambahkan user ke group docker (agar tidak perlu sudo)
sudo usermod -aG docker $USER
newgrp docker
```

Verifikasi:
```bash
docker version
docker run --rm hello-world
```

### Step 3: Install KinD

```bash
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
  KIND_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
  KIND_ARCH="arm64"
fi

curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-${KIND_ARCH}"
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

Verifikasi:
```bash
kind version
```

### Step 4: Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
```

Verifikasi:
```bash
kubectl version --client
```

### Step 5: Install Helm

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Verifikasi:
```bash
helm version
```

### Step 6: Install Terraform

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
```

Verifikasi:
```bash
terraform version
```

---

## Troubleshooting Umum

### `docker: permission denied`
```bash
sudo usermod -aG docker $USER
# Logout dan login kembali, atau:
newgrp docker
```

### Docker service tidak berjalan
```bash
sudo systemctl start docker
sudo systemctl enable docker  # Auto-start saat boot
```

### KinD gagal start karena resource kurang
Cek memory yang tersedia:
```bash
free -h
# Pastikan ada minimal 4 GB free
```

---

## Langkah Berikutnya

```bash
cd /path/to/01-cicd-local-track
./00-preflight/check-env.sh
```
