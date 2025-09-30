class CoralSpecies {
  final String name;
  final String imagePath;
  final String description;
  final String category; // Menambahkan kategori (Flora Laut)
  final String ocean; // Menambahkan samudra
  final String subtype; // Menambahkan subtipe (seperti "Mangrove", "Kelp", dll)

  int likeCount;
  int commentCount;

  CoralSpecies({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.category,
    required this.ocean,
    required this.subtype,
    this.likeCount = 0,
    this.commentCount = 0,
  });
}

// Dummy Data - Menambahkan kategori, subtipe dan samudra pada setiap item
final List<CoralSpecies> coralSpeciesList = [
  CoralSpecies(
    name: "Kelp Raksasa",
    imagePath: "assets/images/KelpRaksasa.jpg",
    description: '''
Kelp raksasa (Macrocystis pyrifera) adalah jenis alga cokelat terbesar di dunia dan tumbuh membentuk hutan bawah laut yang sangat lebat di perairan laut yang dingin dan kaya nutrisi, terutama di sepanjang pantai barat Amerika Utara, Amerika Selatan, Australia, dan wilayah Samudra Pasifik yang beriklim sedang. Kelp bukanlah tumbuhan sejati, melainkan alga makroskopik, namun sering disebut "tumbuhan laut" karena bentuk dan fungsinya menyerupai vegetasi daratan.

Struktur kelp raksasa terdiri dari rhizoid (struktur seperti akar) yang menempel di dasar batuan, stipe (batang utama) yang panjang dan lentur, serta frond (daun-daunan) yang menjulang ke atas menuju permukaan laut. Di sepanjang frond terdapat gelembung udara kecil yang disebut pneumatocyst, yang berfungsi sebagai pelampung agar kelp tetap tegak berdiri dan bisa mendekati cahaya matahari untuk melakukan fotosintesis. Kelp raksasa dapat tumbuh dengan kecepatan luar biasa—hingga 60 cm per hari, dan dalam kondisi ideal, panjangnya bisa mencapai 30 hingga 60 meter, menjadikannya salah satu organisme laut dengan pertumbuhan tercepat di dunia.

Hutan kelp adalah habitat penting bagi ribuan spesies laut, mulai dari ikan, bintang laut, anemon, kepiting, singa laut, hingga berang-berang laut. Ekosistem ini menyediakan tempat berlindung, makanan, dan tempat berkembang biak bagi banyak makhluk laut. Salah satu penghuninya yang paling terkenal adalah berang-berang laut, yang berperan menjaga keseimbangan hutan kelp dengan memakan bulu babi laut yang dapat merusak dasar ekosistem kelp bila populasinya tidak terkendali.

Selain peran ekologisnya, kelp raksasa juga memiliki nilai ekonomi dan industri. Ekstraknya digunakan dalam berbagai produk sehari-hari, seperti kosmetik, pasta gigi, es krim, dan produk farmasi, berkat kandungan alginat, yaitu zat pengental alami yang diekstrak dari dinding sel kelp.

Namun, hutan kelp menghadapi berbagai ancaman serius. Perubahan iklim menyebabkan naiknya suhu laut dan memperlambat pertumbuhan kelp, sementara badai laut yang lebih sering dapat merusak struktur koloni. Selain itu, polusi, penangkapan berlebih terhadap predator bulu babi seperti berang-berang laut, serta invasi spesies asing juga berkontribusi terhadap menurunnya hutan kelp di banyak wilayah.

Sebagai salah satu ekosistem laut paling produktif dan dinamis di dunia, kelp raksasa memainkan peran penting dalam menyerap karbon, menjaga kualitas air, dan mendukung keanekaragaman hayati laut. Melindungi kelp berarti juga menjaga masa depan laut dan semua kehidupan yang bergantung padanya.
''',
    category: 'Flora Laut',
    ocean: 'Pasifik',
    subtype: 'Kelp',
  ),

  CoralSpecies(
    name: "Sargassum",
    imagePath: "assets/images/Sargassum.jpeg",
    description: '''
Sargassum adalah genus alga cokelat laut yang mengapung bebas di permukaan laut, terkenal karena membentuk hamparan luas di Samudra Atlantik bagian tengah, khususnya di wilayah yang dikenal sebagai Laut Sargasso. Tidak seperti sebagian besar alga laut lainnya yang menempel pada dasar laut, Sargassum memiliki gelembung udara kecil (pneumatocyst) yang memungkinkannya tetap mengapung dan menyebar dalam jumlah besar di lautan terbuka.

Tumbuhan laut ini memiliki struktur menyerupai tumbuhan darat, dengan daun semu, batang semu, dan buah semu, meskipun sebenarnya bukan tumbuhan sejati, melainkan jenis alga makroskopik dari kelompok alga cokelat (Phaeophyceae). Sargassum dapat tumbuh dengan cepat dan menyebar sangat luas, membentuk mat atau gumpalan terapung yang dapat membentang hingga ribuan kilometer.

Hamparan Sargassum menciptakan habitat unik dan penting bagi banyak spesies laut, termasuk ikan, penyu, kepiting, udang, dan bahkan spesies-spesies endemik seperti ikan Sargassum yang hanya ditemukan di antara alga ini. Alga ini juga menyediakan tempat berlindung bagi larva ikan dan organisme laut muda lainnya, menjadikannya pusat keanekaragaman hayati di lautan terbuka.

Namun, dalam dekade terakhir, Sargassum juga menjadi perhatian karena sering menyebabkan ledakan populasi (bloom) yang besar, terutama di wilayah Karibia, Teluk Meksiko, dan Afrika Barat, akibat perubahan iklim, limpasan nutrisi dari sungai, dan aktivitas manusia. Ledakan Sargassum ini dapat menumpuk di pantai, membusuk, dan menimbulkan bau belerang menyengat, mengganggu aktivitas pariwisata, perikanan, serta ekosistem pesisir. Dalam kondisi membusuk, Sargassum juga melepaskan gas beracun seperti hidrogen sulfida yang bisa berdampak pada kesehatan manusia jika terpapar dalam jumlah besar.

Meskipun demikian, Sargassum juga memiliki potensi ekonomi, misalnya sebagai bahan bioenergi, pupuk organik, pakan ternak, dan bahan dasar kosmetik atau obat-obatan, selama pengelolaannya dilakukan secara berkelanjutan.

Dengan dua sisi perannya—sebagai penyedia habitat penting di laut terbuka dan sekaligus sebagai masalah ekologis dan sosial di wilayah pesisir—Sargassum mencerminkan kompleksitas hubungan antara alga laut, perubahan lingkungan, dan aktivitas manusia. Upaya pemantauan dan pengelolaan berbasis ilmu pengetahuan menjadi penting untuk menyeimbangkan manfaat ekologisnya dengan dampak yang ditimbulkannya.
''',
    category: 'Flora Laut',
    ocean: 'Atlantik',
    subtype: 'Alga',
  ),

  CoralSpecies(
    name: "Rumput Laut Turtle Grass",
    imagePath: "assets/images/RumputLautTurtleGrass.jpg",
    description: '''
Turtle grass (Thalassia testudinum) adalah salah satu jenis rumput laut sejati (seagrass) yang hidup di perairan dangkal, hangat, dan jernih, terutama di wilayah Laut Karibia, Teluk Meksiko, dan sepanjang pantai tropis Amerika Tengah hingga Florida. Rumput laut ini dinamai “turtle grass” karena merupakan makanan utama penyu laut hijau (green sea turtle), yang sangat bergantung padanya sebagai sumber nutrisi.

Berbeda dengan alga laut, turtle grass adalah tumbuhan berbunga sejati yang memiliki akar, batang, daun, bunga, dan menghasilkan biji. Akar-akarnya tumbuh menjalar di bawah pasir atau lumpur laut dangkal dan membentuk sistem akar dan rimpang yang padat, yang membantu menstabilkan dasar laut serta mencegah erosi. Daunnya panjang, pipih, dan berbentuk seperti pita—biasanya berwarna hijau terang hingga hijau tua—dan bisa tumbuh hingga 30 cm atau lebih, membentuk padang lamun yang lebat.

Turtle grass berperan sangat penting dalam ekosistem pesisir tropis. Ia menyediakan habitat dan tempat berkembang biak bagi berbagai spesies laut, seperti ikan muda, udang, kepiting, bintang laut, kuda laut, dan bahkan spesies langka seperti dugong dan manatee. Selain itu, padang turtle grass juga bertindak sebagai penyerap karbon yang sangat efisien, membantu memitigasi dampak perubahan iklim, dan menjaga kejernihan air laut dengan memperlambat pergerakan sedimen.

Tanaman ini berkembang biak melalui dua cara: secara seksual melalui bunga dan biji, serta secara vegetatif melalui rimpang yang merambat di bawah dasar laut. Pertumbuhan turtle grass cukup lambat, sehingga kerusakan akibat aktivitas manusia seperti jangkar kapal, penambangan pasir, pencemaran, dan pembangunan pantai dapat memakan waktu lama untuk pulih.

Karena perannya yang sangat penting dalam menjaga kesehatan ekosistem laut dangkal, turtle grass dilindungi di banyak negara. Pelestarian padang lamun ini tidak hanya berdampak pada keanekaragaman hayati laut, tetapi juga pada keberlanjutan perikanan, perlindungan garis pantai dari abrasi, dan kualitas hidup masyarakat pesisir. Sebagai pilar ekosistem laut tropis, turtle grass adalah contoh sempurna bagaimana tumbuhan laut kecil dapat memiliki dampak besar terhadap keseimbangan alam secara keseluruhan.
''',
    category: 'Flora Laut',
    ocean: 'Hindia',
    subtype: 'Rumput Laut',
  ),

  CoralSpecies(
    name: "Irish Moss",
    imagePath: "assets/images/IrishMoss.jpeg",
    description: '''
Irish moss, atau yang secara ilmiah dikenal sebagai *Chondrus crispus*, adalah sejenis alga merah yang tumbuh di wilayah pesisir Samudra Atlantik Utara, terutama di sepanjang pantai Irlandia, Inggris, Kanada bagian timur, dan Amerika Serikat bagian timur laut. Meskipun disebut “moss” (lumut), tanaman laut ini bukan lumut sejati, melainkan ganggang laut makroskopik yang tergolong dalam kelompok Rhodophyta.

Irish moss memiliki bentuk renda bercabang-cabang seperti kipas kecil, dengan warna yang bervariasi tergantung lingkungan—mulai dari ungu tua, merah kehitaman, hijau zaitun, hingga putih kekuningan ketika dikeringkan. Tanaman ini tumbuh melekat pada batu-batu di zona pasang surut, dan dapat bertahan di lingkungan yang ekstrem, seperti paparan sinar matahari langsung, ombak, hingga suhu air yang berfluktuasi.

Keunikan utama Irish moss adalah kandungan karagenan—zat gelatin alami yang diekstraksi dari dinding selnya. Karagenan digunakan secara luas dalam industri makanan dan kosmetik sebagai pengental, penstabil, atau pengemulsi, dan bisa ditemukan dalam produk seperti es krim, susu nabati, puding, pasta gigi, losion, dan sabun. Selain itu, Irish moss juga populer dalam dunia pengobatan herbal dan nutrisi, karena diyakini mengandung berbagai mineral seperti yodium, zat besi, magnesium, kalsium, kalium, dan vitamin A, E, K, serta sejumlah antioksidan.

Secara tradisional, Irish moss telah digunakan di Irlandia dan Karibia untuk membuat minuman tonik dan sup kesehatan, terutama karena dipercaya meningkatkan daya tahan tubuh, memperbaiki pencernaan, dan membantu pemulihan tubuh. Dalam budaya Karibia, Irish moss bahkan dianggap sebagai minuman penambah stamina pria.

Irish moss dapat dipanen secara alami dari laut atau dibudidayakan di wilayah pesisir, tetapi pengelolaannya perlu dilakukan secara berkelanjutan. Pemotongan yang tidak hati-hati atau panen berlebihan bisa merusak populasi lokal dan ekosistem mikro yang bergantung padanya, termasuk hewan laut kecil yang hidup di sekitar alga ini.

Dengan manfaat nutrisi, ekonomi, dan ekologis yang besar, Irish moss menjadi salah satu tanaman laut yang sangat dihargai, baik di dunia kuliner, kesehatan alami, maupun industri modern. Namun, karena meningkatnya permintaan global, penting untuk menjaga praktik panen yang berkelanjutan agar alga berharga ini tetap lestari bagi generasi mendatang.
''',
    category: 'Flora Laut',
    ocean: 'Atlantik',
    subtype: 'Alga',
  ),

  CoralSpecies(
    name: "Halophila Ovalis",
    imagePath: "assets/images/HalophilaOvalis.jpeg",
    description: '''
Halophila ovalis adalah salah satu jenis lamun (seagrass) yang tumbuh di perairan dangkal tropis dan subtropis, termasuk di wilayah pesisir Indonesia, Asia Tenggara, Australia, hingga Afrika Timur. Tumbuhan laut ini termasuk dalam keluarga Hydrocharitaceae, dan merupakan salah satu lamun dengan persebaran paling luas di dunia. Karena ukurannya kecil dan bentuk daunnya yang oval, tanaman ini sering dikenal dengan nama umum "dugong grass", karena menjadi salah satu makanan favorit bagi dugong dan penyu laut.

Halophila ovalis memiliki struktur tumbuhan sejati, yaitu akar, batang (rimpang), dan daun. Akarnya tumbuh di bawah substrat pasir atau lumpur dan berfungsi untuk menambatkan tanaman serta menyerap nutrisi. Daunnya tumbuh berpasangan, berbentuk oval, berwarna hijau cerah, dan memiliki ukuran kecil dengan panjang sekitar 1–4 cm, menjadikannya salah satu spesies lamun terkecil. Rimpangnya menjalar dan membentuk koloni padat yang dapat menutupi dasar laut dangkal.

Lamun ini sangat penting secara ekologis karena membentuk padang lamun yang menjadi habitat, tempat berlindung, dan sumber makanan bagi berbagai spesies laut seperti ikan kecil, invertebrata, moluska, penyu, dan dugong. Selain itu, Halophila ovalis berperan besar dalam menstabilkan sedimen dasar laut, menyaring air laut, dan menyerap karbon, menjadikannya penting dalam mitigasi perubahan iklim dan menjaga kesehatan lingkungan pesisir.

Halophila ovalis mampu beradaptasi dengan cepat di berbagai jenis substrat dan salinitas air, serta dapat berkembang biak secara vegetatif melalui rimpang maupun secara generatif melalui bunga dan biji. Kemampuannya untuk tumbuh cepat dan menyebar luas membuatnya ideal untuk proyek rehabilitasi ekosistem lamun di wilayah pesisir yang rusak.

Namun, meskipun memiliki ketahanan yang baik, Halophila ovalis tetap rentan terhadap berbagai ancaman manusia, seperti reklamasi pantai, pencemaran, penggunaan alat tangkap yang merusak dasar laut, dan aktivitas perahu (jangkar). Hilangnya padang lamun akibat aktivitas ini dapat berdampak besar pada keanekaragaman hayati laut dan produktivitas perikanan lokal.

Dengan perannya yang sangat penting dalam ekosistem laut dangkal, Halophila ovalis menjadi salah satu spesies kunci dalam konservasi ekosistem pesisir. Upaya pelestarian dan rehabilitasi padang lamun akan sangat bermanfaat tidak hanya untuk menjaga keanekaragaman hayati, tetapi juga untuk mendukung ketahanan pesisir terhadap perubahan lingkungan yang terus berlangsung.
''',
    category: 'Flora Laut',
    ocean: 'Pasifik',
    subtype: 'Rumput Laut',
  ),

  CoralSpecies(
    name: "Gracilaria",
    imagePath: "assets/images/Gracilaria.jpeg",
    description: '''
Gracilaria adalah genus alga merah (Rhodophyta) yang tersebar luas di perairan tropis dan subtropis di seluruh dunia, termasuk di wilayah pesisir Indonesia. Alga ini tumbuh menempel di substrat keras seperti batu, karang mati, atau dasar berlumpur di perairan yang relatif tenang dan dangkal. Gracilaria memiliki bentuk bercabang menyerupai semak dengan warna merah muda hingga merah tua, meskipun warnanya bisa berubah menjadi kecokelatan atau kehijauan tergantung kondisi lingkungan.

Gracilaria memiliki nilai ekologis dan ekonomi yang tinggi. Secara ekologis, alga ini menyediakan habitat dan tempat berlindung bagi berbagai mikroorganisme dan hewan laut kecil seperti ikan muda, moluska, dan udang. Gracilaria juga membantu menstabilkan dasar perairan dan menyerap kelebihan nutrien dari lingkungan, sehingga berperan dalam menjaga kualitas air laut dan mencegah eutrofikasi (ledakan alga liar akibat pencemaran nutrien).

Dari sisi ekonomi, Gracilaria adalah salah satu sumber utama agar-agar—zat gelatin yang banyak digunakan dalam industri makanan, kosmetik, farmasi, dan mikrobiologi. Agar diperoleh melalui proses ekstraksi dari dinding sel Gracilaria, dan digunakan sebagai pengental, pengemulsi, atau media pertumbuhan bakteri dalam laboratorium. Selain itu, Gracilaria juga digunakan sebagai pakan ternak laut, pupuk organik, dan bahkan bahan baku bioenergi.

Gracilaria mudah dibudidayakan, dan di Indonesia sering ditanam di tambak air payau atau pesisir laut dangkal. Budidaya ini memiliki prospek yang baik karena tidak memerlukan pakan tambahan, tumbuh cepat, dan dapat dipanen dalam waktu relatif singkat. Budidaya Gracilaria biasanya dilakukan dengan metode tancap atau rakit apung, tergantung kondisi lokasi dan jenis airnya.

Namun, budidaya Gracilaria juga menghadapi tantangan seperti serangan hama dan penyakit, kualitas air yang menurun akibat pencemaran, serta perubahan suhu dan salinitas air karena dampak perubahan iklim. Oleh karena itu, pengelolaan yang baik dan berkelanjutan menjadi penting untuk menjaga produksi dan manfaat ekologis alga ini.

Sebagai sumber daya hayati laut yang bernilai tinggi, Gracilaria berperan penting dalam mendukung ekonomi pesisir, ketahanan pangan, serta konservasi ekosistem laut, terutama jika dikelola secara berkelanjutan dan ramah lingkungan.
''',
    category: 'Flora Laut',
    ocean: 'Pasifik',
    subtype: 'Alga',
  ),

  CoralSpecies(
    name: "Arctic Algae",
    imagePath: "assets/images/ArcticAlgae.jpg",
    description: '''
Arctic algae adalah kelompok alga yang hidup di lingkungan ekstrem di kawasan Kutub Utara, termasuk di permukaan, kolom air, maupun lapisan es laut (sea ice). Mereka terdiri dari berbagai jenis, terutama alga mikro seperti diatom dan flagellata, serta beberapa jenis alga makro (seperti *Melosira arctica*) yang mampu bertahan hidup dalam suhu yang sangat dingin, kadar cahaya rendah, dan salinitas tinggi. Meskipun ukurannya kecil dan sering tak terlihat, Arctic algae memainkan peran kunci dalam ekosistem laut kutub, sebagai produsen utama di dasar rantai makanan.

Salah satu ciri khas Arctic algae adalah kemampuannya berfotosintesis di bawah lapisan es yang tebal dan tembus cahaya sangat minim. Mereka sering tumbuh menempel di bawah permukaan es laut atau melayang di kolom air saat musim semi dan musim panas, ketika cahaya matahari mulai menembus permukaan es. Beberapa spesies seperti *Melosira arctica* bahkan membentuk untaian panjang mirip gel silinder yang menggantung dari dasar es, menjadi sumber makanan penting bagi zooplankton dan organisme mikroskopis lainnya.

Arctic algae sangat penting karena mereka menghasilkan oksigen dan bahan organik yang menopang kehidupan zooplankton seperti krill dan copepod, yang kemudian menjadi makanan bagi ikan, burung laut, anjing laut, dan paus. Jadi, meskipun kecil, Arctic algae adalah fondasi utama rantai makanan laut di Arktik. Selain itu, mereka juga membantu menyerap karbon dioksida (CO₂) dari atmosfer, sehingga turut berperan dalam siklus karbon global.

Namun, perubahan iklim berdampak besar terhadap Arctic algae. Pencairan es laut yang lebih cepat dan luas mengubah pola musim pertumbuhan mereka, mengganggu waktu ketersediaan makanan bagi konsumen seperti zooplankton dan ikan. Perubahan ini dapat mengganggu sinkronisasi ekosistem—misalnya, jika alga tumbuh lebih awal, tetapi zooplankton belum berkembang, maka makanan tidak tersedia saat dibutuhkan. Selain itu, hilangnya habitat es laut juga mengurangi area tempat alga es tumbuh.

Secara keseluruhan, Arctic algae adalah indikator sensitif terhadap perubahan lingkungan. Kesehatan dan produktivitas mereka mencerminkan kondisi iklim dan laut di Kutub Utara. Perlindungan terhadap ekosistem es laut dan pengurangan emisi global sangat penting untuk mempertahankan peran vital Arctic algae dalam mendukung jaringan kehidupan Arktik yang unik dan rapuh.
''',
    category: 'Flora Laut',
    ocean: 'Arktik',
    subtype: 'Alga',
  ),

  CoralSpecies(
    name: "Fucus Distichus",
    imagePath: "assets/images/FucusDistichus.jpg",
    description: '''
Fucus distichus adalah spesies alga cokelat (kelompok Phaeophyceae) yang umum ditemukan di zona intertidal (wilayah pasang surut) pantai berbatu di perairan dingin, terutama di sepanjang pesisir Samudra Atlantik dan Pasifik Utara, termasuk kawasan Arktik, Kanada, dan bagian utara Eropa. Alga ini termasuk dalam genus Fucus, yang merupakan salah satu jenis rumput laut paling dikenal di daerah beriklim dingin.

Ciri khas Fucus distichus adalah tubuhnya yang berbentuk seperti pita pipih bercabang dua, dengan cabang-cabang datar yang tersusun berpasangan (distichous)—itulah asal nama spesiesnya. Warnanya biasanya cokelat kehijauan hingga cokelat tua, dan memiliki gelembung udara kecil (pneumatocyst) yang membantu bagian tubuhnya tetap mengapung saat terendam air laut. Panjangnya bisa mencapai 20 hingga 40 cm, tergantung pada lokasi dan kondisi pertumbuhannya.

Fucus distichus melekat kuat pada substrat batu menggunakan struktur mirip akar yang disebut holdfast, dan hidup dengan cara berfotosintesis. Karena hidup di daerah pasang surut, alga ini harus tahan terhadap perubahan suhu, salinitas, kekeringan saat surut, dan paparan sinar UV—menjadikannya spesies yang sangat tangguh. Ia juga sering tumbuh berkelompok dan membentuk karpet padat di bebatuan, yang memberikan perlindungan dan habitat bagi berbagai hewan kecil seperti siput, kepiting kecil, dan amphipoda.

Dari sisi ekologi, Fucus distichus berperan penting dalam ekosistem pantai berbatu. Ia membantu mengurangi erosi, menjaga kelembapan batuan saat surut, serta menjadi makanan dan tempat berlindung bagi organisme laut lainnya. Karena hidupnya yang menetap dan mudah diamati, alga ini sering dijadikan indikator biologis dalam studi tentang perubahan iklim, pencemaran laut, dan dinamika ekosistem intertidal.

Meskipun tidak sepopuler rumput laut tropis dalam industri makanan, Fucus distichus mengandung senyawa bioaktif seperti fucoidan, mannitol, dan alginat yang memiliki potensi untuk digunakan dalam industri farmasi, kosmetik, dan pupuk organik. Ekstrak dari genus Fucus juga telah digunakan sebagai antioksidan dan antiradang alami.

Dengan kemampuannya bertahan di lingkungan ekstrem dan perannya yang besar dalam mendukung keanekaragaman hayati pesisir, Fucus distichus merupakan bagian penting dari ekosistem laut dingin yang sehat dan dinamis.
''',
    category: 'Flora Laut',
    ocean: 'Arktik',
    subtype: 'Alga',
  ),

  CoralSpecies(
    name: "Durvillaea Antarctica",
    imagePath: "assets/images/DurvillaeaAntarctica.jpg",
    description: '''
Durvillaea antarctica, yang sering dikenal sebagai "bull kelp" atau "southern bull kelp", adalah salah satu spesies alga cokelat terbesar dan terkuat di dunia, dan merupakan penghuni khas pesisir berbatu di wilayah selatan Samudra Pasifik, terutama di sekitar Chile, Argentina bagian selatan, Tasmania, dan Selandia Baru. Alga ini termasuk dalam keluarga Durvillaeaceae, dan terkenal karena struktur tubuhnya yang sangat kuat, lentur, dan tahan terhadap gelombang besar serta arus laut yang ekstrem.

Durvillaea antarctica memiliki thallus (tubuh) besar dan kuat dengan bentuk pita panjang berwarna cokelat keemasan hingga hijau zaitun. Panjangnya bisa mencapai lebih dari 10 meter, dan salah satu ciri uniknya adalah struktur yang berisi udara secara alami dalam jaringan tubuhnya, memungkinkan alga ini mengapung tanpa gelembung pelampung terpisah (berbeda dengan banyak alga cokelat lain seperti Macrocystis). Kemampuan mengapung ini memungkinkan bagian tubuhnya tetap berada di permukaan laut, menangkap cahaya matahari secara optimal untuk fotosintesis.

Durvillaea antarctica menempel pada batuan menggunakan holdfast yang sangat kuat, mirip akar, dan mampu bertahan di zona pasang surut tinggi yang terus-menerus dihantam gelombang. Karena kekuatannya ini, ia sering menjadi komponen utama “sabuk gelombang” yang melindungi garis pantai dari erosi. Saat terlepas dari substratnya, alga ini tetap dapat mengapung dan terbawa arus laut selama berminggu-minggu atau bahkan berbulan-bulan, sering kali menjadi “rakit alami” yang mengangkut mikroorganisme, invertebrata, dan bahkan telur ikan ke tempat baru, berperan dalam dispersi spesies lintas laut.

Dari segi ekologi, Durvillaea antarctica berfungsi sebagai habitat penting bagi berbagai makhluk laut seperti moluska, krustasea kecil, dan anemon laut. Padang alga ini juga menjadi tempat mencari makan bagi burung laut dan mamalia laut tertentu. Karena keberadaannya dominan di zona intertidal yang sulit dijangkau, alga ini merupakan indikator penting dalam studi resiliensi ekosistem laut terhadap perubahan iklim dan tekanan gelombang.

Selain peran ekologisnya, Durvillaea antarctica juga memiliki nilai ekonomi. Di wilayah seperti Chile dan Selandia Baru, alga ini dikumpulkan secara berkelanjutan untuk dijadikan bahan makanan, pupuk, dan sumber alginat, yaitu zat pengental alami yang digunakan dalam industri makanan, kosmetik, dan farmasi. Di beberapa komunitas pesisir, terutama di Chile, alga ini juga dimanfaatkan secara tradisional sebagai bahan baku kerajinan atau konsumsi lokal.

Sebagai salah satu makroalga paling tangguh dan produktif di dunia laut selatan, Durvillaea antarctica tidak hanya penting bagi stabilitas ekosistem pesisir berombak, tetapi juga mencerminkan adaptasi luar biasa organisme laut terhadap kondisi ekstrem, sekaligus membuka peluang bagi penelitian bioteknologi dan konservasi laut di wilayah sub-Antarktik.
''',
    category: 'Flora Laut',
    ocean: 'Antartika',
    subtype: 'Alga',
  ),

  CoralSpecies(
    name: "Himantothallus Grandifolius",
    imagePath: "assets/images/HimantothallusGrandifolius.jpg",
    description: '''
Himantothallus grandifolius adalah spesies alga cokelat besar yang hidup di perairan dingin dan ekstrem wilayah Antartika. Alga ini termasuk dalam kelas Phaeophyceae (alga cokelat) dan dikenal sebagai salah satu makroalga dominan di zona sublitoral (perairan dangkal di bawah garis pasang surut) pada ekosistem pesisir Antartika, terutama di sekitar Semenanjung Antartika dan Kepulauan Shetland Selatan. Kehadirannya menandai pentingnya kehidupan bentik (dasar laut) di wilayah kutub yang keras.

Himantothallus grandifolius memiliki tubuh (thallus) yang besar, lebar, dan seperti daun, yang bisa tumbuh hingga lebih dari 1 meter panjangnya. Warna tubuhnya bervariasi dari cokelat zaitun hingga cokelat tua, dan permukaannya fleksibel namun tebal, memungkinkan tanaman ini bertahan dari arus laut kuat, suhu rendah, dan minim cahaya. Struktur tubuhnya terdiri dari helaian lebar dan rimpang pendek yang berfungsi untuk menempel kuat pada bebatuan dasar laut, serta menjangkarkan tubuhnya dari ombak dan arus kutub yang kuat.

Alga ini berperan penting dalam ekosistem Antartika sebagai produsen primer, menghasilkan oksigen dan menyediakan makanan serta tempat berlindung bagi berbagai organisme laut, seperti invertebrata bentik, ikan kecil, dan mikroorganisme. Keberadaan Himantothallus juga menciptakan mikrohabitat penting bagi spesies laut yang tidak mampu bertahan di area terbuka yang dingin dan terbuka.

Kemampuan Himantothallus untuk berfotosintesis di perairan yang sangat dingin dan dengan pencahayaan terbatas membuatnya menjadi objek penelitian penting dalam biologi kutub dan fisiologi tumbuhan ekstrem. Selain itu, ia juga menunjukkan kemampuan adaptasi luar biasa terhadap kondisi ekstrem seperti es laut musiman, kadar cahaya rendah, dan nutrien tinggi, menjadikannya indikator biologis potensial dalam memantau perubahan lingkungan laut kutub akibat perubahan iklim.

Meskipun tidak dimanfaatkan secara komersial seperti beberapa alga lainnya, Himantothallus grandifolius memiliki nilai ekologis dan ilmiah yang tinggi. Ia mencerminkan betapa kehidupan laut bisa berkembang bahkan di lingkungan yang paling keras di Bumi, serta pentingnya menjaga keutuhan ekosistem laut Antartika yang unik dan sensitif terhadap perubahan global.
''',
    category: 'Flora Laut',
    ocean: 'Antartika',
    subtype: 'Alga',
  ),
];
