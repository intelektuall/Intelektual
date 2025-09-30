import 'package:flutter/material.dart';

class FactItem {
  final String title;
  final IconData icon;
  final String description;
  final String ocean; // Tambahan ini
  final String fullContent;

  FactItem({
    required this.title,
    required this.icon,
    required this.description,
    required this.ocean,
    required this.fullContent,
  });
}

// Dummy Data
final List<FactItem> factList = [
  FactItem(
    title: "Samudra Hindia",
    icon: Icons.water,
    description:
        "Samudra terbesar ketiga di dunia yang sangat berperan dalam sistem iklim global.",
    ocean: "Hindia",
    fullContent: '''
Samudra Hindia adalah samudra terbesar ketiga di dunia setelah Samudra Pasifik dan Samudra Atlantik, mencakup sekitar 20% dari total permukaan air Bumi. Samudra ini terletak di antara benua Asia di utara, Afrika di barat, Australia di timur, dan dibatasi oleh Samudra Selatan di selatan. Luasnya sekitar 70 juta kilometer persegi, menjadikannya jalur laut vital yang menghubungkan Timur Tengah, Asia Selatan, Asia Tenggara, dan Afrika Timur.

Samudra Hindia memiliki peran penting dalam sistem iklim global, terutama karena fenomena muson yang memengaruhi cuaca di wilayah sekitarnya, seperti India, Indonesia, dan Afrika Timur. Di dalamnya terdapat sejumlah laut besar seperti Laut Arab, Teluk Benggala, dan Teluk Oman.

Samudra ini juga menyimpan kekayaan alam yang sangat besar, mulai dari sumber daya perikanan hingga cadangan minyak dan gas bumi bawah laut. Keanekaragaman hayatinya sangat tinggi, termasuk terumbu karang, paus, penyu, hiu, dan berbagai spesies ikan tropis.

Beberapa pulau dan negara kepulauan seperti Maladewa, Sri Lanka, dan Madagaskar bergantung pada Samudra Hindia untuk ekonomi, perikanan, dan pariwisata. Namun, wilayah ini juga menghadapi tantangan serius seperti perubahan iklim, kenaikan permukaan air laut, pencemaran laut, dan konflik geopolitik akibat kepentingan strategis negara-negara besar.

Sebagai samudra yang padat lalu lintas pelayaran dan kaya akan kehidupan, Samudra Hindia memegang peran penting tidak hanya secara ekologis, tetapi juga secara ekonomi dan geostrategis dalam tatanan global.
''',
  ),

  FactItem(
    title: "Samudra Atlantik",
    icon: Icons.sailing,
    description:
        "Samudra yang memisahkan Benua Amerika dari Eropa dan Afrika, terkenal dengan Arus Teluknya.",
    ocean: "Atlantik",
    fullContent: '''
Samudra Atlantik adalah samudra terbesar kedua di dunia setelah Samudra Pasifik, membentang dari Samudra Arktik di utara hingga Samudra Selatan di selatan, serta diapit oleh benua Amerika di barat dan Eropa serta Afrika di timur. Luasnya mencapai sekitar 85 juta kilometer persegi, dan merupakan jalur pelayaran utama yang menghubungkan negara-negara di kedua sisi samudra, menjadikannya sangat penting dalam sejarah perdagangan dunia, termasuk dalam era penjelajahan dan kolonialisme.

Samudra ini juga menjadi tempat bertemunya arus laut besar seperti Arus Teluk (Gulf Stream) yang memengaruhi iklim Eropa dan Amerika Utara. Di dasar Samudra Atlantik terdapat Mid-Atlantic Ridge, yaitu pegunungan bawah laut yang menjadi bukti aktifnya proses geologi berupa pemisahan lempeng tektonik.

Samudra Atlantik memiliki keanekaragaman hayati yang kaya, termasuk paus, lumba-lumba, ikan kod, dan berbagai spesies plankton yang menopang rantai makanan laut. Lautan ini juga menjadi tempat bagi berbagai fenomena alam, seperti badai Atlantik dan siklon tropis yang bisa berdampak besar pada wilayah pesisir.

Selain kekayaan hayati, Atlantik juga mengandung sumber daya ekonomi penting seperti minyak bumi, gas alam, dan perikanan. Namun, seperti samudra lainnya, Samudra Atlantik menghadapi tantangan lingkungan serius akibat perubahan iklim, pencemaran plastik, serta penangkapan ikan berlebihan yang mengancam kelestarian ekosistemnya.

Sebagai samudra yang memiliki peran besar dalam sejarah, iklim, dan ekonomi dunia, Samudra Atlantik tetap menjadi wilayah laut yang sangat vital untuk masa depan umat manusia.
''',
  ),

  FactItem(
    title: "Samudra Pasifik",
    icon: Icons.waves,
    description:
        "Samudra terbesar dan terdalam di dunia, meliputi lebih dari 63 juta mil persegi atau sekitar sepertiga permukaan Bumi.",
    ocean: "Pasifik",
    fullContent: '''
Samudra Pasifik adalah samudra terbesar dan terdalam di dunia, meliputi lebih dari 63 juta mil persegi atau sekitar sepertiga permukaan Bumi, serta membentang dari Asia dan Australia di barat hingga Amerika di timur. Samudra ini tidak hanya luas secara geografis, tetapi juga kaya secara ekologis dan geologis, dengan menyimpan Palung Mariana—titik terdalam di lautan Bumi dengan kedalaman lebih dari 11.000 meter. Di sepanjang tepiannya terdapat Cincin Api Pasifik, yaitu zona seismik aktif tempat sering terjadi gempa bumi dan letusan gunung berapi.

Samudra Pasifik mencakup ribuan pulau tropis dan negara kepulauan seperti Indonesia, Filipina, Jepang, Papua Nugini, hingga negara-negara kecil di Oseania, menjadikannya rumah bagi beragam budaya dan sistem ekologi laut yang unik. Arus laut besar seperti Arus Kuroshio dan Arus Ekuator Pasifik memengaruhi iklim global dan menjadi bagian penting dari sistem sirkulasi termohalin dunia.

Samudra ini juga menjadi wilayah penting dalam aktivitas perdagangan internasional, eksplorasi energi, dan sumber pangan dari sektor perikanan. Namun, Pasifik juga menjadi pusat perhatian global karena masalah lingkungan serius seperti pemutihan karang, tumpukan sampah plastik di Great Pacific Garbage Patch, serta dampak perubahan iklim terhadap pulau-pulau kecil yang terancam tenggelam.

Sebagai samudra yang paling luas, dalam, dan kompleks di dunia, Samudra Pasifik memainkan peran vital dalam dinamika iklim, biodiversitas, ekonomi maritim, dan keseimbangan planet secara keseluruhan.
''',
  ),

  FactItem(
    title: "Samudra Arktik",
    icon: Icons.ac_unit,
    description:
        "Samudra terkecil dan terdangkal, terletak di sekitar Kutub Utara dan ditutupi es sepanjang tahun.",
    ocean: "Arktik",
    fullContent: '''
Samudra Arktik adalah samudra terkecil dan terdangkal di antara lima samudra di dunia, terletak di sekitar Kutub Utara dan dikelilingi oleh benua-benua seperti Eropa, Asia, dan Amerika Utara. Sebagian besar permukaannya tertutup oleh es laut sepanjang tahun, meskipun luas es ini terus menyusut drastis akibat pemanasan global.

Meskipun ukurannya kecil dibandingkan samudra lainnya, Arktik memiliki peran penting dalam menjaga keseimbangan iklim global, karena es lautnya membantu memantulkan radiasi matahari dan mengatur suhu Bumi. Samudra ini juga merupakan rumah bagi berbagai spesies yang sangat teradaptasi terhadap kondisi ekstrem, seperti beruang kutub, walrus, paus beluga, dan plankton es yang menjadi dasar rantai makanan laut kutub.

Di bawah permukaan lautnya terdapat cadangan besar minyak dan gas bumi yang menjadi incaran eksplorasi, sekaligus menimbulkan kekhawatiran akan potensi kerusakan lingkungan. Selain itu, Samudra Arktik menjadi jalur pelayaran yang semakin strategis karena pencairan es membuka rute laut baru yang lebih pendek antara Asia dan Eropa.

Namun, wilayah ini juga sangat rentan terhadap dampak perubahan iklim, pencemaran mikroplastik, dan gangguan ekosistem akibat peningkatan aktivitas manusia. Dengan segala keterbatasannya, Samudra Arktik tetap menjadi kawasan yang krusial untuk ilmu pengetahuan, geopolitik, dan konservasi lingkungan global.
''',
  ),

  FactItem(
    title: "Samudra Selatan",
    icon: Icons.snowing,
    description:
        "Samudra yang mengelilingi Antartika, berperan penting dalam mengatur iklim global.",
    ocean: "Selatan",
    fullContent: '''
Samudra Selatan, juga dikenal sebagai Samudra Antartika, adalah samudra terbaru yang secara resmi diakui secara internasional dan mengelilingi benua Antartika, membentang dari pantai Antartika hingga sekitar garis lintang 60° selatan. Meskipun bukan yang paling luas, Samudra Selatan memainkan peran yang sangat penting dalam sistem iklim global karena arusnya yang kuat, yaitu Arus Sirkumpolar Antartika, yang menghubungkan dan menyeimbangkan semua samudra besar lainnya.

Samudra ini juga berfungsi sebagai penyerap karbon dioksida dalam jumlah besar dan menyimpan sekitar 60% air laut dunia yang sangat dingin, menjadikannya pusat pengatur suhu Bumi. Wilayah ini merupakan habitat unik bagi berbagai spesies laut kutub, termasuk paus biru, anjing laut Weddell, krill Antartika, dan penguin kaisar, yang semuanya sangat bergantung pada es laut musiman.

Lautannya yang ekstrem dan keras juga menjadi ladang penelitian ilmiah global, baik untuk studi iklim, oseanografi, maupun keanekaragaman hayati laut dalam. Namun, ekosistem Samudra Selatan kini menghadapi tekanan besar akibat pemanasan global, mencairnya es laut, dan eksploitasi sumber daya seperti krill dan ikan.

Dengan sifatnya yang terpencil dan masih relatif murni, Samudra Selatan menjadi salah satu kawasan laut yang paling penting untuk dilindungi demi menjaga keseimbangan ekologis Bumi secara menyeluruh.
''',
  ),
];
