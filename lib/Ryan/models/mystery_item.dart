import 'package:flutter/material.dart';

class MysteryItem {
  final String title;
  final IconData icon;
  final String description;
  final String ocean; // Tambahan
  final String fullContent;

  MysteryItem({
    required this.title,
    required this.icon,
    required this.description,
    required this.ocean, // Tambahan
    required this.fullContent,
  });
}

// Dummy Data
final List<MysteryItem> mysteryList = [
  MysteryItem(
    title: "Misteri Samudra Pasifik",
    icon: Icons.question_mark,
    description: "Terdapat laporan tentang suara misterius 'Bloop' yang terdengar dari kedalaman Samudra Pasifik, hingga kini asalnya belum diketahui.",
    ocean: "Pasifik",
    fullContent: '''
Suara misterius yang dikenal sebagai “Bloop” pertama kali terdengar pada tahun 1997 oleh National Oceanic and Atmospheric Administration (NOAA) melalui jaringan hidrofon yang dipasang di Samudra Pasifik untuk memantau aktivitas seismik bawah laut. Suara ini memiliki frekuensi sangat rendah tetapi cukup kuat untuk terdeteksi oleh sensor yang berjarak lebih dari 5.000 kilometer, dan karakternya terdengar menyerupai suara biologis—seolah berasal dari makhluk hidup raksasa yang belum dikenal. Karena tidak ada hewan laut yang diketahui mampu menghasilkan suara sekuat itu, fenomena ini sempat menimbulkan spekulasi luas, termasuk teori bahwa suara itu berasal dari makhluk laut misterius, hingga dikaitkan dengan legenda seperti Cthulhu. Namun, setelah bertahun-tahun penelitian, para ilmuwan NOAA menyimpulkan bahwa kemungkinan terbesar suara Bloop berasal dari fenomena geofisik alami, terutama suara runtuhan gunung es raksasa (icequake) di Antartika yang retak dan pecah di bawah laut, menciptakan gelombang suara yang sangat mirip dengan karakteristik biologis. Penjelasan ini diperkuat oleh lokasi asal suara yang dekat dengan gletser di wilayah Samudra Pasifik Selatan. Meskipun misterinya sebagian besar telah terpecahkan, Bloop tetap menjadi salah satu contoh paling menarik tentang bagaimana laut dalam, khususnya wilayah luas dan dalam seperti Samudra Pasifik, masih menyimpan fenomena yang belum sepenuhnya dipahami oleh manusia. Misteri seperti ini menunjukkan betapa luasnya ruang pengetahuan yang belum terjamah di kedalaman samudra, dan bagaimana teknologi serta ilmu pengetahuan terus berperan penting dalam mengungkap rahasia lautan terdalam.

''',
  ),
  MysteryItem(
    title: "Misteri Samudra Atlantik",
    icon: Icons.help_outline,
    description: "Segitiga Bermuda di Samudra Atlantik dikenal sebagai tempat hilangnya kapal dan pesawat secara misterius.",
    ocean: "Atlantik",
    fullContent: '''
Segitiga Bermuda, yang terletak di wilayah barat Samudra Atlantik antara Miami (Florida), Bermuda, dan Puerto Riko, telah lama dikenal sebagai lokasi misterius karena berbagai laporan tentang hilangnya kapal dan pesawat secara tiba-tiba dan tanpa jejak. Fenomena ini mulai populer pada pertengahan abad ke-20, terutama setelah peristiwa hilangnya Penerbangan 19—sebuah skuadron pesawat militer AS pada tahun 1945—yang memicu gelombang spekulasi dan perhatian publik. Sejak saat itu, ratusan insiden dikaitkan dengan area ini, yang oleh sebagian orang dianggap memiliki kekuatan supranatural, gangguan magnetik, hingga dugaan adanya teknologi asing atau portal ruang-waktu. Namun, berdasarkan penelitian ilmiah yang telah dilakukan, sebagian besar kejadian di Segitiga Bermuda dapat dijelaskan melalui sebab-sebab alamiah, seperti cuaca ekstrem yang tiba-tiba, kesalahan navigasi, medan magnet bumi yang memengaruhi instrumen kompas, hingga arus laut seperti Arus Teluk (Gulf Stream) yang sangat kuat dan dapat dengan cepat menghilangkan jejak reruntuhan. Selain itu, wilayah ini juga merupakan salah satu jalur pelayaran dan penerbangan tersibuk di dunia, sehingga wajar jika angka kecelakaan lebih tinggi dibandingkan area lain. Studi statistik menunjukkan bahwa tingkat kehilangan di Segitiga Bermuda tidak lebih tinggi secara signifikan dibanding wilayah laut lainnya jika dihitung berdasarkan volume lalu lintas. Maka dari itu, meskipun aura misteri tetap melekat kuat dalam budaya populer, komunitas ilmiah sepakat bahwa tidak ada bukti yang mendukung keberadaan kekuatan aneh atau luar biasa di Segitiga Bermuda, dan bahwa kejadian-kejadian yang terjadi di sana lebih masuk akal bila dijelaskan melalui faktor-faktor alam, teknis, dan manusia.
''',
  ),
  MysteryItem(
    title: "Misteri Samudra Hindia",
    icon: Icons.explore,
    description: "Hilangnya pesawat Malaysia Airlines MH370 di Samudra Hindia masih menjadi misteri terbesar dalam sejarah penerbangan modern.",
    ocean: "Hindia",
    fullContent: '''
Hilangnya pesawat Malaysia Airlines MH370 pada 8 Maret 2014 merupakan salah satu misteri terbesar dalam sejarah penerbangan modern dan hingga kini belum sepenuhnya terpecahkan. Pesawat Boeing 777 itu lepas landas dari Kuala Lumpur menuju Beijing dengan membawa 239 orang di dalamnya, namun menghilang dari radar sipil sekitar satu jam setelah lepas landas. Data militer menunjukkan bahwa pesawat secara misterius berbelok dari jalur semula dan menuju ke arah barat daya, sebelum akhirnya diduga jatuh di wilayah terpencil Samudra Hindia bagian selatan. Wilayah yang diduga sebagai lokasi jatuhnya MH370 merupakan bagian dari laut terdalam dan paling terpencil di dunia, dengan arus laut yang kuat, kedalaman ekstrem, dan kondisi bawah laut yang kompleks, yang membuat pencarian menjadi sangat sulit dan penuh tantangan. Penyelidikan internasional yang melibatkan berbagai negara dan teknologi canggih telah dilakukan, termasuk pemindaian dasar laut menggunakan sonar dan analisis data satelit dari Inmarsat, yang menunjukkan bahwa pesawat kemungkinan besar jatuh di suatu tempat di sekitar "Koridor Selatan" Samudra Hindia. Beberapa potongan puing pesawat, seperti flaperon yang ditemukan di Pulau Réunion dan pantai-pantai lain di wilayah Samudra Hindia barat, telah dikonfirmasi berasal dari MH370, namun lokasi pasti bangkai utama pesawat masih belum ditemukan. Penyebab pasti hilangnya MH370 juga belum diketahui karena tanpa kotak hitam dan puing utama, penyelidik hanya dapat berspekulasi berdasarkan data terbatas, termasuk kemungkinan intervensi manusia atau kegagalan sistem yang kompleks. Misteri ini bukan hanya menyisakan duka bagi keluarga korban, tetapi juga membuka perdebatan luas tentang keamanan penerbangan, transparansi data, dan keterbatasan teknologi pelacakan pesawat di area laut luas seperti Samudra Hindia. Kejadian ini menyoroti betapa masih banyak wilayah lautan dunia yang belum sepenuhnya terjangkau oleh teknologi dan pengetahuan manusia, sekaligus menjadi pengingat akan pentingnya kerja sama internasional dalam menghadapi tragedi global.
''',
  ),
  MysteryItem(
    title: "Misteri Samudra Arktik",
    icon: Icons.ac_unit,
    description: "Penemuan aneh seperti es yang berwarna biru dan formasi bawah laut tak biasa membuat Samudra Arktik penuh teka-teki.",
    ocean: "Arktik",
    fullContent: '''
Samudra Arktik memang menyimpan banyak keunikan dan teka-teki alam yang hingga kini masih terus diteliti. Salah satu fenomena paling mencolok adalah es berwarna biru cerah yang sering ditemukan di wilayah kutub utara. Warna biru tersebut muncul karena es di Arktik dapat terbentuk secara sangat padat tanpa banyak gelembung udara, sehingga hanya panjang gelombang cahaya biru yang bisa menembus dan dipantulkan kembali. Semakin tua dan padat es tersebut, maka semakin dalam pula warna birunya. Ini sangat berbeda dengan es putih biasa yang banyak mengandung gelembung udara dan memantulkan hampir semua cahaya. Fenomena ini bukan hanya indah, tetapi juga memberikan informasi penting tentang usia, struktur, dan stabilitas es laut di wilayah kutub.

Selain itu, dasar Samudra Arktik juga menyimpan formasi bawah laut yang tidak biasa, termasuk gunung laut, jurang dalam, dan celah lempeng tektonik aktif seperti Lomonosov Ridge dan Mendeleev Ridge. Beberapa dari formasi ini baru terdeteksi pada abad ke-21 berkat pemetaan sonar canggih dan ekspedisi laut dalam. Keberadaan formasi ini memicu pertanyaan ilmiah tentang asal-usul geologisnya serta potensi cadangan mineral dan kehidupan ekstrem di sekitarnya. Beberapa area bahkan memperlihatkan aktivitas metana bawah laut, di mana gelembung gas metana muncul dari dasar laut dan menunjukkan potensi pengaruh besar terhadap perubahan iklim bila terjadi pelepasan dalam skala besar.

Gabungan antara lingkungan ekstrem, medan bawah laut yang kompleks, dan minimnya eksplorasi membuat Samudra Arktik menjadi salah satu wilayah paling misterius di planet ini. Kondisi ini menjadikan setiap penemuan ilmiah baru di wilayah tersebut—apakah itu bentuk es tak biasa, kehidupan mikroba ekstrem, atau struktur geologi purba—sebagai petunjuk penting dalam memahami dinamika bumi dan dampaknya terhadap perubahan iklim global. Di tengah pencairan es akibat pemanasan global, misteri-misteri yang tersembunyi di Arktik menjadi semakin penting untuk diungkap, baik demi ilmu pengetahuan maupun masa depan lingkungan planet kita.
''',
  ),
  MysteryItem(
    title: "Misteri Samudra Selatan",
    icon: Icons.snowing,
    description: "Kapal-kapal yang menjelajahi perairan ganas di Samudra Selatan sering melaporkan fenomena cuaca ekstrem yang tidak dapat dijelaskan.",
    ocean: "Selatan",
    fullContent: '''
Samudra Selatan, yang mengelilingi benua Antartika, dikenal sebagai salah satu wilayah laut paling ekstrem dan berbahaya di dunia. Kapal-kapal yang melintasi perairan ini, baik untuk ekspedisi ilmiah maupun pelayaran komersial, sering melaporkan fenomena cuaca yang sangat ganas dan tidak selalu dapat diprediksi secara akurat. Cuaca di Samudra Selatan dapat berubah dalam hitungan menit—dari langit cerah menjadi badai salju disertai angin topan dan ombak raksasa. Hal ini disebabkan oleh fakta bahwa samudra ini tidak dibatasi oleh daratan besar, memungkinkan angin dan arus laut berputar tanpa hambatan mengelilingi Antartika, menciptakan sistem cuaca yang sangat dinamis. Salah satu fenomena paling terkenal adalah "Roaring Forties", "Furious Fifties", dan "Screaming Sixties"—istilah untuk menggambarkan kekuatan angin luar biasa yang terjadi pada garis lintang 40°, 50°, dan 60° selatan. Angin ini menghasilkan gelombang laut yang bisa mencapai tinggi lebih dari 20 meter dan menciptakan badai laut yang bisa melumpuhkan kapal dalam waktu singkat. Selain itu, munculnya kabut es, hujan es, dan arus dingin yang membawa bongkahan es laut atau gunung es membuat pelayaran di wilayah ini semakin berisiko. Dalam beberapa kasus, pelaut melaporkan fenomena seperti "freak waves" atau gelombang anomali yang muncul tiba-tiba dan jauh lebih tinggi dari gelombang normal di sekitarnya—suatu kejadian yang hingga kini masih menjadi topik penelitian oseanografi. Karena sifat Samudra Selatan yang terpencil, sulit diakses, dan ekstrem secara meteorologis, banyak fenomena cuaca yang terjadi di sana belum sepenuhnya dipahami. Kondisi ini menjadikan Samudra Selatan sebagai laboratorium alami yang menantang bagi para ilmuwan, sekaligus sebagai pengingat bahwa masih banyak kekuatan alam di laut lepas yang belum bisa dijelaskan secara penuh oleh sains modern.
''',
  ),
];
