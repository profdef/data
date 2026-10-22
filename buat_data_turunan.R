# Membuat ulang berkas data turunan yang dirujuk dalam buku.
# Jalankan dari folder akar proyek buku (folder yang berisi _quarto.yml):
#   Rscript data/buat_data_turunan.R
#
# Berkas yang dihasilkan:
#   data/raw/laporan_minggu13.csv         (Bab 18, contoh parameter minggu_laporan:13)
#   data/raw/data_dbd_mingguan.csv        (Bab 8, contoh anatomi dokumen Quarto)
#   data/processed/framingham_bersih.csv  (Bab 9, contoh ekspor CSV)
#   data/processed/framingham_bersih.xlsx (Bab 9, contoh ekspor Excel)

library(tidyverse)
library(janitor)
library(lubridate)
library(writexl)

set.seed(2024)

# 1. Laporan minggu 1-13 ---------------------------------------------------
# Berkas asli (minggu 1-12) disalin apa adanya, lalu ditambah satu putaran
# laporan minggu ke-13 (Senin, 25 Maret 2024) dari 24 puskesmas yang sama,
# dengan "kekotoran" data yang serupa (format tanggal campur, huruf kapital
# dan spasi kecamatan tidak konsisten) agar alur pembersihan Bab 16 tetap relevan.
laporan_asli <- read_csv("data/raw/laporan_dbd_mingguan.csv",
                         col_types = cols(.default = "c"))

puskesmas <- laporan_asli |>
  mutate(
    nama_puskesmas = str_to_title(str_squish(nama_puskesmas)),
    kecamatan = str_to_title(str_squish(kecamatan))
  ) |>
  distinct(nama_puskesmas, kecamatan) |>
  arrange(kecamatan, nama_puskesmas)

stopifnot(nrow(puskesmas) == 24)

tanggal_m13 <- as.Date("2024-03-25")
format_tanggal <- c("%d/%m/%Y", "%Y-%m-%d", "%d-%m-%Y")

minggu13 <- puskesmas |>
  mutate(
    id_laporan = sprintf("RPT-%03d", 288 + row_number()),
    tanggal_lapor = format(tanggal_m13, sample(format_tanggal, n(), replace = TRUE)),
    # kasus menurun mengikuti fase akhir kurva epidemi (minggu 12 = 8 kasus)
    jumlah_kasus = as.character(rpois(n(), lambda = 0.25)),
    gaya = sample(c("asli", "kapital", "kecil", "spasi"), n(),
                  replace = TRUE, prob = c(.6, .15, .15, .1)),
    kecamatan = case_when(
      gaya == "kapital" ~ str_to_upper(kecamatan),
      gaya == "kecil"   ~ str_to_lower(kecamatan),
      gaya == "spasi"   ~ paste0(kecamatan, " "),
      .default = kecamatan
    ),
    nama_puskesmas = if_else(gaya == "kapital",
                             str_to_upper(nama_puskesmas), nama_puskesmas)
  ) |>
  select(id_laporan, nama_puskesmas, tanggal_lapor, kecamatan, jumlah_kasus) |>
  slice_sample(prop = 1)

bind_rows(laporan_asli, minggu13) |>
  write_csv("data/raw/laporan_minggu13.csv", na = "")

# 2. Data ringkas per kecamatan (contoh Bab 8) ------------------------------
# Total kasus DBD minggu ke-12 per kecamatan, hasil pembersihan berkas asli.
read_csv("data/raw/laporan_dbd_mingguan.csv", show_col_types = FALSE) |>
  clean_names() |>
  mutate(
    kecamatan = str_to_title(str_squish(kecamatan)),
    tanggal_lapor = parse_date_time(tanggal_lapor, orders = c("dmy", "ymd")),
    minggu_epidemiologi = epiweek(tanggal_lapor),
    jumlah_kasus = if_else(jumlah_kasus < 0 | jumlah_kasus > 100, NA_real_, jumlah_kasus)
  ) |>
  distinct(id_laporan, .keep_all = TRUE) |>
  filter(minggu_epidemiologi == 12) |>
  group_by(kecamatan) |>
  summarise(jumlah_kasus = sum(jumlah_kasus, na.rm = TRUE), .groups = "drop") |>
  write_csv("data/raw/data_dbd_mingguan.csv")

# 3. Ekspor Framingham (contoh Bab 9) --------------------------------------
data_framingham <- read_csv("data/raw/framingham.csv", show_col_types = FALSE)
write_csv(data_framingham, "data/processed/framingham_bersih.csv")
write_xlsx(data_framingham, "data/processed/framingham_bersih.xlsx")
