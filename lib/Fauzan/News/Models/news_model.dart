class News {
  final String headline;
  final String synopsis;
  final String newsbody;
  final DateTime date;
  final String imageUrl;
  final String category;

  News({
    required this.headline,
    required this.synopsis,
    required this.newsbody,
    required this.date,
    required this.imageUrl,
    required this.category,
  });
}

final List<News> newsList = [
  News(
    headline: "Drone termal 'pengubah permainan' untuk survei anjing laut",
    synopsis:
        "Teknologi pesawat nirawak baru menjadi 'pengubah permainan' bagi tim yang mengumpulkan data tentang anjing laut di Calf of Man tahun ini, kata para konservasionis.\n\nSebanyak 98 anak anjing laut direkam dan dipantau selama survei 10 minggu, yang merupakan jumlah tertinggi sejak perekaman dimulai pada tahun 2009. \n\nPetugas kelautan Manx Wildlife Trust Lara Howe mengatakan anjing laut itu 'sangat tersamarkan di balik batu', tetapi pencitraan termal membuat mereka 'sangat mudah dikenali'.\n\nSurvei itu penting karena memberi indikasi kepada lembaga tersebut tentang 'kesehatan ekosistem secara keseluruhan' karena hewan-hewan itu 'membantu menjaga keseimbangannya', katanya.",
    newsbody:
        "Teknologi pesawat nirawak baru menjadi 'pengubah permainan' bagi tim yang mengumpulkan data tentang anjing laut di Calf of Man tahun ini, kata para konservasionis.\n\nSebanyak 98 anak anjing laut direkam dan dipantau selama survei 10 minggu, yang merupakan jumlah tertinggi sejak perekaman dimulai pada tahun 2009. \n\nPetugas kelautan Manx Wildlife Trust Lara Howe mengatakan anjing laut itu 'sangat tersamarkan di balik batu', tetapi pencitraan termal membuat mereka 'sangat mudah dikenali'.\n\nSurvei itu penting karena memberi indikasi kepada lembaga tersebut tentang 'kesehatan ekosistem secara keseluruhan' karena hewan-hewan itu 'membantu menjaga keseimbangannya', katanya.",
    date: DateTime.parse("2025-03-19"),
    imageUrl: "assets/images/anjglaut.webp",
    category: "latest",
  ),
  News(
    headline:
        "Bayi lumba-lumba terlihat bersama kawanannya di lepas pantai Yorkshire",
    synopsis:
        "Kawanan 40 ekor lumba-lumba hidung botol yang terlihat di lepas pantai Yorkshire merupakan salah satu yang terbesar yang terlihat dalam 12 bulan terakhir, menurut seorang ahli.\n\nLumba-lumba tersebut dilaporkan terlihat di lepas pantai Filey, Yorkshire Utara, pada hari Sabtu. Pada hari yang sama, kelompok lain yang terdiri dari sekitar 13 ekor terlihat di lepas pantai Flamborough, Yorkshire Timur, tepat sebelum pukul 11:30 BST.\n\nRobin Petch, dari Sea Watch Foundation, mengatakan bahwa seekor anak lumba-lumba yang baru lahir termasuk dalam kelompok terakhir dan telah diidentifikasi berdasarkan lipatan janin 'yang menunjukkan bahwa usianya tidak lebih dari beberapa minggu'.\n\nMakhluk-makhluk tersebut, yang tampaknya telah bermigrasi dari Moray Firth di Skotlandia, sedang berburu makanan atau berkumpul untuk kawin, imbuh Tn. Petch.",
    newsbody:
        "Kawanan 40 ekor lumba-lumba hidung botol yang terlihat di lepas pantai Yorkshire merupakan salah satu yang terbesar yang terlihat dalam 12 bulan terakhir, menurut seorang ahli.\n\nLumba-lumba tersebut dilaporkan terlihat di lepas pantai Filey, Yorkshire Utara, pada hari Sabtu. Pada hari yang sama, kelompok lain yang terdiri dari sekitar 13 ekor terlihat di lepas pantai Flamborough, Yorkshire Timur, tepat sebelum pukul 11:30 BST.\n\nRobin Petch, dari Sea Watch Foundation, mengatakan bahwa seekor anak lumba-lumba yang baru lahir termasuk dalam kelompok terakhir dan telah diidentifikasi berdasarkan lipatan janin 'yang menunjukkan bahwa usianya tidak lebih dari beberapa minggu'.\n\nMakhluk-makhluk tersebut, yang tampaknya telah bermigrasi dari Moray Firth di Skotlandia, sedang berburu makanan atau berkumpul untuk kawin, imbuh Tn. Petch.",
    date: DateTime.parse("2025-03-18"),
    imageUrl: "assets/images/lumba.webp",
    category: "latest",
  ),
  News(
    headline: "Paus 'sangat langka' terlihat di lepas pantai Donegal",
    synopsis:
        "Seekor paus langka telah tercatat di lepas pantai County Donegal, menurut Irish Whale and Dolphin Group (IWDG).\n\nIa terlihat berenang di dekat Sliabh Liag pada hari Senin.\n\nPaus kanan Atlantik Utara termasuk mamalia laut besar yang paling terancam punah di planet ini.\n\nDiperkirakan jumlahnya kurang dari 350 ekor hingga tahun 2023 dan mereka bisa punah dalam waktu 20 tahun.\n\n“Ini adalah catatan yang sangat langka untuk Atlantik timur, tempat spesies ini sebagian besar telah punah selama beberapa dekade, jika tidak lebih lama,” kata kelompok tersebut.\n\n“Kami dapat membuat argumen yang meyakinkan bahwa identifikasi positif terakhir spesies ini di Irlandia terjadi pada tahun 1910.”",
    newsbody:
        "Seekor paus langka telah tercatat di lepas pantai County Donegal, menurut Irish Whale and Dolphin Group (IWDG).\n\nIa terlihat berenang di dekat Sliabh Liag pada hari Senin.\n\nPaus kanan Atlantik Utara termasuk mamalia laut besar yang paling terancam punah di planet ini.\n\nDiperkirakan jumlahnya kurang dari 350 ekor hingga tahun 2023 dan mereka bisa punah dalam waktu 20 tahun.\n\n“Ini adalah catatan yang sangat langka untuk Atlantik timur, tempat spesies ini sebagian besar telah punah selama beberapa dekade, jika tidak lebih lama,” kata kelompok tersebut.\n\n“Kami dapat membuat argumen yang meyakinkan bahwa identifikasi positif terakhir spesies ini di Irlandia terjadi pada tahun 1910.”",
    date: DateTime.parse("2025-03-17"),
    imageUrl: "assets/images/paus.webp",
    category: "recommended",
  ),
  News(
    headline: "30.000 makhluk laut mendapatkan pemeriksaan kesehatan tahunan.",
    synopsis:
        "Lebih dari 30.000 makhluk di akuarium Sea Life di seluruh Inggris telah dihitung selama inventarisasi tahunan.\n\nHewan laut dihitung, ditimbang, dan diukur di 11 pusat, termasuk penguin gentoo di Sea Life London, penyu hijau di National Sea Life Centre di Birmingham, dan anjing laut di Sea Life Weymouth.\n\nPemeriksaan kesehatan dilakukan, setiap pendatang baru dicatat, dan pembersihan musim dingin di akuarium selesai dilakukan.\n\nAcara tahunan ini memungkinkan pusat Sea Life di Inggris untuk mengambil bagian dalam program pengembangbiakan internasional, bersama dengan pusat Sea Life lainnya di seluruh dunia.",
    newsbody:
        "Lebih dari 30.000 makhluk di akuarium Sea Life di seluruh Inggris telah dihitung selama inventarisasi tahunan.\n\nHewan laut dihitung, ditimbang, dan diukur di 11 pusat, termasuk penguin gentoo di Sea Life London, penyu hijau di National Sea Life Centre di Birmingham, dan anjing laut di Sea Life Weymouth.\n\nPemeriksaan kesehatan dilakukan, setiap pendatang baru dicatat, dan pembersihan musim dingin di akuarium selesai dilakukan.\n\nAcara tahunan ini memungkinkan pusat Sea Life di Inggris untuk mengambil bagian dalam program pengembangbiakan internasional, bersama dengan pusat Sea Life lainnya di seluruh dunia.",
    date: DateTime.parse("2025-03-16"),
    imageUrl: "assets/images/penguin.webp",
    category: "trending",
  ),
  News(
    headline: "Penyu tempayan yang terluka dilepaskan kembali ke alam liar",
    synopsis:
        "Seekor penyu tempayan yang terluka telah dilepaskan kembali ke alam liar.\n\nPenyu tersebut, yang diberi nama Nazaré, terdampar di sebuah pantai di Cumbria pada bulan Februari, tidak menunjukkan tanda-tanda pergerakan dan tertutup oleh alga.\n\nMakhluk tersebut menjalani program rehabilitasi yang berhasil di berbagai fasilitas Sea Life.\n\nNazaré diterbangkan ke Azores dan dilepaskan kembali ke alam liar awal bulan ini.\n\nReptil tersebut diselamatkan dari sebuah pantai di Pulau Walney, Barrow-in-Furness, pada tanggal 4 Februari.\n\nPenyu tersebut ditemukan dalam kondisi sangat kedinginan, menderita pneumonia, dan ditutupi oleh alga dan rumput laut yang tebal saat tiba di Sea Life Blackpool.",
    newsbody:
        "Seekor penyu tempayan yang terluka telah dilepaskan kembali ke alam liar.\n\nPenyu tersebut, yang diberi nama Nazaré, terdampar di sebuah pantai di Cumbria pada bulan Februari, tidak menunjukkan tanda-tanda pergerakan dan tertutup oleh alga.\n\nMakhluk tersebut menjalani program rehabilitasi yang berhasil di berbagai fasilitas Sea Life.\n\nNazaré diterbangkan ke Azores dan dilepaskan kembali ke alam liar awal bulan ini.\n\nReptil tersebut diselamatkan dari sebuah pantai di Pulau Walney, Barrow-in-Furness, pada tanggal 4 Februari.\n\nPenyu tersebut ditemukan dalam kondisi sangat kedinginan, menderita pneumonia, dan ditutupi oleh alga dan rumput laut yang tebal saat tiba di Sea Life Blackpool.",
    date: DateTime.parse("2025-03-20"),
    imageUrl: "assets/images/penyu.webp",
    category: "recommended",
  ),
];
