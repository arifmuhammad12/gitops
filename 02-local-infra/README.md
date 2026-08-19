# Stage 02 — Local Infrastructure (KinD Cluster via Terraform)

Stage ini digunakan untuk melakukan provisioning multi-node Kubernetes cluster lokal (1 Control Plane & 2 Worker Nodes) menggunakan Terraform provider untuk KinD.

## Prasyarat
- Docker daemon sudah berjalan di laptop Anda (`./00-preflight/check-env.sh`)
- Stage `01-ci-jenkins` selesai dipelajari
- Terraform & KinD CLI terpasang

## Perintah Eksekusi

```bash
# 1. Navigasi ke folder terraform
cd 02-local-infra/terraform

# 2. Inisialisasi provider Terraform
terraform init

# 3. Lihat rencana provisioning
terraform plan

# 4. Terapkan (buat KinD cluster)
terraform apply -auto-approve

# 5. Verifikasi cluster Kubernetes lokal
kubectl get nodes
```

## Hasil Kesiapan Cluster
```
NAME                                 STATUS   ROLES           AGE   VERSION
devops-local-cluster-control-plane   Ready    control-plane   2m    v1.32.2
devops-local-cluster-worker          Ready    <none>          2m    v1.32.2
devops-local-cluster-worker2         Ready    <none>          2m    v1.32.2
```

## Teardown (Menghapus Cluster)

```bash
terraform destroy -auto-approve
```
