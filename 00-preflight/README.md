# Stage 00 — Pre-flight Check

Sebelum memulai lab apapun, pastikan semua tool sudah terinstall dan berjalan dengan benar.

## Menjalankan Pre-flight Check

```bash
# Human-readable (untuk siswa)
./00-preflight/check-env.sh

# JSON output (untuk di-paste ke web checker)
./00-preflight/check-env.sh --json
```

## Minimum Requirements

| Requirement | Minimum |
|-------------|---------|
| Docker | 24.x |
| KinD | 0.20.x |
| kubectl | 1.28.x |
| Helm | 3.14.x |
| Terraform | 1.8.x |
| Git | 2.x |
| RAM | 8 GB |
| Disk Free | 20 GB |

## Output Contoh

```
╔══════════════════════════════════════════════════════╗
║    Be A DevOps Employee — Pre-flight Checker v1.0   ║
╚══════════════════════════════════════════════════════╝

  ✅ Docker       → 27.1.0
  ✅ KinD         → v0.23.0
  ✅ kubectl      → v1.30.2
  ✅ Helm         → v3.15.3
  ✅ Terraform    → v1.9.4
  ✅ Git          → 2.45.2
  ✅ RAM          → 16 GB
  ✅ Disk Free    → 45 GB free

  ────────────────────────────────────────
  Passed: 8  |  Warnings: 0  |  Failed: 0

  🎉 Environment siap! Lanjutkan ke: 01-ci-jenkins/
```

## Jika Ada yang ❌ (Fail)

Kembali ke panduan instalasi sesuai OS Anda:
- [Mac Apple Silicon](../onboarding/mac-as/README.md)
- [Windows WSL2](../onboarding/windows-wsl2/README.md)
- [Linux Ubuntu/Debian](../onboarding/linux/README.md)

---

**Langkah berikutnya setelah semua ✅**: [01-ci-jenkins →](../01-ci-jenkins/README.md)
