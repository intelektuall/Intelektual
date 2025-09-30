class MarineSpecies {
  final String name;
  final String imagePath;
  final String description;
  final String category; // Menambahkan kategori (Fauna Laut)
  final String ocean; // Menambahkan samudra
  final String
  subtype; // Menambahkan subtipe (seperti "Mamalia Laut", "Ikan", dll)

  int likeCount;
  int commentCount;

  MarineSpecies({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.category,
    required this.ocean,
    required this.subtype,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarineSpecies &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

// Dummy Data - Menambahkan kategori, subtipe, dan samudra pada setiap item
final List<MarineSpecies> marineSpeciesList = [
  MarineSpecies(
    name: "Giant Pacific Octopus",
    imagePath: "assets/images/GiantPacificOctopus4.jpg",
    description: '''
Giant Pacific Octopus (Enteroctopus dofleini) adalah spesies gurita terbesar di dunia yang hidup di perairan dingin Samudra Pasifik Utara, mulai dari Jepang hingga pantai barat Amerika Utara, termasuk Alaska dan California. Hewan ini dapat tumbuh hingga mencapai panjang 4 hingga 5 meter dengan berat lebih dari 50 kilogram, bahkan beberapa individu tercatat memiliki berat hampir 70–90 kilogram. Meskipun berukuran besar, umurnya relatif pendek, yaitu sekitar tiga hingga lima tahun.

Gurita ini hidup di dasar laut yang dalam, terutama di wilayah berbatu atau gua-gua laut, dan aktif berburu di malam hari. Makanannya mencakup berbagai hewan laut seperti kepiting, kerang, udang, ikan kecil, bahkan sesekali gurita lain. Dengan menggunakan paruhnya yang tajam dan racun, ia dapat menembus cangkang mangsanya.

Giant Pacific Octopus juga terkenal karena tingkat kecerdasannya yang tinggi. Ia mampu memecahkan teka-teki, membuka toples, mengenali manusia, serta menggunakan kamuflase secara efektif dengan mengubah warna dan tekstur kulitnya untuk menyatu dengan lingkungan. Dalam hal reproduksi, betina akan bertelur sebanyak 20.000 hingga 100.000 butir dan menjaga telur-telur tersebut tanpa makan hingga menetas selama sekitar enam bulan. Setelah itu, ia akan mati, seperti halnya jantan yang juga mati tak lama setelah kawin, sebuah siklus hidup yang disebut semelparitas.

Meskipun tidak tergolong spesies yang terancam punah, Giant Pacific Octopus tetap rentan terhadap dampak perubahan iklim, polusi laut, dan aktivitas penangkapan. Fakta menarik lainnya, gurita ini memiliki tiga jantung, darah berwarna biru karena kandungan hemosianin, dan mampu meregenerasi lengannya yang putus serta menyelinap melalui celah sekecil lubang koin berkat tubuhnya yang lunak tanpa tulang.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Moluska',
  ),

  MarineSpecies(
    name: "Manta Ray",
    imagePath: "assets/images/MantaRay2.jpg",
    description: '''
Manta ray atau ikan pari manta adalah salah satu spesies ikan pari terbesar di dunia yang termasuk dalam keluarga Mobulidae dan genus Mobula. Hewan laut ini dikenal dengan tubuhnya yang lebar seperti sayap dan gerakannya yang elegan saat "terbang" di dalam air. Manta ray dapat ditemukan di perairan tropis dan subtropis di seluruh dunia, terutama di sekitar terumbu karang, laut terbuka, dan kawasan pesisir. Ada dua spesies utama manta ray, yaitu reef manta ray (Mobula alfredi) yang lebih kecil dan hidup di perairan dekat pantai, serta giant oceanic manta ray (Mobula birostris) yang lebih besar dan menjelajahi laut lepas.

Ukuran manta ray bisa sangat mengesankan. Spesies terbesar dapat memiliki lebar tubuh hingga 7 meter dan berat lebih dari 1.300 kilogram. Meskipun ukurannya besar, manta ray tidak berbahaya bagi manusia karena mereka tidak memiliki duri beracun seperti ikan pari lainnya dan merupakan pemakan plankton. Mereka menyaring air laut untuk menangkap plankton, ikan kecil, dan larva menggunakan mulut besar mereka yang berada di bagian depan tubuh. Manta ray sering terlihat berenang dalam kelompok kecil, tapi kadang juga berenang sendirian atau berkumpul dalam jumlah besar saat musim kawin atau saat mencari makan.

Salah satu keunikan manta ray adalah kecerdasannya. Penelitian menunjukkan bahwa hewan ini memiliki otak paling besar di antara semua ikan bertulang rawan, termasuk hiu. Mereka juga menunjukkan tanda-tanda perilaku sosial yang kompleks dan bisa mengenali bayangan diri di cermin — kemampuan yang sangat langka di dunia hewan. Dalam hal reproduksi, manta ray berkembang biak secara ovovivipar, artinya telur menetas di dalam tubuh induk dan kemudian melahirkan anak yang sudah berkembang penuh.

Sayangnya, manta ray menghadapi berbagai ancaman, termasuk penangkapan berlebihan, terutama untuk diambil insangnya yang digunakan dalam pengobatan tradisional Asia, serta kerusakan habitat dan pencemaran laut. Karena itu, banyak negara dan organisasi konservasi kini melindungi spesies ini. Manta ray telah masuk dalam daftar spesies rentan menurut International Union for Conservation of Nature (IUCN). Keindahan, ukuran, serta sifat damainya membuat manta ray menjadi salah satu ikon kehidupan laut yang sangat dihormati, khususnya oleh para penyelam dan pecinta alam laut.
''',
    category: 'Fauna Laut',
    ocean: 'Atlantik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Green Sea Turtle",
    imagePath: "assets/images/GreenSeaTurtle.jpg",
    description: '''
Green sea turtle (Chelonia mydas) adalah salah satu spesies penyu laut terbesar dan paling dikenal di dunia. Meskipun disebut "green" atau hijau, nama ini sebenarnya berasal dari warna lemak tubuhnya yang kehijauan akibat pola makan herbivora, bukan dari warna tempurungnya. Tempurung (karapas) green sea turtle berwarna cokelat kehitaman atau zaitun, dengan bentuk yang datar dan oval. Spesies ini dapat ditemukan di seluruh perairan tropis dan subtropis di dunia, termasuk Samudra Atlantik, Pasifik, dan Hindia, serta di sekitar terumbu karang, padang lamun, dan pesisir berpasir.

Green sea turtle dapat tumbuh hingga panjang lebih dari 1 meter dan berat mencapai 150–200 kilogram. Mereka mengalami perubahan pola makan seiring bertambahnya usia. Saat masih muda, mereka bersifat omnivora, memakan ubur-ubur, krustasea, dan alga. Namun saat dewasa, mereka beralih menjadi herbivora dan lebih banyak mengonsumsi lamun dan alga laut. Perubahan ini juga memengaruhi sistem pencernaan dan warna lemak tubuh mereka, yang menjadi lebih hijau.

Salah satu aspek paling luar biasa dari green sea turtle adalah perilaku migrasinya. Penyu ini mampu menempuh jarak ribuan kilometer antara area makan dan tempat bertelur. Betina akan kembali ke pantai tempat mereka menetas untuk bertelur, dalam proses yang dikenal sebagai natal homing. Mereka dapat bertelur hingga 100 telur dalam satu sarang dan melakukannya beberapa kali dalam satu musim. Setelah menetas, tukik akan bergegas menuju laut, namun hanya sebagian kecil yang berhasil tumbuh dewasa karena ancaman predator dan kondisi lingkungan.

Green sea turtle saat ini tergolong sebagai spesies yang terancam punah, menurut International Union for Conservation of Nature (IUCN). Populasi mereka terus menurun akibat perburuan (baik daging maupun telur), kerusakan habitat, polusi laut, dan terjerat alat tangkap ikan. Selain itu, perubahan iklim juga berdampak pada kelangsungan hidup mereka, terutama karena suhu pasir memengaruhi jenis kelamin tukik yang menetas.

Dengan karakteristik tubuh yang unik, kemampuan migrasi luar biasa, dan peran penting dalam menjaga ekosistem laut seperti padang lamun, green sea turtle menjadi salah satu spesies laut yang sangat penting untuk dilindungi dan dilestarikan.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Reptil Laut',
  ),

  MarineSpecies(
    name: "Pacific Seahorse",
    imagePath: "assets/images/PacificSeahorse.jpeg",
    description: '''
Pacific seahorse (Hippocampus ingens) adalah spesies kuda laut terbesar yang ditemukan di wilayah Samudra Pasifik bagian timur. Spesies ini tersebar mulai dari California bagian selatan di Amerika Serikat hingga ke pesisir barat Amerika Selatan, termasuk Meksiko, Panama, Ekuador, dan Kepulauan Galápagos. Mereka hidup di habitat laut dangkal seperti hutan lamun, terumbu karang, hingga perairan berlumpur dan berbatu, biasanya pada kedalaman antara 1 hingga 60 meter.

Pacific seahorse memiliki tubuh khas kuda laut dengan leher melengkung dan moncong panjang. Ukurannya bisa mencapai 30 cm, menjadikannya salah satu spesies kuda laut terbesar di dunia. Warna tubuhnya bervariasi dari abu-abu, cokelat, hingga merah atau kuning keemasan, dan bisa berubah menyesuaikan lingkungan sebagai bentuk kamuflase untuk menghindari predator. Tubuhnya ditutupi oleh pelat-pelat keras dan memiliki ekor yang kuat dan melingkar, digunakan untuk mencengkeram tumbuhan laut atau struktur lain agar tidak terbawa arus.

Berbeda dari kebanyakan hewan laut, peran kehamilan pada kuda laut justru dipegang oleh jantan. Betina akan memasukkan telur ke dalam kantong khusus di perut jantan, yang kemudian dibuahi dan dierami hingga menetas. Dalam sekali masa kehamilan, pejantan Pacific seahorse bisa melahirkan puluhan hingga ratusan anak seukuran jarum kecil. Perilaku ini sangat unik dalam dunia hewan dan menjadikan kuda laut simbol keunikan biologis.

Sayangnya, Pacific seahorse saat ini menghadapi ancaman serius akibat perdagangan ilegal untuk obat tradisional, kerusakan habitat laut, serta penangkapan tak sengaja oleh alat tangkap ikan. Spesies ini telah diklasifikasikan sebagai rentan (Vulnerable) oleh International Union for Conservation of Nature (IUCN). Upaya konservasi seperti pengaturan perdagangan melalui CITES (Convention on International Trade in Endangered Species) dan perlindungan habitat pesisir menjadi penting untuk menjaga kelestarian Pacific seahorse yang tidak hanya unik dari sisi bentuk, tapi juga penting dalam keseimbangan ekosistem laut.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Orca",
    imagePath: "assets/images/Orca(KillerWhale).jpeg",
    description: '''
Orca (Orcinus orca), juga dikenal sebagai paus pembunuh (killer whale), adalah spesies mamalia laut terbesar dalam keluarga lumba-lumba (Delphinidae) dan merupakan salah satu predator puncak di lautan. Meskipun dijuluki "paus pembunuh", orca sebenarnya bukan paus sejati, melainkan lumba-lumba terbesar di dunia. Hewan ini terkenal dengan tubuhnya yang ramping dan kuat, berwarna hitam-putih yang mencolok, serta kecerdasannya yang luar biasa.

Orca tersebar di hampir semua lautan di dunia, dari perairan Arktik dan Antarktika yang dingin hingga laut tropis. Mereka sangat adaptif dan dapat hidup di berbagai kondisi lingkungan laut. Orca memiliki panjang tubuh antara 5 hingga 9 meter, dengan berat mencapai 6 ton, tergantung jenis kelamin dan populasinya. Betina umumnya lebih kecil daripada jantan, yang juga memiliki sirip punggung yang lebih tinggi dan tegak, bisa mencapai 1,8 meter.

Sebagai predator puncak, orca memiliki pola makan yang sangat beragam dan tergantung pada kelompoknya (disebut pod). Beberapa pod memangsa ikan seperti salmon, sementara pod lainnya berburu anjing laut, cumi-cumi, burung laut, bahkan paus besar seperti paus biru muda. Orca berburu secara berkelompok dan menggunakan strategi yang sangat terkoordinasi, mirip seperti serigala di darat. Mereka dikenal sangat cerdas, memiliki sistem komunikasi kompleks, memori sosial kuat, dan bahkan tradisi perburuan yang diturunkan antar generasi.

Dalam hal reproduksi, orca hidup dalam kelompok matrilineal yang dipimpin oleh betina tertua. Betina mulai berkembang biak pada usia sekitar 15 tahun dan dapat melahirkan setiap 3 hingga 10 tahun, dengan masa kehamilan sekitar 17 bulan. Orca bisa hidup sangat lama; betina dapat hidup lebih dari 80 tahun, sementara jantan rata-rata hidup 30 hingga 60 tahun.

Meskipun orca tidak memiliki predator alami, mereka tetap menghadapi ancaman dari aktivitas manusia, seperti polusi laut (terutama kontaminasi logam berat dan PCB), gangguan dari kapal dan sonar militer, serta kekurangan mangsa akibat perikanan berlebihan. Orca juga pernah menjadi target penangkapan untuk dipelihara di taman laut, meskipun praktik ini kini banyak dikritik karena berdampak buruk terhadap kesejahteraan mereka.

Dengan kombinasi kekuatan fisik, kecerdasan sosial tinggi, dan peran penting dalam ekosistem laut, orca merupakan salah satu makhluk paling mengagumkan dan dihormati di lautan.
''',
    category: 'Fauna Laut',
    ocean: 'Atlantik',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Clownfish",
    imagePath: "assets/images/Clownfish.jpg",
    description: '''
Clownfish (Amphiprioninae) adalah jenis ikan laut kecil yang terkenal karena warna tubuhnya yang cerah dan hubungan uniknya dengan anemon laut. Clownfish memiliki tubuh berwarna oranye cerah dengan tiga garis putih mencolok yang melintang secara vertikal di kepala, badan, dan ekor. Ikan ini hidup di perairan hangat Samudra Pasifik dan Samudra Hindia, termasuk di sekitar terumbu karang kawasan Asia Tenggara, Jepang, Australia, hingga Kepulauan Solomon.

Clownfish biasanya hidup berpasangan atau dalam kelompok kecil di dalam perlindungan anemon laut, yang memiliki tentakel beracun. Namun, clownfish memiliki lendir pelindung khusus di kulitnya yang membuatnya kebal terhadap racun tersebut. Hubungan antara clownfish dan anemon ini bersifat simbiosis mutualisme: clownfish mendapat perlindungan dari predator dan sisa makanan dari anemon, sementara anemon mendapat makanan dari sisa pakan clownfish serta perlindungan dari parasit.

Dalam hal ukuran, clownfish biasanya tumbuh hingga panjang sekitar 7 hingga 12 cm tergantung spesiesnya. Salah satu spesies paling terkenal adalah Amphiprion ocellaris, yang menjadi ikon dalam film animasi Finding Nemo. Clownfish adalah ikan yang sangat teritorial dan sering menjaga area sekitar anemonnya dengan agresif.

Salah satu hal paling unik dari clownfish adalah sistem reproduksi dan hierarki sosialnya. Clownfish semuanya lahir sebagai jantan. Dalam satu kelompok, hanya ada satu betina dominan, dan jika betina tersebut mati, jantan terbesar akan berubah kelamin menjadi betina untuk mengambil alih peran tersebut. Sistem ini disebut protandri, yaitu perubahan kelamin dari jantan ke betina.

Meskipun clownfish tidak tergolong hewan yang terancam punah, mereka tetap menghadapi ancaman dari kerusakan terumbu karang, perdagangan ikan hias, serta perubahan iklim yang mengakibatkan pemutihan anemon. Oleh karena itu, konservasi habitat alami mereka menjadi penting untuk menjaga keseimbangan ekosistem laut tempat mereka hidup.

Dengan warna cerah, perilaku sosial yang menarik, dan hubungan simbiotik yang unik, clownfish menjadi salah satu ikon kehidupan laut yang paling dikenal dan dikagumi di seluruh dunia.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Great White Shark",
    imagePath: "assets/images/GreatWhiteShark.jpg",
    description: '''
Great white shark (Carcharodon carcharias) adalah salah satu predator laut paling ikonik dan ditakuti di dunia. Hiu ini dikenal karena ukurannya yang besar, kekuatan rahangnya yang luar biasa, serta reputasinya sebagai pemburu yang sangat efisien. Great white shark tersebar luas di perairan beriklim sedang dan hangat di seluruh dunia, termasuk di Samudra Atlantik, Pasifik, dan Hindia. Mereka umumnya ditemukan di dekat garis pantai, tetapi juga dapat menjelajahi perairan laut lepas yang dalam.

Hiu ini dapat tumbuh hingga panjang lebih dari 6 meter dan berat mencapai 2.000 kilogram. Tubuhnya berbentuk torpedo dengan punggung berwarna abu-abu kebiruan atau keabu-abuan gelap dan bagian bawah berwarna putih—ciri khas yang membantu mereka menyamar saat mengintai mangsa dari bawah. Makanan utama great white shark meliputi anjing laut, singa laut, ikan besar, penyu laut, bahkan bangkai paus. Mereka juga memiliki indra penciuman yang sangat tajam, mampu mendeteksi setetes darah dalam jutaan liter air, serta dapat merasakan medan listrik yang dihasilkan oleh detak jantung mangsanya melalui organ khusus yang disebut ampullae of Lorenzini.

Salah satu aspek paling menarik dari great white shark adalah kemampuan mereka dalam berburu. Mereka sering menyerang dari bawah dengan kecepatan tinggi, mengandalkan elemen kejutan untuk melumpuhkan mangsa. Serangan ini sangat kuat sehingga mangsa besar bisa terpental keluar dari air dalam proses yang disebut breaching. Meskipun terkenal karena serangan terhadap manusia, kasus tersebut sangat jarang dan umumnya bukan karena niat memangsa, melainkan karena rasa ingin tahu atau kesalahan identifikasi.

Great white shark merupakan hewan soliter dan memiliki kemampuan migrasi yang sangat luas. Beberapa individu tercatat berpindah dari Afrika Selatan ke perairan Australia dan kembali, menempuh jarak ribuan kilometer. Dalam hal reproduksi, great white bersifat ovovivipar, artinya telur menetas di dalam tubuh induk dan anak-anak hiu lahir hidup. Anak-anak hiu yang baru lahir sudah mandiri dan berukuran cukup besar, sekitar 1,2–1,5 meter.

Saat ini, great white shark dikategorikan sebagai spesies rentan (Vulnerable) oleh International Union for Conservation of Nature (IUCN), akibat dari penangkapan berlebihan, perburuan sirip hiu, dan tangkapan sampingan (bycatch) oleh nelayan. Mereka juga lambat berkembang biak, yang membuat populasi sulit pulih dengan cepat. Sebagai predator puncak, kehadiran great white shark sangat penting untuk menjaga keseimbangan rantai makanan laut dan ekosistem secara keseluruhan.
''',
    category: 'Fauna Laut',
    ocean: 'Atlantik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Atlantic Puffin",
    imagePath: "assets/images/AtlanticPuffin.jpeg",
    description: '''
Atlantic puffin (Fratercula arctica) adalah burung laut kecil yang dikenal karena penampilannya yang unik dan menggemaskan. Burung ini sering dijuluki “badut laut” atau “parrot of the sea” karena memiliki paruh besar berwarna oranye terang, pipi putih, dan tubuh hitam-putih seperti tuksedo. Atlantic puffin merupakan salah satu dari tiga spesies puffin, dan satu-satunya yang ditemukan di wilayah Samudra Atlantik Utara.

Burung ini hidup di perairan dingin dan berbatu, terutama di sekitar pantai Kanada timur, Greenland, Islandia, Norwegia, dan Britania Raya. Selama musim kawin (musim semi dan musim panas), puffin datang ke darat dan membuat sarang di tebing curam atau liang di tanah, sering kali secara berkoloni besar. Di luar musim kawin, mereka menghabiskan hampir seluruh hidupnya di laut lepas, berenang dan menyelam untuk mencari makan.

Atlantic puffin adalah penyelam andal. Dengan bantuan sayapnya yang berfungsi seperti sirip, mereka bisa menyelam hingga kedalaman 60 meter untuk menangkap ikan kecil seperti herring dan capelin. Mereka dapat membawa beberapa ikan sekaligus dalam paruhnya berkat struktur khusus yang memungkinkan ikan tetap di tempat meskipun paruh terbuka.

Burung ini berukuran kecil, dengan panjang tubuh sekitar 25 cm, berat sekitar 500 gram, dan rentang sayap sekitar 50–60 cm. Puffin kawin seumur hidup dan biasanya hanya menghasilkan satu telur per musim. Anak puffin (disebut puffling) dirawat selama beberapa minggu di sarang sebelum akhirnya pergi ke laut sendirian.

Sayangnya, populasi Atlantic puffin menghadapi ancaman serius dari perubahan iklim, penangkapan ikan berlebihan (yang mengurangi stok makanan mereka), polusi laut, dan hilangnya habitat bersarang. Di beberapa wilayah seperti Islandia, jumlah puffin telah menurun drastis. Oleh karena itu, puffin saat ini diklasifikasikan sebagai rentan (Vulnerable) oleh IUCN.

Dengan wajah yang menggemaskan, perilaku sosial yang menarik, dan kemampuan berenang luar biasa, Atlantic puffin menjadi simbol kehidupan laut utara dan salah satu burung laut paling dicintai di dunia.
''',
    category: 'Fauna Laut',
    ocean: 'Atlantik',
    subtype: 'Burung Laut',
  ),

  MarineSpecies(
    name: "Leatherback Turtle",
    imagePath: "assets/images/LeatherbackTurtle.jpg",
    description: '''
Leatherback turtle (Dermochelys coriacea) adalah spesies penyu terbesar di dunia dan satu-satunya yang tidak memiliki tempurung keras. Sebagai anggota keluarga Dermochelyidae, penyu ini berbeda dari spesies penyu laut lainnya karena memiliki kulit punggung yang bertekstur seperti kulit yang dilapisi lapisan tipis tulang, bukan sisik keras. Permukaan punggungnya berwarna gelap dengan bintik-bintik putih atau abu-abu, dan bentuk tubuhnya lebih memanjang serta aerodinamis.

Leatherback dapat tumbuh hingga panjang lebih dari 2 meter dan berat lebih dari 600 kilogram, menjadikannya reptil laut terbesar yang masih hidup saat ini. Penyu ini tersebar luas di seluruh lautan tropis hingga subarktik di dunia dan terkenal karena kemampuan migrasinya yang ekstrem. Mereka mampu menempuh ribuan kilometer dalam satu perjalanan, dari daerah bertelur di pantai tropis hingga wilayah makan di perairan dingin.

Tidak seperti penyu lainnya, leatherback mampu bertahan di perairan yang sangat dingin karena memiliki mekanisme termoregulasi yang unik, termasuk ukuran tubuh besar, metabolisme tinggi, dan lapisan lemak tebal di bawah kulit. Makanan utamanya adalah ubur-ubur, dan karena itu mereka memainkan peran penting dalam menjaga keseimbangan populasi ubur-ubur di laut.

Siklus hidupnya mirip dengan penyu laut lainnya. Betina akan naik ke pantai berpasir untuk bertelur, menggali lubang dengan sirip belakangnya, dan meletakkan sekitar 80–100 telur dalam satu sarang. Setelah bertelur, ia kembali ke laut, dan tukik (anak penyu) akan menetas sekitar dua bulan kemudian, kemudian bergerak sendiri ke laut.

Sayangnya, leatherback turtle kini termasuk spesies yang sangat terancam punah, terutama karena hilangnya habitat bersarang, pencemaran laut (khususnya sampah plastik yang mereka kira ubur-ubur), terjerat alat tangkap ikan, serta perubahan iklim yang memengaruhi suhu pasir tempat telur dierami—faktor yang menentukan jenis kelamin tukik.

Sebagai hewan purba yang telah ada sejak zaman dinosaurus, leatherback turtle bukan hanya simbol penting dalam konservasi laut, tapi juga penjaga ekosistem yang vital. Upaya perlindungan global melalui kawasan konservasi laut, pengawasan perikanan, dan pengurangan sampah plastik sangat penting untuk menjaga kelangsungan hidup spesies luar biasa ini.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Reptil Laut',
  ),

  MarineSpecies(
    name: "Bluefin Tuna",
    imagePath: "assets/images/BluefinTuna.jpeg",
    description: '''
Bluefin tuna adalah salah satu spesies ikan laut terbesar, tercepat, dan paling kuat di dunia. Nama ilmiahnya adalah Thunnus thynnus untuk jenis Atlantic bluefin tuna, namun terdapat juga spesies lain seperti Pacific bluefin tuna (Thunnus orientalis) dan Southern bluefin tuna (Thunnus maccoyii). Ikan ini dikenal karena tubuhnya yang besar, bentuknya yang ramping dan aerodinamis, serta kemampuan berenangnya yang luar biasa cepat—mereka bisa melaju hingga kecepatan lebih dari 70 km/jam.

Bluefin tuna memiliki tubuh berwarna biru metalik di bagian punggung dan perak di bagian perut, yang membantu mereka berkamuflase di laut. Ukurannya sangat mengesankan; Atlantic bluefin tuna, misalnya, dapat tumbuh hingga 3 meter panjangnya dan berat lebih dari 600 kilogram. Mereka merupakan predator puncak yang memangsa ikan kecil seperti sarden, makarel, dan cumi-cumi.

Salah satu ciri paling unik dari bluefin tuna adalah kemampuannya dalam mengatur suhu tubuhnya, yang disebut regional endothermy. Ini memungkinkan mereka menjaga suhu tubuh tetap hangat di perairan dingin, memberi mereka keunggulan dalam berburu dan migrasi jarak jauh. Mereka dikenal melakukan migrasi ribuan kilometer melintasi lautan dari daerah makan ke daerah pemijahan (bertelur), seperti dari Samudra Atlantik ke Laut Mediterania atau Teluk Meksiko.

Sayangnya, bluefin tuna sangat terancam oleh penangkapan berlebihan (overfishing) karena permintaan tinggi di pasar global, terutama untuk sushi dan sashimi kelas premium. Seekor bluefin tuna bahkan pernah terjual seharga jutaan dolar di pelelangan ikan di Jepang. Akibat eksploitasi ini, populasi mereka—terutama Atlantic dan Southern bluefin—telah menurun drastis, dan saat ini dikategorikan sebagai terancam punah (endangered) oleh IUCN.

Sebagai spesies dengan pertumbuhan lambat dan kematangan seksual yang terlambat (sekitar usia 8 tahun), bluefin tuna sangat rentan terhadap penangkapan berlebihan. Oleh karena itu, berbagai organisasi internasional seperti ICCAT (International Commission for the Conservation of Atlantic Tunas) mengatur kuota tangkapan dan perlindungan habitatnya.

Bluefin tuna adalah simbol penting dari kekuatan laut, kecepatan, dan tantangan konservasi modern. Menjaga keberlangsungan hidupnya berarti melindungi keseimbangan ekosistem laut dan memastikan keberlanjutan sumber daya perikanan global.
''',
    category: 'Fauna Laut',
    ocean: 'Atlantik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Humpback Whale",
    imagePath: "assets/images/HumpbackWhale.jpg",
    description: '''
Humpback whale (Megaptera novaeangliae) adalah salah satu spesies paus balin yang paling dikenal dan dikagumi di dunia karena ukuran tubuhnya yang besar, perilaku akrobatiknya, dan nyanyian khas jantannya yang indah. Paus ini dapat ditemukan di hampir semua lautan di dunia, bermigrasi ribuan kilometer antara perairan dingin di kutub (tempat mereka mencari makan) dan perairan hangat di daerah tropis atau subtropis (tempat mereka berkembang biak dan melahirkan).

Humpback whale memiliki panjang tubuh sekitar 12 hingga 16 meter dan berat mencapai 25 hingga 40 ton. Mereka mudah dikenali dari punuk kecil di depan sirip punggungnya, sirip dada yang sangat panjang (bisa mencapai sepertiga panjang tubuh), serta ekornya yang besar dengan pola unik pada bagian bawah—yang digunakan peneliti untuk mengidentifikasi individu secara visual. Warna tubuhnya umumnya hitam keabu-abuan dengan bintik-bintik putih di bagian perut, sirip, atau ekor.

Paus ini merupakan pemakan zooplankton dan ikan kecil seperti ikan teri atau sarden, yang mereka tangkap menggunakan sistem filter dari balin di dalam mulutnya. Salah satu teknik berburu paling menarik dari humpback whale adalah "bubble net feeding", di mana mereka meniup gelembung berbentuk lingkaran untuk mengumpulkan ikan dalam satu tempat sebelum menyambar mereka dari bawah secara serempak.

Salah satu perilaku paling khas humpback whale adalah kemampuan melompat keluar dari air (breaching) dan memukul permukaan air dengan sirip atau ekornya, yang diduga berkaitan dengan komunikasi, permainan, atau membersihkan tubuh dari parasit. Paus jantan juga dikenal karena nyanyiannya yang kompleks dan merdu, yang bisa berlangsung selama 10–20 menit dan diulang-ulang. Nyanyian ini kemungkinan digunakan untuk menarik pasangan dan menunjukkan dominasi selama musim kawin.

Humpback whale berkembang biak dengan melahirkan satu anak setelah masa kehamilan sekitar 11 hingga 12 bulan. Anak paus yang baru lahir bisa berukuran sekitar 4–5 meter dan akan menyusu selama hampir satu tahun.

Dulunya, humpback whale diburu secara besar-besaran untuk diambil minyak dan dagingnya, sehingga populasinya sempat menurun drastis. Namun sejak diberlakukannya larangan perburuan paus secara global, populasinya mulai pulih, meskipun masih menghadapi ancaman seperti tabrakan dengan kapal, pencemaran suara laut, dan jaring ikan.

Sebagai makhluk besar yang lembut dan memiliki perilaku sosial yang kompleks, humpback whale tidak hanya penting bagi keseimbangan ekosistem laut, tetapi juga menjadi simbol upaya konservasi mamalia laut di seluruh dunia. Mereka kini menjadi daya tarik wisata ekowisata (whale watching) yang mendukung kesadaran dan pelestarian lingkungan laut.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Portuguese Man o'War",
    imagePath: "assets/images/PortugueseMano' War.jpg",
    description: '''
Portuguese Man o’ War (Physalia physalis) adalah makhluk laut unik yang sering disangka ubur-ubur, padahal sebenarnya bukan. Ia merupakan koloni dari empat jenis polip (organisme kecil) yang saling bergantung dan berfungsi sebagai satu individu, sehingga tergolong dalam kelompok siphonophora. Makhluk ini terkenal karena penampilannya yang mencolok dan sengatan yang sangat menyakitkan, bahkan bisa berbahaya bagi manusia.

Ciri khas utama Portuguese Man o’ War adalah “layar” mengapungnya, yaitu kantung gas berwarna biru keunguan di permukaan air yang disebut pneumatophore. Kantung ini memungkinkan hewan tersebut terdorong oleh angin di permukaan laut, seperti perahu layar mini—itulah asal nama “Man o’ War”, yang diambil dari kapal perang Portugis kuno. Di bawah permukaannya, menjuntai tentakel panjang yang bisa mencapai 10 hingga 30 meter, meskipun rata-rata sekitar 10 meter. Tentakel ini dilengkapi dengan nematosista, yaitu sel penyengat yang digunakan untuk melumpuhkan mangsa dan mempertahankan diri.

Makhluk ini hidup di perairan hangat seluruh dunia, terutama di Samudra Atlantik, Pasifik, dan Hindia. Ia tidak bisa berenang dan hanya mengandalkan angin serta arus laut untuk bergerak. Makanannya terdiri dari ikan kecil dan plankton, yang disengat lalu ditarik ke polip pencernaan.

Sengatan Portuguese Man o’ War bisa menyebabkan rasa sakit yang luar biasa pada manusia, bahkan ketika sudah terdampar di pantai atau tentakelnya terlepas dari tubuh. Reaksi pada manusia bisa berupa luka bakar pada kulit, sesak napas, kram otot, dan dalam kasus yang sangat jarang, reaksi alergi parah (anafilaksis).

Meskipun menakutkan, Portuguese Man o’ War memiliki peran penting dalam rantai makanan laut. Ia juga menjadi makanan bagi beberapa predator khusus seperti penyu laut (khususnya penyu belimbing) dan ikan tertentu yang kebal terhadap sengatannya.

Sebagai makhluk laut yang sangat menarik secara biologis, Portuguese Man o’ War menunjukkan betapa beragam dan kompleksnya kehidupan laut. Meskipun indah dipandang dari jauh, hewan ini perlu dihindari di laut atau saat ditemukan terdampar, karena sengatannya tetap aktif bahkan setelah mati.
''',
    category: 'Fauna Laut',
    ocean: 'Atlantik',
    subtype: 'Cnidaria',
  ),

  MarineSpecies(
    name: "Dugong",
    imagePath: "assets/images/Dugong.jpeg",
    description: '''
Dugong (Dugong dugon) adalah mamalia laut herbivora yang termasuk dalam ordo Sirenia, dan satu-satunya anggota keluarga Dugongidae yang masih hidup. Dugong sering disebut sebagai “sapi laut” karena makanannya yang berupa tumbuhan laut (seperti lamun), tubuh besar, dan gerakannya yang lamban. Hewan ini memiliki hubungan kekerabatan dekat dengan manatee, meskipun habitat dan beberapa ciri fisiknya berbeda.

Dugong dapat ditemukan di perairan dangkal tropis dan subtropis, terutama di kawasan Samudra Hindia dan Pasifik Barat, termasuk Indonesia, Australia, Filipina, dan kawasan Asia Tenggara lainnya. Mereka biasanya hidup di sekitar padang lamun di teluk, laguna, dan pesisir yang tenang. Tubuh dugong berbentuk silindris dan memanjang, berwarna abu-abu hingga cokelat keabu-abuan, dengan ekor berbentuk seperti sirip ekor lumba-lumba (horizontal) dan tidak memiliki sirip punggung. Panjang tubuhnya bisa mencapai 3 meter dan berat hingga 400 kilogram.

Sebagai herbivora laut, dugong mengonsumsi berbagai jenis lamun (seagrass) dengan cara mencabut tanaman dari dasar laut menggunakan bibir atasnya yang kuat. Mereka menghabiskan sebagian besar waktunya makan dan bisa mengonsumsi hingga 40 kilogram lamun per hari. Pola makan ini sangat penting bagi kesehatan ekosistem laut karena membantu menjaga keseimbangan pertumbuhan lamun.

Dugong bernapas dengan paru-paru dan harus naik ke permukaan secara berkala untuk menghirup udara. Meskipun lamban, mereka bisa menyelam hingga kedalaman 10 meter dan bertahan di bawah air selama 6–10 menit sebelum muncul kembali ke permukaan. Dugong memiliki sistem reproduksi yang lambat; betina hanya melahirkan satu anak setelah masa kehamilan sekitar 13–15 bulan, dan anak tersebut akan disusui selama lebih dari satu tahun. Karena pertumbuhan populasi yang lambat, dugong sangat rentan terhadap gangguan lingkungan.

Saat ini, dugong tergolong sebagai spesies rentan (Vulnerable) menurut IUCN. Populasinya terus menurun akibat kerusakan habitat lamun, tabrakan dengan kapal, tertangkap jaring nelayan, dan perburuan ilegal. Perubahan iklim dan pembangunan pesisir juga menjadi ancaman serius bagi kelangsungan hidupnya.

Sebagai bagian dari warisan laut tropis, dugong memiliki peran penting dalam menjaga keseimbangan ekosistem pesisir. Oleh karena itu, upaya konservasi melalui perlindungan habitat alami, pengawasan aktivitas manusia di pesisir, serta edukasi masyarakat menjadi sangat penting untuk memastikan keberlangsungan hidup hewan yang lembut dan karismatik ini.
''',
    category: 'Fauna Laut',
    ocean: 'Hindia',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Indian Mackerel",
    imagePath: "assets/images/RastrellKanagRob.jpg",
    description: '''
Indian mackerel (Rastrelliger kanagurta) adalah spesies ikan laut yang sangat umum dijumpai di perairan tropis dan subtropis kawasan Indo-Pasifik. Ikan ini termasuk dalam keluarga Scombridae, yang juga mencakup tuna dan tenggiri. Indian mackerel memiliki nilai ekonomi yang tinggi karena merupakan salah satu ikan konsumsi utama di banyak negara Asia, termasuk Indonesia, India, Thailand, dan Filipina.

Ciri khas dari Indian mackerel adalah tubuhnya yang ramping dan memanjang, dengan warna perak mengilap di bagian bawah dan biru kehijauan di bagian atas, serta adanya garis-garis atau bintik gelap di sisi tubuhnya. Ukuran tubuhnya sedang, umumnya panjang sekitar 20–30 cm, meskipun bisa tumbuh hingga 35 cm. Sirip ekornya bercabang seperti huruf V dan tubuhnya tertutup sisik halus.

Indian mackerel hidup berkelompok (bergerombol) di perairan dangkal dekat pantai, terutama di daerah estuari, teluk, dan perairan dengan dasar berlumpur atau berpasir. Mereka adalah ikan pelagis, artinya hidup di kolom air (bukan dasar laut) dan sering bermigrasi mengikuti arus serta musim. Ikan ini sangat aktif dan dikenal sebagai perenang cepat.

Dari segi makanan, Indian mackerel bersifat planktivora, terutama memakan fitoplankton dan zooplankton, tetapi kadang juga mengonsumsi telur ikan dan larva kecil. Mereka memainkan peran penting dalam rantai makanan laut sebagai konsumen primer dan juga sebagai mangsa bagi predator yang lebih besar seperti tuna, hiu, dan burung laut.

Indian mackerel berkembang biak dengan cara bertelur di laut terbuka, dan satu induk bisa menghasilkan ribuan telur yang akan menetas dalam waktu singkat. Siklus hidupnya cepat, dan ikan ini tumbuh serta matang dengan cepat, yang menjadikannya penting dalam perikanan tangkap.

Meskipun populasinya masih melimpah di banyak wilayah, Indian mackerel dapat terancam oleh penangkapan berlebih (overfishing), perubahan kualitas air laut, serta kerusakan ekosistem pesisir. Pengelolaan perikanan yang berkelanjutan sangat penting agar stok ikan ini tetap stabil dan bisa dimanfaatkan secara terus-menerus oleh masyarakat pesisir.

Dengan nilai ekonomis yang tinggi, peran ekologis yang penting, serta penyebaran yang luas, Indian mackerel menjadi salah satu spesies kunci dalam ekosistem laut dan ketahanan pangan pesisir Asia.
''',
    category: 'Fauna Laut',
    ocean: 'Hindia',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Whale Shark",
    imagePath: "assets/images/WhaleShark.jpeg",
    description: '''
Whale shark (Rhincodon typus) adalah spesies ikan terbesar di dunia dan merupakan anggota dari kelompok hiu (bukan paus), meskipun namanya mengandung kata "whale" karena ukurannya yang raksasa dan gaya makannya yang menyerupai paus penyaring. Meskipun ukurannya sangat besar, whale shark dikenal sebagai hewan yang jinak dan tidak berbahaya bagi manusia.

Whale shark dapat tumbuh hingga panjang lebih dari 12 meter, bahkan beberapa individu tercatat mencapai lebih dari 18 meter, dengan berat mencapai 15–20 ton. Tubuhnya berwarna abu-abu kebiruan dengan pola bintik-bintik putih dan garis-garis terang yang unik pada setiap individu, seperti sidik jari. Mulutnya sangat besar, bisa mencapai lebih dari 1 meter lebarnya, dan terletak di bagian depan kepala (tidak di bawah seperti hiu pada umumnya).

Makanan utama whale shark adalah plankton, telur ikan, dan organisme kecil lainnya seperti udang kecil dan ikan kecil. Meskipun memiliki lebih dari 3.000 gigi kecil, mereka tidak digunakan untuk mengunyah. Whale shark merupakan filter feeder (pemakan saringan), menyaring makanan dari air dengan cara membuka mulut lebar saat berenang, lalu menyaring partikel makanan melalui celah insangnya. Mereka bisa menyaring ratusan liter air per jam untuk mendapatkan makanan.

Whale shark ditemukan di perairan tropis dan hangat di seluruh dunia, termasuk di sekitar Indonesia, Filipina, Australia, dan Meksiko. Mereka sering terlihat di permukaan laut saat sedang makan dan cenderung bermigrasi dalam jarak jauh untuk mencari lokasi makan dan berkembang biak. Meskipun masih banyak yang belum diketahui tentang perilaku dan reproduksinya, whale shark diketahui melahirkan anak yang sudah berkembang penuh (ovovivipar), dan betina bisa mengandung ratusan embrio dalam tubuhnya.

Saat ini, whale shark tergolong sebagai spesies yang terancam punah (Endangered) menurut IUCN, karena berbagai ancaman seperti penangkapan berlebihan, tabrakan dengan kapal, perdagangan ilegal bagian tubuh, dan kerusakan habitat laut. Mereka juga sering menjadi target wisata laut, seperti atraksi berenang bersama whale shark, yang jika tidak diatur dengan bijak bisa menyebabkan stres dan gangguan perilaku.

Dengan ukuran megah, sifat damai, dan perannya sebagai indikator kesehatan laut, whale shark menjadi salah satu ikon konservasi laut tropis yang paling penting dan menakjubkan di dunia.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Hawksbill Turtle",
    imagePath: "assets/images/HawksbillTurtle.jpeg",
    description: '''
Hawksbill turtle (Eretmochelys imbricata) adalah salah satu spesies penyu laut yang paling mudah dikenali dan juga paling terancam punah. Penyu ini dikenal karena tempurungnya yang indah dengan pola sisik bertumpuk berwarna cokelat keemasan dan hitam, yang membuatnya menjadi sasaran utama perdagangan ilegal untuk dijadikan bahan kerajinan seperti sisir, kacamata, dan perhiasan—yang disebut sebagai "tortoiseshell".

Hawksbill memiliki tubuh ramping dan moncong tajam yang melengkung menyerupai paruh burung elang, yang menjadi asal usul namanya. Ukurannya relatif kecil dibandingkan spesies penyu lainnya, dengan panjang tubuh dewasa sekitar 60–90 cm dan berat antara 45–70 kg. Mereka tersebar luas di perairan tropis dan subtropis, terutama di kawasan Samudra Atlantik, Pasifik, dan Hindia, termasuk perairan Indonesia, Karibia, dan kawasan terumbu karang dunia.

Habitat utama hawksbill adalah terumbu karang, tempat mereka mencari makan dan bertelur. Tidak seperti penyu laut lainnya, hawksbill memiliki pola makan yang sangat spesifik, yaitu memakan spons laut, ubur-ubur, dan anemon. Dengan moncongnya yang runcing, mereka bisa menjangkau celah-celah sempit di antara terumbu untuk menemukan makanan. Dengan mengendalikan populasi spons, hawksbill membantu menjaga keseimbangan ekosistem terumbu karang.

Seperti penyu laut lainnya, hawksbill adalah reptil yang bernapas dengan paru-paru dan perlu naik ke permukaan air secara berkala. Mereka berkembang biak dengan bertelur di pantai berpasir yang sepi pada malam hari. Betina biasanya bertelur setiap 2–4 tahun sekali dan bisa mengeluarkan sekitar 100–200 butir telur dalam satu sarang. Tukik yang menetas akan langsung menuju laut, tetapi hanya sebagian kecil yang bertahan hidup hingga dewasa karena tingginya tingkat predasi dan gangguan lingkungan.

Saat ini, hawksbill turtle dikategorikan sebagai "Critically Endangered" (Kritis Terancam Punah) oleh IUCN. Ancaman terbesar bagi mereka meliputi perdagangan ilegal tempurung, kerusakan habitat pantai dan terumbu karang, perburuan telur, tertangkap alat tangkap ikan, dan perubahan iklim yang memengaruhi suhu pasir dan habitat peneluran.

Sebagai simbol keindahan laut tropis dan penanda kesehatan terumbu karang, hawksbill turtle sangat penting dalam upaya konservasi global. Perlindungan melalui penegakan hukum, kawasan konservasi laut, pengelolaan wisata yang berkelanjutan, serta edukasi masyarakat menjadi kunci utama dalam menjaga kelangsungan hidup spesies yang luar biasa ini.
''',
    category: 'Fauna Laut',
    ocean: 'Atlantik',
    subtype: 'Reptil Laut',
  ),

  MarineSpecies(
    name: "Indian Ocean Bottlenose Dolphin",
    imagePath: "assets/images/IndianOceanBottlenoseDolphin.jpg",
    description: '''
Indian Ocean bottlenose dolphin (Tursiops aduncus) adalah salah satu spesies lumba-lumba yang paling dikenal dan cerdas di dunia. Mereka termasuk dalam keluarga Delphinidae dan merupakan kerabat dekat dari common bottlenose dolphin (Tursiops truncatus), tetapi berbeda dalam ukuran tubuh, habitat, dan beberapa ciri fisik. Seperti namanya, lumba-lumba ini terutama ditemukan di perairan pesisir dan dangkal Samudra Hindia, termasuk sepanjang pantai Afrika Timur, Asia Selatan, dan wilayah perairan Indonesia, Australia bagian utara, hingga ke Laut Merah.

Indian Ocean bottlenose dolphin memiliki tubuh ramping dan panjang dengan warna abu-abu kebiruan di bagian atas dan lebih terang di bagian bawah. Salah satu ciri khasnya adalah adanya bintik-bintik gelap di perut dan sisi tubuh, terutama pada individu dewasa—berbeda dari spesies bottlenose lainnya. Ukurannya relatif sedang, dengan panjang tubuh sekitar 2,5 hingga 2,8 meter dan berat antara 150 hingga 230 kilogram.

Spesies ini hidup secara berkelompok (pod) yang bisa terdiri dari beberapa ekor hingga puluhan individu, tergantung kondisi lingkungan dan musim. Mereka sangat sosial dan sering terlihat berenang, melompat, atau bermain di dekat perahu, menjadikannya salah satu hewan laut yang paling sering diamati oleh manusia. Lumba-lumba ini juga dikenal karena kecerdasan tinggi, mampu menggunakan gelombang sonar (echolocation) untuk bernavigasi dan mencari mangsa seperti ikan, cumi-cumi, dan krustasea kecil.

Indian Ocean bottlenose dolphin berkembang biak dengan cara melahirkan, dan betina biasanya hanya melahirkan satu anak setiap 3–6 tahun setelah masa kehamilan sekitar 12 bulan. Anak lumba-lumba akan disusui selama lebih dari satu tahun dan belajar banyak perilaku sosial dari induknya dan anggota pod lainnya.

Meskipun belum dikategorikan sebagai sangat terancam punah, lumba-lumba ini tetap menghadapi sejumlah ancaman serius, termasuk polusi laut, tertangkap alat tangkap ikan secara tidak sengaja (bycatch), perburuan, serta gangguan akibat aktivitas wisata dan lalu lintas kapal. Perubahan habitat pesisir juga berdampak pada populasi mereka, mengingat mereka sangat bergantung pada perairan dangkal untuk mencari makan dan berkembang biak.

Sebagai simbol kecerdasan dan kehidupan sosial laut yang kompleks, Indian Ocean bottlenose dolphin memegang peran penting dalam ekosistem laut dan budaya maritim masyarakat pesisir. Konservasi habitat alami, pengelolaan wisata bahari yang berkelanjutan, dan pengurangan polusi laut menjadi kunci penting untuk menjaga kelangsungan hidup spesies ini di masa depan.
''',
    category: 'Fauna Laut',
    ocean: 'Hindia',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Reef Manta Ray",
    imagePath: "assets/images/ReefMantaRay.jpeg",
    description: '''
Reef manta ray (Mobula alfredi) adalah salah satu spesies pari terbesar di dunia dan merupakan makhluk laut yang luar biasa anggun dan cerdas. Spesies ini ditemukan di perairan tropis dan subtropis, terutama di sekitar terumbu karang Samudra Hindia dan Pasifik, termasuk wilayah Indonesia, Maladewa, Australia, dan Hawaii. Meskipun sering dianggap sebagai ikan yang menakutkan karena ukurannya, reef manta ray sama sekali tidak berbahaya, karena tidak memiliki sengat dan hanya memakan plankton.

Ciri paling mencolok dari reef manta ray adalah bentuk tubuhnya yang pipih dan melebar, seperti sayap, dengan lebar bisa mencapai 5 meter, meskipun rata-rata sekitar 3–4 meter. Tubuh bagian atas berwarna hitam keabu-abuan dengan pola unik seperti sidik jari, sedangkan bagian bawahnya lebih terang. Di bagian depan kepalanya terdapat dua cephalopod lobes (tonjolan berbentuk tanduk) yang membantu mengarahkan plankton ke dalam mulut saat mereka berenang.

Reef manta ray adalah filter feeder, mereka menyaring plankton dan organisme mikroskopis dari air saat berenang dengan mulut terbuka. Mereka sering terlihat “terbang” di air dengan gerakan sayap yang besar dan anggun, serta kadang melompat keluar dari air dalam perilaku yang belum sepenuhnya dipahami—mungkin untuk komunikasi, menghilangkan parasit, atau bagian dari perilaku sosial.

Hewan ini sangat sosial dan sering berkumpul di "cleaning stations", yaitu tempat di terumbu karang di mana ikan kecil seperti cleaner wrasse membersihkan tubuh mereka dari parasit. Reef manta ray juga memiliki otak terbesar dibandingkan semua ikan dan menunjukkan perilaku cerdas seperti pengenalan diri di cermin, navigasi kompleks, dan ingatan jangka panjang.

Reproduksi reef manta ray tergolong lambat. Betina hanya melahirkan satu anak setiap 2–5 tahun, setelah kehamilan sekitar 12–13 bulan. Anak manta lahir dalam keadaan hidup dan langsung bisa berenang sendiri. Karena laju reproduksinya yang rendah, spesies ini sangat rentan terhadap gangguan lingkungan.

Saat ini, reef manta ray dikategorikan sebagai "Vulnerable" (Rentan) oleh IUCN. Ancaman utama mereka adalah penangkapan berlebihan, terutama untuk insang mereka yang dijual sebagai obat tradisional, serta kerusakan habitat, polusi laut, dan gangguan dari wisata bahari yang tidak terkendali.

Sebagai hewan yang mempesona dan penting bagi ekosistem laut, reef manta ray juga memiliki nilai besar dalam ekowisata berkelanjutan, seperti kegiatan menyelam dan snorkeling bersama pari. Konservasi mereka menjadi simbol perlindungan laut tropis yang sehat dan berkelanjutan.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Narwhal",
    imagePath: "assets/images/Narwhal.jpg",
    description: '''
Narwhal (Monodon monoceros) adalah spesies paus bergigi yang hidup di perairan Arktik dan terkenal karena memiliki “tanduk” panjang menyerupai tombak yang tumbuh dari kepalanya. Tanduk ini sebenarnya adalah gigi taring kiri yang tumbuh memanjang dan menembus bibir atas, berbentuk spiral, dan bisa mencapai panjang 2 hingga 3 meter. Karena keunikannya ini, narwhal sering disebut sebagai "unicorn laut" dan telah menginspirasi banyak legenda dan mitos sejak zaman dahulu.

Narwhal adalah bagian dari keluarga paus bergigi (toothed whale) dan berkerabat dekat dengan beluga. Mereka hidup di sekitar perairan dingin Greenland, Kanada bagian utara, dan Rusia, terutama di Laut Arktik. Narwhal jantan biasanya memiliki “tanduk”, meskipun sekitar 15% betina juga bisa memilikinya. Fungsi pasti dari tanduk tersebut belum sepenuhnya diketahui, tetapi para ilmuwan menduga itu digunakan untuk menunjukkan dominasi, menarik pasangan, atau sebagai alat sensorik karena mengandung jutaan ujung saraf yang sensitif.

Tubuh narwhal berwarna abu-abu dengan bercak-bercak gelap, dan biasanya semakin terang seiring bertambahnya usia. Panjang tubuhnya (tidak termasuk tanduk) bisa mencapai 4–5 meter, dengan berat sekitar 800 hingga 1.600 kilogram. Tidak seperti kebanyakan paus lainnya, narwhal tidak bermigrasi jauh, melainkan mengikuti pola musiman di sekitar Arktik, berpindah dari laut terbuka pada musim panas ke bawah es laut yang lebih padat di musim dingin.

Narwhal hidup dalam kelompok kecil (pod) yang terdiri dari beberapa ekor hingga puluhan individu. Mereka menggunakan sonar (echolocation) untuk berkomunikasi dan bernavigasi di air gelap atau penuh es. Makanan utama narwhal meliputi ikan, cumi-cumi, dan udang laut dalam, yang mereka tangkap saat menyelam hingga kedalaman lebih dari 1.500 meter—salah satu penyelaman terdalam yang diketahui dari semua mamalia laut.

Narwhal berkembang biak perlahan. Betina melahirkan satu anak setiap 3–4 tahun setelah masa kehamilan sekitar 15 bulan. Anak narwhal akan disusui selama lebih dari satu tahun sebelum mandiri.

Meskipun narwhal belum masuk dalam kategori sangat terancam punah, mereka tetap menghadapi ancaman akibat perubahan iklim Arktik, hilangnya es laut, gangguan dari aktivitas manusia (seperti eksplorasi minyak), dan perburuan tradisional di beberapa komunitas Inuit. Karena spesies ini sangat tergantung pada ekosistem es laut yang stabil, mereka dianggap sebagai indikator penting dari kesehatan lingkungan Arktik.

Dengan penampilan unik dan habitat yang ekstrem, narwhal menjadi simbol keajaiban alam kutub dan pentingnya perlindungan ekosistem laut yang rapuh.
''',
    category: 'Fauna Laut',
    ocean: 'Arktik',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Beluga Whale",
    imagePath: "assets/images/BelugaWhale.jpg",
    description: '''
Beluga whale (Delphinapterus leucas) adalah salah satu spesies paus bergigi yang paling mudah dikenali karena warna putih cerahnya dan ekspresi wajahnya yang tampak "tersenyum". Beluga berasal dari perairan Arktik dan sub-Arktik, dan sering dijuluki sebagai “kanari laut” karena kemampuannya mengeluarkan berbagai suara nyaring seperti siulan, klik, dan derik.

Beluga berukuran sedang dibandingkan spesies paus lainnya, dengan panjang tubuh sekitar 4–5 meter dan berat mencapai 1.200–1.600 kilogram. Tidak seperti kebanyakan paus lainnya, beluga memiliki leher yang fleksibel karena tulang lehernya tidak menyatu, memungkinkan mereka menoleh ke samping dan atas—kemampuan unik di antara cetacea. Selain itu, beluga tidak memiliki sirip punggung, melainkan memiliki tonjolan di punggung yang membantu mereka berenang di bawah es.

Beluga adalah hewan sosial yang hidup dalam kelompok kecil yang disebut pods, yang bisa terdiri dari beberapa ekor hingga ratusan individu. Mereka berkomunikasi satu sama lain melalui suara sonar (echolocation) dan vokalisasi kompleks. Karena vokalnya yang kaya, beluga dijuluki sebagai paus penyanyi dan menjadi objek studi penting dalam bioakustik laut.

Habitat beluga meliputi perairan dingin dan beres di sekitar Kanada utara, Alaska, Rusia, Greenland, dan Norwegia. Mereka bermigrasi mengikuti musim—pada musim panas sering memasuki sungai dan muara, sementara di musim dingin mereka berada di bawah lapisan es laut, bernapas melalui celah-celah es.

Beluga merupakan pemangsa oportunis yang memakan berbagai jenis mangsa seperti ikan, udang, cumi-cumi, dan kepiting, tergantung lokasi dan musim. Mereka menggunakan sonar untuk mencari mangsa di perairan keruh atau gelap.

Beluga berkembang biak dengan lambat; betina melahirkan satu anak setiap 3–4 tahun, setelah masa kehamilan sekitar 14–15 bulan. Anak beluga lahir berwarna abu-abu tua dan akan berubah menjadi putih seiring bertambahnya usia.

Meskipun beluga tidak tergolong spesies yang sangat terancam secara global, beberapa populasi lokal seperti yang berada di Teluk Cook, Alaska dikategorikan sangat terancam punah (Critically Endangered) oleh IUCN. Ancaman utama mereka mencakup pencemaran laut, perubahan iklim (terutama pencairan es laut), lalu lintas kapal, aktivitas industri di wilayah utara, serta perburuan tradisional di beberapa komunitas Arktik.

Dengan penampilannya yang unik, suara khas, dan sifat sosialnya yang luar biasa, beluga whale menjadi simbol penting ekosistem Arktik dan upaya konservasi laut di daerah kutub. Mereka juga berperan besar dalam budaya masyarakat Inuit dan menjadi daya tarik utama dalam studi ilmiah tentang komunikasi mamalia laut.
''',
    category: 'Fauna Laut',
    ocean: 'Arktik',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Ringed Seal",
    imagePath: "assets/images/RingedSeal.jpeg",
    description: '''
Ringed seal (Pusa hispida) adalah spesies anjing laut yang paling kecil dan paling tersebar luas di kawasan Arktik. Mereka dinamai "ringed" karena memiliki pola bercak-bercak gelap dengan cincin putih di seluruh tubuhnya, terutama di punggung dan sisi tubuh. Ciri ini membedakan mereka dari spesies anjing laut lainnya dan membantu mereka berkamuflase di antara es dan salju.

Ringed seal memiliki tubuh gemuk dan kompak yang cocok untuk bertahan hidup di lingkungan kutub yang ekstrem. Panjang tubuhnya sekitar 1 hingga 1,6 meter, dan beratnya berkisar 50–110 kilogram. Warna tubuh bagian atas biasanya abu-abu gelap atau kecokelatan, sedangkan bagian bawah lebih terang. Lemak tubuh yang tebal (blubber) membantu mereka mempertahankan panas tubuh di air es yang sangat dingin.

Spesies ini sangat bergantung pada es laut sebagai habitat utama untuk beristirahat, melahirkan, dan menyusui anak-anaknya. Ringed seal terkenal karena kemampuannya menggali dan memelihara lubang pernapasan di es laut menggunakan cakar depan mereka yang kuat dan melengkung. Mereka juga membangun "sarang" dari salju dan es di atas lubang es untuk melahirkan dan melindungi anaknya dari predator dan dingin ekstrem.

Ringed seal adalah pemakan ikan kecil, udang-udangan, dan zooplankton, yang mereka tangkap saat menyelam di bawah es. Mereka dapat menyelam hingga kedalaman lebih dari 100 meter dan bertahan di bawah air selama 15–20 menit.

Dalam ekosistem Arktik, ringed seal adalah mangsa utama beruang kutub (polar bear), serta diburu oleh paus orca dan rubah Arktik. Karena itu, mereka memegang peranan penting dalam rantai makanan laut Arktik.

Ringed seal berkembang biak sekali setahun, dan betina biasanya hanya melahirkan satu anak (pup) setelah masa kehamilan sekitar 9 bulan. Anak ringed seal lahir dengan bulu putih tebal yang kemudian akan berganti seiring pertumbuhan.

Meskipun populasi global ringed seal masih relatif stabil, mereka kini menghadapi ancaman serius dari perubahan iklim, khususnya pencairan es laut yang lebih awal dan lebih cepat, yang mengganggu habitat dan musim reproduksi mereka. Polusi laut dan gangguan dari aktivitas industri di kawasan Arktik juga menjadi ancaman tambahan.

Sebagai spesies yang sangat tergantung pada es laut, ringed seal menjadi indikator penting kesehatan ekosistem Arktik. Melindungi mereka berarti juga menjaga keseimbangan dan kelangsungan hidup berbagai spesies lain di lingkar kutub utara.
''',
    category: 'Fauna Laut',
    ocean: 'Arktik',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Walrus",
    imagePath: "assets/images/Walrus.jpg",
    description: '''
Walrus (Odobenus rosmarus) adalah mamalia laut besar yang hidup di wilayah kutub utara, khususnya di sekitar Samudra Arktik. Hewan ini sangat mudah dikenali karena tubuhnya yang besar, kulit tebal berkerut, dan dua taring panjang yang mencuat dari rahang atasnya. Baik jantan maupun betina memiliki taring, meskipun taring jantan biasanya lebih panjang dan digunakan untuk menunjukkan dominasi, mempertahankan diri, menaiki bongkahan es, serta dalam pertarungan antar jantan saat musim kawin.

Walrus memiliki tubuh yang dilapisi lapisan lemak (blubber) yang sangat tebal untuk melindungi mereka dari suhu dingin ekstrem, dan kulit mereka biasanya berwarna abu-abu atau cokelat kemerahan. Hewan ini memiliki kumis tebal yang sangat sensitif dan digunakan untuk meraba dasar laut dalam pencarian mangsa seperti kerang, siput laut, dan invertebrata lainnya yang hidup di dasar perairan dangkal.

Walrus hidup secara sosial dalam kelompok besar yang dapat terdiri dari ratusan hingga ribuan individu dan dikenal sangat vokal, terutama selama musim kawin. Mereka berkembang biak secara lambat, dengan betina hanya melahirkan satu anak setiap dua hingga tiga tahun setelah masa kehamilan sekitar 15 hingga 16 bulan. Anak walrus disusui selama lebih dari satu tahun dan sangat bergantung pada induknya.

Terdapat dua subspesies utama, yaitu walrus Atlantik yang hidup di sekitar Greenland dan timur laut Kanada, serta walrus Pasifik yang ditemukan di Laut Bering dan Laut Chukchi.

Saat ini, walrus menghadapi berbagai ancaman, terutama akibat perubahan iklim yang menyebabkan pencairan es laut, mengurangi habitat beristirahat dan memaksa mereka untuk berkumpul di daratan, yang dapat menimbulkan kepadatan berlebih dan stres. Selain itu, aktivitas industri, pencemaran laut, dan gangguan dari lalu lintas kapal juga turut memperparah situasi.

Sebagai simbol kekuatan dan ketangguhan lingkungan Arktik, perlindungan terhadap walrus sangat penting dalam menjaga keseimbangan ekosistem kutub utara yang semakin rapuh.
''',
    category: 'Fauna Laut',
    ocean: 'Arktik',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Polar Cod",
    imagePath: "assets/images/PolarCod.jpeg",
    description: '''
Polar cod (Boreogadus saida) adalah ikan kecil yang sangat penting dalam ekosistem laut Arktik. Meskipun tubuhnya mungil—dengan panjang rata-rata sekitar 20–30 cm—ikan ini memiliki peran vital sebagai spesies kunci dalam rantai makanan Arktik, menjadi sumber makanan utama bagi berbagai predator seperti burung laut, anjing laut, paus beluga, dan ikan besar lainnya.

Polar cod tersebar luas di perairan kutub utara, termasuk di sekitar Greenland, Kanada utara, Rusia, dan Laut Barents. Mereka mampu bertahan hidup di suhu yang sangat dingin berkat kandungan protein antibeku alami dalam darahnya, yang mencegah pembentukan kristal es dalam jaringan tubuh.

Ciri khas polar cod adalah tubuhnya yang ramping dan berwarna keperakan dengan sedikit warna cokelat atau abu-abu di bagian punggung. Mereka hidup di bawah es laut maupun di perairan terbuka, tergantung usia dan musim. Ikan dewasa cenderung hidup di perairan yang lebih dalam, sementara larva dan remaja sering berada di bawah lapisan es, mencari perlindungan dan makanan berupa plankton kecil. Reproduksi biasanya terjadi di musim dingin, dan betina dapat menghasilkan ribuan telur yang menetas dalam kondisi suhu ekstrem.

Polar cod memiliki kemampuan beradaptasi yang luar biasa terhadap lingkungan yang beku dan minim cahaya. Namun, mereka sangat rentan terhadap perubahan iklim, terutama karena pencairan es laut dan perubahan suhu perairan yang dapat mengganggu habitat dan pola reproduksinya. Karena posisinya yang sentral dalam rantai makanan Arktik, penurunan populasi polar cod dapat berdampak besar bagi kelangsungan hidup banyak spesies lain.

Dengan perannya yang tidak tergantikan dalam ekosistem Arktik, polar cod menjadi indikator penting dari kesehatan lingkungan laut kutub. Melindungi ikan kecil ini berarti juga menjaga stabilitas dan kelangsungan hidup hewan-hewan besar yang bergantung padanya dalam ekosistem ekstrem yang rapuh dan sedang berubah dengan cepat akibat pemanasan global.
''',
    category: 'Fauna Laut',
    ocean: 'Arktik',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Arctic Jellyfish",
    imagePath: "assets/images/ArcticJellyfish2.jpg",
    description: '''
Arctic jellyfish adalah sebutan umum untuk beberapa spesies ubur-ubur yang hidup di perairan dingin dan beku wilayah Arktik. Salah satu spesies paling dikenal adalah Cyanea capillata arctica, atau Lion's mane jellyfish subspesies Arktik, yang merupakan salah satu ubur-ubur terbesar di dunia. Ubur-ubur Arktik memiliki tubuh transparan berbentuk payung dengan tentakel panjang yang dapat menyala samar di kegelapan laut, menciptakan kesan menakjubkan namun juga misterius di kedalaman samudra es.

Ubur-ubur ini mampu bertahan hidup dalam suhu yang sangat rendah karena struktur tubuhnya sebagian besar terdiri dari air dan jaringan gelatin yang fleksibel. Mereka bergerak lambat melalui kontraksi tubuh seperti denyutan, namun lebih sering terbawa oleh arus laut. Sebagai predator penyaring, arctic jellyfish memakan plankton, larva ikan, dan organisme kecil lainnya dengan menggunakan tentakelnya yang panjang dan lengket, yang mengandung sel penyengat atau nematosista untuk melumpuhkan mangsa.

Meskipun terlihat rapuh dan sederhana, ubur-ubur Arktik memainkan peran penting dalam rantai makanan laut kutub. Mereka menjadi sumber makanan bagi berbagai spesies ikan, burung laut, dan bahkan penyu jika berada di wilayah yang lebih selatan. Selain itu, ubur-ubur juga berperan dalam mendaur ulang energi dan nutrisi dalam ekosistem laut dalam yang minim cahaya dan sangat dingin.

Arctic jellyfish menjadi indikator biologis perubahan lingkungan laut. Peningkatan suhu air dan pencairan es akibat perubahan iklim dapat memengaruhi distribusi, jumlah, dan waktu reproduksi ubur-ubur ini. Beberapa studi menunjukkan bahwa perubahan iklim dapat menyebabkan ledakan populasi ubur-ubur di beberapa daerah, yang berpotensi mengganggu keseimbangan ekosistem.

Dengan keanggunan geraknya dan kemampuannya hidup di laut yang membeku, Arctic jellyfish mencerminkan keajaiban serta kerapuhan ekosistem Arktik, yang kini menghadapi tekanan besar dari pemanasan global dan gangguan manusia.
''',
    category: 'Fauna Laut',
    ocean: 'Arktik',
    subtype: 'Cnidaria',
  ),

  MarineSpecies(
    name: "Emperor Penguin",
    imagePath: "assets/images/EmperorPenguin.jpeg",
    description: '''
Emperor penguin (Aptenodytes forsteri) adalah spesies penguin terbesar dan satu-satunya yang berkembang biak secara eksklusif di daratan es Antartika. Hidup di salah satu lingkungan paling ekstrem di bumi, emperor penguin telah berkembang dengan adaptasi luar biasa untuk bertahan hidup di suhu yang bisa mencapai –60°C dan angin kencang yang melebihi 150 km/jam. Ukuran tubuhnya yang besar—bisa mencapai 120 cm dan berat antara 20–40 kilogram—membantu mengurangi kehilangan panas, dan bulunya yang tebal serta lapisan lemak bawah kulit yang tebal memberi perlindungan tambahan terhadap dingin.

Penampilan emperor penguin sangat khas, dengan bulu punggung berwarna hitam, perut putih bersih, dan corak kuning-oranye di sisi leher dan kepala. Mereka adalah perenang dan penyelam yang andal, mampu menyelam hingga kedalaman lebih dari 500 meter dan bertahan di bawah air selama 20 menit untuk mencari ikan, krill, dan cumi-cumi—makanan utama mereka di lautan es.

Yang membuat emperor penguin istimewa adalah pola reproduksinya. Mereka berkembang biak saat musim dingin Antartika, suatu periode ketika hampir semua hewan lain meninggalkan benua tersebut. Setelah betina bertelur satu butir, ia akan pergi ke laut untuk mencari makan, sementara jantan mengerami telur di atas kakinya selama sekitar dua bulan, melindunginya dengan lipatan kulit hangat yang disebut brood pouch. Selama masa ini, jantan tidak makan sama sekali dan bertahan hidup dari cadangan lemak tubuhnya. Setelah menetas, induk betina kembali dan memberi makan anaknya dengan makanan yang telah dicerna. Pengasuhan anak dilakukan secara bergantian antara induk jantan dan betina.

Emperor penguin hidup dalam koloni besar yang bisa mencapai ribuan individu, dan mereka sering berkumpul rapat membentuk "huddles" atau formasi padat untuk berbagi kehangatan di tengah suhu membeku. Perilaku sosial ini sangat penting untuk bertahan hidup selama musim kawin.

Meski populasinya masih tergolong besar, emperor penguin kini menghadapi ancaman serius akibat perubahan iklim. Pencairan es laut yang terjadi lebih cepat setiap tahun mengurangi habitat penting mereka untuk berkembang biak dan mengganggu ketersediaan makanan. Oleh karena itu, banyak ilmuwan memperingatkan bahwa jika tren pemanasan global terus berlanjut, populasi emperor penguin bisa menurun drastis di abad ini.

Dengan keunikannya dalam bertahan hidup di lingkungan paling keras di bumi, emperor penguin bukan hanya simbol dari kehidupan liar Antartika, tetapi juga indikator penting kesehatan lingkungan kutub yang sedang terancam.
''',
    category: 'Fauna Laut',
    ocean: 'Antartika',
    subtype: 'Burung Laut',
  ),

  MarineSpecies(
    name: "Weddell Seal",
    imagePath: "assets/images/WeddellSeal.jpeg",
    description: '''
Weddell seal (Leptonychotes weddellii) adalah salah satu spesies anjing laut yang hidup di wilayah Antartika dan dikenal sebagai penyelam laut dalam yang tangguh serta penghuni paling selatan di antara semua mamalia laut. Hewan ini hidup di sekitar lapisan es padat yang menutupi lautan beku, terutama di kawasan pesisir dan teluk-teluk es, di mana mereka menggali lubang pernapasan di es untuk bertahan hidup di bawah permukaan yang tertutup sepenuhnya.

Tubuh Weddell seal besar dan kekar, dengan panjang mencapai sekitar 2,5 hingga 3 meter dan berat hingga 600 kilogram. Warna tubuhnya abu-abu keperakan dengan pola bercak tidak beraturan, yang membantu mereka berkamuflase di bawah air. Wajahnya bulat dengan mata besar yang membantunya melihat dalam cahaya rendah di bawah es. Salah satu keunggulan utama spesies ini adalah kemampuannya menyelam dalam dan lama; mereka bisa menyelam hingga 600 meter dan bertahan di bawah air selama lebih dari 1 jam, menjadikannya salah satu penyelam terhebat di antara mamalia laut.

Weddell seal memakan berbagai jenis ikan, krill, dan cumi-cumi yang mereka tangkap di bawah es menggunakan sonar alami dan penglihatan tajam. Mereka sering menggali dan memelihara lubang di es menggunakan gigi depan mereka yang kuat agar tetap memiliki akses ke permukaan. Sayangnya, gigi yang aus karena menggerus es bisa membatasi kemampuan mereka membuka lubang, yang dapat memengaruhi kelangsungan hidup seiring bertambahnya usia.

Hewan ini berkembang biak di musim semi Antartika. Betina melahirkan satu anak di atas lapisan es setelah masa kehamilan sekitar 11 bulan, dan anak akan disusui selama beberapa minggu sebelum belajar berenang dan menyelam sendiri. Selama masa ini, induk sangat protektif dan menyuplai energi tinggi melalui susunya agar anak cepat tumbuh.

Weddell seal hidup dalam kelompok kecil atau koloni, tetapi tidak sepadat spesies anjing laut lainnya. Mereka relatif tidak terlalu aktif secara sosial di luar musim kawin, dan menghabiskan banyak waktu menyelam atau beristirahat di es. Meskipun mereka tidak memiliki banyak predator, anjing laut muda rentan terhadap serangan paus orca dan leopard seal.

Saat ini, populasi Weddell seal relatif stabil dan tidak termasuk dalam kategori terancam punah, namun mereka tetap bergantung pada lapisan es laut yang sehat, sehingga sangat rentan terhadap dampak jangka panjang dari perubahan iklim. Dengan kemampuannya yang luar biasa untuk bertahan hidup di lingkungan paling ekstrem di Bumi, Weddell seal menjadi simbol dari ketahanan kehidupan di wilayah kutub yang rapuh.
''',
    category: 'Fauna Laut',
    ocean: 'Antartika',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Antarctic Toothfish",
    imagePath: "assets/images/AntarcticToothfish.jpg",
    description: '''
Antarctic toothfish (Dissostichus mawsoni) adalah ikan besar yang hidup di perairan dingin dan dalam di sekitar Samudra Selatan, khususnya di kawasan pesisir benua Antartika. Ikan ini merupakan predator puncak di ekosistem laut dalam Antartika dan memiliki peran penting dalam menjaga keseimbangan rantai makanan. Karena penampilannya yang besar dan memiliki gigi tajam, ia dijuluki “toothfish,” meskipun secara ilmiah termasuk dalam keluarga Nototheniidae atau cod es (icefish), yang khas hidup di perairan kutub.

Antarctic toothfish dapat tumbuh hingga dua meter panjangnya dan mencapai berat lebih dari 100 kilogram, menjadikannya salah satu spesies ikan terbesar di wilayah Antartika. Tubuhnya kokoh, berwarna abu-abu hingga kecokelatan, dengan sirip punggung memanjang dan rahang yang kuat untuk menangkap mangsa. Salah satu keunikan ikan ini adalah kemampuan hidup di suhu ekstrem yang sangat rendah, berkat kandungan protein antibeku alami dalam darahnya, yang mencegah pembentukan kristal es dalam jaringan tubuh.

Ikan ini hidup di perairan dalam, pada kedalaman 500 hingga lebih dari 2.000 meter, dan bergerak perlahan dalam perairan gelap dan dingin. Makanan utamanya meliputi ikan kecil, cumi-cumi, dan udang-udangan, dan karena berada di puncak rantai makanan, hanya beberapa predator alami seperti paus orca dan anjing laut yang dapat memangsa toothfish dewasa.

Dalam beberapa tahun terakhir, Antarctic toothfish menjadi target perikanan komersial bernilai tinggi, terutama untuk pasar internasional, di mana ia dikenal sebagai “Chilean sea bass” dalam perdagangan. Karena pertumbuhannya lambat dan reproduksinya yang terbatas—induk betina hanya bertelur setelah mencapai usia dewasa yang cukup tua—penangkapan yang berlebihan dapat mengganggu populasi dengan cepat. Saat ini, perikanan toothfish diatur secara ketat oleh CCAMLR (Commission for the Conservation of Antarctic Marine Living Resources) dengan sistem kuota dan pelacakan yang ketat untuk memastikan keberlanjutan.

Antarctic toothfish juga menjadi subjek penting dalam kajian ilmiah tentang adaptasi fisiologis terhadap suhu ekstrem, serta tentang dampak perubahan iklim dan eksploitasi perikanan terhadap ekosistem laut dalam. Karena posisinya yang penting di lingkungan laut Antartika, keberadaan toothfish mencerminkan kesehatan dan stabilitas ekosistem kutub yang unik dan rentan. Upaya konservasi dan pengelolaan yang hati-hati sangat penting untuk memastikan spesies ini tidak terganggu oleh tekanan manusia dan perubahan lingkungan global.
''',
    category: 'Fauna Laut',
    ocean: 'Antartika',
    subtype: 'Ikan',
  ),

  MarineSpecies(
    name: "Leopard Seal",
    imagePath: "assets/images/LeopardSeal.jpeg",
    description: '''
Leopard seal (Hydrurga leptonyx) adalah salah satu predator puncak paling tangguh di ekosistem Antartika. Anjing laut ini mendapat namanya dari pola bintik-bintik gelap di tubuhnya yang menyerupai kulit macan tutul, serta perilakunya yang agresif dan kemampuan berburu yang luar biasa. Tubuhnya ramping, panjang, dan sangat kuat, dengan panjang mencapai 3 hingga 4 meter dan berat bisa melebihi 500 kilogram, menjadikannya salah satu spesies anjing laut terbesar di wilayah kutub selatan.

Leopard seal memiliki kepala besar dengan rahang lebar dan gigi tajam yang mirip reptil, memungkinkan mereka memangsa berbagai jenis hewan. Tidak seperti sebagian besar anjing laut lain yang memakan ikan kecil atau krustasea, leopard seal adalah karnivora sejati yang memangsa penguin, anak anjing laut, ikan, dan krill. Mereka sangat terkenal karena kemampuannya menangkap dan membunuh penguin dengan teknik berburu yang cepat dan mematikan, seperti menyergap mangsa dari bawah es atau dari air terbuka dekat pantai.

Meskipun dikenal ganas terhadap mangsa, leopard seal adalah penyelam yang tenang dan lincah. Mereka dapat menyelam hingga kedalaman lebih dari 300 meter dan bertahan di bawah air selama 15 hingga 30 menit, menggunakan suara dan penglihatan tajam mereka untuk menavigasi dan berburu di bawah es. Mereka sering ditemukan sendirian, tidak seperti spesies anjing laut lain yang hidup berkelompok. Leopard seal adalah spesies soliter, dan interaksi sosial mereka biasanya terbatas pada musim kawin.

Siklus reproduksi mereka dimulai saat musim panas Antartika. Setelah masa kehamilan sekitar 11 bulan, betina akan melahirkan satu anak di atas bongkahan es, dan merawatnya selama beberapa minggu pertama sebelum anaknya mampu berenang dan berburu sendiri.

Leopard seal memainkan peran penting dalam menjaga keseimbangan ekosistem Antartika. Sebagai predator tingkat atas, mereka membantu mengatur populasi penguin dan anjing laut lainnya. Meskipun tidak termasuk spesies yang terancam, mereka sangat sensitif terhadap perubahan iklim, terutama karena bergantung pada es laut sebagai habitat utama untuk beristirahat, melahirkan, dan berburu. Pencairan es yang cepat akibat pemanasan global berpotensi mengganggu pola hidup mereka di masa depan.

Dikenal karena perpaduan kekuatan, kecepatan, dan kecerdasannya, leopard seal adalah salah satu ikon kehidupan liar kutub selatan. Mereka menjadi simbol penting dari dunia liar Antartika yang ekstrem, indah, namun juga sangat rentan terhadap dampak ulah manusia.
''',
    category: 'Fauna Laut',
    ocean: 'Antartika',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Blue Whale",
    imagePath: "assets/images/BlueWhale.jpeg",
    description: '''
Blue whale (Balaenoptera musculus) adalah hewan terbesar yang pernah hidup di Bumi, bahkan melampaui dinosaurus dalam hal ukuran. Panjang tubuhnya bisa mencapai 30 meter, dan beratnya dapat melebihi 180 ton—setara dengan 33 gajah dewasa. Meskipun ukurannya luar biasa besar, blue whale adalah pemakan plankton, terutama krill, sejenis udang kecil yang mereka saring dari air laut menggunakan balin (lembaran seperti sikat) di mulutnya. Dalam satu hari, seekor blue whale bisa mengonsumsi lebih dari 3,5 ton krill, terutama selama musim makan di perairan kutub.

Tubuh blue whale berwarna abu-abu kebiruan dengan bintik-bintik terang yang khas, dan ketika dilihat di bawah air, warna tubuhnya tampak biru kehijauan—itulah asal usul namanya. Bentuk tubuhnya panjang, ramping, dan aerodinamis, dengan kepala yang besar dan datar serta sirip punggung kecil di dekat ekor. Mereka memiliki ekor (fluke) besar dan kuat yang digunakan untuk mendorong tubuhnya saat berenang. Meskipun terlihat lamban, blue whale dapat berenang dengan kecepatan hingga 50 km/jam dalam situasi tertentu.

Blue whale merupakan mamalia laut, artinya mereka bernapas menggunakan paru-paru dan harus naik ke permukaan untuk mengambil udara. Saat mengembuskan napas, mereka mengeluarkan semburan air dan udara yang bisa mencapai ketinggian 9 meter, salah satu ciri paling mencolok yang bisa dilihat dari jauh.

Spesies ini bermigrasi jauh setiap tahun, berpindah dari perairan kutub yang kaya makanan ke perairan tropis atau subtropis untuk berkembang biak dan melahirkan. Masa kehamilan berlangsung sekitar 11 hingga 12 bulan, dan betina melahirkan satu anak setiap dua hingga tiga tahun. Anak blue whale yang baru lahir pun sudah sangat besar, dengan panjang sekitar 7 meter dan berat lebih dari 2 ton, dan akan menyusui hingga satu tahun dengan susu kaya lemak dari induknya.

Meskipun saat ini blue whale dilindungi, mereka pernah berada di ambang kepunahan akibat perburuan paus besar-besaran pada abad ke-20. Populasi mereka menurun drastis hingga hanya tersisa sebagian kecil dari jumlah aslinya. Kini, meskipun jumlahnya perlahan meningkat, mereka masih tergolong terancam punah oleh IUCN. Ancaman utama mereka saat ini adalah tabrakan dengan kapal besar, polusi suara bawah laut, dan perubahan iklim yang memengaruhi distribusi krill sebagai makanan utama mereka.

Blue whale adalah simbol kebesaran dan kerentanan kehidupan laut. Sebagai makhluk terbesar di planet ini, keberadaannya mengingatkan kita akan kekayaan dan keajaiban alam laut, serta pentingnya perlindungan terhadap ekosistem samudra yang menjadi rumah bagi makhluk-makhluk luar biasa seperti mereka.
''',
    category: 'Fauna Laut',
    ocean: 'Pasifik',
    subtype: 'Mamalia Laut',
  ),

  MarineSpecies(
    name: "Krill Antarktika",
    imagePath: "assets/images/KrillAntarktika.jpg",
    description: '''
Krill Antartika (Euphausia superba) adalah sejenis udang kecil yang hidup di perairan dingin dan bersih di sekitar benua Antartika. Meskipun tubuhnya mungil—biasanya hanya sepanjang 2 hingga 6 sentimeter—krill merupakan fondasi utama dari rantai makanan di ekosistem laut Antartika. Dalam jumlahnya yang sangat besar, krill menjadi sumber makanan utama bagi banyak hewan laut besar seperti paus biru, anjing laut, penguin, burung laut, dan ikan-ikan besar. Bahkan, populasi krill Antartika diperkirakan mencapai ratusan juta ton, menjadikannya salah satu biomassa hewan terbesar di Bumi.

Tubuh krill transparan dengan warna kemerahan, dan mereka memiliki mata besar serta kaki renang yang memungkinkan mereka bergerak secara berkelompok dalam formasi besar yang disebut "swarm". Krill aktif berenang di kolom air dan dapat menyelam hingga kedalaman lebih dari 200 meter, terutama saat menghindari predator. Pada malam hari, mereka sering naik ke permukaan laut untuk makan, terutama pada musim panas saat lapisan es mencair dan fitoplankton—sumber makanan utama mereka—berlimpah.

Siklus hidup krill sangat dipengaruhi oleh musim. Pada musim dingin, mereka dapat bertahan hidup dengan memakan lapisan es laut yang mengandung alga mikroskopis. Krill muda sangat bergantung pada es laut sebagai tempat berlindung dan sumber makanan awal. Inilah sebabnya mengapa pencairan es laut akibat perubahan iklim menjadi ancaman besar bagi kelangsungan hidup krill dan seluruh rantai makanan yang bergantung padanya.

Krill juga memiliki kemampuan unik dalam mengganti lapisan luar tubuhnya (molting), yang memungkinkan mereka tumbuh dan juga bertahan saat kekurangan makanan dengan cara menyusutkan tubuh. Proses ini menunjukkan betapa krill telah beradaptasi secara luar biasa terhadap lingkungan laut kutub yang ekstrem dan penuh tantangan.

Selain menjadi makanan penting bagi satwa liar, krill juga mulai menjadi objek eksploitasi industri perikanan, terutama untuk dijadikan bahan suplemen omega-3, pakan akuakultur, dan makanan hewan. Meskipun saat ini masih diawasi oleh CCAMLR (Commission for the Conservation of Antarctic Marine Living Resources), penangkapan krill yang tidak terkendali dapat mengganggu kestabilan ekosistem Antartika secara menyeluruh.

Sebagai organisme kecil yang menopang kehidupan besar di wilayah kutub selatan, krill Antartika adalah simbol penting dari keterkaitan antara semua makhluk laut. Menjaga kelestariannya berarti menjaga keseluruhan ekosistem yang sangat bergantung pada kehadirannya di lautan yang beku dan kaya kehidupan.
''',
    category: 'Fauna Laut',
    ocean: 'Antartika',
    subtype: 'Krustasea',
  ),
];
