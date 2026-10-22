# data

Data latihan untuk buku *Manajemen & Analisis Data Epidemiologi & Kesehatan Masyarakat Menggunakan R, RStudio & Quarto* (Defriman Djafri).

Salin seluruh folder ini ke dalam folder RStudio Project Anda sehingga jalur relatif seperti `"data/raw/framingham.csv"` pada kode buku langsung berfungsi.

## Struktur folder

```
data/
├── raw/          # data mentah, TIDAK PERNAH diubah secara manual
│   ├── framingham.csv
│   ├── birthwt.csv
│   ├── birthwt.xlsx
│   ├── birthwt.sav
│   ├── birthwt.dta
│   ├── laporan_dbd_mingguan.csv
│   ├── laporan_minggu13.csv
│   └── data_dbd_mingguan.csv
├── processed/    # data hasil olahan, siap dianalisis
│   ├── framingham_bersih.csv
│   └── framingham_bersih.xlsx
├── geo/          # data spasial (batas wilayah)
│   └── kecamatan_padang.geojson
└── buat_data_turunan.R
```

## Daftar berkas

| Berkas | Bab | Isi |
|---|---|---|
| `raw/framingham.csv` | 9, 17 | Framingham Heart Study (subset pengajaran), 4.240 observasi, 16 variabel (`male`, `age`, `education`, `currentSmoker`, `cigsPerDay`, `BPMeds`, `prevalentStroke`, `prevalentHyp`, `diabetes`, `totChol`, `sysBP`, `diaBP`, `BMI`, `heartRate`, `glucose`, `TenYearCHD`). |
| `raw/birthwt.csv` / `.xlsx` / `.sav` / `.dta` | 9 | Data `MASS::birthwt` (189 ibu-bayi, Baystate Medical Center 1986) dengan nama variabel bahasa Indonesia: `id_pasien`, `bblr`, `usia_ibu`, `berat_ibu_lwt`, `ras`, `status_merokok`, `riwayat_prematur`, `riwayat_hipertensi`, `iritabilitas_uterus`, `kunjungan_trimester1`, `berat_lahir_gram`. Isi keempat format identik. Bab 12–15 memuat data yang sama langsung dari paket `MASS`. |
| `raw/laporan_dbd_mingguan.csv` | 16, 18 | Laporan mingguan DBD per puskesmas, minggu epidemiologi 1–12 tahun 2024 (312 baris, 5 kolom). Data sintetis: nama 24 puskesmas dan 11 kecamatan Kota Padang asli, angka kasus ilustratif. Sengaja "kotor": format tanggal campur, huruf/spasi kecamatan tidak konsisten, laporan duplikat, nilai tidak masuk akal (`-1`, `150`), dan nilai hilang. |
| `raw/laporan_minggu13.csv` | 18 | Sama seperti di atas ditambah 24 laporan minggu ke-13 (25 Maret 2024), untuk contoh `quarto render ... -P minggu_laporan:13`. |
| `raw/data_dbd_mingguan.csv` | 8 | Total kasus DBD minggu ke-12 per kecamatan (`kecamatan`, `jumlah_kasus`), untuk contoh anatomi dokumen Quarto. Pada contoh di buku berkas ini dibaca tanpa awalan folder (`read_csv("data_dbd_mingguan.csv")`); sesuaikan jalurnya menjadi `"data/raw/data_dbd_mingguan.csv"` bila dijalankan dari folder Project. |
| `processed/framingham_bersih.csv` / `.xlsx` | 9 | Hasil contoh ekspor `write_csv()` dan `write_xlsx()`. |
| `geo/kecamatan_padang.geojson` | 16 | Batas administratif asli 11 kecamatan Kota Padang (kode wilayah BPS, geometri disederhanakan). Kolom: `kd_propinsi`, `kd_dati2`, `kd_kecamatan`, `nm_kecamatan`. |

## Membuat ulang berkas turunan

`laporan_minggu13.csv`, `data_dbd_mingguan.csv`, dan isi folder `processed/` dibuat dari data mentah dengan skrip berikut (dijalankan dari folder akar proyek buku):

```bash
Rscript data/buat_data_turunan.R
```
