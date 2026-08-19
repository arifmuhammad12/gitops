# Panduan Instalasi — Mac Apple Silicon (M1/M2/M3)

> **Estimasi waktu**: 15–20 menit

## Prasyarat

- macOS 13 Ventura atau lebih baru
- Terminal (bawaan macOS atau iTerm2)
- Koneksi internet

---

## Opsi A: One-liner (Direkomendasikan)

Jalankan satu perintah ini, semua tool akan terinstall otomatis:

```bash
curl -fsSL https://raw.githubusercontent.com/YourUsername/be-a-devops-course/main/course-project-local-machine/scripts/install-mac-as.sh | bash
```

> **Tidak aman menjalankan script dari internet tanpa melihat isinya?** Itu pemikiran yang bagus! Buka URL di atas di browser, baca dulu, lalu jalankan jika sudah yakin.

---

## Opsi B: Manual Step-by-step

### Step 1: Install Homebrew

Homebrew adalah package manager untuk macOS. Jika sudah ada, lewati step ini.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Setelah install, tambahkan Homebrew ke PATH (khusus Apple Silicon):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Verifikasi:
```bash
brew --version
# Homebrew 4.x.x
```

### Step 2: Install Docker Desktop

```bash
brew install --cask docker
```

Buka Docker Desktop dari Applications, tunggu hingga ikon Docker di menu bar berhenti berputar (status: running).

Verifikasi:
```bash
docker version
docker run --rm hello-world
```

### Step 3: Install KinD

```bash
brew install kind
```

Verifikasi:
```bash
kind version
# kind v0.23.x ...
```

### Step 4: Install kubectl

```bash
brew install kubectl
```

Verifikasi:
```bash
kubectl version --client
```

### Step 5: Install Helm

```bash
brew install helm
```

Verifikasi:
```bash
helm version
```

### Step 6: Install Terraform

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Verifikasi:
```bash
terraform version
```

### Step 7: Verifikasi Git

Git biasanya sudah ada di macOS. Verifikasi:

```bash
git --version
```

Jika belum ada, install Xcode Command Line Tools:
```bash
xcode-select --install
```

---

## Troubleshooting Umum

### Docker Desktop tidak bisa start
- Pastikan macOS up to date
- Coba restart Docker Desktop dari menu bar
- Jika stuck: `killall Docker && open /Applications/Docker.app`

### `brew: command not found` setelah install Homebrew
```bash
# Tambahkan ke PATH secara manual
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### KinD cluster gagal start
- Pastikan Docker Desktop sudah running (ikon di menu bar)
- Cek resource Docker: Settings → Resources → Memory minimal 4GB

---

## Langkah Berikutnya

Setelah semua terinstall, jalankan:

```bash
cd ../../
./00-preflight/check-env.sh
```
