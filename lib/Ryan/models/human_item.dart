import 'package:flutter/material.dart';

class HumanItem {
  final String title;
  final IconData icon;
  final String description;
  final String fullContent;

  HumanItem({
    required this.title,
    required this.icon,
    required this.description,
    required this.fullContent,
  });
}

// Dummy Data
final List<HumanItem> humanList = [
  HumanItem(
    title: "Konservasi Laut",
    icon: Icons.volunteer_activism, // Icon tangan membantu, cocok untuk konservasi
    description: "Manusia berperan aktif menjaga habitat laut melalui konservasi dan pelestarian.",
    fullContent: '''
Manusia berperan aktif dalam menjaga habitat laut melalui berbagai upaya konservasi dan pelestarian yang bertujuan untuk melindungi ekosistem laut dari kerusakan akibat aktivitas manusia dan perubahan lingkungan. Konservasi laut mencakup segala tindakan yang ditujukan untuk menjaga kelestarian keanekaragaman hayati laut, mempertahankan fungsi ekosistem, dan memastikan bahwa sumber daya laut dapat dimanfaatkan secara berkelanjutan oleh generasi sekarang dan mendatang. Upaya ini menjadi semakin penting mengingat laut menghadapi berbagai ancaman serius, seperti penangkapan ikan berlebihan, polusi plastik, tumpahan minyak, perubahan iklim, serta kerusakan habitat seperti terumbu karang dan padang lamun.

Salah satu bentuk konkret konservasi laut adalah pembentukan kawasan konservasi laut (marine protected areas/MPA) yang membatasi atau melarang aktivitas tertentu di wilayah laut tertentu guna menjaga keutuhan ekosistem dan memberi waktu bagi spesies untuk memulihkan diri. Selain itu, konservasi juga melibatkan rehabilitasi ekosistem, seperti restorasi terumbu karang, penanaman mangrove, dan perlindungan habitat penting seperti daerah pemijahan ikan dan tempat bertelur penyu. Upaya ini tidak hanya dilakukan oleh pemerintah, tetapi juga oleh komunitas lokal, organisasi non-pemerintah, ilmuwan, serta masyarakat umum yang mulai menyadari pentingnya menjaga laut.

Pendidikan dan kampanye kesadaran lingkungan juga menjadi bagian penting dalam konservasi laut. Dengan meningkatkan pengetahuan masyarakat tentang pentingnya ekosistem laut bagi kehidupan manusia—mulai dari penyediaan oksigen, pengaturan iklim, hingga sumber pangan—akan tumbuh rasa tanggung jawab kolektif untuk menjaganya. Pengurangan sampah plastik, penggunaan alat tangkap ramah lingkungan, hingga pengelolaan perikanan secara berkelanjutan merupakan contoh tindakan nyata dari pelestarian yang dapat dilakukan oleh individu maupun kelompok.

Teknologi juga berperan dalam memperkuat konservasi laut, melalui pemantauan satelit, sistem pelacakan kapal untuk mencegah penangkapan ikan ilegal, hingga penggunaan data ilmiah dalam pengambilan kebijakan berbasis ekosistem. Kolaborasi internasional sangat penting karena laut adalah ekosistem terbuka yang melintasi batas negara, sehingga perlindungan habitat laut memerlukan kerja sama lintas negara dan lembaga.

Dengan semua upaya ini, konservasi laut bukan hanya menjadi tanggung jawab para ahli atau pemerintah, tetapi merupakan bagian dari tanggung jawab bersama seluruh umat manusia dalam menjaga keseimbangan bumi. Laut yang sehat berarti kehidupan yang berkelanjutan, karena hampir semua aspek kehidupan—dari udara yang kita hirup hingga makanan yang kita makan—bergantung pada keseimbangan dan kelestarian ekosistem laut.
''',
  ),
  HumanItem(
    title: "Pengurangan Sampah Plastik",
    icon: Icons.recycling, // Icon daur ulang
    description: "Upaya manusia mengurangi limbah plastik untuk menjaga kesehatan ekosistem laut.",
    fullContent: '''
Pengurangan sampah plastik merupakan salah satu upaya manusia yang paling krusial dalam menjaga kesehatan ekosistem laut. Plastik, terutama jenis sekali pakai seperti kantong, botol, dan sedotan, telah menjadi ancaman utama bagi lingkungan laut karena sifatnya yang tidak mudah terurai dan dapat bertahan di laut selama ratusan tahun. Setiap tahun, jutaan ton sampah plastik masuk ke lautan dari berbagai sumber, mulai dari limbah rumah tangga, industri, hingga aktivitas pariwisata pesisir. Sampah ini tidak hanya mencemari perairan, tetapi juga membahayakan kehidupan laut karena sering kali disangka sebagai makanan oleh makhluk seperti penyu, burung laut, dan ikan. Akibatnya, banyak hewan laut yang mati karena tersedak, keracunan, atau mengalami gangguan sistem pencernaan akibat menelan plastik.

Upaya pengurangan sampah plastik dilakukan melalui berbagai pendekatan, mulai dari kebijakan pemerintah hingga perubahan perilaku individu. Beberapa negara dan kota telah menerapkan larangan atau pembatasan penggunaan plastik sekali pakai serta mendorong penggunaan alternatif ramah lingkungan seperti kantong kain, wadah kaca, atau bahan biodegradable. Di sektor industri, banyak perusahaan mulai beralih ke kemasan yang dapat didaur ulang atau menggunakan bahan daur ulang untuk mengurangi limbah baru. Selain itu, kampanye global seperti gerakan “Zero Waste” dan “Plastic Free Ocean” telah meningkatkan kesadaran masyarakat tentang bahaya plastik dan pentingnya mengurangi penggunaannya dalam kehidupan sehari-hari.

Pendidikan lingkungan juga memainkan peran penting dalam membentuk pola pikir baru yang lebih peduli terhadap keberlanjutan. Di sekolah, komunitas, dan media sosial, edukasi tentang dampak plastik terhadap laut dan langkah-langkah pengurangannya terus digalakkan. Kegiatan seperti pembersihan pantai, pengelolaan sampah berbasis masyarakat, dan sistem daur ulang yang efisien menjadi bagian dari solusi yang melibatkan partisipasi langsung masyarakat. Di sisi lain, inovasi teknologi juga berperan penting, seperti pengembangan mesin pemilah sampah otomatis, sistem pengumpulan plastik laut, hingga penciptaan plastik alternatif berbahan dasar alga atau pati.

Upaya ini sangat penting untuk menjaga ekosistem laut tetap sehat karena plastik tidak hanya mencemari air, tetapi juga berkontribusi pada mikroplastik—partikel kecil yang dapat masuk ke rantai makanan dan berakhir di tubuh manusia melalui konsumsi makanan laut. Mikroplastik telah ditemukan di berbagai spesies laut, mulai dari plankton hingga paus, menunjukkan bahwa polusi plastik memiliki dampak luas dan dalam jangka panjang.

Dengan komitmen bersama dari pemerintah, pelaku industri, komunitas, dan individu, pengurangan sampah plastik menjadi langkah nyata dalam menjaga keseimbangan dan kelestarian ekosistem laut. Laut yang bersih dari sampah plastik tidak hanya memberikan kehidupan yang lebih baik bagi biota laut, tetapi juga menjamin keberlangsungan sumber daya alam laut bagi generasi sekarang dan yang akan datang.
''',
  ),
  HumanItem(
    title: "Edukasi & Kampanye",
    icon: Icons.campaign, // Icon kampanye
    description: "Peningkatan kesadaran publik tentang pentingnya menjaga laut melalui pendidikan dan kampanye.",
    fullContent: '''
Peningkatan kesadaran publik tentang pentingnya menjaga laut melalui edukasi dan kampanye merupakan langkah strategis dan fundamental dalam upaya pelestarian ekosistem laut. Edukasi berperan dalam memberikan pemahaman yang mendalam tentang fungsi laut sebagai sistem penyangga kehidupan, sumber pangan, pengatur iklim, serta rumah bagi jutaan spesies makhluk hidup. Melalui pendidikan formal di sekolah dan universitas, serta pendidikan informal seperti seminar, lokakarya, dokumenter, dan media sosial, masyarakat dibekali pengetahuan ilmiah tentang bahaya pencemaran, kerusakan terumbu karang, perubahan iklim, dan pentingnya keanekaragaman hayati laut. Pendidikan lingkungan ini bertujuan menumbuhkan rasa peduli dan tanggung jawab sejak usia dini, agar generasi muda tumbuh dengan kesadaran bahwa laut harus dijaga dan dilestarikan.

Sementara itu, kampanye lingkungan berperan sebagai alat komunikasi publik yang kuat untuk menyampaikan pesan-pesan penting secara luas dan menyentuh emosional masyarakat. Kampanye dilakukan oleh pemerintah, organisasi non-pemerintah, komunitas pecinta lingkungan, hingga tokoh masyarakat atau influencer yang memiliki pengaruh besar di tengah publik. Bentuk kampanyenya bisa berupa gerakan bersih pantai, pengurangan plastik sekali pakai, kampanye #SaveTheOcean, Hari Laut Sedunia, hingga inisiatif penanaman mangrove dan restorasi terumbu karang. Kampanye sering kali memanfaatkan kekuatan visual dan media digital untuk menarik perhatian dan membangun keterlibatan publik secara aktif.

Edukasi dan kampanye saling melengkapi: edukasi membangun pemahaman yang kuat, sementara kampanye menggerakkan aksi. Ketika masyarakat memiliki pengetahuan yang cukup, mereka akan lebih mudah menerima ajakan untuk berpartisipasi dalam kegiatan konservasi, mengubah kebiasaan konsumsi yang merusak laut, serta mendorong kebijakan yang pro-lingkungan. Upaya ini juga penting untuk menciptakan tekanan sosial dan politik agar pemimpin dan pembuat kebijakan lebih serius dalam melindungi wilayah laut. Pada akhirnya, dengan kombinasi edukasi yang mendalam dan kampanye yang menggugah, kesadaran publik tentang pentingnya laut dapat tumbuh secara luas dan berdampak nyata terhadap kelestarian ekosistem laut untuk masa depan yang lebih berkelanjutan.
''',
  ),
  HumanItem(
    title: "Pemulihan Terumbu Karang",
    icon: Icons.nature_people, // Icon alam dan manusia
    description: "Proyek restorasi terumbu karang yang melibatkan komunitas dan ilmuwan.",
    fullContent: '''
Pemulihan terumbu karang adalah serangkaian upaya konservasi aktif yang bertujuan untuk mengembalikan kondisi dan fungsi ekologis terumbu karang yang rusak akibat berbagai tekanan, seperti pemutihan karang, polusi, penangkapan ikan destruktif, serta dampak perubahan iklim. Terumbu karang adalah ekosistem laut yang sangat kaya akan keanekaragaman hayati dan menjadi tempat hidup bagi sekitar 25% spesies laut meskipun hanya menutupi kurang dari 1% permukaan laut. Selain sebagai habitat penting, terumbu karang juga berperan melindungi garis pantai dari erosi, mendukung mata pencaharian nelayan, dan menjadi sumber wisata bahari. Namun, dalam beberapa dekade terakhir, lebih dari sepertiga terumbu karang dunia mengalami degradasi serius.

Proyek restorasi terumbu karang merupakan bagian dari upaya pemulihan ini dan kini banyak melibatkan kerja sama antara ilmuwan, lembaga konservasi, pemerintah, serta komunitas lokal. Proyek semacam ini biasanya dimulai dengan pemetaan dan pemantauan lokasi terumbu yang mengalami kerusakan, diikuti oleh metode pemulihan aktif seperti penanaman fragmen karang, budidaya karang (coral gardening), dan penggunaan struktur buatan seperti rak logam, terumbu beton, atau bio rock sebagai tempat tumbuhnya karang baru. Fragmen karang yang sehat dipotong dari indukan, dibesarkan di tempat pembibitan (nursery), lalu ditransplantasikan ke lokasi yang telah disiapkan agar dapat tumbuh kembali dan membentuk koloni baru. Dalam beberapa kasus, teknik modern seperti pencetakan DNA karang tahan panas atau rekayasa mikrobioma karang juga mulai dikembangkan untuk meningkatkan daya tahan karang terhadap suhu laut yang meningkat.

Salah satu aspek penting dalam keberhasilan pemulihan terumbu karang adalah partisipasi masyarakat lokal. Komunitas nelayan, penyelam, dan warga pesisir sering kali diajak terlibat langsung dalam proses penanaman karang, pengawasan ekosistem, serta kampanye perlindungan laut. Pendekatan ini tidak hanya membangun rasa kepemilikan, tetapi juga memastikan bahwa masyarakat setempat memahami nilai jangka panjang dari menjaga terumbu karang yang sehat, termasuk manfaat ekonomi dari perikanan berkelanjutan dan ekowisata. Di banyak tempat, keterlibatan komunitas bahkan menjadi kunci utama keberhasilan karena mereka memiliki pengetahuan lokal yang sangat berguna dan dapat berkontribusi dalam pemeliharaan jangka panjang.

Pemulihan terumbu karang juga didukung oleh kebijakan dan regulasi, seperti pembentukan kawasan konservasi laut (KKL), larangan penggunaan alat tangkap destruktif seperti bom dan sianida, serta pengawasan terhadap pembangunan pesisir yang merusak ekosistem. Kerja sama lintas sektor—antara ilmuwan kelautan, lembaga pemerintah, organisasi lingkungan, dan sektor swasta—menjadi sangat penting dalam mengintegrasikan data ilmiah dengan kebijakan dan aksi nyata di lapangan.

Meskipun pemulihan terumbu karang adalah proses yang panjang dan membutuhkan biaya serta tenaga yang besar, hasilnya sangat berharga. Terumbu yang berhasil direstorasi dapat kembali menjadi habitat produktif, menyediakan sumber pangan, dan memperkuat ketahanan masyarakat pesisir terhadap bencana alam seperti gelombang besar atau badai. Di tengah ancaman perubahan iklim global, pemulihan terumbu karang bukan hanya tentang memperbaiki apa yang rusak, tetapi juga tentang membangun ketahanan dan keberlanjutan bagi masa depan laut dan manusia yang bergantung padanya.
''',
  ),
];