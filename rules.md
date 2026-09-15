# Aturan & Standar Pengembangan ByUI (ByUI Development Rules)

Dokumen ini mendefinisikan aturan arsitektur, konvensi penulisan kode, standar komponen UI, protokol pengujian, serta pedoman alur kerja untuk pengembangan dan pemeliharaan repositori **ByUI**.

Seluruh kontributor dan asisten AI wajib mematuhi aturan-aturan berikut dalam setiap penambahan atau pembaruan fitur.

---

## Daftar Isi
1. [Prinsip Desain & Filosofi Komponen](#1-prinsip-desain--filosofi-komponen)
2. [Arsitektur Monorepo & Tanggung Jawab Paket](#2-arsitektur-monorepo--tanggung-jawab-paket)
3. [Standar Komponen UI (UI Component Rules)](#3-standar-komponen-ui-ui-component-rules)
4. [Standar Penulisan Kode (Coding Conventions)](#4-standar-penulisan-kode-coding-conventions)
5. [Standar Tema, Warna, & Tipografi (Theming & Styling Rules)](#5-standar-tema-warna--tipografi-theming--styling-rules)
6. [Standar Pengujian (Testing Protocol)](#6-standar-pengujian-testing-protocol)
7. [Aturan Git & Alur Kerja (Workflow Protocol)](#7-aturan-git--alur-kerja-workflow-protocol)
8. [Standar Pemeliharaan pub.dev & Semantic Versioning](#8-standar-pemeliharaan-pubdev--semantic-versioning)

---

## 1. Prinsip Desain & Filosofi Komponen

1. **Aesthetic Sleek & Modern**:
   - Palet warna bernuansa dark-slate modern (`#0F172A`), indigo (`#6366F1`), emerald (`#10B981`), crimson (`#EF4444`), dan amber (`#F59E0B`).
   - Efek visual glassmorphic yang halus, border semi-transparan (`withValues(alpha: ...)`), serta bayangan lembut.
2. **Fluid Spatial Animations**:
   - Transisi koordinat spasial yang halus, multi-arah (top, bottom, left, right), dan kurva elastis/bounce (`Curves.easeOutCubic`, `Curves.easeOutBack`).
   - Penumpukan dinamis (*stacked cards*) yang secara otomatis mengukur ketinggian konten per item tanpa hardcoded height.
3. **High Customizability Without Bloat**:
   - Setiap elemen visual (warna, gradien, radius, border, bayangan, ikon, tipografi) harus dapat dikustomisasi secara opsional, tetapi tetap memiliki nilai bawaan (*sensible defaults*) yang indah langsung setelah dipasang (*out-of-the-box*).
4. **Preview Ringkas & Detail Dialog**:
   - Komponen notifikasi/toast dirancang sebagai kartu *preview* ringkas.
   - Pesan panjang tidak boleh merusak layout layar; default-nya dibatasi 3 baris dengan ellipsis.
   - Pengguna dapat membuka dialog detail lengkap (melalui tap atau drag inward) untuk membaca keseluruhan pesan.

---

## 2. Arsitektur Monorepo & Tanggung Jawab Paket

Repositori ini tersusun dalam struktur monorepo:
```
By_UI/
├── .guide/             # Panduan operasional & rules internal (diabaikan oleh git)
├── packages/
│   └── core/           # PACKAGE UTAMA: Dipublikasikan ke pub.dev sebagai "by_ui"
│       ├── example/    # Wajib untuk pub.dev (10 poin example)
│       ├── lib/        # Source code library publik
│       ├── test/       # Test suite komprehensif
│       ├── CHANGELOG.md
│       ├── LICENSE
│       ├── README.md
│       └── pubspec.yaml
└── apps/
    └── sample/         # Aplikasi showcase interaktif untuk testing & preview GitHub
```

### Aturan Batasan Paket (*Package Boundaries*):
- **`packages/core` TIDAK BOLEH bergantung pada `apps/sample`**.
- `packages/core` tidak boleh memuat aset biner besar (gambar, video, font lokal kustom) yang dapat membengkakkan ukuran arsip tar.gz pada pub.dev.
- Seluruh API publik dari `packages/core` **wajib diekspor secara terpusat melalui `packages/core/lib/by_ui.dart`**.
- Aplikasi `apps/sample` berfungsi sebagai showcase interaktif dan sarana verifikasi langsung pengguna; setiap penambahan opsi kustomisasi baru di `packages/core` idealnya disediakan kontrol interaktifnya pada `ToastShowcaseScreen` atau `DialogShowcaseScreen`.

---

## 3. Standar Komponen UI (UI Component Rules)

### 3.1 Konvensi Penamaan (Naming Conventions)
- Semua komponen, model, controller, dan enum publik wajib diawali dengan prefiks **`By`**:
  - Komponen: `ByToast`, `ByDialog`, `ByToastCard`, `ByToastMorphDialog`
  - Model & Data: `ByToastModel`
  - Enum: `ByToastPosition`, `ByToastSlideDirection`, `ByToastAnimationType`
- **Backward Compatibility**: Jika terjadi refaktor penamaan komponen utama, sediakan `typedef` alias untuk kompatibilitas ke belakang (contoh: `typedef ByNotification = ByToast;`).

### 3.2 Teks, Truncation & Ellipsis Rules
- **Pesan Toast (`message`)**:
  - Wajib menyediakan kustomisasi `maxLines` dan `overflow`.
  - **Nilai bawaan wajib**: `maxLines = 3` dan `overflow = TextOverflow.ellipsis`.
  - Jika pengembang menyetel `maxLines: null`, teks dapat memanjang tanpa batasan baris.
- **Judul Toast (`title`)**:
  - Wajib menyediakan kustomisasi opsional `titleMaxLines` dan `titleOverflow`.
- **Dialog Detail (`ByToastMorphDialog`)**:
  - Dialog detail **TIDAK BOLEH membatasi baris teks** (`maxLines: null`).
  - Harus dibungkus dalam `SingleChildScrollView` dan `Scrollbar` agar pesan yang sangat panjang tetap dapat dibaca seluruhnya dengan nyaman.

### 3.3 Interaktivitas Tap & Drag-to-Dialog
- Toast kartu secara default mendukung transisi morphing ke dialog (`canTapToExpand` dan `canDragToExpand` bernilai `true` saat `onTap == null`).
- Jika pengguna menyediakan callback `onTap` kustom, maka `onTap` tersebut harus diprioritaskan kecuali `enableTapToExpand: true` secara eksplisit diberikan.
- Menyeret kartu toast ke arah tengah layar (*drag towards center*) memicu transisi morphing menjadi dialog modal di tengah layar.
- Menggeser kartu ke arah luar layar (*swipe away from center* atau swipe horizontal) memicu dismiss/penutupan kartu dengan animasi keluar.

### 3.4 Penempatan Spasial & Koordinat
- Mendukung posisi layar ganda: `ByToastPosition.top` dan `ByToastPosition.bottom`.
- Mendukung integrasi anchor bar melalui `GlobalKey`:
  - `ByToast.appBarKey`: Top toast secara otomatis berada di bawah AppBar aktif.
  - `ByToast.bottomBarKey`: Bottom toast secara otomatis berada di atas BottomNavigationBar / BottomAppBar aktif.
- Menghormati `MediaQuery.padding` (SafeArea) perangkat.

---

## 4. Standar Penulisan Kode (Coding Conventions)

1. **Gaya Dart & Linter**:
   - Seluruh kode wajib mematuhi aturan `flutter_lints`.
   - `flutter analyze` harus selalu menghasilkan: **`No issues found!`**.
   - Gunakan format standar Flutter: `dart format .`.

2. **Penggunaan API Modern**:
   - Gunakan `Color.withValues(alpha: ...)` untuk mengatur transparansi warna (hindari API usang `withOpacity`).
   - Gunakan `const` constructor pada widget statis, dekorasi, dan nilai yang tidak berubah.

3. **Dokumentasi Kode (DartDoc)**:
   - Setiap class publik, method publik, field model, dan enum wajib memiliki komentar dokumentasi DartDoc (`///`).
   - Jelaskan fungsi parameter, nilai default, serta dampaknya terhadap visual atau interaksi.

4. **Kebersihan Kode**:
   - Dilarang meninggalkan statement `print()` atau kode debug di dalam `packages/core`.
   - Callback controller dan timer wajib dibersihkan di method `dispose()`.

---

## 5. Standar Tema, Warna, & Tipografi (Theming & Styling Rules)

Pengelolaan tema, palet warna, dan tipografi pada aplikasi showcase (`apps/sample`) wajib memusat pada modul **`apps/sample/lib/theme`** (`AppColors`, `AppTextStyle`, `AppTheme`).

### 5.1 Larangan Hardcoded Warna Hex / Hash (`Color(0xFF...)`)
- **Dilarang keras** menuliskan nilai hexadecimal warna secara langsung (hardcoded) di dalam widget, screen, atau card UI (contoh: `Color(0xFF6366F1)`, `Color(0xFF0F172A)`).
- Seluruh konstanta warna wajib didefinisikan secara tersentral di `apps/sample/lib/theme/app_colors.dart`.
- Gunakan token warna semantik yang sudah tersedia:
  - Brand & Accent: `AppColors.primary`, `AppColors.primaryLight`, `AppColors.primaryDark`, `AppColors.primaryAccent`
  - Status Semantik: `AppColors.success`, `AppColors.error`, `AppColors.warning`, `AppColors.info`
  - Netral Dark: `AppColors.darkScaffoldBg`, `AppColors.darkCard`, `AppColors.darkBorder`, `AppColors.darkTextPrimary`, `AppColors.darkTextSecondary`, `AppColors.darkTextMuted`
  - Netral Light: `AppColors.lightScaffoldBg`, `AppColors.lightCard`, `AppColors.lightBorder`, `AppColors.lightTextPrimary`, `AppColors.lightTextSecondary`, `AppColors.lightTextMuted`

### 5.2 Penghapusan Logika Percabangan Ternary Warna Berulang (`isDark ? a : b`)
- Hindari menulis logika percabangan inline `isDark ? colorA : colorB` berulang-ulang di berbagai widget tree.
- **Gunakan Palette Resolver**:
  ```dart
  // Rekomendasi 1: Menggunakan context (otomatis reaktif terhadap perubahan tema)
  final colors = AppColors.of(context);
  Container(
    color: colors.cardBg,
    borderColor: colors.border,
    child: Text('Halo', style: TextStyle(color: colors.textPrimary)),
  )

  // Rekomendasi 2: Menggunakan boolean isDark jika sudah tersedia di scope
  final colors = AppColors.fromBrightness(isDark);
  ```
- Gunakan getter helper langsung pada `AppColors` bila hanya memerlukan satu properti:
  `AppColors.surface(isDark)`, `AppColors.border(isDark)`, `AppColors.textPrimary(isDark)`, `AppColors.drawerBg(isDark)`.

### 5.3 Standar Tipografi Terpusat (`AppTextStyle`)
- **Dilarang** mendefinisikan styling font yang berulang dan panjang secara manual di setiap widget (misal: `TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: ...)`).
- Gunakan token tipografi dari `apps/sample/lib/theme/app_textstyle.dart`:
  - **Judul & Header**: `AppTextStyle.appBarTitle`, `AppTextStyle.screenHeader`, `AppTextStyle.screenSubtitle`, `AppTextStyle.sectionHeader`, `AppTextStyle.sectionLabel`, `AppTextStyle.fieldLabel`.
  - **Chips & Tombol**: `AppTextStyle.chipSelected`, `AppTextStyle.chipUnselected`, `AppTextStyle.pillButton`.
  - **Badge & Status**: `AppTextStyle.badge`, `AppTextStyle.badgeSmall`.
  - **Isi & Paragraf**: `AppTextStyle.body`, `AppTextStyle.bodyMedium`, `AppTextStyle.caption`, `AppTextStyle.captionBold`, `AppTextStyle.hint`, `AppTextStyle.codeSnippet`.
- Jika memerlukan penyesuaian warna atau atribut minor, gunakan method `.copyWith()`:
  ```dart
  Text('Konfigurasi Aktif', style: AppTextStyle.sectionHeader.copyWith(color: colors.textPrimary))
  ```

### 5.4 Impor Tunggal Terpadu (`app_theme.dart`)
- `apps/sample/lib/theme/app_theme.dart` secara otomatis mengekspor `app_colors.dart` dan `app_textstyle.dart`.
- Komponen atau screen cukup mengimpor:
  ```dart
  import '../theme/app_theme.dart';
  ```
  untuk memperoleh akses lengkap ke `AppTheme`, `AppColors`, `AppColorPalette`, dan `AppTextStyle`.

### 5.5 Transparansi Modern & Performa Rendering
- Selalu gunakan `Color.withValues(alpha: ...)` untuk opasitas dinamis (hindari `withOpacity`).
- Tetapkan `const` pada widget, teks, dan dekorasi yang nilainya statis untuk menjaga *frame rate* 60/120 FPS yang mulus saat transisi tema.

---

## 6. Standar Pengujian (Testing Protocol)

1. **Cakupan Pengujian (Test Coverage)**:
   - Setiap penambahan parameter baru pada komponen publik wajib memiliki tes unit/widget pendamping di folder `packages/core/test/`.
   - Pengujian harus memverifikasi:
     - Rendering default dan nilai bawaan parameter.
     - Penimpaan (*override*) nilai kustom.
     - Interaksi gesture (tap, drag towards center, swipe to dismiss, close button).
     - Siklus hidup overlay (muncul, update stack, dan dismiss bersih).
2. **Validasi Wajib Sebelum Selesai**:
   Sebelum pekerjaan dianggap selesai, seluruh test suite harus dijalankan dan dipastikan lolos:
   ```bash
   cd packages/core && flutter test
   cd ../../apps/sample && flutter test
   ```

---

## 7. Aturan Git & Alur Kerja (Workflow Protocol)

> [!CAUTION]
> **Protokol Strict Manual Git Commit**:
> Asisten AI **DILARANG** menjalankan perintah `git commit` atau `git push` secara otomatis tanpa instruksi langsung dan eksplisit dari pengguna.

1. **Format Pesan Commit (Conventional Commits)**:
   - `feat: <deskripsi>` — Penambahan fitur baru.
   - `fix: <deskripsi>` — Perbaikan bug atau perilaku komponen.
   - `docs: <deskripsi>` — Pembaruan dokumentasi atau panduan.
   - `test: <deskripsi>` — Penambahan atau pembaruan test suite.
   - `refactor: <deskripsi>` — Pembersihan kode tanpa mengubah fungsionalitas publik.
2. **Status Branch**:
   - Pastikan working tree bersih dari file sementara atau artefak build (`.dart_tool`, `build/`).

---

## 8. Standar Pemeliharaan pub.dev & Semantic Versioning

1. **Semantic Versioning (SemVer)**:
   - `PATCH` (0.1.x): Perbaikan bug, penyesuaian style minor yang backward-compatible.
   - `MINOR` (0.x.0): Penambahan fitur baru yang backward-compatible (misal penambahan parameter kustomisasi baru).
   - `MAJOR` (x.0.0): Perubahan breaking changes pada API publik.
2. **Simulasi Pra-Rilis**:
   - Selalu jalankan dry-run di `packages/core` sebelum mempublikasikan:
     ```bash
     cd packages/core
     dart pub publish --dry-run
     ```
   - Pastikan laporan menunjukkan `Package has 0 warnings`.
3. **Poin Pub Maksimal (Pana Score 140/140)**:
   - Pertahankan example lengkap di `packages/core/example/`.
   - Format kode 100% rapi (`dart format .`).
   - Lisensi open-source valid (MIT License).
   - `README.md` dan `CHANGELOG.md` selalu terbarui.
