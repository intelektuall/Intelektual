class Point {
  final String title; // Judul utama poin
  final String? description; // Teks tambahan (opsional)

  Point({required this.title, this.description});
}

class Section {
  final String title; // Subjudul
  final String? text; // Teks biasa sebelum poin
  final List<Point> points; // List poin bernomor dengan teks opsional

  Section({
    required this.title,
    this.text,
    required this.points,
  });
}

class SeaLife {
  final String name;
  final String imagePath;
  final List<Section> sections;

  SeaLife({
    required this.name,
    required this.imagePath,
    required this.sections,
  });
}

// 📌 Contoh Data
List<SeaLife> seaLifeList = [
  SeaLife(
    name: "Samudra Pasifik",
    imagePath: "assets/images/samudraPasifik.jpg",
    sections: [
      Section(
        title: "Deskripsi Umum",
        text: """
Samudra Pasifik juga dikenal sebagai laut teduh. Sementara nama Pasifik sendiri berasal dari Bahasa Spanyol “Pacifio” yang berarti tenang. Samudra pasifik merupakan kawasan kumpulan air terbesar di dunia. Dikatakan terbesar di dunia karena samudra Pasifik ini mencakup sekitar sepertiga dari permukaan Bumi. Apabila diukur dan diangkakan, maka luas samudra pasifik mencapai 179,7 kita kilometer persegi atau 69,4 mi persegi.

Panjang samudra pasifik ini mencapai 15.500 kilometer atau 9.600. samudra ini membentang dari Laut Bering di Arktik hingga batasan es di Laut Ross, Antartika Selatan. Selain itu samudra pasifik juga membentang dari Indonesia hingga pesisir Kolombia. Batas sebelah barat samudra pasifik biasanya diletakkan di Selat Malaka. Tak heran mengapa Samudra Pasifik ini menjadi samudra paling besar atau paling luas di dunia dibandingkan dengan samudra- samudra lainnya.
""",
        points: [],
      ),
      Section(
        title: "Letak Samudra Pasifik",
        text: """
Samudra Pasifik adalah samudra yang memiliki luas paling besar di Bumi dan merupakan raja nya samudra. Samudra Pasifik sangatlah luas dan dalam, sehingga keberadaannya pun mencakup ke dalam berbagai macam wilayah. Secara astronomis samudra pasifik mencapai lebar timur- barat terbesarnya pada sekitar 5° LU yang mana terbentang sekitar 19.800 km dari Indonesia hingga ke pesisir Kolombia.

Sebagian informasi mengenai letak samudra pasifik sudah kita ketahui sebelumnya. Ada yang menyatakan bahwa luas samudra pasifik ini mencapai 1/3 dari luas permukaan Bumi. Oleh karena samudra pasifik ini memenuhi hampir 1/3 dari luas bumi, maka banyak sekali negera- negara yang berada atau berbatasan dengan samudra pasifik ini.
""",
        points: [],
      ),
      Section(
        title: "Karakteristik Samudra Pasifik",
        text: """
 Samudra di dunia terdiri atas beberapa jumlahnya. Masing- masing samudra tersebut mempunyai karakteristiknya masing- masing. Hal ini juga sama halnya dengan samudra pasifik. Samudra pasifik mempunyai ke khasan sendiri yang hanya dimiliki oleh samudra pasifik saja. Beberapa karakteristik yang dimiliki oleh samudra pasifik diantaranya adalah sebagai berikut:
""",
        points: [
          Point(
            title: "Merupakan samudra yang paling luas di dunia",
            description: "Ukuran dari samudra pasifik ini jauh lebih besar daripada samudra- samudra lainnya yang ada di dunia, seperti Atlantik, Arktik dan juga Hindia. Ukuran samudra pasifik ini bahkan mencapai 1/3 dari luas permukaan Bumi.",
          ),
          Point(
            title: "Mempunyai palung yang paling dalam di dunia",
            description: "Tahukah Anda bahwa di dunia ini ada titik terendah? Dan letak titik terendah yang ada di dunia adalah di palung samudra. Ada beberapa palung samudra, dan palung yang paling dalam berada di kawasan samudra pasifik. Palung paling dalam di dunia adalah Palung Mariana yang kedalamannya mencapai 10.911 meter dari permukaan air laut.",
          ),
        ],
      ),
    ],
  ),
  SeaLife(
    name: "Samudra Arktik",
    imagePath: "assets/images/samudraArctic.jpg",
    sections: [
      Section(
        title: "Deskripsi Umum",
        text: """
Samudra Arktik merupakan samudra yang paling kecil dan paling dangkal dibanding samudra di dunia lainnya di planet bumi. Selain itu, samudra ini merupakan samudra yang memiliki suhu permukaan paling rendah dibanding samudra-samudra lainnya karena letaknya mengelilingi kutub utara. Samudra Arktik juga disebut sebagai samudra beku di masa lalu, karena seluruh permukaannya ditutupi es sepanjang tahun. Samudra ini memiliki luas sebesar 14.056 juta km² yang setara dengan 1,5 kali luas Amerika Serikat atau sekitar 8% dari luas samudra pasifik. Sementara panjang garis pantainya sekitar 45.389 km dan kedalaman rata-rata mencapai 1.300 meter (3.406 kaki) dengan titik terdalam sekitar 5.450 meter (17.880 kaki) yang terletak di basin Eurasia.

Samudra Arktik mulai dikenal sejak orang kebangsaan Amerika bernama Robert Peary mendaratkan kaki di kutub utara pada 6 April 1909. Penduduk asli yang menempati wilayah sekitar samudra Arktik adalah suku Eskimo yang sudah menetap di kutub utara sejak 4000 tahun silam. Suku Eskimo merupakan pemakan daging mentah. Samudra Arktik diakui dan ditetapkan sebagai samudra oleh Organisasi Hidrografi Internasional (IHO), meskipun ahli samudra lainnya menyatakan bahwa samudra Arktik bukan termasuk ke dalam klasifikasi samudra, melainkan hanya sebagai laut Mediteran Arktik atau laut Arktik yang menjadi bagian dari laut Mediteranian yang tergabung ke dalam samudra Atlantik. Terdapat pematang Lomonosov di dasar samudra Arktik yang membagi dasar laut basin di Kutub Utara menjadi dua wilayah, yaitu basin Eurasia yang memiliki kedalaman sekitar 4.000–5.450 meter, dan basin Amerika (Hyperborean) yang memiliki kedalaman sekitar 4.000 meter.

Beberapa spesies laut di samudra Arktik terancam punah, karena kawasan ini mempunyai ekosistem yang rapuh dan lambat untuk pulih ketika ada kerusakan. Spesies laut yang terancam punah adalah walrus dan paus. Sementara spesies yang melimpah di perairan kutub utara adalah ubur-ubur surai singa. Samudra Arktik juga memiliki kehidupan tanaman bawah laut yang relatif sedikit, tetapi tidak untuk fitoplankton. Fitoplankton merupakan bagian penting dari laut dan sebagian besar berada di Kutub Utara. Fitoplankton berfotosintesis selama musim panas karena adanya sinar matahari yang keluar pada siang dan malam. Sebaliknya pada musim dingin, fitoplankton berjuang untuk mendapatkan cahaya yang cukup untuk fotosintesis dan bertahan hidup.
""",
        points: [],
      ),
      Section(
        title: "Letak Samudra Arktik",
        text: """
Samudra Arktik terletak di belahan bumi bagian utara dan secara keseluruhan mengelilingi kutub utara. Letak samudra Arktik berada di benua Asia, benua Eropa dan benua Amerika utara bagian utara. Letak astronomis samudra Arktik berada pada 90°00’ garis lintang utara dan 0°00’ garis bujur timur. Samudra Arktik terhubung langsung dengan samudra Pasifik melalui selat Bering, dan terhubung dengan samudra Atlantik melalui laut Greenland dan laut Labrador. Wilayah samudra Arktik hampir dikelilingi oleh daratan dan berbatasan dengan beberapa wilayah yaitu Asia Utara, Amerika Utara, Greenland, serta Jazirah Skandinavia atau Eropa Utara. Beberapa laut yang berada diwilayah samudra Arktik mencakup teluk Baffin, laut Barents, laut Beaufort, laut Chukchi, laut Siberia Timur, laut Greenland, teluk Hudson, selat Hudson, laut Kara, laut Laptev, dan laut Putih.
""",
        points: [],
      ),
      Section(
        title: "Karakteristik Samudra Arktik",
        text: """
 Samudra di dunia terdiri atas beberapa jumlahnya. Masing- masing samudra tersebut mempunyai karakteristiknya masing- masing. Hal ini juga sama halnya dengan samudra pasifik. Samudra pasifik mempunyai ke khasan sendiri yang hanya dimiliki oleh samudra pasifik saja. Beberapa karakteristik yang dimiliki oleh samudra pasifik diantaranya adalah sebagai berikut:
""",
        points: [
          Point(title: "Samudra Arktik adalah samudra terkecil dan terdangkal di dunia."),
          Point(title: "Permukaannya selalu tertutup es, baik saat musim dingin maupun musim sepanjang tahun."),
          Point(title: "Kadar garam dan suhu permukaannya selalu berubah-ubah tergantung dari musim dan kadar pencairan es yang menutupinya."),
          Point(title: "Samudra dengan kadar garam terendah di dunia yang disebabkan rendahnya penguapan serta terbatasnya air yang keluar dari wilayah samudra ini ke daerah selatannya dengan air tawar yang masuk ke samudra Arktik dalam jumlah yang besar."),
          Point(title: "Terdapat basin Eurasia yang memiliki kedalaman sekitar 4.000 – 5.450 meter."),
          Point(title: "Titik terendah terdapat di Basin Eurasia yang mencapai 5.450 meter."),
          Point(title: "Bentuk dasar samudra Arktik sangat bervariasi, yaitu memiliki faultblock–ridge (seperti bukit), zona plains of the abyssal (seperti kawasan berlubang), laut-laut dalam dan basin-basin."),
          Point(title: "Memiliki iklim kutub sepanjang tahun dengan suhu rata-rata -2°C."),
          Point(title: "Musim dingin di samudra Arktik ditandai dengan dingin, gelap, cuaca stabil dan langit yang cerah"),
          Point(title: "Musim panas ditandai dengan adanya sinar matahari, kondisi lembab, berkabut dan adanya angin-angin puyuh lemah dengan hujan dan salju."),
        ],
      ),
    ],
  ),
  SeaLife(
    name: "Samudra Hindia",
    imagePath: "assets/images/samudraHindia.jpg",
    sections: [
      Section(
        title: "Deskripsi Umum",
        text: """
Samudra Hindia adalah samudra terbesar ketiga di dunia. Nama Hindia diambil dari nama negara yaitu India. Samudra Hindia dalam bahasa Sansekerta disebut Ratnakara yang berarti mine of gems (ladang permata). Samudra ini memiliki 20% permukaan air bumi atau sekitar 68.556 juta km². Samudra Hindia mempunyai garis pantai sepanjang 66.526 km dengan kedalaman rata- rata mencapai 3.890 m. Titik terdalam dari samudra Hindia terletak di Palung Jawa yaitu sebelah selatan pulau Jawa dengan kedalaman mencapai 7.725 m. Samudra Hindia juga mempunyai volume air yang diperkirakan sekitar 292.131.000 km³. Terdapat lima punggung laut besar di samudra Hindia yang berpusat di satu titik, yaitu punggung laut Hindia barat daya, Hindia tenggara, Sicilia, Nikety timur, dan Chagos-Lachandive.

Samudra Hindia yang menjadi sarana transportasi dunia ini merupakan muara bagi beberapa sungai, seperti sungai Gangga, sungai Zambezi, sungai Shatt al- Arab, sungai Brahmaputra, sungai Ayeyarwady dan sungai Indus. Beberapa pelabuhan internasional juga berada di wilayah Samudra Hindia, seperti Calcutta di India, Chennai di Madras, India, Colombo di Sri Lanka, Durban di Afrika Selatan, Jakarta di Indonesia, Karachi di Pakistan, Fremantle di Australia, Mumbai di Bombay, India dan Teluk Richards di Afrika Selatan.
""",
        points: [],
      ),
      Section(
        title: "Letak Samudra Pasifik",
        text: """
Secara astronomis, letak samudra Hindia dipisahkan dengan Samudra Atlantik oleh 20ᵒ garis bujur timur, dan dengan Samudra Pasifik oleh 147ᵒ garis bujur timur. Samudra merupakan laut terpanas di dunia ini terdiri dari beberapa kumpulan wilayah perairan, seperti laut Andaman, Great Australian Bight, laut Arab, teluk Bengal, teluk Aden, teluk Persia, teluk Oman, saluran Mozambique, selat Malaka dan laut Merah. Adapun batas-batas wilayah samudra Hindia antara lain:
""",
        points: [
          Point(
            title: "Sebelah utara adalah kawasan Asia Selatan",
          ),
          Point(
            title: "Sebelah selatan adalah Benua Antartika",
          ),
          Point(
            title: "Sebelah barat adalah Jazirah Arab dan benua Afrika",
          ),
          Point(
            title: "Sebelah timur adalah Semenanjung Malaya, Pulau Sumatera, Jawa, Kepulauan Sunda Kecil, dan Benua Australia",
          ),
        ],
      ),
      Section(
        title: "Karakteristik Samudra Hindia",
        text: """
 Samudra di dunia masing-masing mempunyai karakteristik tersendiri yang menjadi ciri khas dari samudra tersebut. Seperti samudra Pasifik yang memiliki beberapa karakteristik, samudra Hindia juga memiliki beberapa karakteristik tersendiri yang membedakan dengan samudra lain. Berikut ini adalah beberapa karakteristik yang dimilki oleh samudra Hindia:
""",
        points: [
          Point(
            title: "Samudra Hindia merupakan satu-satunya samudra yang wilayahnya terletak di belahan bumi bagian timur.",
          ),
          Point(
            title: "Samudra Hindia diapit oleh tiga benua, yaitu benua Afrika, benua Asia, benua Australia serta kutub selatan.",
          ),
          Point(
            title: "Kedalamanan laut di wilayah samudra Hindia diperkirakan mencapai ±3.960 m dan kadar garam rata-rata 34,72%.",
          ),
          Point(
            title: "Samudra Hindia mempunyai arus yang besar dan gelombang yang tinggi.",
          ),
          Point(
            title: "Samudra Hindia mempunyai sedikit pulau, di bagian barat pulau Madagaskar, di timur terdapat pulau Sumatera, Jawa, dan Nusa Tenggara dan di utara terdapat Pulau Ceylon (Sri Lanka) dan Maladewa.",
          ),
          Point(
            title: "Jarang terjadi badai besar di samudra Hindia, berbeda dengan samudra Pasifik dan samudra Atlantik yang sering dilanda badai besar",
          ),
          Point(
            title: "Samudra Hindia merupakan satu-satunya samudra yang batas utaranya tidak menyentuh garis lingkaran kutub utara yang disebabkan terhalang oleh Benua Asia",
          ),
          Point(
            title: "Lempeng Indo-Australia yang merupakan pusat tunjaman lempeng dari benua Asia terletak di dasar samudra Hindia bagian utara, sehingga menyebabkan wilayah ini menjadi daerah labil",
          ),
          Point(
            title: "Tiupan angin muson di samudra Hindia bermanfaat bagi pelaut dalam pelayarannya, sehingga jarak tempuh bisa lebih jauh.",
          ),
          Point(
            title: "Banyak dijumpai lubuk laut atau cekungan di samudra Hindia, seperti cekungan Madagaskar, cekungan Mascarena, dan cekungan Croze.",
          ),
          Point(
            title: "Gelombang besar yang terdapat di samudra Hindia seringkali memunculkan bencana banjir di negara Sri Lanka dan Maladewa.",
          ),
        ],
      ),
    ],
  ),
  SeaLife(
    name: "Samudra Atlantik",
    imagePath: "assets/images/samudraAtlantic.jpg",
    sections: [
      Section(
        title: "Deskripsi Umum",
        text: """
Samudra Atlantik merupakan salah satu samudra yang ada di Bumi disamping samudra Pasifik, Hindia, Arktik, dan Antartika. Sebenarnya nama Atlantik sendiri berasal dari mitologi Yunani, yang berarti laut atlas. Apabila samudra pasifik adalah yang terbesar di dunia, maka peringkat kedua diduduki oleh samudra Atlantik. Besar samudra Atlantik ini meliputi 1/5 luas permukaan Bumi atau 20% luas permukaan Bumi. Apabila diangkakan maka luas samudra Atlantik ini adalah 106.450.000 kilometer persegi.

Lalu apabila laut yang ada di sekitarnya tidak dihitung, maka luasnya adalah 82.362.000 kilometer persegi. lebar samudra Atlantik sangat beragam, muali dari 2.848 km (yakni antara Brasil dan Liberia) hingga 4.830 km (antara Amerika Serikat dan sebelah utara Afrika). Sedangkan volume samudra Atlantik apabila laut di sekitarnya tidak dihitung maka 323.600.000 km³. Hal ini melambangkan bahwa jumlah wilayah yang mengalir ke samudra Atlantik ini lebih besar empat kali dibandingkan dengan Samudra Pasifik maupun Samudra Hindia.

Bentuk samudra Atlantik adalah seperti huruf S yang memanjang dari belahan Bumi sebelah utara hingga ke belahan Bumi sebelah selatan. Sementara untuk kedalaman samudra Atlantik sendiri, rata- rata adalah 3.332 m (apabila bersama dengan laut di sekitarnya), dan tanpa laut di sekitarnya adalah 3.926 m. titik terdalam di samudra ini berada di sebuah palung yang sangat terkenal. Palung yang paling dalam di samudra Atlantik adalah Palung Puerto Rico.
""",
        points: [],
      ),
      Section(
        title: "Letak Samudra Atlantik",
        text: """
Samudra Atlantik merupakan kumpulan air yang terdapat di antara Afrika, Eropa, Samudra Selatan dan juga Benua Amerika. Secara Astronomis samudra Atlantik ini berada di koordinat geografi 0.00 U dan 25.00 B. Batasan antara samudra Atlantik dengan samudra Hindia di sebelah timur, dibatasi pada titik 20 derajat Bujur Timur (BT).

Dan batas antara Samudra Atlantik dengan Samudra Arktik adalah garis dari wilayah Greenland ke Svalbard yang berada di sebelah utara Norwegia. Samudra Atlantik merupakan samudra yang unik karena samudra ini mempunyai pesisir pantai yang tidak beraturan yang mana pesisir pantai ini dibatasi oleh berbagai teluk dan juga lautan. Beberapa laut yang membatasi samudra Atlantik adalah:
""",
        points: [
          Point(title: "Laut Karibia"),
          Point(title: "Teluk St. Lawrence"),
          Point(title: "Teluk Meksiko"),
          Point(title: "Laut Mediterania"),
          Point(title: "Laut Hitam"),
          Point(title: "Laut Baltik"),
          Point(title: "Laut Utara"),
          Point(title: "Laut Norwegia- Greenland"),
        ],
      ),
      Section(
        title: "Karakteristik Samudra Atlantik",
        text: """
Secara umum samudra yang ada di Bumi ini terlihat sama saja antara satu dengan lainnya. Namun samudra- samudra yang berbeda ini ternyata mempunyai ciri khas atau karakteristik nya masing- masing. Begitu pula dengan samudra Atlantik. Samudra Atlantik mempunyai karakteristik yang membuat samudra ini berbeda dengan samudra lainnya. Beberapa karakteristik samudra Atlantik antara lain adalah sebagai berikut:
""",
        points: [
          Point(
            title: "Bentuk nya meliuk yang mirip dengan huruf S",
            description: "Katakteristik atau fakta unik yang dimiliki samudra Atlantik salah satu adalah bentuknya yang meliuk sehingga menyerupai huruf S. oleh karena ini pula samudra Atlantik mempunyai pesisir pantai yang tidak beraturan yang hanya dibatasi dengan berbagai teluk dan lautan.",
          ),
          Point(
            title: "Sering terjadi badai tropis",
            description: "Karakteristik selanjutnya yang dimiliki oleh samudra Atlantik adalah sering terjadinya badai tropis. Badai tropis ini berkembang di sekitar kawasan pesisir pantai di Afrika dekat Tanjung Verd, dan kemudian bergerak ke arah barat menuju ke Laut Karibia (ini terjadi pada bulan Mei- Desember).",
          ),
          Point(
            title: "Sering terjadi angin ribut",
            description: "Selain badai tropis, peristiwa yang sering terjadi adalah angin ribut. Angin ribut biasa terjadi di Atlantik Utara pada musim dingin di utara yang menyebabkan perlintasan samudra terasa lebih sulit dan juga berbahaya.",
          ),
          Point(
            title: "Sebagian besar wilayahnya berada di wilayah garis bujur barat",
            description: """
            Karakteristik samudra Atlantik yang lainnya adalah sebagian besar wilayah samudra ini berada di wilayah garis bujur barat, sehingga samudra ini berada di belahan Bumi bagian barat.

            Itulah beberapa karakteristik atau fakta unik yang memuat samudra Atlantik. Oleh karena karakteristik, maka hal- hal seperti ini tidak didapati oleh samudra yang lainnya.
            """,
          ),
        ],
      ),
    ],
  ),
  SeaLife(
    name: "Samudra Selatan",
    imagePath: "assets/images/samudraSelatan.jpg",
    sections: [
      Section(
        title: "Deskripsi Umum",
        text: """
Perbatasan dan nama untuk samudra dan lautan disepakati secara internasional ketika Biro Hidrografi Internasional, pendahulu IHO, mengadakan Konferensi Internasional Pertama pada tanggal 24 Juli 1919. IHO kemudian menerbitkannya dalam “Limits of Oceans and Seas“, edisi pertama adalah tahun 1928. Sejak edisi pertama, batas Samudra Selatan semakin bergerak ke selatan; sejak 1953, telah dihilangkan dari publikasi resmi dan diserahkan kepada kantor hidrografi lokal untuk menentukan batas mereka sendiri.

IHO memasukkan samudra dan definisinya sebagai perairan di selatan 60 derajat lintang selatan dalam revisinya tahun 2000, tetapi hal ini belum diadopsi secara formal, karena kebuntuan yang berlanjut tentang beberapa konten, seperti sengketa penamaan atas Laut Jepang. Definisi IHO tahun 2000, bagaimanapun, diedarkan dalam edisi draf pada tahun 2002, dan digunakan oleh beberapa orang di dalam IHO dan oleh beberapa organisasi lain seperti CIA World Factbook dan Merriam-Webster. Pemerintah Australia menganggap Samudra Selatan terletak tepat di sebelah selatan Australia

Yayasan National Geographic mengakui lautan ini secara resmi pada Juni 2021.[6][7] Sebelumnya, ia menggambarkannya dalam jenis huruf yang berbeda dari lautan dunia lainnya; sebaliknya, itu menunjukkan Samudra Pasifik, Atlantik, dan Hindia yang membentang ke Antartika baik di peta cetak maupun online. Penerbit peta yang menggunakan istilah Southern Ocean di peta mereka menyertakan Hema Maps dan GeoNova.
""",
        points: [],
      ),
      Section(
        title: "Geografi Samudra Selatan",
        text: """
Samudra Selatan secara geologis merupakan samudra termuda, dan terbentuk ketika Antartika dan Amerika Selatan berpisah yang kemudian membuka Selat Drake sekitar 30 juta tahun yang lalu. Pemisahan benua ini memungkinkan pembentukan Arus Lingkar Antarktika.

Dengan batas utara di 60°S, Samudra Selatan berbeda dari samudra lainnya karena batas terbesarnya, batas utara, tidak berbatasan dengan daratan (seperti yang terjadi pada edisi pertama Batas Samudra dan Laut). Sebaliknya, batas utara dari samudra ini adalah dengan Samudra Atlantik, Hindia, dan Pasifik.

Salah satu alasan untuk menganggapnya sebagai samudra terpisah berasal dari fakta bahwa sebagian besar air di Samudra Selatan berbeda dengan air di samudra lainnya. Air yang masuk di sekitar Samudra Selatan cukup cepat karena Arus Sirkumpolar Antartika yang bersirkulasi di sekitar Antartika. Air di Samudra Selatan bagian selatan, misalnya, Selandia Baru, lebih menyerupai air di Samudra Selatan bagian selatan Amerika Selatan daripada air di Samudra Pasifik.

Samudra Selatan memiliki kedalaman antara 4.000 dan 5.000 m (13.000 dan 16.000 ft) di sebagian besar luasnya dengan hanya area perairan dangkal yang terbatas. Kedalaman 7,236 m (23,74 ft) terbesar Samudra Selatan terjadi di ujung selatan Palung Sandwich Selatan, pada 60°00'S, 024°W. Landas benua Antartika umumnya tampak sempit dan luar biasa dalam, ujungnya berada pada kedalaman hingga 800 m (2.600 ft), dibandingkan dengan rata-rata global 133 m (436 ft).Samudra Selatan, secara geologis merupakan samudra termuda, terbentuk ketika Antartika dan Amerika Selatan berpisah, membuka Selat Drake, kira-kira 30 juta tahun yang lalu. Pemisahan benua memungkinkan pembentukan Arus Lingkar Antarktika.

Ekuinoks sejalan dengan pengaruh musim matahari, bongkahan es Antartika berfluktuasi dari rata-rata minimum 26 juta kilometer persegi (10×106 sq mi) di bulan Maret menjadi sekitar {{convert|18.8|e6km2|e6sqmi} } pada bulan September, peningkatan luas lebih dari tujuh kali lipat.
""",
        points: [],
      ),
      Section(
        title: "Sub-divisi Samudra Selatan",
        text: """
Sub-divisi lautan adalah fitur geografis seperti "laut", "selat", "teluk", dan "saluran". Ada banyak sub-divisi Samudra Selatan yang didefinisikan dalam draf edisi keempat tahun 2002 yang tidak pernah disetujui dari publikasi IHO Limits of Oceans and Seas. Beberapa di antaranya seperti "Laut Cosmonauts" yang diusulkan Rusia tahun 2002, "Laut Kerjasama", dan "Laut Somov (penjelajah kutub Rusia pertengahan 1950-an)" tidak termasuk dalam dokumen IHO 1953 yang saat ini masih berlaku, karena nama mereka sebagian besar berasal dari tahun 1962 dan seterusnya. Otoritas geografis dan atlas terkemuka tidak menggunakan tiga nama terakhir ini, termasuk World Atlas edisi ke-10 tahun 2014 dari Yayasan National Geographic Amerika Serikat dan edisi ke-12 British Atlas Waktu Dunia tahun 2014, tetapi peta yang dikeluarkan Soviet dan Rusia melakukannya. Dalam urutan searah jarum jam ini termasuk (dengan sektor):
""",
        points: [
          Point(title: "Laut Weddell (57°18'B – 12°16'T)"),
          Point(title: "Laut Raja Haakon VII(20°W – 45°BT)"),
          Point(title: "Laut Lazarev (0° – 14°BT)"),
          Point(title: "Laut Riiser-Larsen (14° – 30°BT)"),
          Point(title: "Laut Cosmonauts (30° – 50°BT"),
          Point(title: "Laut Kerjasama (59°34' – 85°BT)"),
          Point(title: "Laut Davis (82° – 96°BT)"),
          Point(title: "Laut Mawson (95°45' – 113°BT)"),
          Point(title: "Laut Dumont D'Urville (140°BT)"),
          Point(title: "Laut Somov (150° – 170°BT)"),
          Point(title: "Ross Sea (166°E – 155°W)"),
          Point(title: "Laut Amundsen (102°20′ – 126°W)"),
          Point(title: "Laut Bellingshausen (57°18' – 102°20'W)"),
          Point(title: "Bagian dari Selat Drake(54° – 68°W)"),
          Point(title: "Selat Bransfield (54° – 62°W)"),
          Point(title: "Bagian dari Laut Scotia (26°30' – 65°W)"),
        ],
      ),
    ],
  ),
];
