import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileAbout extends StatefulWidget {
  const ProfileAbout({super.key});

  @override
  State<ProfileAbout> createState() => _ProfileAboutState();
}

class _ProfileAboutState extends State<ProfileAbout> {
  final List<Map<String, dynamic>> teamMembers = [
    {
      'image': 'assets/images/2.jpg',
      'name': 'MHD. Hatami',
      'status': 'Leader',
      'whatsapp': '6289678136633',
    },
    {
      'image': 'assets/images/3.jpg',
      'name': 'Fauzan R.HRP',
      'status': 'Frontend Dev',
      'whatsapp': '62895613355540',
    },
    {
      'image': 'assets/images/4.jpg',
      'name': 'Eka Satria',
      'status': 'Backend Dev',
      'whatsapp': '6282168529918',
    },
    {
      'image': 'assets/images/5.jpg',
      'name': 'Ryan Rafly Tanjung',
      'status': 'UI/UX Designer',
      'whatsapp': '6281370607685',
    },
  ];

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _openWhatsApp(String phone) {
    final url = 'https://wa.me/$phone';
    _launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.grey[100];
    final textColorPrimary = isDarkMode ? Colors.white : Colors.black87;
    final textColorSecondary = isDarkMode ? Colors.white70 : Colors.black54;
    final accentColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        title: Text(
          "Profile About",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Sopan Santun Team",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: accentColor,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: teamMembers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final member = teamMembers[index];
                  return Card(
                    elevation: 6,
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // FOTO TIM
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: Image.asset(
                            member['image'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // NAMA & STATUS
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 6,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  member['name'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColorPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member['status'],
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: textColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // TOMBOL ICON
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Tooltip(
                                message: "Tim ${member['name']}",
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent[100],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.people,
                                    color: accentColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Tooltip(
                                message: "Hubungi via WhatsApp",
                                child: GestureDetector(
                                  onTap:
                                      () => _openWhatsApp(member['whatsapp']),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green[100],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // FOOTER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Terima kasih telah menggunakan aplikasi kami! Kami berharap dapat terus memberikan layanan terbaik untuk Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(thickness: 1, color: accentColor),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.contact_mail, color: accentColor),
                      const SizedBox(width: 8),
                      Text(
                        "Contact Person",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.email,
                            color: Colors.blueAccent,
                          ),
                          title: const Text("sopansantunteam@gmail.com"),
                          onTap:
                              () => _launchURL(
                                "mailto:sopansantunteam@gmail.com",
                              ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.green),
                          title: const Text("+6289678136633"),
                          onTap: () => _launchURL("tel:+6289678136633"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
