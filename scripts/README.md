# scripts — Utilitas Lintas-Stage

Skrip bantu yang berlaku lintas stage.

## Kandidat isi
- `bootstrap.sh` — verifikasi prasyarat & inisialisasi awal.
- `cost-check.sh` — estimasi/cek resource GCP yang masih hidup (SM-C1).
- `teardown-all.sh` — teardown berurutan semua stage (urutan terbalik).

**Konvensi:** bash `set -euo pipefail`; keluar non-zero saat gagal.
