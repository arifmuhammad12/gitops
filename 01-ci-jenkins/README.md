# 01 — CI: Jenkins Container (JCasC) + Shared Library & DevSecOps

**Prasyarat:** Docker Desktop / Engine telah aktif di laptop Anda.

---

## 🎯 Tujuan

Membangun fondasi Continuous Integration (CI) otomatis dan tersentralisasi (*Centralized DevOps Pipeline*) menggunakan **Jenkins Configuration as Code (JCasC)**, **Groovy Shared Library**, dan **Aqua Security Trivy**.

---

## 🚀 Menjalankan Jenkins

Jalankan container Jenkins dari folder `01-ci-jenkins/`:

```bash
cd 01-ci-jenkins

# Opsi 1: Menggunakan Docker Compose (Direkomendasikan)
docker compose up -d

# Opsi 2: Menggunakan Docker Run Manual
docker run -d \
  --name jenkins \
  --restart always \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  rezanaipospos/jenkins-devops-course:latest
```

---

## 🔑 Kredensial & Akses Login

Image `rezanaipospos/jenkins-devops-course:latest` telah dikonfigurasi menggunakan **JCasC** sehingga Setup Wizard dilewati dan plugin esensial langsung terpasang:

* **URL Dashboard**: `http://localhost:8080`
* **Username**: `admin`
* **Password**: `admin123` *(atau sesuai env `JENKINS_ADMIN_PASSWORD`)*

---

## 🛡️ Konfigurasi DevSecOps (Trivy Security Scanning)

> ⚠️ **Catatan Penting (Default Configuration):**  
> Secara default, nilai parameter `enableSecurityScan` diatur ke **`false`** agar proses build awal berlangsung cepat.  
> Untuk mengaktifkan scanning otomatis celah keamanan (CVE) dan kebocoran secret pada source code serta Docker image, atur parameter menjadi **`enableSecurityScan: true`** pada pipeline script:

```groovy
@Library('course-shared-library') _

containerPipeline(
    appRepoUrl: 'https://github.com/USERNAME/backend-go.git',
    appName: 'backend-go',
    buildBranch: 'development',
    enableSecurityScan: true // Aktifkan DevSecOps Trivy Scan
)
```

---

## 📁 Struktur Folder

```
01-ci-jenkins/
├── docker/              # Dockerfile untuk custom image Jenkins + JCasC config
├── docker-compose.yml   # Definisi compose container Jenkins & volume mapping
├── helm-values/         # (Opsional) Nilai helm chart untuk skenario K8s
└── shared-library/      # [Submodule] Jenkins Shared Library repository
```

---

## 🔗 Integrasi GitHub Webhook (PR Trigger)

1. Jalankan Cloudflare Quick Tunnel untuk expose Jenkins lokal:
   ```bash
   cloudflared tunnel --url http://localhost:8080
   ```
2. Tambahkan Webhook di GitHub repository aplikasi (`backend-go`):
   - **Payload URL**: `https://<tunnel-domain>.trycloudflare.com/generic-webhook-trigger/invoke`
   - **Content type**: `application/json`
   - **Events**: *Pull requests*
