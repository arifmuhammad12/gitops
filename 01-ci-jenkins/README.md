# 01 — CI: Jenkins Container + Shared Library & DevSecOps (Local Track)

**Prasyarat:** `00-preflight` (Docker terinstall dan berjalan).

## Tujuan
Memahami arsitektur Continuous Integration (CI) modern dengan **Official Jenkins Docker Container**, **Groovy Shared Library**, dan pemindaian keamanan kontainer (**DevSecOps Trivy**).

## 🚀 Cara Menjalankan Jenkins

Jalankan perintah Docker berikut dari folder `01-ci-jenkins/`:

```bash
# Opsi A: Menggunakan Docker Compose (Direkomendasikan)
cd 01-ci-jenkins
docker compose up -d

# Opsi B: Menggunakan Docker Run Langsung
docker run -d \
  --name jenkins \
  --restart always \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  rezanaipospos/jenkins-devops-course:latest
```

Setelah container aktif, buka browser di **`http://localhost:8080`**.

### 🔑 Akses & Kredensial Login:
Image ini telah di-bake dengan **Jenkins Configuration as Code (JCasC)** sehingga Setup Wizard otomatis dilewati dan seluruh plugin wajib sudah terpasang. Anda dapat langsung login:
- **URL**: `http://localhost:8080`
- **Username**: `admin`
- **Password**: `admin123` *(atau sesuai environment variable `JENKINS_ADMIN_PASSWORD`)*

---

## Model CI Lokal
- **Multibranch Pipeline**: Mengelola branch `main` dan `feature/` secara otomatis.
- **Jenkinsfile Minimal**: Aplikasi hanya menyediakan file `Jenkinsfile` tipis + `.cicd/pipeline.yaml`.
- **DevSecOps Integration**: Pemindaian celah keamanan (Vulnerability Scan) menggunakan **Trivy**.
- **Local Container Registry**: Push image ke local registry tanpa perlu akun cloud berbayar.

## Struktur Shared Library

```
shared-library/
├── vars/
│   ├── containerPipeline.groovy   # Entry point pipeline
│   ├── buildAndPush.groovy        # Build Docker & push ke local registry
│   ├── updateGitops.groovy        # Update tag di repo GitOps
│   ├── notifySlack.groovy         # Notifikasi Slack (opsional)
│   └── trivyScan.groovy           # DevSecOps scanner (Trivy)
├── src/com/course/
│   └── PipelineConfig.groovy      # Parser .cicd/pipeline.yaml
└── examples/
    ├── pipeline.yaml              # Contoh konfigurasi pipeline app
    └── Jenkinsfile                # Contoh Jenkinsfile di repo app
```
