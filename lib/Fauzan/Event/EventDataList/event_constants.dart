// lib/data/event_constants.dart

const List<String> provinces = [
  'None',
  'Aceh',
  'Sumatera Utara',
  'Sumatera Barat',
  'Riau',
  'Kepulauan Riau',
  'Jambi',
  'Sumatera Selatan',
  'Bangka Belitung',
  'Bengkulu',
  'Lampung',
  'DKI Jakarta',
  'Jawa Barat',
  'Jawa Tengah',
  'DI Yogyakarta',
  'Jawa Timur',
  'Banten',
  'Bali',
  'Nusa Tenggara Barat',
  'Nusa Tenggara Timur',
  'Kalimantan Barat',
  'Kalimantan Tengah',
  'Kalimantan Selatan',
  'Kalimantan Timur',
  'Kalimantan Utara',
  'Sulawesi Utara',
  'Sulawesi Tengah',
  'Sulawesi Selatan',
  'Sulawesi Tenggara',
  'Gorontalo',
  'Sulawesi Barat',
  'Maluku',
  'Maluku Utara',
  'Papua',
  'Papua Barat',
  'Papua Selatan',
  'Papua Tengah',
  'Papua Pegunungan',
];

const Map<String, List<String>> citiesByProvince = {
  'DKI Jakarta': [
    'Jakarta Pusat',
    'Jakarta Barat',
    'Jakarta Timur',
    'Jakarta Selatan',
    'Jakarta Utara',
  ],
  'Jawa Barat': ['Bandung', 'Bekasi', 'Bogor', 'Depok', 'Cimahi'],
  'Bali': ['Denpasar', 'Badung', 'Gianyar', 'Tabanan', 'Singaraja'],
  'Sumatera Utara': ['Medan', 'Binjai', 'Pematangsiantar', 'Tebing Tinggi'],
};

/// Daftar seluruh provinsi di Indonesia (38)
String normalizeProvince(String raw) {
  final value = raw.toLowerCase().trim();

  final Map<String, String> provinceMap = {
    // === SUMATERA ===
    'aceh': 'Aceh',
    'sumatera utara': 'Sumatera Utara',
    'north sumatra': 'Sumatera Utara',
    'sumatera barat': 'Sumatera Barat',
    'west sumatra': 'Sumatera Barat',
    'riau': 'Riau',
    'kepulauan riau': 'Kepulauan Riau',
    'riau islands': 'Kepulauan Riau',
    'jambi': 'Jambi',
    'sumatera selatan': 'Sumatera Selatan',
    'south sumatra': 'Sumatera Selatan',
    'bangka belitung': 'Bangka Belitung',
    'kepulauan bangka belitung': 'Bangka Belitung',
    'bengkulu': 'Bengkulu',
    'lampung': 'Lampung',

    // === JAWA ===
    'jakarta': 'DKI Jakarta',
    'dki jakarta': 'DKI Jakarta',
    'jawa barat': 'Jawa Barat',
    'west java': 'Jawa Barat',
    'jawa tengah': 'Jawa Tengah',
    'central java': 'Jawa Tengah',
    'di yogyakarta': 'DI Yogyakarta',
    'yogyakarta': 'DI Yogyakarta',
    'jogja': 'DI Yogyakarta',
    'jawa timur': 'Jawa Timur',
    'east java': 'Jawa Timur',
    'banten': 'Banten',

    // === BALI & NUSA TENGGARA ===
    'bali': 'Bali',
    'nusa tenggara barat': 'Nusa Tenggara Barat',
    'west nusa tenggara': 'Nusa Tenggara Barat',
    'nusa tenggara timur': 'Nusa Tenggara Timur',
    'east nusa tenggara': 'Nusa Tenggara Timur',

    // === KALIMANTAN ===
    'kalimantan barat': 'Kalimantan Barat',
    'west kalimantan': 'Kalimantan Barat',
    'kalimantan tengah': 'Kalimantan Tengah',
    'central kalimantan': 'Kalimantan Tengah',
    'kalimantan selatan': 'Kalimantan Selatan',
    'south kalimantan': 'Kalimantan Selatan',
    'kalimantan timur': 'Kalimantan Timur',
    'east kalimantan': 'Kalimantan Timur',
    'kalimantan utara': 'Kalimantan Utara',
    'north kalimantan': 'Kalimantan Utara',

    // === SULAWESI ===
    'sulawesi utara': 'Sulawesi Utara',
    'north sulawesi': 'Sulawesi Utara',
    'sulawesi tengah': 'Sulawesi Tengah',
    'central sulawesi': 'Sulawesi Tengah',
    'sulawesi selatan': 'Sulawesi Selatan',
    'south sulawesi': 'Sulawesi Selatan',
    'sulawesi tenggara': 'Sulawesi Tenggara',
    'southeast sulawesi': 'Sulawesi Tenggara',
    'gorontalo': 'Gorontalo',
    'sulawesi barat': 'Sulawesi Barat',
    'west sulawesi': 'Sulawesi Barat',

    // === MALUKU ===
    'maluku': 'Maluku',
    'maluku utara': 'Maluku Utara',
    'north maluku': 'Maluku Utara',

    // === PAPUA (PALING SERING BIKIN HILANG) ===
    'papua': 'Papua',
    'papua barat': 'Papua Barat',
    'west papua': 'Papua Barat',

    // hasil GPS sering MASIH "Papua" walau sudah dimekarkan
    'papua selatan': 'Papua Selatan',
    'south papua': 'Papua Selatan',
    'papua tengah': 'Papua Tengah',
    'central papua': 'Papua Tengah',
    'papua pegunungan': 'Papua Pegunungan',
    'highland papua': 'Papua Pegunungan',
  };

  return provinceMap[value] ?? 'None';
}

/// Kategori event (8+ kategori)
const List<String> eventCategories = [
  'None',

  // Dipertahankan
  'Lingkungan',
  'Edukasi',
  'Sosial',

  // Spesifik SDGs 14
  'Bersih Pantai',
  'Konservasi Laut',
  'Penanaman Mangrove',
  'Edukasi Sampah Plastik Laut',
  'Perlindungan Terumbu Karang',
  'Ekosistem Pesisir',
  'Biota Laut',
  'Perikanan Berkelanjutan',
  'Kampanye Laut Bersih',
  'Riset & Observasi Laut',

  // Pendukung (opsional tapi relevan)
  'Teknologi Kelautan',
  'Aksi Relawan Laut',
];
